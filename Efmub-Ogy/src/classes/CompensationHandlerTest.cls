/*******************************************************//**

@class		CompensationHandlerTest

@brief		Test Class for the CompensationHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		CompensationHandler
@see		Compensation (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class CompensationHandlerTest
{
	public static testMethod void testCompensationHandler()
	{
		CWTest testResults = new CWTest( 'testCompensationHandler' );

		Account	account	= new Account
		(	Name		= 'Test Account'
		);
		insert account;

		Contact	contact	= new Contact
		(	LastName	= 'Test',
			AccountId	= account.Id
		);
		insert contact;

		Case	theCase	= new Case
		(	ContactId	= contact.Id
		);
		insert theCase;

		Flight_Leg__c	flightLeg	= new Flight_Leg__c();
		insert flightLeg;

		Compensation__c	complaint	= new Compensation__c
		(	Case__c			= theCase.Id,
			Contact__c		= contact.Id,
			Flight_Leg__c	= flightLeg.Id
		);

		testResults.startTest();

		insert complaint;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}