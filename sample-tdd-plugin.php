<?php
/* 
 * Plugin Name: Sample TDD Plugin 
 * Version:     0.0.1
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

include( dirname( __FILE__ ) . '/library/admin-page-framework/admin-page-framework.php' );
include( dirname( __FILE__ ) . '/include/class/SampleTDDPlugin_AdminPage.php' );

function _loadSampleTDDPlugin() {
    new SampleTDDPlugin_AdminPage;
}
add_action( 'plugins_loaded', '_loadSampleTDDPlugin' );