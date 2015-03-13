<?php
/* 
 * Plugin Name: Sample TDD Plugin 
 * Plugin Author: Michael Uno
 * Version:     0.0.2
 */

function getSampleTDDValue( $mValue ) {
    return $mValue;
}

/**
 * The base class of the main sample class.
 */
class SampleTDDPlugin_Base {
    const NAME      = 'Sample TDD Plugin';
    const VERSION   = '0.0.1';
}

/**
 * Sample class.
 */
class SampleTDDPlugin extends SampleTDDPlugin_Base {
    
    public function get( $mValue ) {
        return $mValue;
    }
    public function render() {
        echo "<p>" . $this->get( 'A' ) . $this->get( 'B' ) . "</p>";
    }
    
}

function _loadSampleTDDPlugin() {
    if ( ! class_exists( 'AdminPageFramework' ) ) {
        return;
    }
    include( dirname( __FILE__ ) . '/include/class/SampleTDDPlugin_AdminPage.php' );
    include( dirname( __FILE__ ) . '/include/class/SampleTDDPlugin_NetworkAdminPage.php' );
    new SampleTDDPlugin_AdminPage;
    new SampleTDDPlugin_NetworkAdminPage;
}
add_action( 'plugins_loaded', '_loadSampleTDDPlugin' );