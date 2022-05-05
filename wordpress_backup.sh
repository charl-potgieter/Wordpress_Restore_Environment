#!/bin/bash

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi

source /etc/wordpress-backup.conf

mkdir -p $backuppath/files
mkdir -p $backuppath/database


ssh $username@$domain
source exit.sh   # exit ssh connection


# mysqldump -h localhost -u jkdwrlryv6s3 -p --no-tablespaces i8640980_wp1 > file_name.sql
