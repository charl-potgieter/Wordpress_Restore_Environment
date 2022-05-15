#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


# Get config path name, first get login user and then user path
# https://www.baeldung.com/linux/identify-user-called-by-sudo
# https://superuser.com/questions/484277/get-home-directory-by-username
loginuser=${SUDO_USER:-$USER}
loginuserhome=$( getent passwd $loginuser | cut -d: -f6 )
configfilepath=$loginuserhome.wordpress-backup.conf


source $configfilepath

# printf "\n"
# echo "Copy previously backed up file...................."
# printf "\n"
# sleep 1


# targetpath is the target of the backup script, hence the name
# Sudo -u www-data rsync -v -a --del - $targetpath/files/* /srv/www/wordpress

# ls $targetpath/files

# # Fix any windows file format newline issues that may arrive if files are stored on windows file system and accessed from a wsl environment
# sudo -u www-data find /srv/www/wordpress/ -type f -print0 | sudo -u www-data xargs -0 dos2unix


# printf "\n"
# echo "Edit wp-config.php file to update user and password...................."
# printf "\n"
# sleep 1

# sed -i "s/define( 'DB_NAME'.*/define( 'DB_NAME', 'wordpress' );/g" /srv/www/wordpress/wp-config.php
# sed -i "s/define( 'DB_USER'.*/define( 'DB_USER', 'wordpress' );/g" /srv/www/wordpress/wp-config.php
# sed -i "s/define( 'DB_PASSWORD'.*/define( 'PASSWORD', '$passwordwp' );/g" /srv/www/wordpress/wp-config.php



# if [ $pause_to_check_system_status -eq 1 ]
# then
#     printf "\n"
#     echo "-------------------------------"
#     echo "      SYSTEM STATUS CHECK"
#     echo "-------------------------------"
#     echo "To check status enter http://localhost in browser, preferably in private mode.  "
#     echo "Wordpress login page should appear.  DON'T LOGIN YET, JUST FOR CHECKING AT THIS STAGE"
#     printf "\n"
#     read -p "Press any key to continue... " -n1 -s
#     printf "\n\n"
# fi




# printf "\n"
# echo "Import wordpress database ((previously backed up from live site)  into MYSQL...................."
# printf "\n"
# sleep 1

# read -e -p "Enter source filepath (tab autocompletes path.  When prompted for password, this is your root password): " db_path
# mysql -u root -p wordpress   <   $db_path

# if [ $pause_to_check_system_status -eq 1 ]
# then
#     printf "\n"
#     echo "-------------------------------"
#     echo "      SYSTEM STATUS CHECK"
#     echo "-------------------------------"
#     echo "wordpress tables should show below if import was succsesful"
#     printf "\n"
#     mysql -e "USE wordpress;SHOW TABLES;" 
#     printf "\n"
#     read -p "Press any key to continue... " -n1 -s
#     printf "\n\n"
# fi


# printf "\n"
# echo "Update the URLs to refer to localhost...................."
# printf "\n"
# sleep 1

# sql_filename="/srv/www/wordpress/temp_sql_url_update.sql"
# read -p "Enter live website url in format www.example.com: " live_url

# #Create the sql
# echo "UPDATE wp_options SET option_value = replace(option_value, 'https://www.example.com', 'http://localhost') WHERE option_name = 'home' OR option_name = 'siteurl';
  
# UPDATE wp_posts SET post_content = replace(post_content, 'https://www.example.com', 'http://localhost');
  
# UPDATE wp_postmeta SET meta_value = replace(meta_value,'https://www.example.com','http://localhost');

# UPDATE wp_options SET option_value = replace(option_value, 'https://www.example.com', 'http://localhost') WHERE option_name = 'home' OR option_name = 'siteurl';
  
# UPDATE wp_posts SET post_content = replace(post_content, 'https://www.example.com', 'http://localhost');
  
# UPDATE wp_postmeta SET meta_value = replace(meta_value,'https://www.example.com','http://localhost');" > $sql_filename


# #Replace www.example.com with live site url
# sed -i -e "s/www.example.com/${live_url}/g" $sql_filename

# #Execute above sql to update from live url to localhost
# mysql wordpress < $sql_filename


# sudo service mysql restart
# sudo service apache2 restart


# echo "Log in with private mode browser at localhost/wp-admin.  User name and password is the same as that used for the live site wordpress login.  Go to Settings / Permalinks and click “Save Changes”. Even though no input change this fixes the link issues which occur when domain us moved to local.
# Should now be able to enter private mode browser as localhost.  Links should work and there should be no redirect to the live site and restore environment should be up and running"

# printf "\n"
# read -p "Press any key to continue... " -n1 -s
# printf "\n\n"