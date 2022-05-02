!/bin/bash

# NOTES
#  -  Script to be run as root

#Set 1 to pause to allow system status, 0 to proceed without checks
pause_to_check_system_status=1



printf "\n"
echo "Updating system...................."
printf "\n"
sleep 1

sudo apt-get update
sudo apt-get upgrade


printf "\n"
echo "Installing apache...................."
printf "\n"
sleep 1

apt-get install apache2
service apache2 start

if [ $pause_to_check_system_status -eq 1 ]
then
    printf "\n"
    echo "-------------------------------"
    echo "      SYSTEM STATUS CHECK"
    echo "-------------------------------"
    echo "To check status enter localhost in browser, preferably in private mode.  "
    echo "Apache Ubuntu default page should be displayed.  "
    printf "\n"
    read -p "Press any key to continue... " -n1 -s
    printf "\n\n"
fi


printf "\n"
echo "Creating Wordpress directory...................."
printf "\n"
sleep 1

mkdir -p /srv/www
chown www-data: /srv/www
sudo -u www-data mkdir -p /srv/www/wordpress



printf "\n"
echo "Creating apache configuration for Wordpress...................."
printf "\n"
sleep 1

conf_file_path=/etc/apache2/sites-available/wordpress.conf
echo "<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>" > $conf_file_path

#Enable site
a2ensite wordpress

#Enable URL rewriting
sudo a2enmod rewrite

# Disable the default "It Works” site
sudo a2dissite 000-default

sudo service apache2 start
sudo service apache2 reload


printf "\n"
echo "Install mysql, php and various dependencies...................."
printf "\n"
sleep 1

sudo apt install ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
#                  php-zip



printf "\n"
echo "Configure MYSQL database...................."
printf "\n"
sleep 1


service mysql start

mysql -e "CREATE DATABASE wordpress;"

while true; do
  read -s -p "Enter password for wordpress@localhost.  NEEDS TO BE THE SAME AS LIVE SITE " wp_password
  echo
  read -s -p "Confirm password  " wp_password2
  echo
  [ "$wp_password" = "$wp_password2" ] && break
  printf "\n"
  echo "Passwords dont match - please try again"
  printf "\n"
done

mysql -e "CREATE USER wordpress@localhost IDENTIFIED BY '${wp_password}';"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;"
mysql -e "FLUSH PRIVILEGES;"
service mysql restart



printf "\n"
echo "Install phpMyAdmin...................."
echo "Select apache2 as webserver"
echo "Configure database for phpMyAdmin with dbconfig-common (don’t perform manual configuration)"
printf "\n"
read -p "Press any key to continue... " -n1 -s

apt-get install phpmyadmin

service mysql restart
service apache2 restart


if [ $pause_to_check_system_status -eq 1 ]
then
    printf "\n"
    echo "-------------------------------"
    echo "      SYSTEM STATUS CHECK"
    echo "-------------------------------"
    echo "To check status enter http://localhost/phpmyadmin in browser, preferably in private mode.  "
    echo "phpMyAdmin welcome page should be displayed.   User = wordpress, password = that chosen duuring MYSQL configuration"
    printf "\n"
    read -p "Press any key to continue... " -n1 -s
    printf "\n\n"
fi


printf "\n"
echo "Copy previously backed up file...................."
printf "\n"
sleep 1

read -e -p "Enter source filepath (tab autocompletes path.  Source path undergodaddy is public_html subfolder): " backup_path
sudo -u www-data cp -rv $backup_path/* /srv/www/wordpress


apt-get install dos2unix
sudo -u www-data find /srv/www/wordpress/ -type f -print0 | sudo -u www-data xargs -0 dos2unix


printf "\n"
echo "Edit wp-config.php file to update user and password...................."
printf "\n"
sleep 1

sed -i "s/define( 'DB_NAME'.*/define( 'DB_NAME', 'wordpress' );/g" /srv/www/wordpress/wp-config.php
sed -i "s/define( 'DB_USER'.*/define( 'DB_USER', 'wordpress' );/g" /srv/www/wordpress/wp-config.php
sed -i "s/define( 'DB_PASSWORD'.*/define( 'PASSWORD', '$wp_password' );/g" /srv/www/wordpress/wp-config.php



if [ $pause_to_check_system_status -eq 1 ]
then
    printf "\n"
    echo "-------------------------------"
    echo "      SYSTEM STATUS CHECK"
    echo "-------------------------------"
    echo "To check status enter http://localhost in browser, preferably in private mode.  "
    echo "Wordpress login page should appear.  DON'T LOGIN YET, JUST FOR CHECKING AT THIS STAGE"
    printf "\n"
    read -p "Press any key to continue... " -n1 -s
    printf "\n\n"
fi




printf "\n"
echo "Import wordpress database ((previously backed up from live site)  into MYSQL...................."
printf "\n"
sleep 1

read -e -p "Enter source filepath (tab autocompletes path.  When prompted for password, this is your root password): " db_path
mysql -u root -p wordpress   <   $db_path

if [ $pause_to_check_system_status -eq 1 ]
then
    printf "\n"
    echo "-------------------------------"
    echo "      SYSTEM STATUS CHECK"
    echo "-------------------------------"
    echo "wordpress tables should show below if import was succsesful"
    printf "\n"
    mysql -e "USE wordpress;SHOW TABLES;" 
    printf "\n"
    read -p "Press any key to continue... " -n1 -s
    printf "\n\n"
fi


printf "\n"
echo "Update the URLs to refer to localhost...................."
printf "\n"
sleep 1

sql_filename="/srv/www/wordpress/temp_sql_url_update.sql"
read -p "Enter live website url in format www.example.com: " live_url

#Create the sql
echo "UPDATE wp_options SET option_value = replace(option_value, 'https://www.example.com', 'http://localhost') WHERE option_name = 'home' OR option_name = 'siteurl';
  
UPDATE wp_posts SET post_content = replace(post_content, 'https://www.example.com', 'http://localhost');
  
UPDATE wp_postmeta SET meta_value = replace(meta_value,'https://www.example.com','http://localhost');

UPDATE wp_options SET option_value = replace(option_value, 'https://www.example.com', 'http://localhost') WHERE option_name = 'home' OR option_name = 'siteurl';
  
UPDATE wp_posts SET post_content = replace(post_content, 'https://www.example.com', 'http://localhost');
  
UPDATE wp_postmeta SET meta_value = replace(meta_value,'https://www.example.com','http://localhost');" > $sql_filename


#Replace www.example.com with live site url
sed -i -e "s/www.example.com/${live_url}/g" $sql_filename

#Execute above sql to update from live url to localhost
mysql wordpress < $sql_filename


sudo service mysql restart
sudo service apache2 restart


echo "Log in with private mode browser at localhost/wp-admin.  User name and password is the same as that used for the live site wordpress login.  Go to Settings / Permalinks and click “Save Changes”. Even though no input change this fixes the link issues which occur when domain us moved to local.
Should now be able to enter private mode browser as localhost.  Links should work and there should be no redirect to the live site and restore environment should be up and running"

printf "\n"
read -p "Press any key to continue... " -n1 -s
printf "\n\n"