/*******************************************************//**

@class		DelayCodeHandler

@brief		Trigger Handler for DelayCodes

	This class is called by the DelayCode trigger to manage DelayCodes.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		DelayCode (trigger)
@see		DelayCodeHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class DelayCodeHandler implements CWTrigger.Handler
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