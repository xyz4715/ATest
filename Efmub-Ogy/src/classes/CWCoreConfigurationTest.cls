/*******************************************************//**

@class		CWCoreConfigurationTest

@brief		CW Core Configuration Test Class

	Test class for the CWCoreConfiguration class.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-10-16	LiquidHub.GHA
	Created.

@see		CWCoreConfiguration

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWCoreConfigurationTest
{
	static testMethod void testCWCoreConfiguration()
	{
		CWTest	testResults		= new CWTest( 'testCWCoreConfiguration' );
		String	testingMethod	= 'CWCoreConfiguration.get';

		testResults.startTest();

		testResults.assert
		(	testingMethod + ' - Positive',
			CWCoreConfiguration.get( 'Default_ErrorHandler__c' ) == 'CWException.ThrowError',
			testingMethod + ' returned the wrong value\n'
		);

		testResults.clearErrors();
		testResults.assert
		(	testingMethod + ' - Negative',
			CWCoreConfiguration.get( 'NotAField' ) == null
		&&	testResults.checkErrors()
		&&	testResults.lastErrorStartsWith( testingMethod ),
			testingMethod + ' did not error with a bad field name\n'
		);

		testResults.assert
		(	testingMethod + ' - Positive with Fallback',
			CWCoreConfiguration.get( 'Default_ErrorHandler__c', 'TestString' ) == 'CWException.ThrowError',
			testingMethod + ' returned the wrong value\n'
		);

		testResults.assert
		(	testingMethod + ' - Negative with Fallback',
			CWCoreConfiguration.get( 'NotAField', 'TestString' ) == 'TestString',
			testingMethod + ' did not return the fallback value\n'
		);

		testResults.stopTest();
		testResults.report();
	}
}