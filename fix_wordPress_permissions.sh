#!/bin/bash

# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# @Author ieselisra
# https://github.com/ieselisra/wordpress_fix_permissions_debian10/new/main
#

echo '|---------------------------------------------|'
echo '|   WordPress Permission Reparation Script   |'
echo '|---------------------------------------------|'
echo ''


while true
 do

    # Default variable values (set as www-data)
    configUser_asWwwData='y'
    configGroup_asWwwData='y'


    # Variables
    ## Change "www-data" for your default http user:group
    ## The user will be asked later for a different desired user:group
    wordPress_desiredOwner=www-data # <-- wordpress owner DEFAULT 
    wordPress_desiredGroup=www-data # <-- wordpress group DEFAULT
    webServer_defaultGroup=www-data # <-- webserver group APACHE DEFAULT
    
    # Ask for the objective absolute path
    # Reset if no path was introduced
    echo 'Where`s your WordPress installation? (0 to close) '
    while true
    do
        read -e -p 'Path:' wordPress_rootFolder
        if [ ! $wordPress_rootFolder == '' ]
        then
            break
        else
            echo 'The Path can´t be empty ' $wordPress_rootFolder
        fi
    done

    # If wordPress_rootFolder = 0, close
    if [ $wordPress_rootFolder == 0 ]
    then
           break
    fi

    
    # Ask for desired User (leaving it blank means "Y", also www-data)
    read -e -p 'Config User as www-data: (Y/n ): ' configUser_asWwwData
    
    ## If desired User isn't www-data, ask for the desired User
    if [ $configUser_asWwwData = n ] 
    then
            read -e -p '	Desired OWNER : ' wordPress_desiredOwner
    fi
    

    # Ask for desired Group (leaving it blank means "Y", also www-data)
    read -e -p 'Config Group as :www-data?? (Y/n): ' configGroup_asWwwData

    ## If desired Group isn't www-data, ask for desired Group
    if [ $configGroup_asWwwData = n ]
    then
            read -e -p '	Desired GROUP : ' wordPress_desiredGroup
    fi

    
    
    # So, let's take the proper actions

    ## Step 1: chown desiredOwner:desiredGroup (OR www-data:www-data)
    echo '::STEP 1/5:: Setting new Owner ( '${wordPress_desiredOwner}':'${wordPress_desiredGroup}' )'
    sudo find ${wordPress_rootFolder} -exec chown ${wordPress_desiredOwner}:${wordPress_desiredGroup} {} \;

    ## Step 2: Set Permissions
    echo '::STEP 2/5:: Set Permissions: 755 to dirs and 644 to Files'
    sudo find ${wordPress_rootFolder} -type d -exec chmod 755 {} \;
    sudo find ${wordPress_rootFolder} -type f -exec chmod 644 {} \;

    ## Step 3: Allow WordPress to manage wp-config.php (preventing world access)
    echo '::STEP 3/5:: wp-config.php : Preventing world access (660)'
    sudo chgrp ${webServer_defaultGroup} ${wordPress_rootFolder}/wp-config.php
    sudo chmod 660 ${wordPress_rootFolder}/wp-config.php

    ## Step 4: Allow WordPress to manage wp-content
    echo '::STEP 4/5:: Allow WordPress to manage wp-content (Dirs to 755 & Files to 664)'
    sudo find ${wordPress_rootFolder}/wp-content -exec chgrp ${webServer_defaultGroup} {} \;
    sudo find ${wordPress_rootFolder}/wp-content -type d -exec chmod 775 {} \;
    sudo find ${wordPress_rootFolder}/wp-content -type f -exec chmod 664 {} \;

    ## Step 5: privatize wp-content 
    echo '::STEP 5/5:: Privatize /wp-content (Set 755)'
    sudo chmod 755 /$wordPress_rootFolder/wp-content

    echo '| ---------------------------------------------------  |'
    echo '|                  PERMISSIONS FIXED                   |'
    echo '| ---------------------------------------------------  |'
    echo ' '
    echo 'Do you want to fix another WordPress installation?'
done

echo '|----------------------|'
echo '|        CLOSING       |'
echo '|----------------------|'
