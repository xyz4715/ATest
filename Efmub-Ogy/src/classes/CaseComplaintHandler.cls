/*******************************************************//**

@class		CaseComplaintHandler

@brief		Trigger Handler for CaseComplaints

	This class is called by the CaseComplaint trigger to manage CaseComplaints.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		CaseComplaint (trigger)
@see		CaseComplaintHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class CaseComplaintHandler implements CWTrigger.Handler
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