trigger CaseComment on CaseComment (before update,before insert,before delete) {
 //Added by AMOL PHX-122
 Set <ID> parentSet = new Set <ID>();
if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        
         
          for(CaseComment  c : Trigger.new)
          {
            parentSet.add(c.ParentId);
          }
          
          List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          
          for(CaseComment cc: Trigger.new){
             if (CaseList[0].Status =='Closed'){
             cc.addError('Cannot Edit/Add as parent case status is closed');
          }
          }
         
    }
    
     if(trigger.isbefore && trigger.isdelete){
              
                  for(CaseComment c : Trigger.old)
                  {
                    parentSet.add(c.ParentId);
                  }
                  List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
              
                  for(CaseComment cc: Trigger.old){
                 if (CaseList[0].Status =='Closed'){
                 cc.addError('Cannot Edit/Add as parent case status is closed');
                 }
              }
    
    }
}