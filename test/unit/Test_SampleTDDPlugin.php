<?php
/**
 * @group sample_test_plugin
 */
class Test_SampleTDDPlugin extends WP_UnitTestCase {
    
    public function setUp() {
        parent::setUp();
    }

    public function tearDown() {
        parent::tearDown();
    }

    public function test_constants() {

        $this->assertEquals( 'Sample TDD Plugin', SampleTDDPlugin::NAME );
        
    }
    
    public function test_method_return_values() {
        
        $_oSampleTDDPlugin = new SampleTDDPlugin;
        $this->assertEquals( 
            'A', 
            $_oSampleTDDPlugin->get( 'A' ) 
        );
        
    }
    
    public function test_method_output() {

        $_oSampleTDDPlugin = new SampleTDDPlugin;
        $this->expectOutputString( '<p>AB</p>' );
        print $_oSampleTDDPlugin->render();
        
    }
    
}    