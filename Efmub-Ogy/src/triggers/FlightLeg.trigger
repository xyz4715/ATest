/*******************************************************//**

@class		FlightLeg

@brief		Flight_Leg__c Trigger

	Handles all trigger activity for Flight_Leg__c.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		FlightLegHandler
@see		FlightLegHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger FlightLeg on Flight_Leg__c
(	before insert,	before update,	before delete,
	after  insert,	after  update,	after  delete,	after  undelete
)
{
	(new CWTrigger()).handle( new FlightLegHandler() );
}