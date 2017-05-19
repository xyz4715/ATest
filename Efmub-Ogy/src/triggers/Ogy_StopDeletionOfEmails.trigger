trigger Phx_StopDeletionOfEmails on EmailMessage (before insert,before delete,before update) {
    
    if(Trigger.isDelete){
        Id id1 = UserInfo.getProfileId();
        List<Profile> profileName = [Select Name from Profile where Id =: id1 limit 1];
        String MyProflieName = profileName[0].Name;
        
         for(EmailMessage a: Trigger.old)
        {
            if(MyProflieName!='System Administrator'&&(a.ParentId.getSObjectType().getDescribe().getName()=='Case'||a.ParentId.getSObjectType().getDescribe().getName()=='Account' || a.ParentId.getSObjectType().getDescribe().getName()=='EmailMessage') )
            {
            
                system.debug('value of parentId obj is'+a.ParentId.getSObjectType().getDescribe().getName());
                a.adderror('You are not allowed to delete Email attachments,Please contact Bess');
            
            }
        }
    }
    if(Trigger.isinsert){
         List<PHX_Restricted_Email_List__c> reds = PHX_Restricted_Email_List__c.getall().values();
         Set<String> restrictEmailDomainSet = new Set<String>();
         if(reds.size()>0){
              for(PHX_Restricted_Email_List__c r:reds){
               restrictEmailDomainSet.add(r.PHX_Email_Id__c.tolowercase());
              }
         }
          
         for(EmailMessage e: Trigger.new)
         {
            if(e.ParentId.getSObjectType().getDescribe().getName()=='Case' && (e.CcAddress != null && isEmailIDMatched(e.CcAddress.tolowercase(),restrictEmailDomainSet)) || (e.BccAddress!= null && isEmailIDMatched(e.BccAddress.tolowercase(),restrictEmailDomainSet)) || (e.ToAddress!= null && isEmailIDMatched(e.ToAddress.tolowercase(),restrictEmailDomainSet))  )
            {
                e.adderror('You are not allowed to send email to this person.');
            }
         }
         
        
    }
    
    //Added by amol PHX-122
     Set <ID> parentSet = new Set <ID>();
     if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {
        
         for(EmailMessage e: Trigger.new)
         {
            if(e.ParentId.getSObjectType().getDescribe().getName()=='Case'){
                parentSet.add(e.ParentId);
            }
         }
         List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          for(EmailMessage e: Trigger.new)
         {
           if (CaseList[0].Status =='Closed'){
             e.addError('Cannot Edit/Add as parent case status is closed');
            }
         }
        
    }
      if(trigger.isbefore && trigger.isdelete )
    {
        
         for(EmailMessage e: Trigger.old)
         {
            if(e.ParentId.getSObjectType().getDescribe().getName()=='Case'){
                parentSet.add(e.ParentId);
            }
         }
         List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          for(EmailMessage ee: Trigger.old)
         {
           if (CaseList[0].Status =='Closed'){
             ee.addError('Cannot Edit/Add as parent case status is closed');
            }
         }
        
    }
   
     public Boolean isEmailIDMatched(string emailId, Set<String> restrictEmailDomainSet){
         Boolean result=false;
         Set<string> domains = new Set<string>();
           if(restrictEmailDomainSet != null){
             for(String s:restrictEmailDomainSet){
               if(s.contains('*')){
                system.debug('ww '+s.split('\\*'));
                string ass=s.split('\\*').get(1).trim();
                ass=ass.replaceFirst('.','');
                 domains.add(ass);
               }
               else{
                 if(s==emailId){
                    result =true;
                    return result;
                  }
               }
             }
             if(!result && domains != null){
              for(string s:domains){
               if(emailId.contains(s)){
                result =true;
                return result;
                }
              }
              //result=emailId.contains(domains);
              //system.debug('@@ '+domains );
              //system.debug('@@ '+emailId.contains(domains) );
             }
           }
           return result;
         }
    
}