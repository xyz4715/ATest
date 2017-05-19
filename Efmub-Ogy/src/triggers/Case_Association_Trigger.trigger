// Author - Vincent Lui

trigger Case_Association_Trigger on CaseAssociation__c (before delete, before insert, after insert, after delete,before update) {
  (new CWTrigger()).handle( new Case_Association_Handler() );
   //Added by Amol PHX-122
    Set <ID> parentSet = new Set <ID>();
  if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        
         
          for(CaseAssociation__c c : Trigger.new)
          {
            parentSet.add(c.Case__c);
          }
          
          List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          
          for(CaseAssociation__c cc: Trigger.new){
             if (CaseList[0].Status =='Closed'){
             cc.addError('Cannot Edit/Add as parent case status is closed');
          }
          }
    }
    
     if(trigger.isbefore && trigger.isdelete){
              
                  for(CaseAssociation__c c : Trigger.old)
                  {
                    parentSet.add(c.Case__c);
                  }
                  List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(CaseAssociation__c cc: Trigger.old){
                 if (CaseList[0].Status =='Closed'){
                 cc.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
    
    }

}