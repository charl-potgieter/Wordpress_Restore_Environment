#!/bin/bash

# Geth the login user (need to factor in script may be running as sudo)
# https://www.baeldung.com/linux/identify-user-called-by-sudo
loginuser=${SUDO_USER:-$USER}
echo $loginuser


# Get login user home path
# https://superuser.com/questions/484277/get-home-directory-by-username
loginuserhome=$( getent passwd $loginuser | cut -d: -f6 )
echo $loginuserhome