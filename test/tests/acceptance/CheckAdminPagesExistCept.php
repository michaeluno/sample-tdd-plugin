<?php 
$I = new AcceptanceTester( $scenario );
$I->wantTo( 'Check the existence of the admin setting page of the plugin.' );

$I->amOnPage( '/wp-login.php' );
$I->fillField( 'Username', 'admin' );
$I->fillField( 'Password','admin' );
$I->click( 'Log In' );
$I->see( 'Dashboard' );

$I->amOnPage( '/wp-admin/admin.php?page=sample_tdd_plugin' );
$I->see( 'Sample TDD Plugin', 'h2' );
$I->see( 'This is a sample TDD plugin which does nothing!', 'p' );