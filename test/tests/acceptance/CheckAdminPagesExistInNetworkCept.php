<?php 
$scenario->group( 'multisite' );
$I = new AcceptanceTester( $scenario );

$I->wantTo( 'Check the existence of the network admin page of the plugin.' );
$I->amOnPage( '/wp-login.php' );
$I->fillField( 'Username', 'admin' );
$I->fillField( 'Password','admin' );
$I->click( 'Log In' );
$I->see( 'Dashboard' );

$I->amOnPage( '/wp-admin/network/admin.php?page=sample_tdd_plugin_network' );
$I->see( 'Network Sample TDD Plugin', 'h3' );
$I->see( 'This is a sample TDD plugin which does nothing!', 'p' );