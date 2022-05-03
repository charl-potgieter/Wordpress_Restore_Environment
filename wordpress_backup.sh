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
else
    backup_path=$(head -n 1 $backup_config_file)
    read -p "Backing up to $backup_path, y to continue any other key to change: " path_choice
    if [ $path_choice != "y" ]; then
        read -e -p "Enter backup filepath (tab autocompletes path): " backup_path
        echo $backup_path > $backup_config_file
    fi
fi

backup_path=$(head -n 1 $backup_config_file)
mkdir -p $backup_path/files
mkdir -p $backup_path/database