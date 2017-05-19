/*******************************************************//**

@class		CWDeploymentTest

@brief		Special Test to Limit Deployment

	This special test method fails if the current user is not
	authorized to perform a deployment in this org.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-07-20	LiquidHub.GHA
	Created.

@see		CWCoreConfiguration__c (Custom Setting)

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest(seeAllData=true)
private class CWDeploymentTest
{
	private static testMethod void testDeploymentAuthorization()
	{
		System.assert( CWCoreConfiguration__c.getInstance().Allow_Deployment__c, 'The current User is not authorized to deploy to this org.' );
	}
}