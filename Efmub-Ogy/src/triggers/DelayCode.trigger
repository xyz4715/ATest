/*******************************************************//**

@class		DelayCode

@brief		Delay_Code__c Trigger

	Handles all trigger activity for Delay_Code__c.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		DelayCodeHandler
@see		DelayCodeHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger DelayCode on Delay_Code__c
(	before insert,	before update,	before delete,
	after  insert,	after  update,	after  delete,	after  undelete
)
{
	(new CWTrigger()).handle( new DelayCodeHandler() );
}