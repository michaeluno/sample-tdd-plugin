<?php
/**
 * @group sample_test_plugin
 */
class Test_Function extends WP_UnitTestCase {
    
    public function setUp() {
        parent::setUp();
    }

    public function tearDown() {
        parent::tearDown();
    }

    public function test_funciton() {

        $_mUnknownValue = getSampleTDDValue( true );
        $this->assertEquals( true, $_mUnknownValue );
        
    }
    
}    