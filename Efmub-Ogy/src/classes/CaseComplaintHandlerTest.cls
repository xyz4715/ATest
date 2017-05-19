/*******************************************************//**

@class		CaseComplaintHandlerTest

@brief		Test Class for the CaseComplaintHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		CaseComplaintHandler
@see		CaseComplaint (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class CaseComplaintHandlerTest
{
	public static testMethod void testCaseComplaintHandler()
	{
		CWTest testResults = new CWTest( 'testCaseComplaintHandler' );

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

		Case_Complaint__c	complaint	= new Case_Complaint__c
		(	Case__c			= theCase.Id,
			Flight_Leg__c	= flightLeg.Id
		);

		testResults.startTest();

		insert complaint;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}