/*******************************************************//**

@class		UserHandler

@brief		Trigger Handler for Users

	This class is called by the User trigger to manage Users.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		User (trigger)
@see		UserHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class UserHandler implements CWTrigger.Handler
{
	/*******************************************************
						beforeTrigger
	*******************************************************/

	public void beforeTrigger( CWTrigger theTrigger )
	{
		theTrigger.flag		= true;			//	prevent re-triggering on these records

		//	nothing to do here yet...
	}

	/*******************************************************
						afterTrigger
	*******************************************************/

	public void afterTrigger( CWTrigger theTrigger )
	{
		theTrigger.flag		= true;			//	prevent re-triggering on these records

		//	nothing to do here yet...
	}
}