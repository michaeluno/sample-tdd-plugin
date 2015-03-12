<?php 
$I = new AcceptanceTester( $scenario );
$I->wantTo( 'Login to WordPress.' );
$I->amOnPage( '/wp-login.php' );
$I->fillField( 'Username', 'admin' );
$I->fillField( 'Password','admin' );
$I->click( 'Log In' );
$I->see( 'Dashboard' );

$I->wantTo( 'Check the existence of the custom post type post listing page of the demo plugin.' );
$I->amOnPage( '/wp-admin/admin.php?page=sample_tdd_plugin' );
$I->see( 'Sample TDD Plugin', 'h2' );
$I->see( 'This is a sample TDD plugin which does nothing!', 'p' );