/*******************************************************//**

@class      CaseComplaint

@brief      Case_Complaint__c Trigger

    Handles all trigger activity for Case_Complaint__c.

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2015-12-01  LiquidHub.GHA
    Created.

@see        CaseComplaintHandler
@see        CaseComplaintHandlerTest

    (c)2015 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

trigger CaseComplaint on Case_Complaint__c
(   before insert,  before update,  before delete,
    after  insert,  after  update,  after  delete,  after  undelete
)
{
    (new CWTrigger()).handle( new CaseComplaintHandler() );
    
    //Added by AMOL PHX-122
     Set <ID> parentSet = new Set <ID>();
    if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        
         
          for(Case_Complaint__c c : Trigger.new)
          {
            parentSet.add(c.Case__c);
          }
          
          List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          
          for(Case_Complaint__c  cc: Trigger.new){
             if (CaseList[0].Status =='Closed'){
             cc.addError('Cannot Edit/Add as parent case status is closed');
          }
          }
    }
    
    if(trigger.isbefore && trigger.isdelete){
              
                  for(Case_Complaint__c  c : Trigger.old)
                  {
                    parentSet.add(c.Case__c);
                  }
                  List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(Case_Complaint__c  cc: Trigger.old){
                 if (CaseList[0].Status =='Closed'){
                 cc.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
    
    }
}