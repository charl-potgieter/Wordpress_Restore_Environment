## Setup backup / restore environment

1. Run script TBA_TBA_TBA as sudo
2. Copy .wodrpress-backup.conf into user home directory
3. Create file ~/.my.cnf for purposes of mysqldump authentication containing the mysql user and password (can be found in live site directory in file wp-config.php):

        [mysqldump]
        user=mysqluser
        password=secret
4. Create file ~/.netrc with details of remote machine domain as well as the ftp password (this may be the same as cpanel password):

        machine example.com
        login username
        password userpassword


## Run backup

Run  as standard user (not sudo) to ensure the configuration files per above are picked up correctly


## Run restore





