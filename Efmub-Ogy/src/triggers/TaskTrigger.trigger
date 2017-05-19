trigger TaskTrigger on Task (before update,before insert,before delete) {

//Added by AMOL PHX-122
 Set <ID> parentSet = new Set <ID>();
 
 if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        
         for(Task e: Trigger.new)
         {
            if(e.WhatId.getSObjectType().getDescribe().getName()=='Case'){
                parentSet.add(e.WhatId);
            }
         }
         List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          for(Task e: Trigger.new)
         {
           if (CaseList[0].Status =='Closed'){
             e.addError('Cannot Edit/Add as parent case status is closed');
            }
         }
        
    }
    
    if(trigger.isbefore && trigger.isdelete){
              
                  for(Task e : Trigger.old)
                  {
                    if(e.WhatId.getSObjectType().getDescribe().getName()=='Case'){
                    parentSet.add(e.WhatId);
                }
                  }
                  List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(Task ee: Trigger.old){
                     if (CaseList[0].Status =='Closed'){
                       ee.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
    
    }
}