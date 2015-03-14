<?php
/**
 * Manually include the bootstrap script as Codeception bootstrap runs after loading this file.
 * @see https://github.com/Codeception/Codeception/issues/862
 */
include_once( dirname( __FILE__ ) . '/_bootstrap.php' );
/**
 * @group sample_test_plugin
 */
class SampleTDDPlugin_AdminPage_Test extends WP_UnitTestCase {
    
    public function setUp() {
        parent::setUp();
    }

    public function tearDown() {
        parent::tearDown();
    }

    public function testMethodsExist() {
        
        $_oAdminPage = new SampleTDDPlugin_AdminPage;
        $this->assertTrue( method_exists( $_oAdminPage, 'setUp' ) );
        $this->assertTrue( method_exists( $_oAdminPage, 'do_sample_tdd_plugin' ) );
        
    }
    
    public function testSetUpReturnValue() {
        
        $_oAdminPage = new SampleTDDPlugin_AdminPage;
        $this->assertEquals( null, $_oAdminPage->setUp() );
        
    }        
    
    public function testMethodReturnValues() {
        
        ob_start();
        $_oAdminPage = new SampleTDDPlugin_AdminPage;
        $_oAdminPage->do_sample_tdd_plugin();
        $_sOutput = ob_get_contents();
        $this->assertContains( 'Sample TDD Plugin', $_sOutput );
        ob_end_clean();        
        
    }
     
}