/*******************************************************//**

@class      Account

@brief      Account Trigger

    Handles all trigger activity for Account.

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2015-12-01  LiquidHub.GHA
    Created.

@see        AccountHandler
@see        AccountHandlerTest

    (c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger Account on Account
(   before insert,  before update,  before delete,
    after  insert,  after  update,  after  delete,  after  undelete
)
{
    (new CWTrigger()).handle( new AccountHandler() );
    /*STart Below code is for Sandbox only*/
    if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        for(Account  acc: Trigger.new){
             if (acc.PersonEmail !=NULL && acc.PersonEmail !='' && acc.Valid_Email__c != true && !(acc.PersonEmail.contains('xyz'))){             
                 acc.PersonEmail = string.valueOf(acc.PersonEmail).replace('@','@xyz');
          }
        }
    }
    /*End*/
}