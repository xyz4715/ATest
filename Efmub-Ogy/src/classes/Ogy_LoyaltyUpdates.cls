public class Phx_LoyaltyUpdates
{   
    //public static string existingAccountAddress;
    public static FetchContactDetails.LoyaltyDetails checkLoyaltyDB(string SkyMiles,string LoyaltyNumber,string accountId )
    {
        system.debug('input-->'+SkyMiles+'--'+LoyaltyNumber);
        if(String.isNotBlank(SkyMiles)){
            system.debug('sk');
            Skymiles.Lookup theSearch = new Skymiles.Lookup();    
            system.debug('theSearch');
            theSearch.setSkyMilesNumber(SkyMiles);
            system.debug('SkyMilessearch');
            Skymiles.MemberInformation result =  theSearch.find();
            System.debug('Result--SK' + result);
            system.debug('find');
            //Account AccD =[select id,PersonMailingStreet,personMailingCity,personMailingState,personMailingPostalCode from Account where SkyMiles_Number__pc = :SkyMiles  OR Flying_Blue_Number__pc=:LoyaltyNumber limit 1];
            //existingAccountAddress = AccD.PersonMailingStreet + AccD.personMailingCity + AccD.personMailingState + AccD.personMailingPostalCode;
            updateMilesonAccount(SkyMiles,result,'SkyMiles',accountId);
            system.debug('updateMilesonAccount');
            if(String.isNotBlank(LoyaltyNumber))
            {
                system.debug('skL');
                Skymiles.FlyingBlueMember fbmember = new Skymiles.FlyingBlueMember();
                SkyMiles.MemberInformation result1 = fbmember.getMember(LoyaltyNumber);
                updateMilesonAccount(LoyaltyNumber ,result1,'FlyingBlue',accountId );
            } 
            System.debug('Result--' + result);
            return memeberDetails(result,'Loyalty');
        }           
        else if(String.isNotBlank(LoyaltyNumber)&& String.isBlank(SkyMiles)){
            system.debug('LoyaltyNumber');
            Skymiles.FlyingBlueMember fbmember = new Skymiles.FlyingBlueMember();
            SkyMiles.MemberInformation result = fbmember.getMember(LoyaltyNumber); 
             updateMilesonAccount(LoyaltyNumber ,result,'FlyingBlue',accountId );                     
            return memeberDetails(result,'FlyingBlue');
        }else{
            system.debug('else');
            return null ;
        }
        
    }
    
    public static void updateMilesonAccount(string skymiles , Skymiles.MemberInformation Results, string DbName,string accountId  )
    {
        Account Acc =[select id,PersonMailingStreet,personMailingCity,personMailingState,personMailingPostalCode,SkyMiles_Number__pc ,Flying_Blue_Number__pc, Current_Miles_FB__pc,Current_Miles__pc ,Flying_Blue_Status__pc,SkyMiles_Status__pc,Lifetime_Miles__pc from 
                      Account where id=:accountId  limit 1];
        if(Acc.SkyMiles_Number__pc!=null || Acc.Flying_Blue_Number__pc!=null){
            system.debug('Miles Info before>>>>>'+'--'+DbName+'--'+Results+'--'+Acc.Current_Miles__pc+Acc.SkyMiles_Status__pc+Acc.Current_Miles_FB__pc+Acc.Flying_Blue_Status__pc);          
            system.debug('SkyM#--'+Acc.SkyMiles_Number__pc);
            system.debug('FB#--'+Acc.Flying_Blue_Number__pc);
            
        if(Acc.SkyMiles_Number__pc!=null && DbName == 'SkyMiles' && Results!=null)
        {
            Acc.Current_Miles__pc =  Results.person_acc.Current_Miles__pc ;                  
            Acc.SkyMiles_Status__pc  = Results.person_acc.SkyMiles_Status__pc ;
           //Added by Amol 12052017
            Acc.Lifetime_Miles__pc = Results.person_acc.Lifetime_Miles__pc;
        }
        if(Acc.Flying_Blue_Number__pc!=null && DbName == 'FlyingBlue' && Results!=null)
        {
            Acc.Current_Miles_FB__pc = Results.person_acc.Current_Miles_FB__pc ;
            Acc.Flying_Blue_Status__pc= Results.person_acc.Flying_Blue_Status__pc; 
        }
            try{
        update Acc;
            }catch(exception e){
                system.debug('e->'+e);
            }
        }
        
    }
    public static FetchContactDetails.LoyaltyDetails memeberDetails (SkyMiles.MemberInformation details,string DbName)
    {
        SkyMiles.MemberInformation result = details;
        list<SkyMiles.MemberAddress> lstAddresses =  result.addresses;                 
        list<SkyMiles.MemberEmail> lstEmails =  result.emails;
        list<SkyMiles.MemberPhone> lstPhones =  result.phones;
        system.debug('memeberDetails');
        set<FetchContactDetails.LoyaltyAddressDetails> addressDList = new set<FetchContactDetails.LoyaltyAddressDetails>();
        set<string> PhoneList = new set<string>();
        set<string> EmailList = new set<string>();
        system.debug('result--'+ result);
        system.debug('result.addresses-'+ result.addresses);
        system.debug('result.emails-'+ result.emails);
        system.debug('result.phones-'+ result.phones);
        system.debug('addressDList-'+ addressDList);
        
        system.debug('lstAddresses-'+ lstAddresses);
        system.debug('lstEmails-'+ lstEmails);
        system.debug('lstPhones-'+ lstPhones);
        
        
        integer n =0;
        
        for(SkyMiles.MemberPhone lstP :lstPhones)
        {
            system.debug('lstPhones:-'+DbName+'--'+ lstPhones);
            PhoneList.add(result.phones[n].person_acc.Phone);
        }
        integer y =0;
        for(SkyMiles.MemberEmail lstP :lstEmails )
        {
            system.debug('lstPhones:-'+DbName+'--'+ lstEmails);
            EmailList.add(result.emails[y].person_acc.PersonEmail);
        }
        
        integer i =0;
        Map<string,FetchContactDetails.LoyaltyAddressDetails> addreddDuplicateCheck = new Map<string,FetchContactDetails.LoyaltyAddressDetails>();
        for(SkyMiles.MemberAddress lst :lstAddresses)
        {
             system.debug('lstPhones:-'+DbName+'--'+ lstAddresses);
            FetchContactDetails.LoyaltyAddressDetails addressD = new FetchContactDetails.LoyaltyAddressDetails();
            addressD.PersonMailingStreet = result.addresses[i].person_acc.personMailingStreet;                     
            addressD.personMailingCity = result.addresses[i].person_acc.personMailingCity;
            addressD.personMailingState = result.addresses[i].person_acc.personMailingState;
            addressD.personMailingPostalCode = result.addresses[i].person_acc.personMailingPostalCode; 
            i=i+1;
            string addressString = addressD.PersonMailingStreet + addressD.personMailingCity + addressD.personMailingState + addressD.personMailingPostalCode;
            /*if(existingAccountAddress.touppercase()==addressString.touppercase()){
                continue;
            }*/
            addreddDuplicateCheck.put(addressString.replaceAll( '\\s+', ''),addressD);
        }
        system.debug('addreddDuplicateCheck'+addreddDuplicateCheck);
        for(FetchContactDetails.LoyaltyAddressDetails addressDe :addreddDuplicateCheck.values()){
            addressDList.add(addressDe);
        }
        system.debug('flyingBlue'+result.person_acc);            
        FetchContactDetails.LoyaltyDetails LDetails = new FetchContactDetails.LoyaltyDetails();
        if(DbName=='FlyingBlue'){
            LDetails.dataBaseStatus = result.person_acc.Flying_Blue_Status__pc;
            LDetails.CurrentMiles = result.person_acc.Current_Miles_FB__pc;
            LDetails.dataBaseNumber = result.person_acc.Flying_Blue_Number__pc;
        }else{
            LDetails.dataBaseStatus = result.person_acc.SkyMiles_Status__pc;
            LDetails.CurrentMiles = result.person_acc.Current_Miles__pc;
            LDetails.dataBaseNumber = result.person_acc.SkyMiles_Number__pc;
        }
        LDetails.FirstName = result.person_acc.FirstName;
        LDetails.LastName = result.person_acc.LastName;
        LDetails.AddressList = addressDList;
        LDetails.Phone = PhoneList;
        LDetails.PersonEmail = EmailList;
        LDetails.dBName = DbName;
        
        
        system.debug('the complete wrapped account is'+LDetails);
        system.debug('street addreses of LoyaltyAddressDetails are'+addressDList);
        return LDetails;
    }
}