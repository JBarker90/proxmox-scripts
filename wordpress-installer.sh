#!/bin/bash

# Define the database variables
DB_USER="your-db-user"
DB_PASS="your-db-pass"
DB_NAME="your-db-name"

# Define the WordPress installation directory
WP_DIR="/var/www/html/wordpress"

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

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzvf /tmp/latest.tar.gz -C /tmp
mv /tmp/wordpress $WP_DIR
chown -R www-data:www-data $WP_DIR
chmod -R 755 $WP_DIR

# Generate new salts
NEW_SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
NEW_SALTS=$(echo "$NEW_SALTS" | sed 's/\//\\\//g')

# Update wp-config.php with new salts
cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sed -i "/define('AUTH_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('AUTH_KEY''))" $WP_DIR/wp-config.php
sed -i "/define('SECURE_AUTH_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('SECURE_AUTH_KEY''))" $WP_DIR/wp-config.php
sed -i "/define('LOGGED_IN_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('LOGGED_IN_KEY''))" $WP_DIR/wp-config.php
sed -i "/define('NONCE_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('NONCE_KEY''))" $WP_DIR/wp-config.php
sed -i "/define('AUTH_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('AUTH_SALT''))" $WP_DIR/wp-config.php
sed -i "/define('SECURE_AUTH_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('SECURE_AUTH_SALT''))" $WP_DIR/wp-config.php
sed -i "/define('LOGGED_IN_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('LOGGED_IN_SALT''))" $WP_DIR/wp-config.php
sed -i "/define('NONCE_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('NONCE_SALT''))" $WP_DIR/wp-config.php

# Create the MySQL database and user
mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Update wp-config.php with database credentials
sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

echo "WordPress has been installed and new salts have been generated."
