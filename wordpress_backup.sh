#!/bin/bash

printf "\n"
echo  "NOTE: For this script to work first need to add this pc (host) IP address to godaddy cpanel under Remote Mysql "
echo "https://au.godaddy.com/help/connect-remotely-to-a-mysql-database-in-my-linux-hosting-account-16103 "
printf "\n"

source ~/.wordpress-backup.conf

mkdir -p $targetpath/files
mkdir -p $targetpath/database

if [ $timestamped -eq 1 ]
then
    current_time=$(date "+%Y%m%d-%H%M%S")
    backupfilename=$current_time"-mysql.database"
else
    backupfilename=mysql.database
fi


printf "\n"
echo "Backing up database (may take a little while)..."

mysqldump --column-statistics=0 -h powernumerics.com  --no-tablespaces $mysqldatabase > $targetpath/database/$backupfilename


printf "\n"
echo "Mirroring files via FTP..."
lftp $domain <<EOF
# the next 3 lines put you in ftpes mode. Uncomment if you are having trouble connecting.
# set ftp:ssl-force true
# set ftp:ssl-protect-data true
set ssl:verify-certificate no
# transfer starts now...
set sftp:auto-confirm yes
mirror --use-pget-n=10 $sourcepath $targetpath/files;
exit
EOF