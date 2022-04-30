#!/bin/bash

#Set 1 to pause to allow system status, 0 to proceed without checks
pause_to_check_system_status=1

printf "\n"
echo "Updating system...................."
printf "\n"
sleep 2

sudo apt-get update
sudo apt-get upgrade


printf "\n"
echo "Installing apache...................."
printf "\n"
sleep 2

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