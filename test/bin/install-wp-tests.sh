#!/usr/bin/env bash

if [ -f install-wp-tests.cfg ]; then
    source install-wp-tests.cfg
fi

DB_NAME=${1-$DB_NAME}
DB_USER=${2-$DB_USER}
DB_PASS=${3-$DB_PASS}
DB_HOST=${4-localhost}
WP_VERSION=${5-latest}

WP_TESTS_DIR=${WP_TESTS_DIR-$TEMP/wordpress-tests-lib}
TEMP=$([ -z "${TEMP}" ] && echo "/tmp" || echo "$TEMP")
WP_CORE_DIR=$TEMP/wordpress/

if [ -z "${DB_NAME}" ] || [ -z "${DB_USER}" ] ; then
    echo "usage: $0 <db-name> <db-user> <db-pass> [db-host] [wp-version]"
    exit 1
fi

set -ex

download() {
    
    # If file exists return
    if [ -f "$2" ]; then
        echo "Download: Using the cached file."
        return
    fi

    if [ `which curl` ]; then
        curl -s "$1" > "$2";
    elif [ `which wget` ]; then
        wget -nv -O "$2" "$1"
    fi
}
install_wp() {
    mkdir -p $WP_CORE_DIR

    if [ $WP_VERSION == 'latest' ]; then 
        local ARCHIVE_NAME='latest'
    else
        local ARCHIVE_NAME="wordpress-$WP_VERSION"
    fi

    download https://wordpress.org/${ARCHIVE_NAME}.tar.gz  $TEMP/wordpress.tar.gz
    tar --strip-components=1 -zxmf $TEMP/wordpress.tar.gz -C $WP_CORE_DIR

    download https://raw.github.com/markoheijnen/wp-mysqli/master/db.php $WP_CORE_DIR/wp-content/db.php
    
}

install_test_suite() {
    # portable in-place argument for both GNU sed and Mac OSX sed
    if [[ $(uname -s) == 'Darwin' ]]; then
        local ioption='-i .bak'
    else
        local ioption='-i'
    fi

    # set up testing suite
    mkdir -p $WP_TESTS_DIR
    cd $WP_TESTS_DIR
    svn co --quiet https://develop.svn.wordpress.org/trunk/tests/phpunit/includes/

    
    # If file exists return
    if [ -f "$WP_TESTS_DIR/wp-tests-config.php" ]; then
        rm -f "$WP_TESTS_DIR/wp-tests-config.php"        
    fi    
    download https://develop.svn.wordpress.org/trunk/wp-tests-config-sample.php $WP_TESTS_DIR/wp-tests-config.php
    sed $ioption "s:dirname( __FILE__ ) . '/src/':getenv( 'TEMP' ) . '/wordpress/':" wp-tests-config.php
    sed $ioption "s/youremptytestdbnamehere/$DB_NAME/" wp-tests-config.php
    sed $ioption "s/yourusernamehere/$DB_USER/" wp-tests-config.php
    sed $ioption "s/yourpasswordhere/$DB_PASS/" wp-tests-config.php
    sed $ioption "s|localhost|${DB_HOST}|" wp-tests-config.php
}


install_db() {
	# parse DB_HOST for port or socket references
	local PARTS=(${DB_HOST//\:/ })
	local DB_HOSTNAME=${PARTS[0]};
	local DB_SOCK_OR_PORT=${PARTS[1]};
	local EXTRA=""
    
	if ! [ -z $DB_HOSTNAME ] ; then
		# if [[ "$DB_SOCK_OR_PORT" =~ ^[0-9]+$ ]] ; then # =~ is not available on some systems
        if echo $DB_SOCK_OR_PORT | grep -E '^[0-9]+$' > /dev/null ; then
			EXTRA=" --host=$DB_HOSTNAME --port=$DB_SOCK_OR_PORT --protocol=tcp"
		elif ! [ -z $DB_SOCK_OR_PORT ] ; then
			EXTRA=" --socket=$DB_SOCK_OR_PORT"
		elif ! [ -z $DB_HOSTNAME ] ; then
			EXTRA=" --host=$DB_HOSTNAME --protocol=tcp"
		fi
	fi

	# create database
	mysqladmin create $DB_NAME --user="$DB_USER" --password="$DB_PASS"$EXTRA
    
}

install_wp
install_test_suite
install_db