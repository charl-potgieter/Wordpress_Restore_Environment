## About
TBA TBA TBA

### 1. Create backup / restore environment

1. Run script TBA_TBA_TBA as sudo
2. Copy .wordpress-backup.conf into user home directory and update user, password details etc.
3. Create file ~/.my.cnf for purposes of mysqldump authentication containing the mysql user and password (can be found in live site directory in file wp-config.php):

        [mysqldump]
        user=mysqluser
        password=secret
4. Create file ~/.netrc with details of remote machine domain as well as the ftp password (this may be the same as cpanel password):

        machine example.com
        login username
        password userpassword


### Run backup

Run  as standard user (not sudo) to ensure the configuration files per above are picked up correctly


### Run restore



### External references

https://wordpress.org/support/article/wordpress-backups/

https://wordpress.org/support/article/backing-up-your-wordpress-files/

https://wordpress.org/support/article/backing-up-your-database/

https://www.wpbeginner.com/wp-tutorials/how-to-move-live-wordpress-site-to-local-server/

https://ubuntu.com/tutorials/https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview

https://stackoverflow.com/questions/11929461/how-can-i-run-dos2unix-on-an-entire-directory