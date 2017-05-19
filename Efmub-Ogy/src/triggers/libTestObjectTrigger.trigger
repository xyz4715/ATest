/*******************************************************//**

@class		CWTestObjectTrigger

@brief		Trigger for CWTestObject__c

@author		Michael Wing	(LiquidHub.EMW)

@version	2014-09-17	LiquidHub.EMW
	Created.

@see		

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

trigger CWTestObjectTrigger on CWTestObject__c
(	before insert,	before update,	before delete,
	after  insert,	after  update,	after  delete,	after  undelete
)
{
	(new CWTrigger()).handle();
}