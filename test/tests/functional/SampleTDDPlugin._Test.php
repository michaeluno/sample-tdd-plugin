<?php
/**
 * Manually include the bootstrap script as Codeception bootstrap runs after loading this file.
 * @see https://github.com/Codeception/Codeception/issues/862
 */
include_once( dirname( __FILE__ ) . '/_bootstrap.php' );
/**
 * @group sample_test_plugin
 */
class SampleTDDPlugin_Test extends \WP_UnitTestCase {
    
    public function setUp() {
        parent::setUp();
    }

    public function tearDown() {
        parent::tearDown();
    }

    public function testConstants() {

        $this->assertEquals( 'Sample TDD Plugin', SampleTDDPlugin::NAME );
        
    }
    
    public function testMethodReturnValue() {
        
        $_oSampleTDDPlugin = new SampleTDDPlugin;
        $this->assertEquals( 
            'A', 
            $_oSampleTDDPlugin->get( 'A' ) 
        );
        
    }
    
    public function testMethodOutput() {

        $_oSampleTDDPlugin = new SampleTDDPlugin;
        $this->expectOutputString( '<p>AB</p>' );
        print $_oSampleTDDPlugin->render();
        
    }
    
}    