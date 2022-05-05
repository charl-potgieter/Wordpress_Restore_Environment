#!/bin/bash

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi

source /etc/wordpress-backup.conf

mkdir -p $backuppath/files
mkdir -p $backuppath/database

read -s -p "Enter ssh password for domain: " passw

#ssh $username@$domain
# source exit.sh   # exit ssh connection

sshpass -p$passw ssh $username@$domain mysqldump -h localhost -u $username -p$passw --no-tablespaces i8640980_wp1 > ~/file_name_local.sql

# May have to add host ip?
# https://au.godaddy.com/help/connect-remotely-to-a-mysql-database-in-my-linux-hosting-account-16103


# mysqldump -h localhost -u jkdwrlryv6s3 -p --no-tablespaces i8640980_wp1 > file_name.sql
