/*******************************************************//**

@class		User

@brief		User Trigger

	Handles all trigger activity for User.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		UserHandler
@see		UserHandlerTest

	(c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger User on User
(	before insert,	before update,	before delete,
	after  insert,	after  update,	after  delete,	after  undelete
)
{
	(new CWTrigger()).handle( new UserHandler() );
}