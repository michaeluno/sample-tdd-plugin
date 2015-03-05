<?php
class SampleTDDPlugin_AdminPage extends SampleTDDPlugin_AdminPageFramework {
    
    /**
     * Sets up admin pages.
     */
    public function setUp() {

        $this->setRootMenuPage( 'Sample TDD' );    // where to belong
        $this->addSubMenuItem(
            array(
                'title'        => __( 'Sample TDD Plugin', 'sample-tdd-plugin' ),
                'page_slug'    => 'sample_tdd_plugin'
            )
        );

    }

    /**
     * Called in the middle of page rendering.
     * @callback        action      do_{page slug}
     */
    public function do_sample_tdd_plugin() {  
        ?>
        <h3>Sample TDD Plugin</h3>
        <p>This is a sample TDD plugin which does nothing!</p>
        <?php   
    }
    
}