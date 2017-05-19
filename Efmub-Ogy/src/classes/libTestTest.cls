/*******************************************************//**

@class		CWTestTest

@brief		Test class for CW Core Test Support Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-10-22	LiquidHub.GHA
	Created from test method originally in CWTest.
@version	2014-11-20	LiquidHub.GHA
	Now tests the exception testing methods.

@todo:	Test the TestErrorHandler, 'startTest' and 'stopTest'.

@see		CWTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWTestTest
{
	/*******************************************************
				testCWTest test method
	*******************************************************/

	static testMethod void testCWTest()
	{
		CWTest	testResult	= new CWTest( 'CWTest::testCWTest' );

		CWTest	beingTested	= new CWTest( 'CWTest' );

		beingTested.testingThis	= true;

		beingTested.assert( 'Test 1',	true,	'Test 1 failed.' );
		beingTested.assert( 'Test 2',	false,	'Test 2 failed.' );
		beingTested.assert( 'Test 3',	true );
		beingTested.assert( 'Test 4',	false );
		beingTested.assert( 'Test 5',	0, 0,	'Test 5 failed.' );
		beingTested.assert( 'Test 6',	0, 1,	'Test 6 failed.' );
		beingTested.assert( 'Test 7',	0, 0 );
		beingTested.assert( 'Test 8',	0, 1 );
		beingTested.annotate( 'Annotation' );
		beingTested.fail( 'Failure' );

		testResult.assert
		(	'test report with names',
			'\nCWTest Failed\n'
		+	'Passed: Test 1\n'
		+	'Failed: Test 2\n'
		+	'- Test 2 failed.\n'
		+	'Passed: Test 3\n'
		+	'Failed: Test 4\n'
		+	'Passed: Test 5\n'
		+	'Failed: Test 6\n'
		+	'- Test 6 failed.\n'
		+	'-   Expected: 0\n'
		+	'-   Actual:   1\n'
		+	'Passed: Test 7\n'
		+	'Failed: Test 8\n'
		+	'-   Expected: 0\n'
		+	'-   Actual:   1\n'
		+	'Passed: Annotation\n'
		+	'Failed: Failure\n',
			beingTested.report()
		);

		beingTested	= new CWTest();

		beingTested.testingThis	= true;

		beingTested.assert( null,	true,	'Test 1 failed.' );
		beingTested.assert( null,	false,	'Test 2 failed.' );
		beingTested.assert( null,	true );
		beingTested.assert( null,	false );
		beingTested.assert( null,	0, 0,	'Test 5 failed.' );
		beingTested.assert( null,	0, 1,	'Test 6 failed.' );
		beingTested.assert( null,	0, 0 );
		beingTested.assert( null,	0, 1 );
		beingTested.annotate( null );
		beingTested.fail( null );

		testResult.assert
		(	'test report without names',
			'\nUnnamed Test Method Failed\n'
		+	'Passed: Unnamed Test\n'
		+	'Failed: Unnamed Test\n'
		+	'- Test 2 failed.\n'
		+	'Passed: Unnamed Test\n'
		+	'Failed: Unnamed Test\n'
		+	'Passed: Unnamed Test\n'
		+	'Failed: Unnamed Test\n'
		+	'- Test 6 failed.\n'
		+	'-   Expected: 0\n'
		+	'-   Actual:   1\n'
		+	'Passed: Unnamed Test\n'
		+	'Failed: Unnamed Test\n'
		+	'-   Expected: 0\n'
		+	'-   Actual:   1\n'
		+	'Passed: Unnamed Test\n'
		+	'Failed: Unnamed Test\n',
			beingTested.report()
		);

		testResult.report();
	}

	/*******************************************************
			testCWTestErrorHandler test method
	*******************************************************/

	static testMethod void testCWTestErrorHandler()
	{
		CWTest	testResult	= new CWTest( 'CWTest::testCWTestErrorHandler' );

		CWTest	beingTested	= new CWTest( 'CWTest' );

		beingTested.testingThis	= true;

		beingTested.StartTest();

		CWException.error( 'CWTest error' );
		testResult.assert( 'test that there is an error', beingTested.checkErrors() );
		testResult.assert( 'test that it is the correct error', beingTested.lastErrorStartsWith( 'CWTest' ) );
		testResult.assert( 'test that it is the entire error', beingTested.getErrorString().equals( 'CWTest error' ) );
		beingTested.clearErrors();
		testResult.assert( 'test that there is no error', !beingTested.checkErrors() );

		beingTested.StopTest();

		testResult.report();
	}

	/*******************************************************
			testCWTestThrowException test method
	*******************************************************/

	static testMethod void testCWTestThrowException()
	{
		CWTest	testResult	= new CWTest( 'CWTest::testCWTestThrowException' );

		CWTest	beingTested	= new CWTest( 'CWTest' );

		beingTested.testingThis	= true;

		beingTested.enableExceptions( new Set<String>{ 'firstException', 'secondException' } );

		Boolean	caughtException;

		caughtException = false;
		try { CWTest.throwExceptions( new Set<String>{ 'firstException' } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test firstException', caughtException );

		caughtException = false;
		try { CWTest.throwExceptions( new Map<String,Object>{ 'secondException' => CWException.class } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test secondException', caughtException );

		beingTested.disableExceptions( new Set<String>{ 'firstException' } );

		caughtException = false;
		try { CWTest.throwExceptions( new Set<String>{ 'firstException' } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test firstException', !caughtException );

		caughtException = false;
		try { CWTest.throwExceptions( new Map<String,Object>{ 'secondException' => CWException.class } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test secondException', caughtException );

		beingTested.replaceException( 'secondException', 'firstException' );

		caughtException = false;
		try { CWTest.throwExceptions( new Set<String>{ 'firstException' } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test firstException', caughtException );

		caughtException = false;
		try { CWTest.throwExceptions( new Map<String,Object>{ 'secondException' => CWException.class } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test secondException', !caughtException );

		beingTested.clearExceptions();

		caughtException = false;
		try { CWTest.throwExceptions( new Set<String>{ 'firstException' } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test firstException', !caughtException );

		caughtException = false;
		try { CWTest.throwExceptions( new Map<String,Object>{ 'secondException' => CWException.class } ); }
		catch ( Exception theException ) { caughtException = true; }
		testResult.assert( 'test secondException', !caughtException );

		testResult.report();
	}
}