/*******************************************************//**

@class		AccountHandlerTest

@brief		Test Class for the AccountHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		AccountHandler
@see		Account (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class AccountHandlerTest
{
	public static testMethod void testAccountHandler()
	{
		CWTest testResults = new CWTest( 'testAccountHandler' );

		Account	account	= new Account
		(	Name		= 'Test Account'
		);

		testResults.startTest();

		insert account;

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}