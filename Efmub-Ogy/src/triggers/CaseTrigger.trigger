/*******************************************************//**

@class      CaseTrigger

@brief      Case Trigger

    Handles all trigger activity for Case.

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2015-12-01  LiquidHub.GHA
    Created.

@see        CaseHandler
@see        CaseHandlerTest

    (c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger CaseTrigger on Case
(   before insert,  before update,  before delete,
    after  insert,  after  update,  after  delete,  after  undelete
)
{
    (new CWTrigger()).handle( new CaseHandler() );
    
    if(trigger.isbefore && trigger.isupdate)
    {
        
        CaseHandler.beforeCaseUpdate(trigger.new,trigger.oldmap,trigger.newmap);
    }
}