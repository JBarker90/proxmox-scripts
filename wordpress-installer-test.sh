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
            WP_DIR="${OPTARG}"
            ;;
        \?) # If an option doesn't exist
            help
            exit 1
            ;;
    esac
done

# Check the Variables passed as OPTARG
echo "Your user is: $DB_USER"
echo "Your user is: $DB_PASS"
echo "Your user is: $DB_NAME"
echo "Your user is: $WP_DIR"