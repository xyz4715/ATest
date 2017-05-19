@isTest(seeAllData=true)
private class Phx_StopDeletionOfEmailsTest {
	static testMethod void runPositiveTestCases() {
        case theCase = [select id from Case limit 1];
        
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = theCase.Id; 
        insert email;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser23@testorg.com');
        
        System.runAs(u) {
            try{
            delete email;
            }catch(Exception ex){
            }
        }
         
    }
}