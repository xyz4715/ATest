/*******************************************************//**

@class      SkyFinderUtils

@brief      classes and static functions used by all Skyfinder Controllers


@author     Janeen Anderson   (LiquidHub.JDA)

@version    2016-03-15  LiquidHub.JDA
    Created.


@see        SkyFinderFindContactBasic (Controller)

    (c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class SkyFinderUtils
{

    //////////////////
    // static parameters
    //      -- deltaAccount
    //      -- householdAccountRecType
    //      -- contactEmployeeRecordType
    //      -- passengerContactRecType
    //      -- passengerContactRecTypeString
    //      -- passengerListPageSize
    //      -- searchReturnLimit
    //////////////////

    public static Integer searchReturnLimit // not recommended to make this a custom setting since it depends on SOA behavior
    {   // will alert that too many results were returned if reached
        get
        {
            if (searchReturnLimit == null) searchReturnLimit = 45;
            return searchReturnLimit;
        }
        private set;
    }

    public static Integer passengerListPageSize // TODO: make this a custom setting, add to CWCoreConfiguration
    {   // used by paging struct
        get
        {
            if (passengerListPageSize == null) passengerListPageSize = 20;
            return passengerListPageSize;
        }
        private set;
    }

    public static RecordType contactEmployeeRecordType
    {
        get
        {
            if (contactEmployeeRecordType == null) 
            {
                List<RecordType> rTypes = [SELECT Id FROM   RecordType WHERE  sObjectType = 'Account' AND DeveloperName = 'PersonAccount'];
                contactEmployeeRecordType = rTypes .isEmpty() ? null : rTypes[0];
            }
            return contactEmployeeRecordType;
        }
        // read only
    }

    public static Id passengerContactRecType
    {
        get
        {
            if (passengerContactRecType == null) passengerContactRecType = CWSchema.getRecordTypeId('Account', 'PersonAccount');
            return passengerContactRecType;
        }
        // read only
    }

    public static String passengerContactRecTypeString
    {
        get
        {
            return passengerContactRecType == null ? null : ('\'' + passengerContactRecType + '\'');
        }
    }
    
    // dont think that this part is required as we will not create separate account
    public static Account deltaAccount
    {
        get
        {
            if (deltaAccount == null)
            {
                List<Account> deltaAccountList = [SELECT id FROM Account WHERE FASsmBase__c = 'DL' AND RecordType.DeveloperName = 'Entity'];
                deltaAccount = deltaAccountList.isEmpty() ? null : deltaAccountList[0];
            }
            return deltaAccount;
        }
        // read only
    }
    
    // dont think that this part is required as we will not create separate account
    public static Id householdAccountRecType
    {
        get
        {
            if(householdAccountRecType == null) householdAccountRecType = CWSchema.getRecordTypeId('Account', 'Household'); 
            return householdAccountRecType;
        }
        // read only
    }

    //////////////////
    // static functions
    //      -- retrieveContactFields
    //      -- 
    //////////////////

    public static Map<String,Schema.SObjectField> retrieveContactFields()
    {
        Map<String,Schema.SObjectField> contactFields;
        Schema.sObjectType contactSObjectType  = Account.getSObjectType();
        contactFields       = CWSchema.getSObjectFields( contactSObjectType ); 
        return contactFields;                   
    }

    public static idTupple validateID( String anID )
    {
        idTupple rval = new idTupple();
        rval.isValid = false;
        if (anID == null || anID == '') // no ID is valid ID
        {
            rval.isValid = true;
            return rval;
        } 
        String escapedID = String.escapeSingleQuotes(anID);
        if((escapedID.length() == 15 || escapedID.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', escapedID)) 
        {
            try
            {
                ID testID = Id.valueOf(escapedID);
                rval.myType = testID.getSObjectType();
                rval.isValid = true;
                return rval;
            }
            catch (Exception e)
            {
                // absorb the exception and return not valid
            }
        }
        return rval;
    }

    public static Map<String, Account> queryForMatchingContact( Set<String> loyaltyNumbers ) // key of return map is a loyalty number
    {
        if (loyaltyNumbers == null || loyaltyNumbers.isEmpty()) return new Map<String, Account>();
System.Debug('queryForMatchingContact loyaltyNumbers\n' + loyaltyNumbers);
        CWQuery queryContact = CWQuery.newQuery('Account').addAllFields();
        //queryContact.add( 'AccountID', new List<String>{'Id', 'Name'} );
        CWQuery.WhereClause contactWhere = queryContact.newANDWhereClause('RecordTypeid = ' + passengerContactRecTypeString);
        contactWhere.newORWhereClause().isIN('SkyMiles_Number__pc',new List<String>(loyaltyNumbers))
                                       .isIN('Flying_Blue_Number__pc',new List<String>(loyaltyNumbers));
System.Debug('queryForMatchingContact theWhereClause\n' + queryContact.getWhereClause());
        Map<String, Account> rval = new Map<String, Account>();
        for(Account found : (List<Account>)queryContact.query() )
        {
            if (found.SkyMiles_Number__pc != null) rval.put(found.SkyMiles_Number__pc, found);
            if (found.Flying_Blue_Number__pc != null) rval.put(found.Flying_Blue_Number__pc, found);
        }
        return rval;
    }
    
    public static void replaceWithQueriedContact( Map<String, Account> theContacts, Map<String,SkyFinderMainController.contactDetailWrapper> theList)
    {
System.Debug('replaceWithQueriedContact: ' + theContacts.keyset().size() );
System.Debug('replaceWithQueriedContact: ' + theContacts.keyset() );
System.Debug('replaceWithQueriedContact: ' + theList.keyset() );
        for( String loyaltyNum : theContacts.keyset() )
        {
            SkyFinderMainController.contactDetailWrapper wrpr = theList.get(loyaltyNum);
            if (wrpr == null) continue;
            wrpr.subject = theContacts.get(loyaltyNum);
            Account foundContact = theContacts.get(loyaltyNum);
            wrpr = theList.remove(loyaltyNum);
            if (wrpr == null) continue;
System.Debug('replaceWithQueriedContact: found a contact for ' + loyaltyNum );
            wrpr.subject = foundContact;
            wrpr.searchIndex = String.valueof(wrpr.subject.id);
            theList.put(wrpr.searchIndex, wrpr);
        }
    }
    // not required as we are creating person account
    public static Map<String,Account> createTheseAccounts( Map<String,SkyFinderMainController.contactDetailWrapper> theWrappers, 
                                                           Map<String,SkyFinderMainController.houseHoldAcctWrapper> acctNamesMap ) // keys are index the same arg and rval
    {
        Map<String,Id> placeholderAcctsByName = new Map<String,Id>(); // key acct name
        Map<String,String> allAccts = new Map<String,String>();       // key is theWrappers key, value is accountID
        Map<String,String> accountsToCreate = new Map<String,String>();       // key is theWrappers key
        Set<Id> allAcctIds = new Set<Id>();
        for (String Index : theWrappers.keyset()) 
        {
            SkyFinderMainController.contactDetailWrapper aWppr = theWrappers.get(Index);
            if (aWppr.subject != null && aWppr.subject.Id != null) 
            {
                // capture all accounts looked up to by contacts in theWrappert
                allAccts.put(Index,String.valueof(aWppr.subject.Id));
                allAcctIds.add(aWppr.subject.Id);
            }
            else // the contact does not have its accountId set to a value
            {
                if (aWppr.subject != null && aWppr.selectedAccountName != null) // find the account by name
                {
                    SkyFinderMainController.houseHoldAcctWrapper hhAcctWppr = acctNamesMap.get(aWppr.selectedAccountName);
                    Id theId = hhAcctWppr.accountId;

                    if (theId != null) // we found an existing account that has and ID
                    {
                        allAccts.put(Index,theId);
                        allAcctIds.add(theId);
                        //aWppr.subject.AccountId = theId;
                        aWppr.subjectAccountName = aWppr.selectedAccountName;
                    }
                    else // this account does not exist and we need to create it
                    {
                        accountsToCreate.put(Index,aWppr.selectedAccountName);
                    }
                }                    
            }
        }

        // now that the allAccts map is fill, query for any that are placeholder accounts
        Map<Id,Account> placeholderAccts = new Map<Id,Account>
        (
            [
                SELECT id, isPlaceholder__c, Name, Primary_Contact__c
                From Account
                Where Name In :allAccts.keyset() AND ID IN :allAcctIds AND isPlaceholder__c = true
            ]
        );

        for(String Index : theWrappers.keyset())
        {
            SkyFinderMainController.contactDetailWrapper wrapper = theWrappers.get(Index);
            // replace this account with a new one if it is a placeholder account (it will cause validation issues)
            if (placeholderAccts.keyset().contains(allAccts.get(Index)))
            {
                Account placeHolder = placeholderAccts.get(allAccts.get(Index));
                String oldName = placeHolder.Name;
                Account dummy = new Account();
                dummy.BillingStreet = wrapper.subject.PersonMailingStreet;
                dummy.BillingPostalCode = wrapper.subject.PersonMailingPostalCode;
                String newName = AccountHandler.computeName( wrapper.subject.LastName, dummy );
                accountsToCreate.put(Index,newName);
                acctNamesMap.put(newName, new SkyFinderMainController.houseHoldAcctWrapper(newName, wrapper.subject));
                // need to remove the placeholder from the acctNamesMap
                acctNamesMap.remove(oldName);
            } 
        }
        
        Map<String,Account> accountsCreated = new Map<String,Account>();  
        for(String Index : accountsToCreate.keyset())
        {
            String acctName = accountsToCreate.get(Index);
            SkyFinderMainController.houseHoldAcctWrapper acctSource = acctNamesMap.get(acctName);
            if (acctSource == null) continue;

            Account theNewAcct = new Account( Name = acctName, RecordTypeId = householdAccountRecType );
            accountsCreated.put(Index, theNewAcct);
            acctSource.setAccount(theNewAcct);

            //if (acctSource.nameSource == null || acctSource.nameSource.Id == null) continue;
            // There is a lookup filter that prevents an Account's Primary Contact
            //   from looking up to an contact that doesn't already look up to this account
            // so, you can't create an account with the Primary_Contact__c set to anything
            //ID primaryID =  acctSource.nameSource.Id;
            //theNewAcct.Primary_Contact__c = primaryID;

        }
        insert accountsCreated.values();    // TODO -- wrap this in a try catch, and use the partial success method
        for(String Index : accountsCreated.keyset())
        {  
            // this looks like a redundant loop, but isn't -- it gets the contacts that aren't the primary for the account
            Account anAccount = accountsCreated.get(Index);
            SkyFinderMainController.houseHoldAcctWrapper acctSource = acctNamesMap.get(anAccount.Name);

            SkyFinderMainController.contactDetailWrapper aWppr = theWrappers.get(Index);
            if (acctSource != null && aWppr != null && aWppr.subject != null) acctSource.addContactMember(aWppr.subject);
           // aWppr.subject.AccountId = anAccount.Id;
            aWppr.subjectAccountName = anAccount.Name;
        }
        return accountsCreated;
    }

    public static String insertNewLines( String blobString, Integer lineLength )
    {
        Integer blobLength = blobString.Length();
        Integer numLines = blobLength/lineLength;
        if (blobLength <= lineLength) return blobString;
        List<String> linesList = new List<String>();
        for (Integer i = 0; i < numLines; i++)
        {
            String theSubString;
            theSubString = blobString.substring(i*lineLength,(i+1)*lineLength);
            theSubString = theSubString + '\n';
            linesList.add(theSubString);
        }
        if (numLines*lineLength < blobLength) linesList.add(blobString.substring(numLines*lineLength));

        return String.join(linesList,'');     
    }

//%%%%%%%%%%%%%%%%%% FOR TESTING ONLY
public static String PNRblob 
{ 
    get
    {
        PNRblob = 'PS  ATL  DL A         ATL      TA GE ATLUSATL  DL                                                                                09 FEB 2014  0137 Z     000001     297C29 ATLTAGE                                                                                        QP  QEP/XNV/317                                                                                                                  09 FEB 2014  0137 Z     000001     297C29 ATLTAGE                                                                                        QP  QR-UJN/004                                                                                                                   09 FEB 2014  0227 Z     D010662    ABE431 ATLGSAX                                                                                        QP  QEP/XNV/317                                                                                                                  09 FEB 2014  0242 Z     000001     117410 ATLTAGE                                                                                        SR  SPCL-$SEAT0080/15FEBLAXATL32C/EET/USD0000000.00PAID0060172068944 -0002020424152                                              15 FEB 2014  2118 Z     D027225    10FA30 ATLSUVV                                                                                        XS  DL     1281     NP  24 DEC 2014   ATL  MEM   NN/HK   01   2:50 PM     3:15 PM    RN                                              XS  SEAT RS/XR 11D  GASPER/LEOPHILLIP         DL1281 24DEC ATLMEM                                                                    XS  DL     1615     NP  24 DEC 2014   MEM  SLC   SC/HK   01   4:55 PM     7:18 PM    RN                                              XS  SEAT RS/XR  5C  GASPER/LEOPHILLIP         DL1615 24DEC MEMSLC                                                                    XS  DL     1211     NP  24 DEC 2014   SLC  LAX   SC/HK   01   7:55 PM     9:02 PM    RN                                              XS  SEAT RS/XR 11C  GASPER/LEOPHILLIP         DL1211 24DEC SLCLAX                                                                    DS  SSRFQTUDLPN1*1211/24DEC-GASPER/LEOPHILLIP*SLC/N/RU/DL2020424152                                                                  DS  SSRFQTUDLPN1*1615/24DEC-GASPER/LEOPHILLIP*MEM/N/RU/DL2020424152                                                                  DS  SSRFQTUDLPN1*1281/24DEC-GASPER/LEOPHILLIP*ATL/N/RU/DL2020424152                                                                  AF  SSRFQTUDLPN1*2550/01JAN-GASPER/LEOPHILLIP*ATL/N/RU/DL2020424152                                                                  AF  SSRFQTUDLPN1*2321/01JAN-GASPER/LEOPHILLIP*MSP/N/RU/DL2020424152                                                                  AS  DL     2550     NP  01 JAN 2015   ATL  MSP   NN/SS   01   1:40 PM     3:26 PM    RN                                              AS  DL     2321     NP  01 JAN 2015   MSP  LAX   NN/SS   01   7:10 PM     9:09 PM    RN                                              AV  00022 ATLMSP ATLMSP 0031 0024  ATLMSP 0031 **          00050     00012                                                           AV  00023 MSPLAX MSPLAX 0030 0020  MSPLAX 0030 **          00050     00007                                                           PS  TPA  DL A         TPA      GS R9 TPAUSTPA  DL                                                                                01 MAR 2014  0338 Z     596434     1E4229 TPAGSR9                                                                                        XT  TKT-TK/TE/0248A/07FEB                                                                                                            AE  /TBM MAIL TO                                                                                                                     AE  /LEO PHILLIP GASPER                                                                                                              AE  /2515 HENDERSON MILL RD NE                                                                                                       AE  /ATLANTA GA 30345-2135                                                                                                           AT  TE/1200N/28FEB                                                                                                                   A$  4P  K-        0.00 TX 146.30          USD    146.30 R928FEB                                                                  01 MAR 2014  0346 Z     596434     1E4229 TPAGSR9                                                                                        DS  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062178831091C1/091-092                                                                DS  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062178831091C2/091-092                                                                DS  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062178831092C2/091-092                                                                DS  SSRTKNEVAHK1*1295/03JAN-GASPER/LEOPHILLIP*0062178831092C3/091-092                                                                XT  TKTD-TE/1200N/28FEB                                                                                                              AT  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062179878807C1/807-808                                                                AT  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062179878807C2/807-808                                                                AT  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062179878808C2/807-808                                                                AT  SSRTKNEVAHK1*1295/03JAN-GASPER/LEOPHILLIP*0062179878808C3/807-808                                                                AT  TK/TE/1046P/28FEB                                                                                                                TI  0062179878807-08  EGASPER/LEOPHILLIP                                                                                             TX  TKT NBR 0062178831091-92 08APR13 E GASPER/LEOPHILLIP                                                                         01 MAR 2014  0346 Z     596434     1E4229 TPAGSR9                                                                                        AS  SEAT   /RS 13A  GASPER/LEOPHILLIP         DL2550 01JAN ATLMSP                                                                    AS  SEAT   /RS 14A  GASPER/LEOPHILLIP         DL2321 01JAN MSPLAX                                                                01 MAR 2014  0347 Z     596434     1E4229 TPAGSR9                                                                                    01 MAR 2014  0347 Z     596434     1E4229 TPAGSR9-RCVD $LEOGASPER@AOL.COM                                                                QP  QR-UJN/004                                                                                                                   01 MAR 2014  0654 Z     D010662    05ED20 ATLGSAX                                                                                        SR  SPCL-$SEAT0081/11MARATLLAX19D/EET/USD0000000.00PAID0060172068945 -0002020424152                                              12 MAR 2014  0216 Z     D027225    10FA30 ATLSUVV                                                                                        DS  SSRFQTUDLPN1*2550/01JAN-GASPER/LEOPHILLIP*ATL/N/RU/DL2020424152                                                                  AF  SSRFQTUDLPN1*787/01JAN-GASPER/LEOPHILLIP*ATL/N/RU/DL2020424152                                                                   SC  DL     2550     NP  01 JAN 2015   ATL  MSP   HK/UN   01   1:40 PM     3:26 PM    RN                                              AS  DL      787     NP  01 JAN 2015   ATL  MSP   SC/SC   01   1:40 PM     3:25 PM    RN                                          S.C. REAC-22MAR1537Z                                                                                                                     XS  SEAT RS/NR 13A  GASPER/LEOPHILLIP         DL2550 01JAN ATLMSP                                                                    AS  SEAT RS/NR 13A  GASPER/LEOPHILLIP         DL 787 01JAN ATLMSP                                                                SEAT REAC- 22MAR1630Z                                                                                                                    XS  SEAT RS/NR 13A  GASPER/LEOPHILLIP         DL 787 01JAN ATLMSP                                                                    AS  SEAT   /RS 28A  GASPER/LEOPHILLIP         DL 787 01JAN ATLMSP                                                                SEAT REAC- 22MAR1630Z                                                                                                                    XS  DL     2550     NP  01 JAN 2015   ATL  MSP   HK/WK   01   1:40 PM     3:26 PM    RN                                              SC  DL      787     NP  01 JAN 2015   ATL  MSP   SC/HK   01   1:40 PM     3:25 PM    RN                                              PS  HIB  DL A         HIB      SU NI HIBUSHIB  DL                                                                                23 MAR 2014  1607 Z     169245     1F1C15 HIBSUNI                                                                                        XT  TKT-TK/TE/1046P/28FEB                                                                                                            AE  /TBM MAIL TO                                                                                                                     AE  /LEO PHILLIP GASPER                                                                                                              AE  /2515 HENDERSON MILL RD NE                                                                                                       AE  /ATLANTA GA 30345-2135                                                                                                           AT  TE/1200N/23MAR                                                                                                                   A$  4P  K-USD     0.00 TX 146.30          TTL    146.30 NI23MAR                                                                      AC   K CNS VA X/BNE VA X/LAX DL ATL0.00CSM800/FT261 DL X/MEM DL LAX VA X/MEL VA CNS0.00CSM800/FT261 NUC0.00END R                         E1.00 EXEMPTX                                                                                                                    XD  E/K-*VALID ON DL/SM OAL/PNLTY FOR CHGS                                                                                       23 MAR 2014  1609 Z     169245     1F1C15 HIBSUNI                                                                                        DS  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062179878807C1/807-808                                                                DS  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062179878807C2/807-808                                                                DS  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062179878808C2/807-808                                                                DS  SSRTKNEVAHK1*1295/03JAN-GASPER/LEOPHILLIP*0062179878808C3/807-808                                                                XT  TKTD-TE/1200N/23MAR                                                                                                              AT  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062180847312C1/312-313                                                                AT  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062180847312C2/312-313                                                                AT  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062180847313C2/312-313                                                                AT  SSRTKNEVAHK1*1295/03JAN-GASPER/LEOPHILLIP*0062180847313C3/312-313                                                                AT  TK/TE/1109A/23MAR                                                                                                                TI  0062180847312-13  EGASPER/LEOPHILLIP                                                                                             TX  TKT NBR 0062179878807-08 08APR13 E GASPER/LEOPHILLIP                                                                         23 MAR 2014  1609 Z     169245     1F1C15 HIBSUNI                                                                                    23 MAR 2014  1609 Z     169245     1F1C15 HIBSUNI-RCVD $LEOGASPER@AOL.COM                                                                QP  QR-UJN/004                                                                                                                   23 MAR 2014  1811 Z     D010662    05EC12 ATLGSAX                                                                                        DF  OSI DL FF2020424152-GASPER/LEOPHILLIP **MM/PM**                                                                                  AF  OSI DL FF2020424152-GASPER/LEOPHILLIP **MM/PM**                                                                                  AG  OSI DL **DELTA RESERVE-GASPER/LEOPHILLIP **IP**                                                                                  AG  OSI DL **AFFILIATIONS-GASPER/LEOPHILLIP **IP**                                                                               ELITE AUTOMATION 03APR0845Z                                                                                                              SC  VA        7     Z   17 NOV 2014   BNE  LAX   HK/WK   01  10:15 AM     5:30 AM    RD                                              AS  VA        7     Z   17 NOV 2014   BNE  LAX   TK/TK   01  11:15 AM     6:30 AM    RD                                          22 APR 2014  1926 Z                000000 HDQVARM                                                                                        XS  VA        7     Z   17 NOV 2014   BNE  LAX   HK/WK   01  10:15 AM     5:30 AM    RD                                              SC  VA        7     Z   17 NOV 2014   BNE  LAX   TK/HK   01  11:15 AM     6:30 AM    RD                                              PS  CVG  DL A         CVG      SU NA CVGUSCVG  DL                                                                                23 APR 2014  0310 Z     901975     1E231B CVGSUNA                                                                                        QP  QR-UJN/004                                                                                                                   23 APR 2014  0527 Z     D010662    05ED26 ICGGSAX                                                                                        AT  E/-SK CHG SKD CHG REROUTE                                                                                                    28 APR 2014  1815 Z     125260     1D8E10 TPAGSOJ                                                                                        A$  4P  K-        0.00 TX 146.30          USD    146.30 OJ28APR                                                                  28 APR 2014  1815 Z     125260     1D8E10 TPAGSOJ                                                                                        SC  VA     1295     Z   03 JAN 2015   MEL  CNS   HK/UN   01  12:55 PM     3:20 PM    RD                                              AS  VA     1293     Z   04 JAN 2015   MEL  CNS   TK/TK   01   9:00 AM    11:25 AM    RD                                          14 MAY 2014  0134 Z                000000 HDQVARM                                                                                        SC  DL     1754     NP  17 NOV 2014   LAX  ATL   HK/UN   01  12:30 PM     7:52 PM    RN                                              AS  DL     1754     NP  17 NOV 2014   LAX  ATL   SC/SC   01  12:30 PM     7:50 PM    RN                                          S.C. REAC*SEATS REASSOCIATED*-17MAY1441Z                                                                                                 XS  DL     1754     NP  17 NOV 2014   LAX  ATL   HK/WK   01  12:30 PM     7:52 PM    RN                                              SC  DL     1754     NP  17 NOV 2014   LAX  ATL   SC/HK   01  12:30 PM     7:50 PM    RN                                              SC  VA     1293     Z   04 JAN 2015   MEL  CNS   TK/HK   01   9:00 AM    11:25 AM    RD                                              PS  ATL  DL A         ATL      FT CN ATLUSATL  DL                                                                                18 MAY 2014  0342 Z     D016433    0CD736 ATLFTCN                                                                                        QP  QEP/XNV/117                                                                                                                  18 MAY 2014  0342 Z     D016433    0CD736 ATLFTCN                                                                                        DF  OSI DL FF2020424152-GASPER/LEOPHILLIP **MM/PM**                                                                                  AF  OSI DL FF2020424152-GASPER/LEOPHILLIP **MM/DM**                                                                                  AG  OSI DL **DELTA RESERVE-GASPER/LEOPHILLIP **IP**                                                                                  AG  OSI DL **AFFILIATIONS-GASPER/LEOPHILLIP **IP**                                                                               ELITE AUTOMATION 01JUN0856Z                                                                                                              XD  D/DL2020424152/PM/160000                                                                                                     25 JUN 2014  0856 Z                991C35                                                                                                DS  SSRFQTUDLPN1*1754/17NOV-GASPER/LEOPHILLIP*LAX/N/RU/DL2020424152                                                                  AF  SSRFQTUDLPN1*1754/17NOV-GASPER/LEOPHILLIP*LAX/N/RU/DL2020424152                                                                  SC  DL     1754     NP  17 NOV 2014   LAX  ATL   HK/UN   01  12:30 PM     7:50 PM    RN                                              AS  DL     1754     NP  17 NOV 2014   LAX  ATL   SC/SC   01  12:00 N      7:14 PM    RN                                          S.C. REAC-28JUN1808Z                                                                                                                     XS  SEAT RS/NR 11B  GASPER/LEOPHILLIP         DL1754 17NOV LAXATL                                                                    AS  SEAT RS/NR 11B  GASPER/LEOPHILLIP         DL1754 17NOV LAXATL                                                                SEAT REAC- 28JUN1941Z                                                                                                                    XS  SEAT RS/NR 11B  GASPER/LEOPHILLIP         DL1754 17NOV LAXATL                                                                    AS  SEAT   /RS 18B  GASPER/LEOPHILLIP         DL1754 17NOV LAXATL                                                                SEAT REAC- 28JUN1941Z                                                                                                                    XS  DL     1754     NP  17 NOV 2014   LAX  ATL   HK/WK   01  12:30 PM     7:50 PM    RN                                              IO  FAIL/1616/28JUN/SLC/0N                                                                                                           SC  DL     1754     NP  17 NOV 2014   LAX  ATL   SC/HK   01  12:00 N      7:14 PM    RN                                              PS  SLC  DL A         SLC      SU 0N SLCUSSLC  DL                                                                                28 JUN 2014  2216 Z     946624     1D8426 SLCSU0N                                                                                        XS  DL     1754     NP  17 NOV 2014   LAX  ATL   SC/HK   01  12:00 N      7:14 PM    RN                                              XS  SEAT RS/XR 18B  GASPER/LEOPHILLIP         DL1754 17NOV LAXATL                                                                    DS  SSRFQTUDLPN1*1754/17NOV-GASPER/LEOPHILLIP*LAX/N/RU/DL2020424152                                                                  IO  FAIL/1737/28JUN/HIB/1K                                                                                                           AF  SSRFQTUDLPN1*80/17NOV-GASPER/LEOPHILLIP*LAX/N/OU/DL2020424152                                                                    AS  DL       80     NT  17 NOV 2014   LAX  ATL   SR/SS   01   9:30 AM     4:30 PM    RN                                              PS  HIB  DL A         HIB      SU 1K HIBUSHIB  DL                                                                                28 JUN 2014  2237 Z     325039     1E3E18 HIBSU1K                                                                                        XS  VA     1295     Z   03 JAN 2015   MEL  CNS   HK/UN   01  12:55 PM     3:20 PM    RD                                              DS  SSRTKNEVAHK1*1295/03JAN-GASPER/LEOPHILLIP*0062180847313C3/312-313                                                                PS  HIB  DL A         HIB      SU 1K HIBUSHIB  DL                                                                                28 JUN 2014  2238 Z     325039     1E3E18 HIBSU1K                                                                                        AG  OSI DL TCP W/HHS527                                                                                                          28 JUN 2014  2240 Z     325039     1E3E18 HIBSU1K                                                                                        AS  SEAT   /RS 30C  GASPER/LEOPHILLIP         DL  80 17NOV LAXATL                                                                28 JUN 2014  2241 Z     325039     1E3E18 HIBSU1K                                                                                        XS  SEAT RS/XR 28A  GASPER/LEOPHILLIP         DL 787 01JAN ATLMSP                                                                    XS  SEAT RS/XR 14A  GASPER/LEOPHILLIP         DL2321 01JAN MSPLAX                                                                    AS  SEAT   /RS 20E  GASPER/LEOPHILLIP         DL 787 01JAN ATLMSP                                                                    AS  SEAT   /RS 13A  GASPER/LEOPHILLIP         DL2321 01JAN MSPLAX                                                                28 JUN 2014  2242 Z     325039     1E3E18 HIBSU1K                                                                                    28 JUN 2014  2245 Z     325039     1E3E18 HIBSU1K-RCVD E-LEOGASPER@AOL.COM                                                               QP  QR-UJN/004                                                                                                                   29 JUN 2014  0149 Z     D010662    05ED10 ATLGSAX                                                                                        QP  QR-UJN/004                                                                                                                   29 JUN 2014  0211 Z     D010662    05ED31 ATLGSAX                                                                                        QP  QR-UJN/004                                                                                                                   29 JUN 2014  0211 Z     D010662    05ED31 ATLGSAX                                                                                        QP  QR-XNV/317                                                                                                                   09 JUL 2014  0706 Z     175035     14F716 JAJGSNS                                                                                        IO  FAIL/1512/10JUL/JAJ/WS                                                                                                           AS  VA     1293     Z   03 JAN 2015   MEL  CNS   HN/HN   01   9:00 AM    11:25 AM    RD                                              PS  JAJ  DL A         JAJ      GS WS JAJUSJAJ  DL                                                                                10 JUL 2014  1912 Z     071240     14F639 JAJGSWS                                                                                        AG  SSRACKNDLHK/VAFBNGBY10JUL1912Z*                                                                                                  AG  SSRRLOCDLHK/HDQVAFBNGBY                                                                                                      10 JUL 2014  1912 Z                000000 HDQVARM                                                                                        IO  FAIL/1512/10JUL/JAJ/WS                                                                                                           SC  VA     1293     Z   03 JAN 2015   MEL  CNS   HN/NN   01   9:00 AM    11:25 AM    RD                                          10 JUL 2014  1912 Z     071240     14F639 JAJGSWS                                                                                        AG  SSRACKNDLHK/VAFBNGBY10JUL1912Z*                                                                                                  AG  SSRRLOCDLHK/HDQVAFBNGBY                                                                                                          SC  VA     1293     Z   03 JAN 2015   MEL  CNS   PN/KK   01   9:00 AM    11:25 AM    RD                                          10 JUL 2014  1912 Z                000000 HDQVARM                                                                                        SC  VA     1293     Z   03 JAN 2015   MEL  CNS   KK/XK   01   9:00 AM    11:25 AM    RD                                          10 JUL 2014  1914 Z     071240     14F639 JAJGSWS                                                                                        QP  QR-CNS/013                                                                                                                   10 JUL 2014  1916 Z     D007144    1A7817 ATLSUKR                                                                                        AG  SSROTHSYYOVERLAPPING SEGMENTS PLS REVIEW OR BKG WILL BE CXLD                                                                     AG  SSROTHSDLOVERLAPPING SEGMENTS PLS REVIEW OR BKG WILL BE CXLD                                                                     AG  SSRACKNDLHK/VAFBNGBY10JUL1918Z*                                                                                                  AG  SSRRLOCDLHK/HDQVAFBNGBY                                                                                                      10 JUL 2014  1918 Z                000000 HDQVARM                                                                                        QP  QEP/SQB/573                                                                                                                  10 JUL 2014  1923 Z     071240     14F639 JAJGSWS                                                                                        QP  QR-UJN/004                                                                                                                   10 JUL 2014  2012 Z     D010662    ABE63B ATLGSAX                                                                                        DS  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062180847312C1/312-313                                                                DS  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062180847312C2/312-313                                                                DS  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062180847313C2/312-313                                                                TX  TKT NBR 0062180847312-13 23MAR14 E GASPER/LEOPHILLIP                                                                         10 JUL 2014  2037 Z     132342     163232 IRRSULE                                                                                        X$  4P  K-        0.00 TX 146.30          USD    146.30 OJ28APR                                                                      XC   K CNS VA X/BNE VA X/LAX DL ATL0.00CSM800/FT261 DL X/MEM DL LAX VA X/MEL VA CNS0.00CSM800/FT261 NUC0.00END R                         E1.00 EXEMPTX                                                                                                                    XE   K-USD AY-10.00/XA-5.00/XY-7.00/YC-5.50/AU-48.10/QR-32.00/WG-3.30/WY-35.40/                                                      AG  OSI TYPE Q                                                                                                                       A$  4P  Q-USD     0.00 TX 167.30          TTL    167.30 LE10JUL                                                                      AC   Q CNS VA X/BNE VA X/LAX DL ATL0.00CSM800/FT261 DL X/MSP DL X/LAX VA X/MEL VA CNS0.00CSM800/FT261 NUC0.00END                         ROE1.00 EXEMPTX                                                                                                                  AT  E/VALID ON DL/SM OAL/PNLTY FOR CHGS                                                                                          10 JUL 2014  2040 Z     132342     1EF017 IRRSULE                                                                                        A$  4P  Q-        0.00 TX 146.30          USD    146.30 LE10JUL                                                                  10 JUL 2014  2041 Z     132342     1EF017 IRRSULE                                                                                        XT  TKT-TK/TE/1109A/23MAR                                                                                                            AE  /TBM MAIL TO                                                                                                                     AE  /LEO PHILLIP GASPER                                                                                                              AE  /1114 N E 78TH AV                                                                                                                AE  /PORTLAND OR 97213                                                                                                               AT  TE/1200N/10JUL                                                                                                               10 JUL 2014  2058 Z     132342     163232 IRRSULE                                                                                        XT  TKTD-TE/1200N/10JUL                                                                                                              AT  SSRTKNEVAHK1*0770/17NOV-GASPER/LEOPHILLIP*0062184974584C1/584-585                                                                AT  SSRTKNEVAHK1*0007/17NOV-GASPER/LEOPHILLIP*0062184974584C2/584-585                                                                AT  SSRTKNEVAHK1*0024/01JAN-GASPER/LEOPHILLIP*0062184974585C2/584-585                                                                AT  SSRTKNEVAHK1*1293/04JAN-GASPER/LEOPHILLIP*0062184974585C3/584-585                                                                AT  TK/TE/0458P/10JUL                                                                                                                SR  SPCL-DTC APPLIES';
        return PNRblob;
    }
}
//%%%%%%%%%%%%%%%%%% FOR TESTING ONLY

    //////////////////
    // helper classes
    //      -- pagingStruct
    //      -- reservationSearch
    //      -- reservationWrapper
    //      -- idTupple
    //////////////////

    public class reservationSearch
    {
        public case subjectCase                             { get; set; }
        public Boolean hasCase                              { get; set; }
        public Boolean showResults                          { get; set; }
        public String casePNR                               { get{ return subjectCase == null ? null : subjectCase.PNR__c; } set; }
        public reservationWrapper Input                     { get; set; }
        private Map<String,reservationWrapper> ResultsMap;  // key is integer -->PNR won't work because it isn't unique      
        public List<reservationWrapper> Results            
        { 
            get
            {
                return ResultsMap == null ? new List<reservationWrapper>() : ResultsMap.values();
            }
            set; 
        }
        public String selected                              { get; set; }

        public reservationSearch( case theCase )
        {
            showResults = false;
            if (theCase == null) hasCase = false;
            else
            {
                hasCase = true;
                subjectCase = theCase;
            }
            ResultsMap = new Map<String,reservationWrapper>();
            Input = new reservationWrapper('__INPUT__', this);
        }

        public void attachReservation()
        {
            if (selected == null || subjectCase == null) return;
            reservationWrapper wrpr = ResultsMap.get(selected);

            if (wrpr == null)  return;
            subjectCase.PNR__c = wrpr.PNR;
            update subjectCase;
        }

        public void detachReservation()
        {
            if (selected == null || subjectCase == null) return;
            reservationWrapper wrpr = ResultsMap.get(selected);
            if (wrpr == null)  return;
            subjectCase.PNR__c = null;
            update subjectCase;
        }

        public void search()
        {
            PNR.Lookup aPnr = new PNR.Lookup();
            List<String> pnrList = (Input.PNR == null) ? new List<String>() : CWString.toList(CWString.split(Input.PNR));
            List<String> ticketList = (Input.Ticket == null) ? new List<String>() : CWString.toList(CWString.split(Input.Ticket));       
            Map<String,Account> theContacts = new Map<String,Account>(); // key is PNR for TicketNumber

            if (aPnr != null)
            {
                // loop over comma separated PNRs
                for( String entered : pnrList )
                {
                    PNR.MemberInformation found = Test.isRunningTest() ? null : aPnr.find(entered);
                    if (found == null || found.PNR == null) continue;
                    reservationWrapper theWrapper = new reservationWrapper(entered, this);
                    theWrapper.PNR = found.PNR;
                    theWrapper.Ticket = found.Tickets.isEmpty() ? '' : found.Tickets.get('0');
                    theWrapper.DepatureDate = found.DepartureDate;
                    theWrapper.Carrier = found.Carrier;
                    theWrapper.Origin = found.Origin;
                    theWrapper.PAXName = found.travelers.isEmpty() ? '' : found.travelers.get('0').LastName;
                    ResultsMap.put(theWrapper.PNR, theWrapper);               
                }
            }

            Ticketing.Lookup tck = new Ticketing.Lookup();
            // loop over comma separated TicketNumbers
            if (tck == null) return;
            for( String entered : ticketList )
            {
                Ticketing.MemberInformation result = Test.isRunningTest() ? null : tck.find(entered);
                if (result == null  || result.ticketNumber == null) continue;
                reservationWrapper theWrapper = new reservationWrapper(entered, this);
                theWrapper.PNR = result.PNR;
                theWrapper.Ticket = result.ticketNumber;
                theWrapper.DepatureDate = result.DepartureDate;
                theWrapper.Carrier = result.Carrier;
                theWrapper.Origin = result.Origin;
                theWrapper.PAXName = result.person_acc == null ? '' : result.person_acc.LastName;
                ResultsMap.put(theWrapper.PNR, theWrapper);
            }           
            if (!ResultsMap.isEmpty()) showResults = true;
        }

        public void clear()
        {
            ResultsMap = new Map<String,reservationWrapper>();
            Input = new reservationWrapper('__INPUT__', this);
            showResults = false;
        }
    }

    public class reservationWrapper
    {
        private reservationSearch parent    { get; set; }
        public String PNR                   { get; set; }
        public String Ticket                { get; set; }
        public String Flight                { get; set; }
        public String DepatureDate          { get; set; }
        public String Origin                { get; set; }
        public String Destination           { get; set; }
        public String Carrier               { get; set; }
        public String PAXName               { get; set; }
        public Account subject              { get; set; }
        public String searchIndex           { get; set; }
        public Boolean attached             
        { 
            get
            {
                Boolean rval = false;
                if (parent != null && parent.casePNR != null && PNR == parent.casePNR) rval = true;
                return rval;
            }
            set; 
        }

        public reservationWrapper(String key, reservationSearch containinglist )
        {
            subject = new Account(  );
            searchIndex = key;
            parent = containinglist;
        }
    }

    public class pagingStruct
    {
        private String baseLabel;
        private Integer displaySize;
        private List<SkyFinderMainController.contactDetailWrapper> original;
        private List<List<SkyFinderMainController.contactDetailWrapper>> thePages;
        public Integer currentPageNumber                   { get; set; }
        public Boolean showNext                            { get; set; }
        public Boolean showPrev                            { get; set; }
        public String  label
        {
            get 
            {
                Integer startItem = currentPageNumber * displaySize;
                Integer itemsAvailable = original.size() - startItem;
                if (itemsAvailable >  displaySize) itemsAvailable = displaySize;
                
                label = '   ' + baseLabel + ' ' + (startItem+1) + '-' + (startItem + itemsAvailable) + ' of ' + original.size() + '   ';
                return label;
            }
            private set;
        }
        public List<SkyFinderMainController.contactDetailWrapper> currentPage
        {
            get
            {
                if (thePages.isEmpty()) return new List<SkyFinderMainController.contactDetailWrapper>(); // if constructed with empty target list
                return thePages[currentPageNumber];
            }
            private set;
        }
        public void gotoBeginning()
        {
            showPrev = false;
            showNext = true;
            currentPageNumber = 0;
        }
        public void gotoEnd()
        {
            showPrev = true;
            showNext = false;
            currentPageNumber = thePages.size() - 1;
        }
        public void advance()
        {
            currentPageNumber++;
            showPrev = true;
            if (currentPageNumber >= (thePages.size() - 1) )
            {
                showNext = false;
                currentPageNumber = thePages.size() - 1;
                return;
            }            
        }

        public void goBack()
        {
            currentPageNumber--;
            showNext = true;
            if (currentPageNumber <= 0) 
            {
                showPrev = false;
                currentPageNumber = 0;
                return;
            }                       
        }

        public pagingStruct( String typeString, List<SkyFinderMainController.contactDetailWrapper> target)
        {
            baseLabel = typeString;
            original = target;
            displaySize = passengerListPageSize;
            if (original == null) return;
            currentPageNumber = 0;
            showNext = true;
            showPrev = false;
            thePages = new List<List<SkyFinderMainController.contactDetailWrapper>>();

            List<SkyFinderMainController.contactDetailWrapper> sublist = new List<SkyFinderMainController.contactDetailWrapper>();
            for( Integer i = 0; i < target.size(); i++)
            {
                if ( i > 0 && (Math.mod(i, displaySize) == 0) )
                {
                    Integer thisPageNumber = i / displaySize;
                    thePages.add(sublist);
                    sublist = new List<SkyFinderMainController.contactDetailWrapper>();
                    sublist.add(original[i]);
                }
                else
                {
                    sublist.add(original[i]);
                }                
            }
            if ( Math.mod(original.size(), displaySize) != 0 || original.size() == displaySize) thePages.add(sublist);
        }
    }

    public class idTupple
    {
        public Boolean  isValid             { get; private set; }
        public Schema.SObjectType myType    { get; private set; }
    }
}