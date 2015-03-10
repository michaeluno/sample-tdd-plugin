#!/usr/bin/env bash

# Include the configuration file.
if [ ! -f settings.cfg ]; then
    echo The setting file could not be loaded.
    exit 1
fi
source settings.cfg

# Exit on errors, xtrace
set -ex 
# set -x

uninstall_wordpress() {
    if [ -d "$WP_TEST_DIR" ]; then
    
        # Sometimes the directory cannot be removed. In that case attempt to move it to a different location
        # mv -f "$WP_TEST_DIR" "$TEMP/test-$PROJECT_SLUG"
        # rm -rf "$TEMP/test-$PROJECT_SLUG"
        
        # Sometimes the directory cannot be moved. In that case just delete it.
        rm -rf "$WP_TEST_DIR"
        
    fi
    if [ -d "$WP_TEST_DIR" ]; then
        echo "The directory could not be removed: $WP_TEST_DIR"
    fi
}
uninstall_database_table(){

    if [[ -z "$DB_PASS" ]]; then
        DB_PASS="\"\""
    fi
    RESULT=`mysql -u$DB_USER --password=$DB_PASS --skip-column-names -e "SHOW DATABASES LIKE '$DB_NAME'"`
    if [ "$RESULT" == "$DB_NAME" ]; then
        mysqladmin -u$DB_USER -p$DB_PASS drop $DB_NAME --force
    fi
        
}


# Call functions
uninstall_database_table
uninstall_wordpress
echo Uninstallation has been complete!