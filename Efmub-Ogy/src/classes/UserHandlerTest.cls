/*******************************************************//**

@class		UserHandlerTest

@brief		Test Class for the UserHandler Class

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		UserHandler
@see		User (trigger)

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

@isTest
public class UserHandlerTest
{
	public static testMethod void testUserHandler()
	{
		CWTest testResults = new CWTest( 'testUserHandler' );

		testResults.startTest();

		update new User( Id = UserInfo.getUserId() );

		//	test code goes here...

		testResults.stopTest();
		testResults.report();
	}
}