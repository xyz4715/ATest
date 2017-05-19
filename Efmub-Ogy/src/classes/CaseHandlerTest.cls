/*******************************************************//**

@class		CaseHandlerTest

@brief		Test Class for the CaseHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		CaseHandler
@see		CaseCaseTrigger (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class CaseHandlerTest
{
	public static testMethod void testCaseHandler()
	{
		CWTest testResults = new CWTest( 'testCaseHandler' );

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

		testResults.startTest();

		insert theCase;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}