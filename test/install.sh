#!/usr/bin/env bash

# Script information
SCRIPT_NAME="WordPress Plugin The Test Suite Installer"
SCRIPT_VERSION="1.0.0"

# Scripts defining custom functions
source $(dirname $0)/include/download.sh
source $(dirname $0)/include/info.sh

# Parse arguments
CONFIGURATION_FILE_PATH="settings.cfg"

while getopts “ht:c:l:v:” OPTION
do
    case $OPTION in
        h)
            printUsage
            exit 1
            ;;
        v)
            printVersion
            exit 1
            ;;                 
        l)  
            echo "Setting the lod output directory path."
            COVERAGE_LOG_DIR_PATH=$OPTARG
            ;;            
        c)
            CONFIGURATION_FILE_PATH=$OPTARG
            ;;
        ?)
            printUsage
            exit 1
            ;;
    esac
done

# Configuration File
if [ ! -f "$CONFIGURATION_FILE_PATH" ]; then
    echo The setting file could not be loaded.
    exit 1
fi
source "$CONFIGURATION_FILE_PATH"
echo "Using the configuration file: $CONFIGURATION_FILE_PATH"

# Parse arguments again after including the configuration file
COVERAGE_LOG_DIR_PATH=
while getopts “l” OPTION
do
    case $OPTION in
        l)  
            COVERAGE_LOG_DIR_PATH=$OPTARG
            ;;

    esac
done

# Variables
WORKING_DIR=$(pwd)
if [[ -z "$PROJECT_DIR" ]]; then
    PROJECT_DIR=$(cd "$WORKING_DIR/.."; pwd)
    cd "$WORKING_DIR"
fi
TEMP=$([ -z "${TEMP}" ] && echo "/tmp" || echo "$TEMP")
WP_CLI="$TEMP/wp-cli.phar"
CODECEPT="$TEMP/codecept.phar"
C3="$TEMP/c3.php"

# convert any relative path or Windows path to linux/unix path to be usable for some path related commands such as basename
cd "$WP_TEST_DIR"
local WP_TEST_DIR=$(pwd)   
cd "$WORKING_DIR"

# Exit on errors, xtrace
# set -ex
set -x

downloadWPCLI() {

    download https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar "$WP_CLI"
    if [[ ! $(find "$WP_CLI" -type f -size +0c 2>/dev/null) ]]; then
        echo Could not download wp-cii.
        exit 1
    fi
    
}

installWordPress() {

    # Remove the destination folder if exists to perform a clean install
    rm -rf "$WP_TEST_DIR"

    # We use wp-cli command
    php "$WP_CLI" core download --force --path="$WP_TEST_DIR"
  
    # Change directory to the test WordPres install directory.
    cd "$WP_TEST_DIR"    
    
    rm -f wp-config.php
    php "$WP_CLI" core config --dbname=$DB_NAME --dbuser="$DB_USER" --dbpass="$DB_PASS" --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP
    
    # Renew the database table
    setup_database_table    

    # Create/renew the database
    php "$WP_CLI" core install --url="$WP_URL" --title="$WP_SITE_TITLE" --admin_user="$WP_ADMIN_USER_NAME" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL"
    
}
    setup_database_table(){

        if [[ -z "$DB_PASS" ]]; then
            DB_PASS="\"\""
        fi
        RESULT=`mysql -u$DB_USER -p$DB_PASS --skip-column-names -e "SHOW DATABASES LIKE '$DB_NAME'"`
        if [ "$RESULT" == "$DB_NAME" ]; then
            php "$WP_CLI" db drop --yes
        fi
    
        # mysql -u $DB_USER -p$DB_PASS -e --f "DROP $DB_NAME"
        # mysqladmin -u$#DB_USER -p$DB_PASS drop -f $DB_NAME
        php "$WP_CLI" db create
        
    }
    
# Installs WordPress test suites
installTestSuite() {

    # portable in-place argument for both GNU sed and Mac OSX sed
    if [[ $(uname -s) == 'Darwin' ]]; then
        local ioption='-i .bak'
    else
        local ioption='-i'
    fi
    
    # Download WordPress unit test suite library
    local WP_TEST_SUITES_TEMP_DIR="$TEMP/wordpress-tests-lib"
    mkdir -p "$WP_TEST_SUITES_TEMP_DIR"
    cd "$WP_TEST_SUITES_TEMP_DIR"
    svn co --quiet https://develop.svn.wordpress.org/trunk/tests/phpunit/includes/
        
    # Set up WordPress testing suite library
    cd "$WP_TEST_DIR"
    
    # Some paths written in wp-tests-config.php needs to be modified and on Windows systems, it is difficult to modify them to absolute path.
    # so in order to use dirname(), the test suites library needs to be placed close to the test site directory.
    local WP_TEST_SUITES_DIR="$(pwd)/wordpress-tests-lib"
    
    # Copy the downloaded files to the test WordPress site directory
    cp -r "$WP_TEST_SUITES_TEMP_DIR/" "$WP_TEST_DIR"
    
    # mkdir -p "$WP_TEST_SUITES_DIR"
    # cd "$WP_TEST_SUITES_DIR"
    # svn co --quiet https://develop.svn.wordpress.org/trunk/tests/phpunit/includes/

    # Make sure the configuration file does not exist.
    if [ -f "$WP_TEST_SUITES_DIR/wp-tests-config.php" ]; then
        rm -f "$WP_TEST_SUITES_DIR/wp-tests-config.php"        
    fi    
    download https://develop.svn.wordpress.org/trunk/wp-tests-config-sample.php "$WP_TEST_SUITES_DIR/wp-tests-config.php"
    
    # Edit the tests configuration file.
    cd "$WP_TEST_SUITES_DIR"
    sed $ioption "s:dirname( __FILE__ ) . '/src/':dirname( dirname( __FILE__ ) ) . '/':" wp-tests-config.php
    sed $ioption "s/youremptytestdbnamehere/$DB_NAME/" wp-tests-config.php
    sed $ioption "s/yourusernamehere/$DB_USER/" wp-tests-config.php
    sed $ioption "s/yourpasswordhere/$DB_PASS/" wp-tests-config.php
    sed $ioption "s|localhost|${DB_HOST}|" wp-tests-config.php
        
    # Set the environment variable which is accessed from the unit test bootstrap script.
    export WP_TESTS_DIR="$WP_TEST_SUITES_DIR"
    
}
    
# Uninstalls default plugins    
uninstallPlugins() {
    cd "$WP_TEST_DIR"
    php "$WP_CLI" plugin uninstall akismet
    php "$WP_CLI" plugin uninstall hello
}

# Installs the project plugin
installPlugin() {
    
    # Make sure no old file exists.
    if [ -d "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG" ]; then
        
        # Directly removing the directory sometimes fails saying it's not empty. So move it to a different location and then remove.
        mv -f "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG" "$TEMP/$PROJECT_SLUG"
        rm -rf "$TEMP/$PROJECT_SLUG"
        
        # Sometimes moving fails so remove the directory in case.
        rm -rf "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG"
        
    fi    
    
    # The `ln` command gives "Protocol Error" on Windows hosts so use the cp command.
    # The below cp command appends an asterisk to drop hidden items especially the .git directory but in that case, the destination directory needs to exist.
    mkdir -p "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG"
    # drop hidden files from being copied
    cp -r "$PROJECT_DIR/"* "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG"
    # rm -rf "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/.git" # Remove git system files.
 
    # wp cli command
    cd $WP_TEST_DIR
    php "$WP_CLI" plugin activate $PROJECT_SLUG
    
}

downloadCodeception() {

    download "http://codeception.com/codecept.phar" "$CODECEPT"        
    if [[ ! $(find "$CODECEPT" -type f -size +0c 2>/dev/null) ]]; then
        echo Could not download Codeception.
        exit 1
    fi
    download "https://raw.github.com/Codeception/c3/2.0/c3.php" "$C3"
    if [[ ! $(find "$C3" -type f -size +0c 2>/dev/null) ]]; then
        echo Could not download c3.php.
        exit 1
    fi    
    
}

installCodeception() {
    
    # Run the bootstrap to generate necessary files.
    php "$CODECEPT" bootstrap "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/test/"
    
    # Copy the bootstrap script of the unit tests.
    cp -r "$PROJECT_DIR/test/tests/unit/_bootstrap.php" "$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/test/tests/unit/_bootstrap.php"
    
    # If the output directory is not specified, do not enable coverage.
    ENABLE_COVERAGE="false"
    if [[ -z "$COVERAGE_LOG_DIR_PATH" ]]; then
        ENABLE_COVERAGE="true"
    fi
    
    # Create a acceptance setting file.
    FILE="$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/test/tests/acceptance.suite.yml"
    cat <<EOM >$FILE
class_name: ${TESTER_CLASS_PREFIX}AcceptanceTester
modules:
    enabled:
        - PhpBrowser
        - AcceptanceHelper
    config:
        PhpBrowser:
            url: '$WP_URL'
coverage:
    # acceptance tests fail if this value is true
    enabled: false            
EOM
   # Create a Codeception setting file
   FILE="$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/test/codeception.yml"
   cat <<EOM >$FILE
actor: ${TESTER_CLASS_PREFIX}Tester
paths:
    tests: tests
    log: tests/${COVERAGE_LOG_DIR_PATH}
    data: tests/_data
    helpers: tests/_support
settings:
    bootstrap: _bootstrap.php
    colors: true
    memory_limit: 1024M
modules:
    config:
        Db:
            dsn: 'mysql:host=$DB_HOST;dbname=$DB_NAME'
            user: '$DB_USER'
            password: '$DB_PASS'
            dump: 'tests/_data/dump.sql'
            populate: true
            cleanup: false
coverage:
    enabled: ${ENABLE_COVERAGE}
    whitelist:
        include: 
            - '../include/*'
        exlude:
            - '../library/*'
            - '../test/*'
    blacklist:
        exlude:
            - '../library/*'
            - '../test/*'
            - '*/library/*'
    # url of file which includes c3 router.
    # c3_url: '$WP_URL/'    
EOM
   
    # Make it load c3.php
    cp -r "$C3" "$WP_TEST_DIR/c3.php"
    cd "$WP_TEST_DIR"
    sed -i "s:<?php:<?php require( dirname( __FILE__ ) . '/c3.php' );:" index.php   
    
    # Create sub-directories used by c3
    mkdir -p "$WP_TEST_DIR/report"
    # mkdir -p "$WP_TEST_DIR/report/clover"
    # mkdir -p "$WP_TEST_DIR/report/serialized"
    # mkdir -p "$WP_TEST_DIR/report/html"
    # mkdir -p "$WP_TEST_DIR/report/clean"
    mkdir -p "$WP_TEST_DIR/c3tmp"   
    
}

# Download necessary applications
downloadWPCLI
downloadCodeception

# Install components
installWordPress
installTestSuite
uninstallPlugins
installPlugin
installCodeception

echo Installation has been complete!
$SHELL