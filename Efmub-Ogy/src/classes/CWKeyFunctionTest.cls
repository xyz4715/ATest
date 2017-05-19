/*******************************************************//**

@class		CWKeyFunctionTest

@brief		Tests for CWKeyFunction Class

	The CWKeyFunctionTest class contains the test methods for the
	CWKeyFunction class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-12-17	LiquidHub.GHA
	Created.

@see		CWKeyFunction

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWKeyFunctionTest
{
	private class KeyFunctionTest extends CWKeyFunction
	{
		public override Object getKey( sObject theRecord )
		{
			return	theRecord.get( 'Text_40__c' );
		}
	}

	static testMethod void testKeyFunction()
	{
		List<CWTestObject__c>	testObjects		= new List<CWTestObject__c>
		{
			new CWTestObject__c( Text_40__c = 'A' ),
			new CWTestObject__c( Text_40__c = 'B' ),
			new CWTestObject__c( Text_40__c = 'C' ),
			new CWTestObject__c( Text_40__c = 'D' )
		};

		(new CWIterable( (Iterable<Object>) testObjects, (CWFunction) new KeyFunctionTest() )).toList();
	}
}