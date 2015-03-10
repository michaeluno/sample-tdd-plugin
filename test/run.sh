#!/usr/bin/env bash

SCRIPT_NAME="WordPress Plugin The Test Suite Script Executor"
SCRIPT_VERSION="1.0.0"

# Include scripts defining functions
source $(dirname $0)/include/download.sh
source $(dirname $0)/include/info.sh


# Parse arguments
CONFIGURATION_FILE_PATH="settings.cfg"
while getopts “ht:c:v” OPTION
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
        c)
            CONFIGURATION_FILE_PATH=$OPTARG
            ;;
        l)  
            COVERAGE_LOG_DIR_PATH=$OPTARG
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

# Set up variables 
TEMP=$([ -z "${TEMP}" ] && echo "/tmp" || echo "$TEMP")
CODECEPT="$TEMP/codecept.phar"

# convert any Windows path to linux/unix path to be usable for some path related commands such as basename
cd "$WP_TEST_DIR"
WP_TEST_DIR=$(pwd)   
CODECEPT_TEST_DIR="$WP_TEST_DIR/wp-content/plugins/$PROJECT_SLUG/test"

echo "$PROJECT_SLUG"
echo "$CODECEPT_TEST_DIR"

# Make sure Codeception is installed
download http://codeception.com/codecept.phar "$CODECEPT"

# Run tests
# @usage    php codecept run -c /path/to/my/project
# @see      http://codeception.com/install

# Run acceptance tests 
# The --coverage option causes an error with acceptance and functional tests. So do them separately.
# @see  https://github.com/Codeception/Codeception/issues/515
# php "$CODECEPT" run acceptance --steps --colors --config="$CODECEPT_TEST_DIR"
php "$CODECEPT" run acceptance --steps --colors --config="$CODECEPT_TEST_DIR"

# Run unit tests
# @bug the --steps option makes the coverage not being generated
php "$CODECEPT" run unit --colors --coverage-xml --config="$CODECEPT_TEST_DIR"

echo "Tests has completed!"