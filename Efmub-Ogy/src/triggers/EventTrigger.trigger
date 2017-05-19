trigger EventTrigger on Event (before insert,before update,before delete) {
 //Added by AMOL PHX-122
   Set <ID> parentSet = new Set <ID>();
 if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
       
         for(Event e: Trigger.new)
         {
            if(e.WhatId.getSObjectType().getDescribe().getName()=='Case'){
                parentSet.add(e.WhatId);
            }
         }
         List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          for(Event ee: Trigger.new)
         {
           if (CaseList[0].Status =='Closed'){
             ee.addError('Cannot Edit/Add as parent case status is closed');
            }
         }
        
    }
      if(trigger.isbefore && trigger.isdelete){
    
       
         for(Event e: Trigger.old)
         {
            if(e.WhatId.getSObjectType().getDescribe().getName()=='Case'){
                parentSet.add(e.WhatId);
            }
         }
         List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          for(Event ee: Trigger.old)
         {
           if (CaseList[0].Status =='Closed'){
             ee.addError('Cannot Edit/Add as parent case status is closed');
            }
         }
        
    }
    
}