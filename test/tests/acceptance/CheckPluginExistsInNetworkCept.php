<?php 
$scenario->group( 'multisite' );
$I = new AcceptanceTester( $scenario );

$I->wantTo( 'Check the existence of the plugin in the network admin.' );
$I->amOnPage( '/wp-login.php' );
$I->fillField( 'Username', 'admin' );
$I->fillField( 'Password','admin' );
$I->click( 'Log In' );
$I->see( 'Dashboard' );

$I->amOnPage( '/wp-admin/network' );
$I->click( 'Plugins');
$I->see( 'Sample TDD Plugin' );