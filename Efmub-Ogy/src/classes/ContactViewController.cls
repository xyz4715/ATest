/*******************************************************//**

@class      ContactViewController

@brief      Controller for Connection pages

This controller/extension serves for all Connection__c related pages.

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2016-01-15  LiquidHub.GHA
Created.
@version    2016-02-11  LiquidHub.GHA
Now saves SkyMiles Status, Current and Lifetime Mileage,
Million Miler and Active Sky Club to the Contact record.
@version    2016-05-01  LiquidHub.GHA
Updates 360 Customer and MQM fields.
@version    2016-05-08  LiquidHub.GHA
Added Flying Blue functionality.

@see        ContactViewControllerTest
@see        ContactView (page)

(c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

public with sharing class ContactViewController
{
    private final Id    recordId;
    
    //public Contact      record // Commented by Anil
    public Account record
    {
        get
        {
            if ( record == null && recordId != null )
            {
                CWQuery     query       = CWQuery.newQuery( Account.getSObjectType() ).addFieldSet( 'PersonAccount_View' );//ContactView_Fields to PersonAccount_View //Contact to Account
                query.newWhereClause( 'Id = ' + CWString.quote( String.valueOf( recordId ) ) );
                CWQuery     caseQuery   = query.newSubquery( 'Cases' )
                    .add( new List<String>{ 'CreatedDate', 'SuppliedName', 'SuppliedPhone', 'SuppliedEmail' } )
                    .add( new List<String>{ 'Web_Street__c', 'Web_City__c', 'Web_State__c', 'Web_Postal_Code__c', 'Web_Country__c' } )
                    .orderByDescending( 'CreatedDate' ).setLimit( 1 );
                caseQuery.newWhereClause( 'Origin = ' + CWString.quote( 'Web' ) );
                
                for ( Account aRecord : (List<Account>) query.query() )//Contact to Account
                {
                    record              = aRecord;
                    break;
                }
            }
            return record;
        }
        private set;
    }
    
    private Boolean updateRecord;
    
    public String   name
    {
        get
        {
            List<String>    nameStrings     = new List<String>();
            if ( String.isNotBlank( record.Salutation ) ) nameStrings.add( record.Salutation );
            if ( String.isNotBlank( record.FirstName ) ) nameStrings.add( record.FirstName );
            if ( String.isNotBlank( record.MiddleName ) ) nameStrings.add( record.MiddleName );
            if ( String.isNotBlank( record.LastName ) ) nameStrings.add( record.LastName );
            if ( String.isNotBlank( record.Suffix ) ) nameStrings.add( record.Suffix );
            return String.join( nameStrings, ' ' );
        }
    }
    
    public String   age
    {
        get
        {
            if ( record.PersonBirthdate != null )//Birthdate to PersonBirthdate
            {
                Integer thisYear    = Date.today().year();
                Integer ageInteger  = thisYear - record.PersonBirthdate.year();//Birthdate to PersonBirthdate
                if ( Date.newInstance( thisYear, record.PersonBirthdate.month(), record.PersonBirthdate.day() ) > Date.today() ) ageInteger--; //Birthdate to PersonBirthdate
                return String.valueOf( ageInteger );
            }
            return '';
        }
    }
    
    public List<String> mailingStreet
    {
            get { return String.isNotBlank( record.PersonMailingStreet ) ? record.PersonMailingStreet.split( '\n' ) : new List<String>(); }
    }
    
    public String   mailingCityStateZip
    {
        get
        {
            return
                (String.isNotBlank( record.PersonMailingCity ) ? record.PersonMailingCity : '')
                +   (String.isNotBlank( record.PersonMailingState ) ? ', ' + record.PersonMailingState : '')
                +   (String.isNotBlank( record.PersonMailingPostalCode ) ? ' ' + record.PersonMailingPostalCode : '');
        }
    }
    
    public List<String> otherStreet
    {
        get { return String.isNotBlank( record.PersonOtherStreet ) ? record.PersonOtherStreet.split( '\n' ) : new List<String>(); }
    }
    
    public String   otherCityStateZip
    {
        get
        {
            return
                (String.isNotBlank( record.PersonOtherCity ) ? record.PersonOtherCity : '')
                +   (String.isNotBlank( record.PersonOtherState ) ? ', ' + record.PersonOtherState : '')
                +   (String.isNotBlank( record.PersonOtherPostalCode ) ? ' ' + record.PersonOtherPostalCode : '');
        }
    }
    
    /*******************************************************
Constructor - when class is used as an extension
*******************************************************/
    
    public ContactViewController( ApexPages.StandardController stdController )
    {
        recordId = (Id) stdController.getRecord().get( 'Id' );
    }
    
    /*******************************************************
Constructor - when class is used as a controller
*******************************************************/
    
    public ContactViewController()
    {
        try
        {
            recordId = Id.valueOf( ApexPages.currentPage().getParameters().get( 'id' ) );
        }
        catch ( Exception theException )
        {
            recordId = null;
        }
    }
    
    /*******************************************************
properties
*******************************************************/
    
    private String  originalSkyMilesNumber;
    private String  originalFlyingBlueNumber;
    
    public Boolean  queriedWebCase      { get { return CWCollection.isNotEmpty( record.Cases ); } }
    public Boolean  queriedSkyMiles     { get { return String.isNotBlank( originalSkyMilesNumber ); } }
    public Boolean  queriedFlyingBlue   { get { return String.isNotBlank( originalFlyingBlueNumber ); } }
    
    public Case     webCase             { get { return queriedWebCase ? record.Cases[0] : null; } }
    public Boolean  webCaseHasName      { get { return String.isNotBlank( webCase.SuppliedName ); } }
    public Boolean  webCaseHasAddress   { get { return String.isNotBlank( webCase.Web_Street__c ); } }
    public Boolean  webCaseHasPhone     { get { return String.isNotBlank( webCase.SuppliedPhone ); } }
    public Boolean  webCaseHasEmail     { get { return String.isNotBlank( webCase.SuppliedEmail ); } }
    
    //private Contact webContact // Commented by Anil
    private Account webContact
    {
        get
        {
            if ( webContact == null )
            {
                webContact  = new Account
                    (   PersonMailingStreet       = webCase.Web_Street__c,
                     PersonMailingCity         = webCase.Web_City__c,
                     PersonMailingState        = webCase.Web_State__c,
                     PersonMailingPostalCode   = webCase.Web_Postal_Code__c,
                     PersonMailingCountry      = webCase.Web_Country__c,
                     Phone               = webCase.SuppliedPhone,
                     PersonEmail               = webCase.SuppliedEmail,
                     FirstName           = webCase.SuppliedName.substringBefore( ' ' ),
                     LastName            = webCase.SuppliedName.substringAfterLast( ' ' )
                    );
            }
            return webContact;
        }
        private set;
    }
    
    /*
public List<String> webCaseStreet
{
get { return String.isNotBlank( webContact.MailingStreet ) ? webContact.MailingStreet.split( '\n' ) : new List<String>(); }
}

public String   webCaseCityStateZip
{
get
{
return
(String.isNotBlank( webContact.MailingCity ) ? webContact.MailingCity : '')
+   (String.isNotBlank( webContact.MailingState ) ? ', ' + webContact.MailingState : '')
+   (String.isNotBlank( webContact.MailingPostalCode ) ? ' ' + webContact.MailingPostalCode : '');
}
}

public String   webCaseCountry      { get { return webContact.MailingCountry; } }
//*/
    
    public ContactInfo  webCaseAddressInfo
    {
        get
        {
            if ( webCaseAddressInfo == null )
            {
                webCaseAddressInfo  = new ContactInfo
                    (   0,
                     new SkyMiles.MemberAddress
                     (   'Web',
                      webCase.Web_Street__c,
                      webCase.Web_City__c,
                      webCase.Web_State__c,
                      webCase.Web_Country__c,
                      webCase.Web_Postal_Code__c
                     ),
                     record
                    );
            }
            return webCaseAddressInfo;
        }
        private set;
    }
    
    public ContactInfo  webCaseEmailInfo
    {
        get
        {
            if ( webCaseEmailInfo == null )
            {
                webCaseEmailInfo    = new ContactInfo
                    (   0,
                     new SkyMiles.MemberEmail( 'Web', webCase.SuppliedEmail ),
                     record
                    );
            }
            return webCaseEmailInfo;
        }
        private set;
    }
    
    public ContactInfo  webCasePhoneInfo
    {
        get
        {
            if ( webCasePhoneInfo == null )
            {
                webCasePhoneInfo    = new ContactInfo
                    (   0,
                     new SkyMiles.MemberPhone( 'Web', webCase.SuppliedPhone ),
                     record
                    );
            }
            return webCasePhoneInfo;
        }
        private set;
    }
    
    public SkyMiles.MemberInformation   skyMilesMemberInformation       { get; private set; }
    
    public List<ContactInfo>    skyMilesContactInformation
    {
        get
        {
            if ( skyMilesContactInformation == null )
            {
                skyMilesContactInformation = new List<ContactInfo>();
            }
            return skyMilesContactInformation;
        }
        private set;
    }
    
    public SkyMiles.MemberInformation   flyingBlueMemberInformation     { get; private set; }
    
    public List<ContactInfo>    flyingBlueContactInformation
    {
        get
        {
            if ( flyingBlueContactInformation == null )
            {
                flyingBlueContactInformation = new List<ContactInfo>();
            }
            return flyingBlueContactInformation;
        }
        private set;
    }
    
    /*******************************************************
checkInformation action
*******************************************************/
    
    public PageReference checkInformation()
    {
        if  (   String.isBlank( record.SkyMiles_Number__pc )
             &&  String.isBlank( record.Flying_Blue_Number__pc )
             &&  webCase == null
            )
        {
            return cancel();
        }
        
        updateRecord    = false;
        
        Integer index   = 0;
        
        if ( record.SkyMiles_Number__pc != originalSkyMilesNumber && record.SkyMiles_Number__pc != null )
        {
            originalSkyMilesNumber          = record.SkyMiles_Number__pc;
            skyMilesContactInformation      = null;
            
            SkyMiles.MemberInformation  memberInformation   = (new SkyMiles.Lookup()).setSkyMilesNumber( record.SkyMiles_Number__pc ).find();
            
            if ( memberInformation != null && memberInformation.person_acc != null )
            {
                skyMilesMemberInformation       = memberInformation;
                
                for ( SkyMiles.MemberAddress address : memberInformation.addresses )
                {
                    skyMilesContactInformation.add( new ContactInfo( index++, address, record ) );
                }
                for ( SkyMiles.MemberPhone phone : memberInformation.phones )
                {
                    skyMilesContactInformation.add( new ContactInfo( index++, phone, record ) );
                }
                for ( SkyMiles.MemberEmail email : memberInformation.emails )
                {
                    skyMilesContactInformation.add( new ContactInfo( index++, email, record ) );
                }
            }
            
            if  (   memberInformation.person_acc.SkyMiles_Status__pc != null
                 &&  record.SkyMiles_Status__pc != memberInformation.person_acc.SkyMiles_Status__pc
                )
            {
                record.SkyMiles_Status__pc   = memberInformation.person_acc.SkyMiles_Status__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Million_Miler__pc != null
                 &&  record.Million_Miler__pc != memberInformation.person_acc.Million_Miler__pc
                )
            {
                record.Million_Miler__pc     = memberInformation.person_acc.Million_Miler__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.X360_Customer__pc != null
                 &&  record.X360_Customer__pc != memberInformation.person_acc.X360_Customer__pc
                )
            {
                record.X360_Customer__pc     = memberInformation.person_acc.X360_Customer__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Current_Miles__pc != null
                 &&  record.Current_Miles__pc != memberInformation.person_acc.Current_Miles__pc
                )
            {
                record.Current_Miles__pc     = memberInformation.person_acc.Current_Miles__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Lifetime_Miles__pc != null
                 &&  record.Lifetime_Miles__pc != memberInformation.person_acc.Lifetime_Miles__pc
                )
            {
                record.Lifetime_Miles__pc    = memberInformation.person_acc.Lifetime_Miles__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Delta_Sky_Club__pc != null
                 &&  record.Delta_Sky_Club__pc != memberInformation.person_acc.Delta_Sky_Club__pc
                )
            {
                record.Delta_Sky_Club__pc    = memberInformation.person_acc.Delta_Sky_Club__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.MQM__pc != null
                 &&  record.MQM__pc != memberInformation.person_acc.MQM__pc
                )
            {
                record.MQM__pc               = memberInformation.person_acc.MQM__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.MQS__pc != null
                 &&  record.MQS__pc != memberInformation.person_acc.MQS__pc
                )
            {
                record.MQS__pc               = memberInformation.person_acc.MQS__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.MQD__pc != null
                 &&  record.MQS__pc != memberInformation.person_acc.MQD__pc
                )
            {
                record.MQD__pc               = memberInformation.person_acc.MQD__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Last_Year_MQM_SM__pc != null
                 &&  record.Last_Year_MQM_SM__pc != memberInformation.person_acc.Last_Year_MQM_SM__pc
                )
            {
                record.Last_Year_MQM_SM__pc  = memberInformation.person_acc.Last_Year_MQM_SM__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Last_Year_MQS_SM__pc != null
                 &&  record.Last_Year_MQS_SM__pc != memberInformation.person_acc.Last_Year_MQS_SM__pc
                )
            {
                record.Last_Year_MQS_SM__pc  = memberInformation.person_acc.Last_Year_MQS_SM__pc;
                updateRecord                = true;
            }
            
            if  (   memberInformation.person_acc.Last_Year_MQD_SM__pc != null
                 &&  record.Last_Year_MQD_SM__pc != memberInformation.person_acc.Last_Year_MQD_SM__pc
                )
            {
                record.Last_Year_MQD_SM__pc  = memberInformation.person_acc.Last_Year_MQD_SM__pc;
                updateRecord                = true;
            }
        }
        
        if ( record.Flying_Blue_Number__pc != originalFlyingBlueNumber && record.Flying_Blue_Number__pc != null )
        {
            originalFlyingBlueNumber            = record.Flying_Blue_Number__pc;
            flyingBlueContactInformation        = null;
            
            SOA_AirFranceLoyalty.ProvideIndividualDataService_v1_soap11http     service     = new SOA_AirFranceLoyalty.ProvideIndividualDataService_v1_soap11http();
            SOA_AirFranceLoyalty.IndividualInformationResponse                  response    = service.invoke( record.Flying_Blue_Number__pc );
            
            if ( CWSoap.isSuccessfulResponse( response ) )
            {
                SkyMiles.MemberInformation  memberInformation   = new SkyMiles.MemberInformation( response );
                
                flyingBlueMemberInformation     = memberInformation;
                
                for ( SkyMiles.MemberAddress address : memberInformation.addresses )
                {
                    flyingBlueContactInformation.add( new ContactInfo( index++, address, record ) );
                }
                for ( SkyMiles.MemberPhone phone : memberInformation.phones )
                {
                    flyingBlueContactInformation.add( new ContactInfo( index++, phone, record ) );
                }
                for ( SkyMiles.MemberEmail email : memberInformation.emails )
                {
                    flyingBlueContactInformation.add( new ContactInfo( index++, email, record ) );
                }
                
                if  (   memberInformation.person_acc.Flying_Blue_Status__pc != null
                     &&  record.Flying_Blue_Status__pc != memberInformation.person_acc.Flying_Blue_Status__pc
                    )
                {
                    record.Flying_Blue_Status__pc    = memberInformation.person_acc.Flying_Blue_Status__pc;
                    updateRecord                    = true;
                }
                
                if  (   memberInformation.person_acc.Current_Miles_FB__pc != null
                     &&  record.Current_Miles_FB__pc != memberInformation.person_acc.Current_Miles_FB__pc
                    )
                {
                    record.Current_Miles_FB__pc      = memberInformation.person_acc.Current_Miles_FB__pc;
                    updateRecord                    = true;
                }
                
                if  (   memberInformation.person_acc.Lifetime_Miles_FB__pc != null
                     &&  record.Lifetime_Miles_FB__pc != memberInformation.person_acc.Lifetime_Miles_FB__pc
                    )
                {
                    record.Lifetime_Miles_FB__pc     = memberInformation.person_acc.Lifetime_Miles_FB__pc;
                    updateRecord                    = true;
                }
            }
        }
        
        Boolean doContactUpdate     = false;
        
        if ( String.isNotBlank( record.Loyalty_Refresh_Alert_Image__pc ) )
        {
            doContactUpdate                 = true;
            record.Last_Loyalty_Refresh__pc  = DateTime.now();
            updateRecord                    = true;
        }
        
        if ( updateRecord ) update record;
        
        return doContactUpdate ? null : null;
    }
    
    /*******************************************************
copyContactInfo action
*******************************************************/
    
    public String   dragType            { get; set; }
    public String   dragElement         { get; set; }
    public String   dropElement         { get; set; }
    
    public void copyContactInfo()
    {
        Boolean isWebCase       = dragElement.startsWith( 'WebCase' );
        Boolean isSkyMiles      = dragElement.startsWith( 'SkyMiles' );
        Boolean isFlyingBlue    = dragElement.startsWith( 'FlyingBlue' );
        Boolean isLoyalty       = isWebCase || isSkyMiles || isFlyingBlue;
        
        //Contact dragContact     =
        Account dragContact     =
            isWebCase       ?   webContact
            :   isSkyMiles      ?   skyMilesMemberInformation.person_acc
                :   isFlyingBlue    ?   flyingBlueMemberInformation.person_acc
                    :   record;
        
        if ( dragType == 'name' && dropElement == 'Name' )
        {
            record.put( 'Salutation',   dragContact.get( 'Salutation'   ) );
            record.put( 'FirstName',    dragContact.get( 'FirstName'    ) );
            record.put( 'MiddleName',   dragContact.get( 'MiddleName'   ) );
            record.put( 'LastName',     dragContact.get( 'LastName'     ) );
            record.put( 'Suffix',       dragContact.get( 'Suffix'       ) );
            return;
        }
        
        if  (   dragType == 'name'
             ||  dragType == 'gender'
             ||  dragType == 'birthdate'
            )
        {
            record.put( dropElement, dragContact.get( dropElement ) );
            return;
        }
        
        dragContact     =
            isWebCase       ?   webContact
            :   isSkyMiles      ?   skyMilesContactInformation[ Integer.valueOf( dragElement.substringAfter( '_' ) ) ].contact
                :   isFlyingBlue    ?   flyingBlueContactInformation[ Integer.valueOf( dragElement.substringAfter( '_' ) ) ].contact
                    :   record;
        
        if ( dragType == 'address' )
        {
            copyAddress( dragContact, isLoyalty ? 'MailingAddress' : dragElement, record, dropElement );
            return;
        }
        if ( dragType == 'phone' )
        {
            record.put( dropElement, dragContact.get( isLoyalty ? 'Phone' : dragElement ) );
            return;
        }
        if ( dragType == 'email' )
        {
            record.put( dropElement, dragContact.get( isLoyalty ? 'Email' : dragElement ) );
            return;
        }
    }
    
    private void copyAddress( Account dragContact, String dragElement, Account dropContact, String dropElement )// COntact to Account
    {
        Map<String,String>  streetField         = new Map<String,String>{ 'MailingAddress' => 'MailingStreet',     'OtherAddress' => 'OtherStreet'     };
            Map<String,String>  cityField           = new Map<String,String>{ 'MailingAddress' => 'MailingCity',       'OtherAddress' => 'OtherCity'       };
                Map<String,String>  stateField          = new Map<String,String>{ 'MailingAddress' => 'MailingState',      'OtherAddress' => 'OtherState'      };
                    Map<String,String>  postalCodeField     = new Map<String,String>{ 'MailingAddress' => 'MailingPostalCode', 'OtherAddress' => 'OtherPostalCode' };
                        Map<String,String>  countryField        = new Map<String,String>{ 'MailingAddress' => 'MailingCountry',    'OtherAddress' => 'OtherCountry'    };
                            
                            dropContact.put( streetField.get( dropElement ),     dragContact.get( streetField.get( dragElement ) )     );
        dropContact.put( cityField.get( dropElement ),       dragContact.get( cityField.get( dragElement ) )       );
        dropContact.put( stateField.get( dropElement ),      dragContact.get( stateField.get( dragElement ) )      );
        dropContact.put( postalCodeField.get( dropElement ), dragContact.get( postalCodeField.get( dragElement ) ) );
        dropContact.put( countryField.get( dropElement ),    dragContact.get( countryField.get( dragElement ) )    );
    }
    
    /*******************************************************
updateContact action
*******************************************************/
    
    public PageReference updateContact()
    {
        update record;
        return revert();
    }
    
    /*******************************************************
updateContact action
*******************************************************/
    
    public PageReference updateContactContinue()
    {
        update record;
        return cancel();
    }
    
    /*******************************************************
revert action
*******************************************************/
    
    public PageReference revert()
    {
        record = null;
        return null;
    }
    
    /*******************************************************
cancel action
*******************************************************/
    
    public PageReference cancel()
    {
        PageReference   standardView    = new PageReference( '/' + recordId + '?nooverride=1' );
        
        return standardView;
    }
    
    /*******************************************************
ContactInfo wrapper class
*******************************************************/
    
    public class ContactInfo
    {
        private Integer index;
        public String   indexString         { get { return String.valueOf( index ); } }
        
        public Boolean  isAddress           { get { return isAddress == true; } private set; }
        public Boolean  isPhone             { get { return isPhone == true; } private set; }
        public Boolean  isEmail             { get { return isEmail == true; } private set; }
        public Boolean  isDifferent         { get { return differs(); } }
        
        public SkyMiles.MemberAddress   address     { get; set; }
        public SkyMiles.MemberPhone     phone       { get; set; }
        public SkyMiles.MemberEmail     email       { get; set; }
        
        private Account record; //Contact //Account
        
        //public Contact  contact //Commented by Anil
        public Account contact
        {
            get
            {
                return
                    isAddress   ?   address.person_acc
                    :   isPhone     ?   phone.person_acc
                        :   isEmail     ?   email.person_acc
                            :                   null;
            }
        }
        
        public ContactInfo( Integer index, SkyMiles.MemberAddress address, Account record )// Contact record to Account Record
        {
            this.record     = record;
            this.index      = index;
            this.address    = address;
            isAddress       = true;
        }
        
        public ContactInfo( Integer index, SkyMiles.MemberPhone phone, Account record )// Contact record to Account Record
        {
            this.record     = record;
            this.index      = index;
            this.phone      = phone;
            isPhone         = true;
        }
        
        public ContactInfo( Integer index, SkyMiles.MemberEmail email, Account record )// Contact record to Account Record
        {
            this.record     = record;
            this.index      = index;
            this.email      = email;
            isEmail         = true;
        }
        
        private Boolean differs()
        {
            return
                isAddress   ?   addressDiffers()
                :   isEmail     ?   emailDiffers()
                    :   isPhone     ?   phoneDiffers()
                        :                   false;
        }
        
        private Boolean addressDiffers()
        {
            return
                (   getComparableAddress( address.person_acc, 'PersonMailing' )  != getComparableAddress( record, 'PersonMailing' )
                 &&  getComparableAddress( address.person_acc, 'PersonMailing' )  != getComparableAddress( record, 'PersonOther' )
                );
        }
        
        private String getComparableAddress( Account record, String fieldPrefix ) // Contact record to Account Record
        {
            String  street      = (String) record.get( fieldPrefix + 'Street' );
            String  city        = (String) record.get( fieldPrefix + 'City' );
            String  state       = (String) record.get( fieldPrefix + 'State' );
            String  postalCode  = (String) record.get( fieldPrefix + 'PostalCode' );
            String  country     = (String) record.get( fieldPrefix + 'Country' );
            
            List<String>    addressComponents   = new List<String>();
            if ( String.isNotBlank( street      ) ) addressComponents.add( street       .normalizeSpace().toUpperCase() );
            if ( String.isNotBlank( city        ) ) addressComponents.add( city         .normalizeSpace().toUpperCase() );
            if ( String.isNotBlank( state       ) ) addressComponents.add( state        .normalizeSpace().toUpperCase() );
            if ( String.isNotBlank( postalCode  ) ) addressComponents.add( postalCode   .normalizeSpace().toUpperCase() );
            if ( String.isNotBlank( country     ) ) addressComponents.add( country      .normalizeSpace().toUpperCase() );
            
            return String.join( addressComponents, ' ' );
        }
        
        private Boolean emailDiffers()
        {
            String  thisEmail   = email.person_acc.PersonEmail != null ? email.person_acc.PersonEmail.toUpperCase() : null;
            
            return
                (   thisEmail       != (record.Personal_Email__pc != null ? record.Personal_Email__pc.toUpperCase() : null)
                 &&  thisEmail       != (record.Work_Email__pc != null ? record.Work_Email__pc.toUpperCase() : null)
                 &&  thisEmail       != (record.Other_Email__pc != null ? record.Other_Email__pc.toUpperCase() : null)
                 &&  thisEmail       != (record.Other_Email_2__pc != null ? record.Other_Email_2__pc.toUpperCase() : null)
                 &&  thisEmail       != (record.Other_Email_3__pc != null ? record.Other_Email_3__pc.toUpperCase() : null)
                );
        }
        
        private Boolean phoneDiffers()
        {
            String  thisPhone   = phone.person_acc.Phone != null ? phone.person_acc.Phone.toUpperCase().replaceAll( '\\W', '' ) : null;
            return
                (   thisPhone       != (record.PersonHomePhone != null ? record.PersonHomePhone.toUpperCase().replaceAll( '\\W', '' ) : null)
                 &&  thisPhone       != (record.PersonMobilePhone != null ? record.PersonMobilePhone.toUpperCase().replaceAll( '\\W', '' ) : null)
                 &&  thisPhone       != (record.Work_Phone__pc != null ? record.Work_Phone__pc.toUpperCase().replaceAll( '\\W', '' ) : null)
                 &&  thisPhone       != (record.PersonOtherPhone != null ? record.PersonOtherPhone.toUpperCase().replaceAll( '\\W', '' ) : null)
                );
        }
    }
}