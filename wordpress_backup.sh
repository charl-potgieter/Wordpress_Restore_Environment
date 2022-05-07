#!/bin/bash

# Requires installation of mysqldump and pv

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi

source /etc/wordpress-backup.conf

mkdir -p $backuppath/files
mkdir -p $backuppath/database

# NOTE: For below to work first need to add pc (host) IP address to godaddy cpanel under Remote Mysql
printf "\n"
echo  "NOTE: For above to work first need to add pc (host) IP address to godaddy cpanel under Remote Mysql "
echo "https://au.godaddy.com/help/connect-remotely-to-a-mysql-database-in-my-linux-hosting-account-16103 "
printf "\n"
echo "When prompted for a password, enter the mysql database password.  This can be located in file wp-config.php in the live site domain.  This file is located in public_html on Godaddy shared hosting."
printf "\n"
echo "Backing up database..."

mysqldump --column-statistics=0 -h $domain -u $mysqlusername -p --no-tablespaces $mysqldatabase > $backuppath/database/mysql.database