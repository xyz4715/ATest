/*******************************************************//**

@class		DelayCodeHandlerTest

@brief		Test Class for the DelayCodeHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		DelayCodeHandler
@see		DelayCode (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class DelayCodeHandlerTest
{
	public static testMethod void testDelayCodeHandler()
	{
		CWTest testResults = new CWTest( 'testDelayCodeHandler' );

		Flight_Leg__c	flightLeg	= new Flight_Leg__c();
		insert flightLeg;

		Delay_Code__c	delayCode	= new Delay_Code__c
		(	Flight_Leg__c	= flightLeg.Id
		);

		testResults.startTest();

		insert delayCode;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}