/*******************************************************//**

@class		FlightLegHandlerTest

@brief		Test Class for the FlightLegHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		FlightLegHandler
@see		FlightLeg (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class FlightLegHandlerTest
{
	public static testMethod void testFlightLegHandler()
	{
		CWTest testResults = new CWTest( 'testFlightLegHandler' );

		Flight_Leg__c	flightLeg	= new Flight_Leg__c();

		testResults.startTest();

		insert flightLeg;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}