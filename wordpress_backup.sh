#!/bin/bash

# Requires installation of mysqldump and pv

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi


printf "\n"
echo  "NOTE: For this script to work first need to add this pc (host) IP address to godaddy cpanel under Remote Mysql "
echo "https://au.godaddy.com/help/connect-remotely-to-a-mysql-database-in-my-linux-hosting-account-16103 "
printf "\n"

source /etc/wordpress-backup.conf

echo "The MYSQL is generally located in file wp-config.php in the live site domain.  This file is located in public_html on Godaddy shared hosting."

mkdir -p $targetpath/files
mkdir -p $targetpath/database

if [ $timestamped -eq 1 ]
then
    current_time=$(date "+%Y%m%d-%H%M%S")
    backupfilename=$current_time"-mysql.database"
else
    backupfilename=mysql.database
fi

mysqldump --column-statistics=0 -h $domain -u $mysqlusername -p --no-tablespaces $mysqldatabase > $targetpath/database/$backupfilename

echo "Database backup complete."



read -s -p "Enter password for ftp (it may be the same as cpanel password) " ftppassword

# Below code snippet sourced from here:
# https://gist.github.com/pixeline/0f9f922cffb5a6bba97a

printf "\n"
echo "Mirroring files via FTP..."
lftp -u "$ftpusername","$ftppassword" $domain <<EOF
# the next 3 lines put you in ftpes mode. Uncomment if you are having trouble connecting.
# set ftp:ssl-force true
# set ftp:ssl-protect-data true
set ssl:verify-certificate no
# transfer starts now...
set sftp:auto-confirm yes
mirror --use-pget-n=10 $sourcepath $targetpath;
ls
exit
EOF

