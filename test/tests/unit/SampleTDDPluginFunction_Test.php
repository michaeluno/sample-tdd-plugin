<?php

/**
 * @group sample_test_plugin
 */

class SampleTDDPluginFunction_Test extends \Codeception\TestCase\Test
{
    /**
     * @var \UnitTester
     */
    protected $tester;

    protected function _before() {
        
        $GLOBALS['_sProjectDirPath'] = dirname( dirname( dirname( dirname( __FILE__ ) ) ) );
        include_once( $GLOBALS['_sProjectDirPath'] . '/include/function/functions.php' );        
        
    }

    protected function _after()
    {
    }

    // tests
    public function testFunctions() {

        $this->assertEquals( __METHOD__, getSampleTDDValue( __METHOD__ ) );
        
    }
    
 
}
