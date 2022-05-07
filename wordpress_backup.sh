#!/bin/bash

# Requires installation of mysqldump and pv

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi

source /etc/wordpress-backup.conf

read -s -p "Enter password for ftp (it may be the same as cpanel password) " ftppassword

# mkdir -p $backuppath/files
# mkdir -p $backuppath/database

# # NOTE: For below to work first need to add pc (host) IP address to godaddy cpanel under Remote Mysql
# printf "\n"
# echo  "NOTE: For above to work first need to add pc (host) IP address to godaddy cpanel under Remote Mysql "
# echo "https://au.godaddy.com/help/connect-remotely-to-a-mysql-database-in-my-linux-hosting-account-16103 "
# printf "\n"
# echo "When prompted for a password, enter the mysql database password.  This can be located in file wp-config.php in the live site domain.  This file is located in public_html on Godaddy shared hosting."
# printf "\n"

# if [ $timestamped -eq 1 ]
# then
#     current_time=$(date "+%Y%m%d-%H%M%S")
#     backupfilename=$current_time"-mysql.database"
# else
#     backupfilename=mysql.database
# fi

# mysqldump --column-statistics=0 -h $domain -u $mysqlusername -p --no-tablespaces $mysqldatabase > $backuppath/database/$backupfilename

# echo "Database backup complete."


# Below code snippet sourced from here:
# https://gist.github.com/pixeline/0f9f922cffb5a6bba97a
echo $ftpusername@$domain

lftp -u "$ftpusername","$ftppassword" $domain <<EOF
# the next 3 lines put you in ftpes mode. Uncomment if you are having trouble connecting.
# set ftp:ssl-force true
# set ftp:ssl-protect-data true
set ssl:verify-certificate no
# transfer starts now...
set sftp:auto-confirm yes
# mirror --use-pget-n=10 $REMOTE_DIR $LOCAL_DIR;
ls
exit
EOF

