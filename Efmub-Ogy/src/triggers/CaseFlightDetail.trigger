trigger CaseFlightDetail  on Case_Flight_Detail__c (before insert,  before update,before delete) {
//Added by AMOL PHX-122
  
          Set <ID> parentSet = new Set <ID>();
          
          if(trigger.isbefore && trigger.isdelete){
              
                  for(Case_Flight_Detail__c c : Trigger.old)
                  {
                    parentSet.add(c.Case__c);
                  }
                  List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(Case_Flight_Detail__c cc: Trigger.old){
                 if (CaseList[0].Status =='Closed'){
                 cc.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
                  
              
          }
          if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert){
                  for(Case_Flight_Detail__c c : Trigger.new)
                  {
                    parentSet.add(c.Case__c);
                  }
                     List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(Case_Flight_Detail__c cc: Trigger.new){
                 if (CaseList[0].Status =='Closed'){
                 cc.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
          }
          
    
    
}