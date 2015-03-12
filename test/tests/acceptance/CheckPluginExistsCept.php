<?php 
$I = new AcceptanceTester( $scenario );
$I->wantTo( 'Check the existence of the demo plugin.' );
$I->amOnPage( '/wp-login.php' );
$I->fillField( 'Username', 'admin' );
$I->fillField( 'Password','admin' );
$I->click( 'Log In' );
$I->see( 'Dashboard' );
$I->click( 'Plugins');
$I->see( 'Sample TDD Plugin' );