<?php
/**
 * @group sample_test_plugin
 */
class Test_SampleTDDPlugin_AdminPage extends WP_UnitTestCase {
    
    public function setUp() {
        parent::setUp();
    }

    public function tearDown() {
        parent::tearDown();
    }

    public function test_methods_exist() {
        
        $_oAdminPage = new SampleTDDPlugin_AdminPage;
        $this->assertTrue( method_exists( $_oAdminPage, 'setUp' ) );
        $this->assertTrue( method_exists( $_oAdminPage, 'do_sample_tdd_plugin' ) );
        
    }
    
    public function test_method_return_values() {
        
        ob_start();
        $_oAdminPage = new SampleTDDPlugin_AdminPage;
        $_oAdminPage->do_sample_tdd_plugin();
        $_sOutput = ob_get_contents();
        $this->assertContains( 'Sample TDD Plugin', $_sOutput );
        ob_end_clean();        
        
    }
     
}