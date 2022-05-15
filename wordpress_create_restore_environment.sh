#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi

# Get config path name, first get login user and then user path
# https://www.baeldung.com/linux/identify-user-called-by-sudo
# https://superuser.com/questions/484277/get-home-directory-by-username
loginuser=${SUDO_USER:-$USER}
loginuserhome=$( getent passwd $loginuser | cut -d: -f6 )
configfilepath=$loginuserhome/.wordpress-backup.conf

source $configfilepath

# printf "\n"
# echo "Updating system...................."
# printf "\n"
# sleep 1
# apt-get update
# apt-get upgrade

# printf "\n"
# echo "Install all necessary programs...................."
# printf "\n"
# sleep 1
# apt-get install \
#     apache2 \
#     ghostscript \
#     libapache2-mod-php \
#     mysql-server \
#     php \
#     php-bcmath \
#     php-curl \
#     php-imagick \
#     php-intl \
#     php-json \
#     php-mbstring \
#     php-mysql \
#     php-xml \
#     php-zip \
#     dos2unix \
#     lftp


# service apache2 start

# if [ $pausetocheck -eq 1 ]
# then
#     printf "\n"
#     echo "-------------------------------"
#     echo "      SYSTEM STATUS CHECK"
#     echo "-------------------------------"
#     echo "To check status enter localhost in browser, preferably in private mode.  "
#     echo "Apache Ubuntu default page should be displayed.  "
#     printf "\n"
#     read -p "Press any key to continue... " -n1 -s
#     printf "\n\n"
# fi


# printf "\n"
# echo "Creating Wordpress directory...................."
# printf "\n"
# sleep 1

# mkdir -p /srv/www
# chown www-data: /srv/www
# sudo -u www-data mkdir -p /srv/www/wordpress


# printf "\n"
# echo "Creating apache configuration for Wordpress...................."
# printf "\n"
# sleep 1

# conf_file_path=/etc/apache2/sites-available/wordpress.conf
# echo "<VirtualHost *:80>
#     DocumentRoot /srv/www/wordpress
#     <Directory /srv/www/wordpress>
#         Options FollowSymLinks
#         AllowOverride Limit Options FileInfo
#         DirectoryIndex index.php
#         Require all granted
#     </Directory>
#     <Directory /srv/www/wordpress/wp-content>
#         Options FollowSymLinks
#         Require all granted
#     </Directory>
# </VirtualHost>" > $conf_file_path

# #Enable site
# a2ensite wordpress

# #Enable URL rewriting
# a2enmod rewrite

# # Disable the default "It Works” site
# a2dissite 000-default

# service apache2 start
# service apache2 reload


# printf "\n"
# echo "Configure MYSQL database...................."
# printf "\n"
# sleep 1


# service mysql start

# mysql -e "CREATE DATABASE wordpress;"

# mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY '${passwordwp}';"
# mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;"
# mysql -e "FLUSH PRIVILEGES;"
# service mysql restart


# printf "\n"
# echo "Install phpMyAdmin...................."
# echo "Select apache2 as webserver"
# echo "Configure database for phpMyAdmin with dbconfig-common (dont perform manual configuration)"
# printf "\n"
# read -p "Press any key to continue... " -n1 -s

# apt-get install phpmyadmin

# service mysql restart
# service apache2 restart


# if [ $pausetocheck -eq 1 ]
# then
#     printf "\n"
#     echo "-------------------------------"
#     echo "      SYSTEM STATUS CHECK"
#     echo "-------------------------------"
#     echo "To check status enter http://localhost/phpmyadmin in browser, preferably in private mode.  "
#     echo "phpMyAdmin welcome page should be displayed.   User = wordpress, password = that chosen during MYSQL configuration"
#     printf "\n"
#     read -p "Press any key to continue... " -n1 -s
#     printf "\n\n"
# fi

# printf "\n"
# echo "Environment setup complete"