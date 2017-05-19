/*******************************************************//**

@class		InvestigationHandlerTest

@brief		Test Class for the InvestigationHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		InvestigationHandler
@see		Investigation (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class InvestigationHandlerTest
{
	public static testMethod void testInvestigationHandler()
	{
		CWTest testResults = new CWTest( 'testInvestigationHandler' );

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

		Investigation__c	investigation	= new Investigation__c
		(	Case__c		= theCase.Id
		);

		testResults.startTest();

		insert investigation;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}