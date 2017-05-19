trigger Phx_AttachmentTrigger on Attachment (before delete,before update,before insert) {

    Id id1 = UserInfo.getProfileId();
    List<Profile> profileName = [Select Name from Profile where Id =: id1 limit 1];
    String MyProflieName = profileName[0].Name;
    list<string> strlst = new list<string>();
     Set <ID> parentSet = new Set <ID>();
    if(trigger.isdelete){
    for(Attachment a: Trigger.old)
    {
        if((MyProflieName!='System Administrator' && a.OwnerId != UserInfo.getUserId() ) &&(a.ParentId.getSObjectType().getDescribe().getName()=='Case'||a.ParentId.getSObjectType().getDescribe().getName()=='Account' || a.ParentId.getSObjectType().getDescribe().getName()=='EmailMessage') )
        {
        
            system.debug('value of parentId obj is'+a.ParentId.getSObjectType().getDescribe().getName());
            a.adderror('You are not allowed to delete attachments, please contact your system administrator in order to delete.');
        
        }
        if(a.ParentId.getSObjectType().getDescribe().getName()=='Case'){
              parentSet.add(a.ParentId);
            }
            
     }       
        List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          
          for(Attachment  cc: Trigger.old){
             if (CaseList[0].Status =='Closed'){
             cc.addError('Cannot Edit/Add as parent case status is closed');
             }
          }
  
    }
    if(trigger.isbefore && trigger.isupdate || trigger.isbefore && trigger.isinsert)
    {      
         
          for(Attachment c : Trigger.new)
          {  if(c.ParentId.getSObjectType().getDescribe().getName()=='Case'){
              parentSet.add(c.ParentId);
            }
          }
          List <Case> CaseList = [SELECT Id, Status FROM Case WHERE Id IN : parentSet];
          
          for(Attachment  cc: Trigger.new){
             if (CaseList[0].Status =='Closed'){
             cc.addError('Cannot Edit/Add as parent case status is closed');
          }
          }
    }
    
}