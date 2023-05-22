#!/bin/bash

# Define the database variables
#DB_USER="your-db-user"
#DB_PASS="your-db-pass"
#DB_NAME="your-db-name"

# Define the WordPress installation directory
#WP_DIR="/var/www/html/wordpress"

help(){
    # This Displays a Help message
    echo "This script will install WordPress on Web Servers."
    echo
    echo "Syntax: wordpress-installer.sh [-h] | [-u <DB_USER>] [-p <DB_PASS>] [-n <DB_NAME>] [-d <DIR>]"
    echo "options:"
    echo "  -h    Print this Help message."
    echo "  -u    This specifies the DB_USER that you would like to use."
    echo "  -p    This specifies the DB_PASS that you would like to use."
    echo "  -n    This specifies the DB_NAME that you would like to use."
    echo "  -d    This specifies the DB_DIR that you would like to install WordPress."
    echo
}

# Different Options for arguments
while getopts "hu:p:n:d:" option; do
    case $option in
        h) # Displays help message
            help
            exit 1
            ;;
        u) # Specifies DB_USER
            DB_USER="${OPTARG}"
            ;;
        p) # Specifies DB_PASS
            DB_PASS="${OPTARG}"
            ;;
        n) # Specifies DB_NAME
            DB_NAME="${OPTARG}"
            ;;
        d) # Specifies installation DIR for WordPress
            WP_DIR=$(readlink -f "${OPTARG}")
            ;;
        \?) # If an option doesn't exist
            help
            exit 1
            ;;
    esac
done

if [[ $# == 0 || "${#1}" -gt 2 ]]; then
    help
    exit 1
fi

# Download and extract WordPress
WP_USER=$(stat -c '%U' "$WP_DIR")

printf '\n'
echo "==============================================="
echo "Downloading the latest version of WordPress... "
echo "==============================================="
printf '\n'

wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C /tmp
cp -a /tmp/wordpress "$WP_DIR"
cd "$WP_DIR"/wordpress || exit
cp -a . ../
rm -rf "$WP_DIR"/wordpress
chown -R "$WP_USER":"$WP_USER" "$WP_DIR"
find "$WP_DIR" -type d -exec chmod 755 {} \;
find "$WP_DIR" -type f -exec chmod 644 {} \;

# Check if the database and user exist
# Create the MySQL database and user if it doesn't
if sudo mysql -e "use $DB_NAME" >/dev/null 2>&1; then
    echo "======================================="
    echo "The database $DB_NAME already exists..."
    echo "Skipping..."
    echo "======================================="
else
    echo "======================================="
    echo "Creating new database $DB_NAME..."
    sudo mysql -e "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    sudo mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
    sudo mysql -e "FLUSH PRIVILEGES;"
    echo "Done..."
    echo "======================================="
fi

# Update and create new wp-config.php with database credentials
cp -a "$WP_DIR"/wp-config-sample.php "$WP_DIR"/wp-config.php
sed -i "s/database_name_here/$DB_NAME/" "$WP_DIR"/wp-config.php
sed -i "s/username_here/$DB_USER/" "$WP_DIR"/wp-config.php
sed -i "s/password_here/$DB_PASS/" "$WP_DIR"/wp-config.php

#   Set authentication unique keys and salts in wp-config.php
perl -i -pe '
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' "$WP_DIR"/wp-config.php

# Cleaning up after download
printf '\n'
echo "============================="
echo "Cleaning up..."
echo "============================="
rm -rf /tmp/wordpress
rm -rf /tmp/latest.tar.gz
printf '\n'

# Done...
printf '\n'
echo "==============================================================="
echo "Done..."
echo
echo "WordPress has been installed and new salts have been generated."
echo "==============================================================="
printf '\n'