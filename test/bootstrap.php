<?php
$_sTestsDirPath = getenv( 'WP_TESTS_DIR' );
if ( ! $_sTestsDirPath ) {
    $_sTestsDirPath = getenv( 'TEMP' ) . '/wordpress-tests-lib';
}        

require_once $_sTestsDirPath . '/includes/functions.php';

function _loadPluginManually() {
	require dirname( dirname( __FILE__ ) ) . '/sample-tdd-plugin.php';
}
tests_add_filter( 'muplugins_loaded', '_loadPluginManually' );

require $_sTestsDirPath . '/includes/bootstrap.php';

activate_plugin( 'sample-tdd-plugin/sample-tdd-plugin.php' );