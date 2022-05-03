#!/bin/bash

# Script should only be run as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script can only be run as root"
    exit
fi

backup_config_file="/etc/wordpres-backup.config"

#Store backup path in config file if config doesnt exist
if [ ! -f $backup_config_file ]; then
    read -e -p "Enter backup filepath (tab autocompletes path): " backup_path
    echo $backup_path > $backup_config_file   
fi