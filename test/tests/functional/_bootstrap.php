<?php
$_sTestsDirPath                 = getenv( 'WP_TESTS_DIR' );
// $_sSystemTempDirPath         = getenv( 'TEMP' ) ? getenv( 'TEMP' ) : '/tmp';
$GLOBALS['_sProjectDirPath']    = dirname( dirname( dirname( dirname( __FILE__ ) ) ) );
$_sTestSiteDirPath              = dirname( dirname( dirname( $GLOBALS['_sProjectDirPath'] ) ) );
if ( ! $_sTestsDirPath ) {
    $_sTestsDirPath = $_sTestSiteDirPath . '/wordpress-tests-lib';
}        

require_once $_sTestsDirath . '/includes/functions.php';
return;

function _loadPluginManually() {
	require $GLOBALS['_sProjectDirPath'] . '/sample-tdd-plugin.php';
}
tests_add_filter( 'muplugins_loaded', '_loadPluginManually' );

require $_sTestsDirPath . '/includes/bootstrap.php';

activate_plugin( 'sample-tdd-plugin/sample-tdd-plugin.php' );