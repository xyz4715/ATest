/*******************************************************//**

@class		CWPartitionTest

@brief		Tests for CWPartition Class

	The CWPartitionTest class contains the test methods for the
	CWPartition class.

@author		Tim Smith (LiquidHub.TRS)

@version	2014-11-11	LiquidHub.TRS
	Created.

@see		CWPartition

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWPartitionTest
{
	/*******************************************************
					Constants
	*******************************************************/

	private static final String	FIELD_VALUE	= 'Test';
	private static final String	FIELD_NAME	= 'Name';

	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwPartitionUnitTest()
	{
		////	Begin Test
		CWTest testResults		= new CWTest( 'CWPartitionTest' );
		String testingMethod;

		testResults.startTest();

		////	Construct CWPartition
		CWPartition		partition	= new CWPartition( FIELD_NAME );
						partition	= new CWPartition( new List<Account>{ new Account( Name = FIELD_VALUE ) }, FIELD_NAME );
						partition	= new CWPartition( new CWIterable( ( Iterable<Object> ) new List<Account>{ new Account( Name = FIELD_VALUE ) } ), FIELD_NAME );

		////	keySet method test
		testingMethod				= 'keySet';
		Set<Object> 	keySet		= partition.keySet();

		////	keySet method test assertions
		testResults.assert
		(	testingMethod,
			keySet.contains( FIELD_VALUE ),
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	get method test
		testingMethod				= 'get';
		List<Account>	accounts	= partition.get( FIELD_VALUE );

		////	get method test assertions
		testResults.assert
		(	testingMethod,
			FIELD_VALUE,
			accounts[0].Name,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		testResults.stopTest();
		testResults.report();
	}
}