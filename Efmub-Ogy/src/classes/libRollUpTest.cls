/*******************************************************//**

@class		CWRollUpTest

@brief		Tests for CW Core Framework Roll-Up Class

	This class computes roll-up summary values from a collection
	of sObjects.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-08-06	LiquidHub.GHA
	Created.
@version	2014-09-24	LiquidHub.GHA
	Reworked to use CWProcessor.

@todo		Increase CWRollupTest coverage to 100%.

@see		CWRollUp

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWRollUpTest
{
	static List<CWTestObject__c> testObjects = new List<CWTestObject__c>
	{	new CWTestObject__c( Number_8_0__c = null ),
		new CWTestObject__c( Number_8_0__c = 1 ),
		new CWTestObject__c( Number_8_0__c = 2 ),
		new CWTestObject__c( Number_8_0__c = 3 ),
		new CWTestObject__c( Number_8_0__c = 4 ),
		new CWTestObject__c( Number_8_0__c = 5 )
	};

	static testMethod void testCWRollUp()
	{
		CWTest	testResults		= new CWTest( 'CWRollUpTest' );

		testResults.startTest();

		testResults.assert
		(	'CWRollUp.count',
			5,
			CWRollUp.count( testObjects, 'Number_8_0__c' ),
			'CWRollUp.count returned the wrong value.'
		);

		testResults.assert
		(	'CWRollUp.sum',
			15,
			CWRollUp.sum( testObjects, 'Number_8_0__c' ),
			'CWRollUp.sum returned the wrong value.'
		);

		testResults.assert
		(	'CWRollUp.average',
			3,
			CWRollUp.average( testObjects, 'Number_8_0__c' ),
			'CWRollUp.average returned the wrong value.'
		);

		testResults.assert
		(	'CWRollUp.minimum',
			1,
			CWRollUp.minimum( testObjects, 'Number_8_0__c' ),
			'CWRollUp.minimum returned the wrong value.'
		);

		testResults.assert
		(	'CWRollUp.maximum',
			5,
			CWRollUp.maximum( testObjects, 'Number_8_0__c' ),
			'CWRollUp.maximum returned the wrong value.'
		);

		testResults.stopTest();
		testResults.report();
	}
}