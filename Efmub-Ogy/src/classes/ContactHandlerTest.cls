/*******************************************************//**

@class		ContactHandlerTest

@brief		Test Class for the ContactHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		ContactHandler
@see		Contact (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class ContactHandlerTest
{
	public static testMethod void testContactHandler()
	{
		CWTest testResults = new CWTest( 'testContactHandler' );

		Account	account	= new Account
		(	Name		= 'Test Account'
		);
		insert account;

		Contact	contact	= new Contact
		(	LastName	= 'Test',
			AccountId	= account.Id
		);

		testResults.startTest();

		insert contact;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}