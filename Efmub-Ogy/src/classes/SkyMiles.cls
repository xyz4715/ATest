/*******************************************************//**

 NOTE:  Please perform local editing and C/I github. No code with compile issue should be allowed into devpro1.
 --- Yunzhen 
 
@class      SkyMiles

@brief      SkyMiles Utility Class

    This class abstracts the information returned from the
    SOA_LoyaltyMember service.

@author     Glyn Anderson   (LiquidHub.GHA)
@author     Janeen Anderson (LiquidHub.JA)

@version    2016-01-16  LiquidHub.GHA
    Created.
@version    2016-02-11  LiquidHub.GHA
    Added additional fields from service calls into the Contact.
    Invalid responses are returned as a Dom.Document in the
    MemberInformation structure.
@version    2016-05-01  LiquidHub.GHA
    Reconstituted code to determine 360 Customer and MQM fields.
@version    2016-05-08  LiquidHub.GHA
    Added Flying Blue (AirFranceLoyalty) functionality.
@version    2016-05-08  LiquidHub.JA
    Handle AirFrance MemberInformation construction without exception
        when not found.  And added inner class for SOA_AirFranceLoyalty invoke call.

@see        SkyMilesTest

    (c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

public class SkyMiles
{
    /*******************************************************
                MemberInformation class

    This class contains all of the (useful) information returned
    by a call to the LoyaltyMember service "RetrieveMaster" or
    "Search" operations.
    *******************************************************/

    public class MemberInformation
    {
        public Dom.Document     response;
        //Start_Sandesh_HTL_11-04-2017
        //Below Code changes to migrate Contact to PersonAccount
        
        //public Contact  contact     { get; private set; }
        public Account person_acc     { get; private set; }

        public String   name
        {
            get
            {
                List<String>    nameStrings     = new List<String>();
                if ( String.isNotBlank( person_acc.Salutation ) ) nameStrings.add( person_acc.Salutation );
                if ( String.isNotBlank( person_acc.FirstName ) ) nameStrings.add( person_acc.FirstName );
                if ( String.isNotBlank( person_acc.MiddleName ) ) nameStrings.add( person_acc.MiddleName );
                if ( String.isNotBlank( person_acc.LastName ) ) nameStrings.add( person_acc.LastName );
                if ( String.isNotBlank( person_acc.Suffix ) ) nameStrings.add( person_acc.Suffix );
                return String.join( nameStrings, ' ' );
            }
        }

        public String   languageCode        { get; private set; }
        public String   privacyCode         { get; private set; }

        public Boolean  activeSkyClub       { get; private set; }

        public List<MemberAddress>  addresses   { get; private set; }
        public List<MemberEmail>    emails      { get; private set; }
        public List<MemberPhone>    phones      { get; private set; }

        /***************************************************
                    MemberInformation constructor

        This constructor converts the response from "RetrieveMaster"
        into a MemberInformation object.
        ***************************************************/

        public MemberInformation( SOA_LoyaltyMember.RetrieveMasterResponseType record, SOA_LoyaltyTracking.RetrieveBalanceInfoResponseType balanceInfo )
        {
            
            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   Salutation          = record.MemberPersonalInfo.Title,
                FirstName           = record.MemberPersonalInfo.FirstName,
                MiddleName          = record.MemberPersonalInfo.MiddleName,
                LastName            = record.MemberPersonalInfo.LastName,
                Suffix              = record.MemberPersonalInfo.Suffix,
                Gender__pc          = genderLookup.get( record.MemberPersonalInfo.GenderCode ),
                PersonBirthdate     = SkyMiles.convertDate( record.MemberPersonalInfo.BirthDate ),
                SkyMiles_Number__pc = record.LoyaltyMemberNumber
            );

            languageCode            = record.MemberLanguageCode;
            privacyCode             = record.MemberPrivacyCode;

            activeSkyClub           = record.ActiveSkyClubIndicator == 'Y';

            if ( record.TierLevelInfo != null )
            {
                String  todayString     = DateTime.now().format( 'yyyyMMdd' );

                String  tierLevelCode;
                String  tierLevelEffectiveDate;
                String  millionMilerLevelCode;
                String  millionMilerLevelEffectiveDate;
                String  memberValueLevelCode;
                String  memberValueLevelEffectiveDate;

                for ( SOA_LoyaltyMember.TierLevelInfoType tierLevel : record.TierLevelInfo )
                {
                    if  (   todayString < tierLevel.EffectiveDate       //  not effective yet
                        ||  tierLevel.ExpirationDate < todayString      //  already expired
                        ) continue;

                    if ( tierLevel.ClassificationCode == 'MB' )
                    {
                        if ( tierLevelEffectiveDate != null && tierLevel.EffectiveDate < tierLevelEffectiveDate ) continue;

                        tierLevelCode           = tierLevel.WithinType;
                        tierLevelEffectiveDate  = tierLevel.EffectiveDate;
                    }

                    if ( tierLevel.ClassificationCode == 'MM' )
                    {
                        if ( millionMilerLevelEffectiveDate != null && tierLevel.EffectiveDate < millionMilerLevelEffectiveDate ) continue;

                        millionMilerLevelCode           = tierLevel.WithinType;
                        millionMilerLevelEffectiveDate  = tierLevel.EffectiveDate;
                    }

                    if ( tierLevel.ClassificationCode == 'MV' )
                    {
                        if ( memberValueLevelEffectiveDate != null && tierLevel.EffectiveDate < memberValueLevelEffectiveDate ) continue;

                        memberValueLevelCode            = tierLevel.WithinType;
                        memberValueLevelEffectiveDate   = tierLevel.EffectiveDate;
                    }
                }

                person_acc.SkyMiles_Status__pc  = tierLevelLookup.get( tierLevelCode );
                person_acc.Million_Miler__pc    = millionMilerLevelCode != null ? 'Yes' : 'No';
                person_acc.X360_Customer__pc    = memberValueLevelCode == 'TS' ? 'Yes' : 'No';
            }

            if ( record.VRUInfo != null )
            {
                person_acc.MQM__pc  =
                    String.isNotBlank( record.VRUInfo.MQMYTD )
                ?   Decimal.valueOf( record.VRUInfo.MQMYTD )
                :   null;
            }

            if ( balanceInfo != null && balanceInfo.BalanceDetails != null )
            {
                person_acc.MQM__pc  =
                    String.isNotBlank( balanceInfo.BalanceDetails.YearToDateQualifiyingMiles )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.YearToDateQualifiyingMiles )
                :   0;
                person_acc.MQS__pc  =
                    String.isNotBlank( balanceInfo.BalanceDetails.YearToDateQualifyingSegments )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.YearToDateQualifyingSegments )
                :   0;
                person_acc.MQD__pc  =
                    String.isNotBlank( balanceInfo.BalanceDetails.CurrentYearAnnualMQR )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.CurrentYearAnnualMQR )
                :   0;
                person_acc.Last_Year_MQM_SM__pc =
                    String.isNotBlank( balanceInfo.BalanceDetails.QualifyingMilesYearMinusOne )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.QualifyingMilesYearMinusOne )
                :   0;
                person_acc.Last_Year_MQS_SM__pc =
                    String.isNotBlank( balanceInfo.BalanceDetails.QualifyingSegmentsYearMinusOne )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.QualifyingSegmentsYearMinusOne )
                :   0;
                person_acc.Last_Year_MQD_SM__pc =
                    String.isNotBlank( balanceInfo.BalanceDetails.PreviousYearAnnualMQR )
                ?   Decimal.valueOf( balanceInfo.BalanceDetails.PreviousYearAnnualMQR )
                :   0;
            }

            person_acc.Current_Miles__pc  = 
                String.isNotBlank( record.MemberProgramBalanceAvailableMileageAmount )
            ?   Decimal.valueOf( record.MemberProgramBalanceAvailableMileageAmount )
            :   null;

            person_acc.Lifetime_Miles__pc  =
                String.isNotBlank( record.MemberProgramBalanceTotalProgramMileageAmout )
            ?   Decimal.valueOf( record.MemberProgramBalanceTotalProgramMileageAmout )
            :   null;

            person_acc.Delta_Sky_Club__pc  = record.ActiveSkyClubIndicator == 'Y' ? 'Yes' : 'No';

            addresses    = new List<MemberAddress>();
            if ( record.MemberAddressInfo != null )
            {
                for ( SOA_LoyaltyMember.MemberAddressInfoType address : record.MemberAddressInfo )
                {
                    MemberAddress  memberAddress  = new MemberAddress( address );
                    if ( memberAddress.isValid ) addresses.add( memberAddress );
                }
            }

            emails      = new List<MemberEmail>();
            if ( record.MemberEmailContactInfo != null )
            {
                for ( SOA_LoyaltyMember.MemberEmailContactInfoType email : record.MemberEmailContactInfo )
                {
                    emails.add( new MemberEmail( email ) );
                }
            }

            phones      = new List<MemberPhone>();
            if ( record.MemberPhoneContactInfo != null )
            {
                for ( SOA_LoyaltyMember.MemberPhoneContactInfoType phone : record.MemberPhoneContactInfo )
                {
                    phones.add( new MemberPhone( phone ) );
                }
            }

/*  Other fields in 'record' not yet used:
        public String AMEXReserveCardHolderIndicator;
        public String DatePasswordLastChanged;
        public String LockDate;
        public String MemberAccountTypeCode;
        public String MemberAliasFlag;
        public String MemberEmergencyLock;
        public String MemberEnrollmentDate;
        public String MemberPasswordExistsIndicator;
        public String MemberPinExists;
        public String MemberProgramBalanceAvailableMileageAmount;
        public String MemberProgramBalanceLockedMileageAmount;
        public String MemberSQAExistFlag;
        public String MemberStatusCode;
        public String MemberUrgentMemoIndicator;
        public String NumberOfFFPsForTravelCompanion;
        public String NumberOfTravelCompanions;
        public String PayWithMiles;
        public String ProgramMembershipStatusCode;
        public String ReturnCode;
        public String ReturnMessage;
        public String SecurityQuestion1;
        public String SecurityQuestion2;
        public String SkyClubExpirationDate;
//*/
        }

        /***************************************************
                    MemberInformation constructor

        This constructor converts the response from "Search"
        into a MemberInformation object.
        ***************************************************/

        public MemberInformation( SOA_LoyaltyMember.SearchResponseInfoType record )
        {
            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   Salutation          = record.PersonalInfo.Prefix,
                FirstName           = record.PersonalInfo.FirstName,
                MiddleName          = record.PersonalInfo.MiddleName,
                LastName            = record.PersonalInfo.LastName,
                Suffix              = record.PersonalInfo.Suffix,
                Gender__pc          = genderLookup.get( record.PersonalInfo.GenderCode ),
                PersonBirthdate     = SkyMiles.convertDate( record.PersonalInfo.DateOfBirth ),
                SkyMiles_Number__pc = record.LoyaltyAccountNumber
            );

            if ( record.TierLevelClassification == 'MB' )
            {
                person_acc.SkyMiles_Status__pc  = tierLevelLookup.get( record.TierLevelCode );
            }

            person_acc.Current_Miles__pc    =
                String.isNotBlank( record.CurrentAvailableMiles )
            ?   Decimal.valueOf( record.CurrentAvailableMiles )
            :   null;

            person_acc.Lifetime_Miles__pc   =
                String.isNotBlank( record.TotalProgramMiles )
            ?   Decimal.valueOf( record.TotalProgramMiles )
            :   null;

            addresses   = new List<MemberAddress>();
            if ( record.AddressInfo != null )
            {
                addresses.add( new MemberAddress( record.AddressInfo ) );
            }

            emails      = new List<MemberEmail>();

            phones      = new List<MemberPhone>();
            if ( record.PhoneInfo != null )
            {
                for ( SOA_LoyaltyMember.PhoneInfoType phone : record.PhoneInfo )
                {
                    phones.add( new MemberPhone( phone ) );
                }
            }
            if ( String.isNotBlank( record.PhoneBusiness ) )
            {
                phones.add( new MemberPhone( 'B', record.PhoneBusiness ) );
            }
            if ( String.isNotBlank( record.PhoneHome ) )
            {
                phones.add( new MemberPhone( 'H', record.PhoneHome ) );
            }

            languageCode    = record.PersonalInfo.CorrespondingLanguagePreference;
            privacyCode     = record.PersonalInfo.PrivacyCode;

/*  Other fields in 'record' not yet used:
        public String CurrentValue;
        public String FutureValue;
        public String IndValue;
        public String PreviousValue;
//*/
        }

        /***************************************************
                    MemberInformation constructor

        This constructor converts the response from AirFranceLoyalty
        into a MemberInformation object.
        ***************************************************/

        public MemberInformation( SOA_AirFranceLoyalty.IndividualInformationResponse record )
        {
            if (record == null) return;
            //contact     = new Contact();
            person_acc    = new Account();
            if (record.individual != null && record.individual.individualInformations != null)
            {
                person_acc.Salutation              = record.individual.individualInformations.civility;
                person_acc.FirstName               = record.individual.individualInformations.firstName;
                person_acc.MiddleName              = record.individual.individualInformations.secondFirstName;
                person_acc.LastName                = record.individual.individualInformations.lastName;
                //contact.Suffix                  = record.individual.individualInformations.???, 
                person_acc.Gender__pc              = genderLookup.get( record.individual.individualInformations.gender );
                person_acc.PersonBirthdate         = SkyMiles.convertFBDate( record.individual.individualInformations.dateOfBirth );
                person_acc.Flying_Blue_Number__pc  = record.individual.individualInformations.personnalIdentity;
            }

            if ( record.contractBloc != null )
            {
                String  todayString     = DateTime.now().format( 'yyyy-MM-dd' );

                String  tierLevelCode;
                String  tierLevelEffectiveDate;
                String  currentMiles;

                for ( SOA_AirFranceLoyalty.ContractBloc contractInfo : record.contractBloc )
                {
                    if  (   contractInfo.contractType.contractType != 'FP'
                        ||  (   String.isNotBlank( contractInfo.contractType.validityStartDate )
                            &&  todayString < contractInfo.contractType.validityStartDate       //  not effective yet
                            )
                        ||  (   String.isNotBlank( contractInfo.contractType.validityEndDate )
                            &&  contractInfo.contractType.validityEndDate < todayString         //  already expired
                            )
                        ||  (   tierLevelEffectiveDate != null
                            &&  contractInfo.contractType.validityStartDate < tierLevelEffectiveDate
                            )
                        ) continue;

                    tierLevelCode           = contractInfo.contractType.tierLevel;
                    tierLevelEffectiveDate  = contractInfo.contractType.validityStartDate;
                    currentMiles            = contractInfo.contractType.milesBalance;
                }

                person_acc.Flying_Blue_Status__pc   = fbTierLevelLookup.get( tierLevelCode );
                person_acc.Current_Miles_FB__pc     = currentMiles != null ? Decimal.valueOf( currentMiles ) : null;
            }

            addresses    = new List<MemberAddress>();
            if ( record.postalAddressBloc != null )
            {
                for ( SOA_AirFranceLoyalty.PostalAddressBloc address : record.postalAddressBloc )
                {
                    MemberAddress  memberAddress  = new MemberAddress( address );
                    if ( memberAddress.isValid ) addresses.add( memberAddress );
                }
            }

            emails      = new List<MemberEmail>();
            if ( record.emailBloc != null )
            {
                for ( SOA_AirFranceLoyalty.EmailBloc email : record.emailBloc )
                {
                    emails.add( new MemberEmail( email ) );
                }
            }

            phones      = new List<MemberPhone>();
            if ( record.telecomBloc != null )
            {
                for ( SOA_AirFranceLoyalty.TelecomBloc phone : record.telecomBloc )
                {
                    phones.add( new MemberPhone( phone ) );
                }
            }
        }

        /***************************************************
                    MemberInformation constructor

        This constructor converts the response from "RandomUser"
        into a MemberInformation object.
        ***************************************************/

        public MemberInformation( CWObject record )
        {
            CWObject    name    = (CWObject) record.get( 'name' );
            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   Salutation          = (String) name.get( 'title' ),
                FirstName           = (String) name.get( 'first' ),
                MiddleName          = null,
                LastName            = (String) name.get( 'last' ),
                Suffix              = null,
                Gender__pc          = (String) record.get( 'gender' ),
                PersonBirthdate     = DateTime.newInstance( (Long) record.get( 'dob' ) ).date(),
                SkyMiles_Number__pc  = (String) record.get( 'skymiles' )
            );

            languageCode    = null;
            privacyCode     = null;

            person_acc.SkyMiles_Status__pc  = 'Silver';
            person_acc.Lifetime_Miles__pc   = 12345;

            CWObject    location    = (CWObject) record.get( 'location' );
            addresses   = new List<MemberAddress>();
            addresses.add
            (  new MemberAddress
                (  'MailingAddress',
                    (String) location.get( 'street' ),
                    (String) location.get( 'city' ),
                    (String) location.get( 'state' ),
                    'USA',
                    CWString.leftPad( String.valueOf( location.get( 'zip' ) ), '0', 5 )
                )
            );

            emails      = new List<MemberEmail>();
            emails.add( new MemberEmail( 'Personal Email', (String) record.get( 'email' ) ) );

            phones      = new List<MemberPhone>();
            phones.add( new MemberPhone( 'H', (String) record.get( 'phone' ) ) );
            phones.add( new MemberPhone( 'C', (String) record.get( 'cell' ) ) );
        }

        /***************************************************
                    MemberInformation constructor

        This constructor saves the XML response as a Document.
        ***************************************************/

        public MemberInformation( Dom.Document document )
        {
            response    = document;
        }
    }

    /*******************************************************
                    genderLookup property
    *******************************************************/

    private static Map<String,String>  genderLookup
    {
        get
        {
            if ( genderLookup == null )
            {
                genderLookup    = new Map<String,String>
                {   'M'     => 'Male',
                    'F'     => 'Female'
                };
            }
            return genderLookup;
        }
    }

    /*******************************************************
                    tierLevelLookup property
    *******************************************************/

    private static Map<String,String>  tierLevelLookup
    {
        get
        {
            if ( tierLevelLookup == null )
            {
                tierLevelLookup     = new Map<String,String>
                {   'B'     => 'Base Member',
                    'S'     => 'Silver Medallion',
                    'G'     => 'Gold Medallion',
                    'PM'    => 'Platinum Medallion',
                    'PL'    => 'Platinum Medallion',
                    'DM'    => 'Diamond Medallion'
                };
            }
            return tierLevelLookup;
        }
    }

    /*******************************************************
                    fbTierLevelLookup property
    *******************************************************/

    private static Map<String,String>  fbTierLevelLookup
    {
        get
        {
            if ( fbTierLevelLookup == null )
            {
                fbTierLevelLookup       = new Map<String,String>
                {   'P'     => 'Flying Young Fledgling',
                    'J'     => 'Flying Young',
                    'A'     => 'Ivory (Base)',
                    'B'     => 'Silver',
                    'R'     => 'Gold',
                    'M'     => 'Platinum',
                    'C'     => 'Club 2000'
                };
            }
            return fbTierLevelLookup;
        }
    }

    /*******************************************************
                    MemberAddress class

    This represents an address, which is stored in the
    "MailingAddress" fields of a Contact record.
    *******************************************************/

    public class MemberAddress
    {
        //public Contact  contact     { get; private set; }
        public Account  person_acc     { get; private set; }
        public Boolean  isValid     { get; private set; }
        public Boolean  isPrimary   { get; private set; }
        public String   label       { get; private set; }

        public String   cityStateZip
        {  
            get
            {
                return
                    (String.isNotBlank( person_acc.PersonMailingCity ) ? person_acc.PersonMailingCity : '')
                +   (String.isNotBlank( person_acc.PersonMailingState ) ? ', ' + person_acc.PersonMailingState : '')
                +   (String.isNotBlank( person_acc.PersonMailingPostalCode ) ? ' ' + person_acc.PersonMailingPostalCode : '');
            }
        }

        /***************************************************
                    MemberAddress constructor

        This constructor converts an address from "RetrieveMaster"
        into a MemberAddress object.
        ***************************************************/

        public MemberAddress( SOA_LoyaltyMember.MemberAddressInfoType address )
        {
            List<String>    streetAddress   = new List<String>();
            if ( String.isNotBlank( address.AddressLine1  ) ) streetAddress.add( address.AddressLine1 );
            if ( String.isNotBlank( address.AddressLine2  ) ) streetAddress.add( address.AddressLine2 );

            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   PersonMailingStreet       = CWString.join( streetAddress, '\n' ),
                PersonMailingCity         = address.CityOrCountyOrWard,
                PersonMailingState        = address.StateOrProvinceCode,
                PersonMailingCountry      = address.CountryCode,
                PersonMailingPostalCode   = address.PostalCode 
            );
            isValid     = true;
            isPrimary   = address.PrimaryAddressIndicator == 'Y';
            if ( String.isNotBlank( address.Location ) ) label = addressTypeLookup.get( address.Location );
            if ( label == null ) label = 'Other Address';

/*  Other fields in 'address' not yet used:
        public String AliasName;
        public String CompanyMailingName;
        public String DistrictCode;
        public String DistrictOrTownOrVillage;
        public String EffectiveDate;
        public String SOASequenceNumber;
        public String SequenceNumber;
        public String TerritoryOrPrefecture;
//*/
        }

        /***************************************************
                    MemberAddress constructor

        This constructor converts an address from "Search"
        into a MemberAddress object.
        ***************************************************/

        public MemberAddress( SOA_LoyaltyMember.AddressInfoType address )
        {
            List<String>    streetAddress   = new List<String>();
            if ( String.isNotBlank( address.AddressLine1  ) ) streetAddress.add( address.AddressLine1 );
            if ( String.isNotBlank( address.AddressLine2  ) ) streetAddress.add( address.AddressLine2 );

           //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   PersonMailingStreet       = CWString.join( streetAddress, '\n' ),
                PersonMailingCity         = address.CityCountyWard,
                PersonMailingState        = address.StateProvCode,
                PersonMailingCountry      = address.CountryCode,
                PersonMailingPostalCode   = address.PostalCode
            );

            isValid     = address.InvalidAddressInd != 'Y';
            isPrimary   = address.PrimaryInd == 'Y';
            if ( String.isNotBlank( address.TypeCode ) ) label = addressTypeLookup.get( address.TypeCode );
            if ( label == null ) label = 'Other Address';

/*  Other fields in 'address' not yet used:
        public String AddressAuditFailedInd;
        public String AddressSequenceNumber;
        public String AreaTerritoryPrefecture;
        public String BusinessName;
        public String DistrictCode;
        public String DistrictTownVillage;
        public String EffectiveDate;
        public String ExpireDate;
        public String FormattedInd;
        public String OccupationCompanyName;
        public String PreferenceCategoryID;
        public String PreferenceShortName;
        public String SequenceNumber;
//*/
        }

        /***************************************************
                    MemberAddress constructor

        This constructor converts an address from AirFranceLoyalty
        into a MemberAddress object.
        ***************************************************/

        public MemberAddress( SOA_AirFranceLoyalty.PostalAddressBloc address )
        {
            SOA_AirFranceLoyalty.PostalAddressType  addressInfo     = address.postalAddressType;
            isValid     = addressInfo != null;
            if ( !isValid ) return;

            List<String>    streetAddress   = new List<String>();
            if ( String.isNotBlank( addressInfo.numberAndStreet  ) ) streetAddress.add( addressInfo.numberAndStreet );
            if ( String.isNotBlank( addressInfo.district  ) ) streetAddress.add( addressInfo.district );

            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   PersonMailingStreet       = CWString.join( streetAddress, '\n' ),
                PersonMailingCity         = addressInfo.city,
                PersonMailingState        = addressInfo.stateCode,
                PersonMailingCountry      = addressInfo.countryCode,
                PersonMailingPostalCode   = addressInfo.zipCode
            );

            isValid     = addressInfo.mediumStatus == 'V';
            isPrimary   = address.mainPostalAddress == 'O';
            if ( String.isNotBlank( addressInfo.mediumCode ) ) label = fbAddressTypeLookup.get( addressInfo.mediumCode );
            if ( label == null ) label = 'Other Address';
        }

        /***************************************************
                    MemberAddress constructor
        ***************************************************/

        public MemberAddress( String type, String street, String city, String state, String country, String postalCode )
        {
            //contact     = new Contact //Commented by Sandesh_HTL to replace Contact with PersonAcount
            person_acc     = new Account
            (   PersonMailingStreet       = street,
                PersonMailingCity         = city,
                PersonMailingState        = state,
                PersonMailingCountry      = country,
                PersonMailingPostalCode   = postalCode
            );

            isValid     = true;
            isPrimary   = false;
            label       = type;
        }
    }

    /*******************************************************
                addressTypeLookup property
    *******************************************************/

    private static Map<String,String>  addressTypeLookup
    {
        get
        {
            if ( addressTypeLookup == null )
            {
                addressTypeLookup   = new Map<String,String>
                {   'H'     => 'Home Address',
                    'B'     => 'Business Address',
                    'O'     => 'Other Address'
                };
            }
            return addressTypeLookup;
        }
        private set;
    }

    /*******************************************************
                fbAddressTypeLookup property
    *******************************************************/

    private static Map<String,String>  fbAddressTypeLookup
    {
        get
        {
            if ( fbAddressTypeLookup == null )
            {
                fbAddressTypeLookup = new Map<String,String>
                {   'D'     => 'Home Address',
                    'P'     => 'Business Address'
                };
            }
            return fbAddressTypeLookup;
        }
        private set;
    }

    /*******************************************************
                    MemberEmail class

    This represents an email address, which is stored in the
    "Email" field of a Contact record.
    *******************************************************/

    public class MemberEmail
    {
        //public Contact  contact     { get; private set; }
        public Account  person_acc  { get; private set; }
        public Boolean  isValid     { get; private set; }
        public Boolean  isPrimary   { get; private set; }
        public String   label       { get; private set; }

        /***************************************************
                    MemberEmail constructor

        This constructor converts an email from "RetrieveMaster"
        into a MemberEmail object.
        ***************************************************/

        public MemberEmail( SOA_LoyaltyMember.MemberEmailContactInfoType email )
        {
            //person_acc     = new Account( Email = email.Address );
            person_acc     = new Account( PersonEmail = email.Address );
            
            

            isValid     = email.InvalidAddress != 'Y';
            isPrimary   = email.PrimaryEmailIndicator == 'Y';
            if ( String.isNotBlank( email.EmailAddressType ) ) label = emailTypeLookup.get( email.EmailAddressType );
            if ( label == null ) label = 'Other Email';

/*  Other fields in 'email' not yet used:
        public String EmailAddressLocation;
        public String HtmlOrPlainTextDesired;
        public String SOASequenceNumber;
        public String SequenceNumber;
//*/
        }

        /***************************************************
                    MemberEmail constructor

        This constructor converts an email from AirFranceLoyalty
        into a MemberEmail object.
        ***************************************************/

        public MemberEmail( SOA_AirFranceLoyalty.EmailBloc email )
        {
            SOA_AirFranceLoyalty.EmailType  emailInfo       = email.emailtype;
            isValid     = emailInfo != null;
            if ( !isValid ) return;

            person_acc     = new Account( PersonEmail = emailInfo.email );

            isValid     = emailInfo.mediumStatus == 'V';
            isPrimary   = false;
            if ( String.isNotBlank( emailInfo.mediumCode ) ) label = fbEmailTypeLookup.get( emailInfo.mediumCode );
            if ( label == null ) label = 'Other Email';
        }

        /***************************************************
                    MemberEmail constructor
        ***************************************************/

        public MemberEmail( String type, String email )
        {
            person_acc     = new Account( PersonEmail = email );

            isValid     = true;
            isPrimary   = false;
            label       = type;
        }
    }

    /*******************************************************
                emailTypeLookup property
    *******************************************************/

    private static Map<String,String>  emailTypeLookup
    {
        get
        {
            if ( emailTypeLookup == null )
            {
                emailTypeLookup     = new Map<String,String>
                {   'H'     => 'Home Email',
                    'B'     => 'Business Email',
                    'O'     => 'Other Email'
                };
            }
            return emailTypeLookup;
        }
        private set;
    }

    /*******************************************************
                fbEmailTypeLookup property
    *******************************************************/

    private static Map<String,String>  fbEmailTypeLookup
    {
        get
        {
            if ( fbEmailTypeLookup == null )
            {
                fbEmailTypeLookup       = new Map<String,String>
                {   'D'     => 'Home Email',
                    'P'     => 'Business Email'
                };
            }
            return fbEmailTypeLookup;
        }
        private set;
    }

    /*******************************************************
                    MemberPhone class

    This represents a phone number, which is stored in the
    "Phone" field of a Contact record.
    *******************************************************/

    public class MemberPhone
    {
        public Account  person_acc     { get; private set; }
        public Boolean  isValid     { get; private set; }
        public Boolean  isPrimary   { get; private set; }
        public String   label       { get; private set; }

        /***************************************************
                    MemberPhone constructor

        This constructor converts a phone number from "RetrieveMaster"
        into a MemberPhone object.
        ***************************************************/

        public MemberPhone( SOA_LoyaltyMember.MemberPhoneContactInfoType phone )
        {
            List<String>    phoneNumber     = new List<String>();
            if ( String.isNotBlank( phone.CountryCode   ) ) phoneNumber.add( '+' + phone.CountryCode );
            if ( String.isNotBlank( phone.AreaCode      ) ) phoneNumber.add( '(' + phone.AreaCode + ')' );
            if ( String.isNotBlank( phone.PhoneNumber   ) ) phoneNumber.add( phone.PhoneNumber );
            if ( String.isNotBlank( phone.Extension     ) ) phoneNumber.add( 'x' + phone.Extension );

            person_acc     = new Account( Phone = CWString.join( phoneNumber, ' ' ) );

            isValid     = true;
            isPrimary   = false;
            if ( String.isNotBlank( phone.TypeCode ) ) label = phoneTypeLookup.get( phone.TypeCode );
            if ( label == null && String.isNotBlank( phone.Location ) ) label = phoneTypeLookup.get( phone.Location );
            if ( label == null ) label = 'Other Phone';

/*  Other fields in 'phone' not yet used:
        public String PagerPIN;
        public String SOASequenceNumber;
        public String SequenceNumber;
//*/
        }

        /***************************************************
                    MemberPhone constructor

        This constructor converts a phone number from "Search"
        into a MemberPhone object.
        ***************************************************/

        public MemberPhone( SOA_LoyaltyMember.PhoneInfoType phone )
        {
            List<String>    phoneNumber     = new List<String>();
            if ( String.isNotBlank( phone.CountryCode   ) ) phoneNumber.add( '+' + phone.CountryCode );
            if ( String.isNotBlank( phone.AreaCode      ) ) phoneNumber.add( '(' + phone.AreaCode + ')' );
            if ( String.isNotBlank( phone.PhoneNumber   ) ) phoneNumber.add( phone.PhoneNumber );
            if ( String.isNotBlank( phone.Extension     ) ) phoneNumber.add( 'x' + phone.Extension );

            person_acc     = new Account( Phone = CWString.join( phoneNumber, ' ' ) );

            isValid     = true;
            isPrimary   = false;
            if ( String.isNotBlank( phone.TypeCode ) ) label = phoneTypeLookup.get( phone.TypeCode );
            if ( label == null && String.isNotBlank( phone.Location ) ) label = phoneTypeLookup.get( phone.Location );
            if ( label == null ) label = 'Other Phone';

/*  Other fields in 'phone' not yet used:
        public String PagerPIN;
        public String PhoneSequenceNumber;
//*/
        }

        /***************************************************
                    MemberPhone constructor

        This constructor converts a phone number from AirFranceLoyalty
        into a MemberPhone object.
        ***************************************************/

        public MemberPhone( SOA_AirFranceLoyalty.TelecomBloc phone )
        {
            SOA_AirFranceLoyalty.TelecomType    phoneInfo       = phone.telecomType;
            isValid     = phoneInfo != null;
            if ( !isValid ) return;

            List<String>    phoneNumber     = new List<String>();
            if ( String.isNotBlank( phoneInfo.countryCode   ) ) phoneNumber.add( '+' + phoneInfo.countryCode );
            if ( String.isNotBlank( phoneInfo.regionCode        ) ) phoneNumber.add( '(' + phoneInfo.regionCode + ')' );
            if ( String.isNotBlank( phoneInfo.phoneNumber   ) ) phoneNumber.add( phoneInfo.phoneNumber );

            person_acc          = new Account( Phone = CWString.join( phoneNumber, ' ' ) );

            isValid     = phoneInfo.mediumStatus == 'V';
            isPrimary   = phone.mainTelecom == 'O';
            if ( String.isNotBlank( phoneInfo.mediumCode ) ) label = fbPhoneTypeLookup.get( phoneInfo.mediumCode );
            if ( label == null ) label = 'Other Phone';
        }

        /***************************************************
                    MemberPhone constructor
        ***************************************************/

        public MemberPhone( String type, String phone )
        {
            person_acc          = new Account( Phone = phone );

            isValid     = true;
            isPrimary   = false;
            label       = phoneTypeLookup.get( type );
        }
    }

    /*******************************************************
                phoneTypeLookup property
    *******************************************************/

    private static Map<String,String>  phoneTypeLookup
    {
        get
        {
            if ( phoneTypeLookup == null )
            {
                phoneTypeLookup     = new Map<String,String>
                {   'H'     => 'Home Phone',
                    'B'     => 'Business Phone',
                    'O'     => 'Other Phone',
                    'C'     => 'Mobile Phone',
                    'F'     => 'Fax',
                    'P'     => 'Pager',
                    'T'     => 'TDD Phone'
                };
            }
            return phoneTypeLookup;
        }
        private set;
    }

    /*******************************************************
                fbPhoneTypeLookup property
    *******************************************************/

    private static Map<String,String>  fbPhoneTypeLookup
    {
        get
        {
            if ( fbPhoneTypeLookup == null )
            {
                fbPhoneTypeLookup       = new Map<String,String>
                {   'D'     => 'Home Phone',
                    'P'     => 'Business Phone'
                };
            }
            return fbPhoneTypeLookup;
        }
        private set;
    }

    /*******************************************************
                    Lookup class

    This class is used to find a specific SkyMiles member
    using their SkyMiles Number.
    *******************************************************/

    public class Lookup
    {
        private SOA_LoyaltyMember.RetrieveMasterRequestType     request;

        /***************************************************
                    Lookup constructor
        ***************************************************/

        public Lookup()
        {
            request     = new SOA_LoyaltyMember.RetrieveMasterRequestType();
        }

        /***************************************************
                    set<Parameter> methods

        Each of these sets a corresponding "RetrieveMaster"
        request parameter.

        These all follow the Monad design pattern.
        ***************************************************/

        public Lookup setFirstName( String firstName )
        {
            request.FirstNameFirstInitial   = firstName;
            return this;
        }

        public Lookup setLastName( String lastName )
        {
            request.LastName    = lastName;
            return this;
        }

        public Lookup setSkyMilesNumber( String skyMilesNumber )
        {
            request.LoyaltyAccountNumber    = skyMilesNumber;
            return this;
        }

        public Lookup setPostalCode( String postalCode )
        {
            request.MemberZip   = postalCode;
            return this;
        }

        /***************************************************
                        find method

        This method returns a MemberInformation object with
        information about the SkyMiles member identified by
        the given SkyMiles Number.

        This method returns null if no member is found, or if
        no SkyMiles Number is provided.
        ***************************************************/

        public MemberInformation find()
        {
            if ( String.isBlank( request.LoyaltyAccountNumber ) ) return null;
//*
            SOA_LoyaltyMember.LoyaltyMember_EP              service     = new SOA_LoyaltyMember.LoyaltyMember_EP();
            SOA_LoyaltyMember.RetrieveMasterResponseType    response    = service.RetrieveMaster( request );

            if ( !CWSoap.isSuccessfulResponse( response ) )
            {
                return new MemberInformation( CWSoap.getResponse( response ) );
            }

            SOA_LoyaltyTracking.LoyaltyTracking_EP                  trackingService     = new SOA_LoyaltyTracking.LoyaltyTracking_EP();
            SOA_LoyaltyTracking.RetrieveBalanceInfoResponseType     trackingResponse    = trackingService.RetrieveBalanceInfo( request.LoyaltyAccountNumber );

            if ( !CWSoap.isSuccessfulResponse( trackingResponse ) )
            {
                trackingResponse    = null;
            }


/*/
            CWObject jsonResponse = new CWObject
            (  (new CWRest.Client
                (   'https://randomuser.me/api/',
                    new Map<String,String>{ 'Content-Type' => 'application/json' },
                    new Map<String,String>{ 'results' => '1', 'nat' => 'US' } 
                )
                ).get()
            );
            List<CWObject>  results     = (List<CWObject>) jsonResponse.get( 'results' );
            CWObject        response    = (CWObject) results[0].get( 'user' );
            response.put( 'skymiles', request.LoyaltyAccountNumber );
//*/

            return new MemberInformation( response, trackingResponse );
        }
    }

    /*******************************************************
                    Search class

    This class is used to search the SkyMiles database for
    members that match the search criteria.
    *******************************************************/

    public class Search implements Iterable<MemberInformation>
    {
        private SOA_LoyaltyMember.SearchRequestType     request;

        public Boolean  hasMore     { get { return request.GetMoreResultsInd == 'Y' || request.LastRecordReceivedSequenceNumber == null; } }

        /***************************************************
                    Search constructor
        ***************************************************/

        public Search()
        {
            request                     = new SOA_LoyaltyMember.SearchRequestType();
            request.GetMoreResultsInd   = 'N';
        }

        /***************************************************
                    set<Parameter> methods

        Each of these sets a corresponding "Search" request
        parameter.

        These all follow the Monad design pattern.
        ***************************************************/

        public Search setFirstName( String firstName )
        {
            request.FirstName       = CWString.left( firstName, 9 );
            return this;
        }

        public Search setMiddleName( String middleName )
        {
            request.MiddleInitial   = CWString.left( middleName, 1 );
            return this;
        }

        public Search setLastName( String lastName )
        {
            request.LastName        = lastName;
            return this;
        }

        public Search setStreetAddress( String streetAddress )
        {
            request.AddressLine     = streetAddress;
            return this;
        }

        public Search setState( String stateCode )
        {
            request.StateProvinceCode   = stateCode;
            return this;
        }

        public Search setCountry( String countryCode )
        {
            request.CountryCode     = countryCode;
            return this;
        }

        public Search setPostalCode( String postalCode )
        {
            request.PostalCode      = postalCode;
            return this;
        }
        //added below by venkata
        public Search setCity( String city)
        {
            request.CityOrCountyOrWard= city;
            return this;
        }
        public Search setTicketNumber( String ticketNumber )
        {
            request.TicketNumber    = ticketNumber;
            return this;
        }
        
        //Added by HTL_sandesh
         public Search setPhone( String phone )
        {
            request.Phone       = phone;
            return this;
        }
        
         public Search setEmail( String email )
        {
            request.Email       = email;
            return this;
        }
        
        //End Htl_sandesh
        
        /***************************************************
                        find method

        This method returns a list of MemberInformation objects
        with information about SkyMiles members that match the
        search criteria provided.

        Subsequent calls will return additional records if 'hasMore'
        is true.

        This method returns null when no more members are found,
        or if no search parameters are provided.
        ***************************************************/

        public List<MemberInformation> find()
        {
            if ( !hasMore ) return null;

            if  (   String.isBlank( request.FirstName           )
                &&  String.isBlank( request.MiddleInitial       )
                &&  String.isBlank( request.LastName            )
                &&  String.isBlank( request.AddressLine         )
                &&  String.isBlank( request.StateProvinceCode   )
                &&  String.isBlank( request.CountryCode         )
                &&  String.isBlank( request.PostalCode          )
                &&  String.isBlank( request.TicketNumber        )
                &&  String.isBlank( request.Phone        )  //Added by HTL_Sandesh_4242017
                &&  String.isBlank( request.Email        )  //Added by HTL_Sandesh_4242017
                ) return null;
            
            System.debug('Sandesh-Phone -' +  request.Phone );
            System.debug('Sandesh-Email -' + request.Email );
            
            SOA_LoyaltyMember.LoyaltyMember_EP      service     = new SOA_LoyaltyMember.LoyaltyMember_EP();
            SOA_LoyaltyMember.SearchResponseType    response    = service.Search_x( request );

            if ( !CWSoap.isSuccessfulResponse( response ) )
            {
                return new List<MemberInformation>{ new MemberInformation( CWSoap.getResponse( response ) ) };
            }

            if ( response == null || response.SearchResponseInfo == null ) return null;     //  @todo: This needs to be trapped along with the status 500 for no record found

            //  check for error(s)
            if ( response.ReturnCode == 'error' )
            {
                CWException.error
                (  CWString.join
                    (  new List<String>
                        {  
                            'LoyaltyMember.Search Error: ',         response.ReturnMessage,     '\n',
                            response.Error.ErrorCode,       ': ',   response.Error.ErrorText,   '\n',
                            response.Error.ReasonCode,      ': ',   response.Error.ReasonText,  '\n',  
                            response.Error.AdditionalInfo,  '\n'
                        }
                    )
                );
                return null;
            }

            List<MemberInformation>     searchResults   = new List<MemberInformation>();

            if ( response == null || response.SearchResponseInfo == null ) return null;     //  @todo: This needs to be trapped along with the status 500 for no record found

            for ( SOA_LoyaltyMember.SearchResponseInfoType record : response.SearchResponseInfo )
            {
                searchResults.add( new MemberInformation( record ) );

                request.LastRecordReceivedAccountNumber     = record.LoyaltyAccountNumber;
                request.LastRecordReceivedLastName          = record.PersonalInfo.LastName;
                request.LastRecordReceivedSequenceNumber    = record.SequenceNumber;
            }
            request.GetMoreResultsInd   = response.MoreResultsAvailable;

            return searchResults;
        }

        /*******************************************************
                        Iterator method

        This method implements the Iterable interface.  It returns
        a SearchIterator instance associated with this Search.
        *******************************************************/

        public virtual Iterator<MemberInformation> Iterator()
        {
            return new SearchIterator( this );
        }
    }

    /*******************************************************
                    SearchIterator class

    This private class implements the Iterator for CWIterable.
    It is only used internally to CWIterable.
    *******************************************************/

    private class SearchIterator implements Iterator<MemberInformation>
    {
        private Search                      theSearch;
        private List<MemberInformation>     results;

        /***************************************************
                    SearchIterator constructor
        ***************************************************/

        private SearchIterator( Search aSearch )
        {
            theSearch   = aSearch;
        }

        /***************************************************
                        hasNext method

        This method implments the Iterator interface.  It
        returns 'true' if this Iterator can supply another
        MemberInformation.
        ***************************************************/

        public Boolean hasNext()
        {
            return
            (   !CWCollection.isEmpty( results )
            ||  theSearch.hasMore
            );
        }

        /***************************************************
                        next method

        This method implments the Iterator interface.  It
        returns the next MemberInformation from the Search,
        or 'null' if there is none.
        ***************************************************/

        public MemberInformation next()
        {
            if ( CWCollection.isEmpty( results ) && theSearch.hasMore )
            {
                results     = theSearch.find();
            }
            return !CWCollection.isEmpty( results ) ? results.remove( 0 ) : null;
        }
    }

    /*******************************************************
                    FlyingBlueMember class
    *******************************************************/
    public class FlyingBlueMember
    {
        private SOA_AirFranceLoyalty.ProvideIndividualDataService_v1_soap11http service;
        public FlyingBlueMember()
        {
            service = new SOA_AirFranceLoyalty.ProvideIndividualDataService_v1_soap11http();
        }

        public SkyMiles.MemberInformation getMember( String loyaltyNumber )
        {
            if (loyaltyNumber == null) return null;
            SOA_AirFranceLoyalty.IndividualInformationResponse response = service.invoke(loyaltyNumber);
            system.debug('fb# response is'+response );
            if (response == null || response.individual == null) return null;
            return new SkyMiles.MemberInformation(response);
        }
    }

    /*******************************************************
                    convertDate method

    Converts the date string returned from LoyaltyMember
    into a Date.  Assumes date string format: YYYYMMDD
    *******************************************************/

    public static Date convertDate( String dateString )
    {
        return
            String.isNotBlank( dateString ) && Pattern.matches( '^\\d{8}$', dateString )
        ?   Date.newInstance( Integer.valueOf( dateString.left(4) ), Integer.valueOf( dateString.left(6).right(2) ), Integer.valueOf( dateString.right(2) ) )
        :   null;
    }

    /*******************************************************
                    convertFBDate method

    Converts the date string returned from AirFranceLoyalty
    into a Date.  Assumes date string format: YYYY-MM-DD
    *******************************************************/

    public static Date convertFBDate( String dateString )
    {
        return
            String.isNotBlank( dateString ) && Pattern.matches( '^\\d{4}\\-\\d{2}\\-\\d{2}$', dateString )
        ?   Date.newInstance( Integer.valueOf( dateString.left(4) ), Integer.valueOf( dateString.left(7).right(2) ), Integer.valueOf( dateString.right(2) ) )
        :   null;
    }
}