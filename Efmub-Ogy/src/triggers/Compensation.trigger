/*******************************************************//**

@class		Compensation

@brief		Compensation__c Trigger

	Handles all trigger activity for Compensation__c.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		CompensationHandler
@see		CompensationHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger Compensation on Compensation__c
(	before insert,	before update,	before delete,
	after  insert,	after  update,	after  delete,	after  undelete
)
{
	(new CWTrigger()).handle( new CompensationHandler() );
}