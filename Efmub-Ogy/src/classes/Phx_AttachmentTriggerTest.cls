@isTest
private class Phx_AttachmentTriggerTest {
    static testMethod void runPositiveTestCases() {
        Account acc = new Account(PersonMailingStreet='testNo',PersonMailingCity='IN',PersonMailingState='test',PersonEmail='test23@test.com',Phone='(888) 899-9999',PersonMailingPostalCode='89798',FirstName='testFN',LastName='TestLN',SkyMiles_Number__pc='7668768765');
        insert acc;
        Attachment attach=new Attachment();   	
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc.id;
        insert attach;
        system.debug('attach-->'+attach);
        List<Attachment> attachments=[select id, name from Attachment where ParentId=:acc.id];
        System.assertEquals(1, attachments.size());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser23@testorg.com');
        
        System.runAs(u) {
            try{
            delete attach;
            }catch(Exception ex){
            }
        }
    }
}