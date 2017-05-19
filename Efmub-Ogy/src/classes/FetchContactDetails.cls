public class FetchContactDetails {
    public static Account newAccountRec;
    public static LoyaltyDetails LDetails;
    @AuraEnabled
    public static Account newAccount(){
        return newAccountRec;
    }
    
    @AuraEnabled
    public static Account getAccountsFromSFDC(string AccountRecId) {
        Account accRec = [SELECT Id, PersonOtherStreet,Work_Email__pc,PersonOtherCity,SkyMiles_Number__pc,Current_Miles__pc,SkyMiles_Status__pc,Flying_Blue_Number__pc,Current_Miles_FB__pc,Flying_Blue_Status__pc,PersonOtherState,PersonOtherPostalCode,FirstName,LastName,BillingStreet,PersonOtherPhone,PersonMobilePhone,Other_Email__pc,BillingCity,BillingState,BillingPostalCode, PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingState, PersonEmail, Phone
                          FROM Account where id =:AccountRecId ORDER BY createdDate ASC];
        system.debug('accRec-->'+accRec);
        return accRec;
    }
    @AuraEnabled
    public static LoyaltyDetails getAccountsFROMWSDL(string skyMilesNumber,string LoyaltyNumber,string accountId ) {      
       LDetails = Phx_LoyaltyUpdates.checkLoyaltyDB(skyMilesNumber,LoyaltyNumber,accountId );        
       system.debug('LDetails-->'+LDetails);
        return LDetails;
    }
    
    @AuraEnabled 
    public static String getUpdateAccount(Account accountRec){
      
        
        system.debug('accountRec-->'+accountRec);
        try{update accountRec;
        return 'Success';
           }catch(Exception ex){
               if(ex.getMessage().contains('Flying_Blue_Number__pc')){
                   return 'Duplicate Flying Blue Number found';
               }else{
                   return 'Duplicate Skymiles Number found';
               }
               
           }
    } 
    
    public class LoyaltyDetails{
        @AuraEnabled
        public string FirstName{get;set;}
        @AuraEnabled
        public string LastName{get;set;}
        @AuraEnabled
        public string dBName{get;set;}
         @AuraEnabled
        public set<LoyaltyAddressDetails> AddressList{get;set;}
        @AuraEnabled
        public set<string> PersonEmail{get;set;}
        @AuraEnabled
        public set<string> Phone{get;set;}
        @AuraEnabled
        public string dataBaseStatus{get;set;}
        @AuraEnabled
        public decimal CurrentMiles{get;set;}
        @AuraEnabled
        public string dataBaseNumber{get;set;}
    }
    public class LoyaltyAddressDetails{
        @AuraEnabled
        public string PersonMailingStreet{get;set;}
        @AuraEnabled
        public string PersonMailingState{get;set;}
        @AuraEnabled
        public string PersonMailingCity{get;set;}
        @AuraEnabled
        public string PersonMailingPostalCode{get;set;}
    }
    
}