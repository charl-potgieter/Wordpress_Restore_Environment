#!/bin/bash

# # NOTES
# #  -  Script to be run as root

# #Set 1 to pause to allow system status, 0 to proceed without checks
# pause_to_check_system_status=0

# printf "\n"
# echo "Updating system...................."
# printf "\n"
# sleep 1

# sudo apt-get update
# sudo apt-get upgrade


# printf "\n"
# echo "Installing apache...................."
# printf "\n"
# sleep 1

# apt-get install apache2
# service apache2 start

# if [ $pause_to_check_system_status -eq 1 ]
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
# sudo a2enmod rewrite

# # Disable the default "It Works” site
# sudo a2dissite 000-default

# sudo service apache2 start
# sudo service apache2 reload


# printf "\n"
# echo "Install mysql, php and various dependencies...................."
# printf "\n"
# sleep 1

# sudo apt install ghostscript \
#                  libapache2-mod-php \
#                  mysql-server \
#                  php \
#                  php-bcmath \
#                  php-curl \
#                  php-imagick \
#                  php-intl \
#                  php-json \
#                  php-mbstring \
#                  php-mysql \
#                  php-xml \
# #                  php-zip



# printf "\n"
# echo "Configure MYSQL database...................."
# printf "\n"
# sleep 1

# service mysql start

# mysql -e "CREATE DATABASE wordpress;"

# while true; do
#   read -s -p "Enter password for wordpress@localhost " wp_password
#   echo
#   read -s -p "Confirm password  " wp_password2
#   echo
#   [ "$wp_password" = "$wp_password2" ] && break
#   printf "\n"
#   echo "Passwords dont match - please try again"
#   printf "\n"
# done

# mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY '${wp_password}';"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;"
mysql -e "FLUSH PRIVILEGES;"
service mysql restart