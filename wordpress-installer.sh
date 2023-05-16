#!/bin/bash

# Define the database variables
DB_USER="your-db-user"
DB_PASS="your-db-pass"
DB_NAME="your-db-name"

# Define the WordPress installation directory
WP_DIR="/var/www/html/wordpress"

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz -P /tmp
tar -xzvf /tmp/latest.tar.gz -C /tmp
sudo mv /tmp/wordpress $WP_DIR
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Generate new salts
NEW_SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
NEW_SALTS=$(echo "$NEW_SALTS" | sed 's/\//\\\//g')

# Update wp-config.php with new salts
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "/define('AUTH_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('AUTH_KEY''))" $WP_DIR/wp-config.php
sudo sed -i "/define('SECURE_AUTH_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('SECURE_AUTH_KEY''))" $WP_DIR/wp-config.php
sudo sed -i "/define('LOGGED_IN_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('LOGGED_IN_KEY''))" $WP_DIR/wp-config.php
sudo sed -i "/define('NONCE_KEY',/c\$(echo \"$NEW_SALTS\" | grep 'define('NONCE_KEY''))" $WP_DIR/wp-config.php
sudo sed -i "/define('AUTH_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('AUTH_SALT''))" $WP_DIR/wp-config.php
sudo sed -i "/define('SECURE_AUTH_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('SECURE_AUTH_SALT''))" $WP_DIR/wp-config.php
sudo sed -i "/define('LOGGED_IN_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('LOGGED_IN_SALT''))" $WP_DIR/wp-config.php
sudo sed -i "/define('NONCE_SALT',/c\$(echo \"$NEW_SALTS\" | grep 'define('NONCE_SALT''))" $WP_DIR/wp-config.php

# Create the MySQL database and user
mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Update wp-config.php with database credentials
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

echo "WordPress has been installed and new salts have been generated."
