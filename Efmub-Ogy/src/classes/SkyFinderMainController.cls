/*******************************************************//**

@class      SkyFinderMainController

@brief      Controller for the SkyFinder Landing Page

This Controller is called by the SkyFinder Landing Page 

@author     Janeen Anderson   (LiquidHub.JDA)

@version    2016-03-16  LiquidHub.JDA
Created.


@see        SkyfinderSearch (Page)

(c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

This is a component of @SolutionName, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class SkyFinderMainController
{
    // static members
    static public Map<String,Schema.SObjectField> contactFields
    {
        get
        {
            if (contactFields == null || contactFields.isEmpty())
            {
                contactFields = SkyFinderUtils.retrieveContactFields();
            }
            return contactFields;
        }
        // read only        
    }
    
    // reservation support
    public SkyFinderUtils.reservationSearch reservations    { get; set; }
    
    //display control
    private Map<String, List<String>>    columns;
    public List<String> hhContactsColumns            
    { 
        get 
        {
            if (columns == null) buildTables();
            return columns.get('householdContacts');
        }
        set;
    }
    public List<String> caseContactsColumns            
    { 
        get 
        {
            if (columns == null) buildTables(); 
            return columns.get('caseContacts');
        }
        set;
    }
    public List<String> pnrContactsColumns            
    { 
        get 
        {
            if (columns == null) buildTables(); 
            return columns.get('prnContacts');
        }
        set;
    }
    public List<String> swContactsColumns            
    { 
        get 
        {
            if (columns == null) buildTables();
            return columns.get('searchWithCaseContacts');
        }
        set;
    }
    public List<String> phxSearchCustprofileColumns            
    { 
        get 
        {
            if (columns == null) buildTables();
            return columns.get('phxSearchCustprofileColumns');
        }
        set;
    }
    
    public List<String> crContactsColumns            
    { 
        get 
        {
            if (columns == null) buildTables();
            return columns.get('createdContacts');
        }
        set;
    }
    public List<String> reservationsColumns
    {
        get
        {
            if (columns == null) buildTables();
            return columns.get('searchReservations');
        }
        set;
    }
    
    void buildTables()
    {
        columns = new Map<String, List<String>>();
        columns.put('householdContacts', new List<String>{ 'Action', 'Name', 'Primary', 'Address', 'Phone', 'Email', 'Skymiles', 'Flying Blue' });
        columns.put('prnContacts', new List<String>{ 'Action', 'Name', 'Primary', 'Account', 'Address', 'Phone', 'Email', 'Skymiles', 'Flying Blue' });
        columns.put('caseContacts', new List<String>{ 'Src', 'Action', 'Primary', 'Name',  'Account', 'Role', 'Skymiles', 'Flying Blue' });
        columns.put('searchWithCaseContacts', new List<String>{ 'Last Name', 'First Name', 'Email address', 'Phone number', 'FB and SkyMIles number', 'Address', 'City', '  Postal Code', 'email' });
        columns.put('createdContacts', new List<String>{ 'Name', 'Skymiles#', 'Flying Blue#', 'Email address', 'Phone', 'Address' });   //columns.put('createdContacts', new List<String>{ 'Name', 'Account', 'Skymiles#', 'Flying Blue#', 'Gender', 'Address', 'Phone', 'email','View Contact' });
        columns.put('searchReservations', new List<String>{ 'Case', 'PNR', 'Alerts', 'Carrier', 'Origin', 'Departure Date', 'Ticket Number', 'Primary PAX Name' });
        
        columns.put('phxSearchCustprofileColumns', new List<String>{ 'Last Name', 'First Name', ' SkyMiles number', 'FB #', 'Email address', 'Phone number','Address', 'City','State', '  Postal Code',' Create/View Customer' });
        //columns.put('phxSearchCustprofileColumns', new List<String>{ 'Last Name', 'First Name', 'Email address', 'Phone number', ' SkyMiles number', 'FB #','Address', 'City','State', '  Postal Code',' Create/View Contact' });
        
    }
    
    
    ////////////////////////////////
    // Support SkyFinder
    //    possible topPanelMode values
    //      -CaseContactWithPNR
    //      -CaseContactNoPNR
    //      -CaseContactNoCase 
    ////////////////////////////////
    
    public Map<String, Map<String,contactDetailWrapper>> tablesMaps;
    
    public Map<String, contactDetailWrapper> createdContactsMap  
    { 
        get
        {
            if (createdContactsMap == null) createdContactsMap = new Map<String, contactDetailWrapper>();
            return createdContactsMap; 
        }
        private set; 
        
    }
    public List<contactDetailWrapper> createdContactsList        
    {
        get
        {
            return createdContactsMap == null ? null : createdContactsMap.values();
        } 
        private set; 
    }
    public Boolean hasCreatedContacts                                           
    { 
        get 
        {
            return (createdContactsMap == null || createdContactsMap.isEmpty()) ? false : true;
        } 
        private set; 
    }
    public Map<Id,Account> householdContacts                                    { get; set; }
    public Map<String,contactDetailWrapper> householdContactsMap { get; set; }
    public String householdContactsSortField                                    { get; set; }
    public Boolean householdContactsSortAscending                               { get; set; }
    
    
    
    public List<contactDetailWrapper>   householdContactsList    
    { 
        get
        {
            if ( householdContactsMap == null ) return new List<contactDetailWrapper>();
            
            List<contactDetailWrapper>   theList     = householdContactsMap.values();
            if ( String.isNotBlank( householdContactsSortField ) )
            {
                
                CWSorter    sorter  = new CWSorter( contactDetailWrapper.class );
                if ( householdContactsSortAscending != false )
                {
                   
                    sorter.sortAscendingNullsLast( householdContactsSortField );
                }
                else
                {
                    
                    sorter.sortDescendingNullsLast( householdContactsSortField );
                }
                sorter.sort( theList );
                system.debug('SortCompleted');
            }
            return theList;
        } 
        set; 
    }
    
    public Map<String,contactDetailWrapper> pnrContactsMap       { get; set; }
    public List<contactDetailWrapper>   pnrContactsList    
    { 
        get
        {
            return pnrContactsMap == null ?
                new List<contactDetailWrapper>() :
            pnrContactsMap.values();
        } 
        set; 
    }
    
    public void Initialize()        // TODO:  this duplicates some functionality , this needs to be fixed
    {
        initialized = true;
        // now query all of the needed fields
       
        
        if(subjectCaseID != null)
        {
            List<case> theCases =
                ([
                    SELECT id, Subject, CaseNumber, Reason,  Account.Name, ContactId, AccountId,Account.IsPlaceholder__c,PNR__c
                    FROM case
                    WHERE id = :subjectCaseID
                ]);
            if (!theCases.isEmpty()) 
            {
                subjectCase = theCases[0];
                subjectCaseID = subjectCase.Id;
                primary = subjectCase.ContactId;
                
                if (subjectCase.ContactId != null) relatedContactsMap.put(subjectCase.ContactId, null);
                subjectHousehold = subjectCase.Account;
                householdContacts = subjectCase.Account.IsPlaceholder__c ? new Map<Id,Account>() :
                new Map<Id,Account>([SELECT id FROM Account Where Id = :subjectCase.AccountId AND RecordTypeId = :SkyFinderUtils.passengerContactRecType]);
                potentialContactIDs.addAll(householdContacts.keyset());
                householdContactsMap = new Map<String,contactDetailWrapper>();
                for ( CaseContactRole aRole : subjectCase.CaseContactRoles)
                {
                    theRoles.put(String.valueof(aRole.ContactID),aRole);
                    relatedContactsMap.put(aRole.ContactID, null);
                }
            }
            if (householdContacts != null) potentialContactIDs.addAll(householdContacts.keySet());
            
            if ( subjectCase.PNR__c != null ) 
            {
                topPanelMode = 'CaseContactWithPNR';
                searchpanel.searchInfo.PNR = subjectCase.PNR__c;
                
                Map<String,String> candidatesForReplacement = searchpanel.makePNRCallout(); // Map<skymiles or flyingBlue number, wrapper.searchIndex>
                
                if (searchpanel.pnrResults != null ) pnrContactsMap = searchpanel.pnrResults.clone();
                if (searchpanel.pnrHistorical != null) pnrContactsMap.putAll(searchpanel.pnrHistorical);
                // find existing contacts in salesforce (by Skymiles and FlyingBlue numbers, 
                //   these are the only unambiguous ones -- unless the Skymiles and FlyingBlue numbers are exactly the same)
                Set<String> toBeQueried = new Set<String>();
                toBeQueried.addAll(candidatesForReplacement.keyset());
                toBeQueried.addAll(pnrContactsMap.keyset());
                System.Debug('toBeQueried ' + toBeQueried.size() + ':' + toBeQueried);
                
                Map<String,Account> found = SkyFinderUtils.queryForMatchingContact( toBeQueried );
                System.Debug('found ' + found.size() + ':' + found.KeySet());
                if (!found.isEmpty()) SkyFinderUtils.replaceWithQueriedContact( found, pnrContactsMap);
                
                // clear the searchpanel input and results
                searchpanel.searchInfo.PNR = null;
                searchpanel.pnrResults = new Map<String,contactDetailWrapper>();
                searchpanel.pnrHistorical = new Map<String,contactDetailWrapper>();
            }
            else topPanelMode = 'CaseContactNoPNR';            
        }
        
        reservations = new SkyFinderUtils.reservationSearch(subjectCaseID == null ? null : subjectCase); 
        
        
        if (subjectCase != null && subjectCase.ContactId != null) 
        {
            queryContacts( new Set<String>{String.ValueOf(subjectCase.AccountId)} );
            if (queriedContacts != null && !queriedContacts.isEmpty()) primaryContact = queriedContacts.values()[0];
        }
        
        if (primaryContact != null)
        {
            primaryCityState = primaryContact.PersonMailingCity == null ? '' : primaryContact.PersonMailingCity;
            primaryCityState = primaryCityState == '' ? primaryContact.PersonMailingState : 
            (primaryContact.PersonMailingState == null ? primaryCityState : primaryCityState + ', ' + primaryContact.PersonMailingState);
                primarySkymiles = primaryContact.SkyMiles_Number__pc;       
        }
        
        tablesMaps = new Map<String, Map<String,contactDetailWrapper>>();
        tablesMaps.put('hhcTab', householdContactsMap);
        tablesMaps.put('relTab', relatedContactsMap);
        tablesMaps.put('pnrTab', pnrContactsMap);
        
    }
    
         
    public Boolean initialized { get; set; }
    public String subjectCaseName
    {
        get
        {
            if (primaryContact == null && initialized != true) 
                Initialize();  // initialized != true with initialize for null value
            return subjectCase == null ? null : subjectCase.CaseNumber;
        }
        private set;
    }
    public Account primaryContact       // used by the header, set in Initialize everything else uses Primary property                  
    { 
        get
        {
            if (primaryContact == null && initialized != true) Initialize();
            return primaryContact;
        }
        private set; 
    }
    
    public ID primaryID                         
    { 
        get 
        { 
            if (primaryContact == null && initialized != true) Initialize();
            return (primaryContact == null || primaryContact.id == null) ? null : primaryContact.id;
        } 
        private set; 
    }
    
    public String primarySkymiles
    {
        get
        {
            if (primaryContact == null && initialized != true) Initialize();
            return (primaryContact == null) ? 'unknown' : primarySkymiles;
        }
        private set;
    }
    
    public String primaryCityState
    {
        get
        {
            if (primaryContact == null && initialized != true) Initialize();
            return (primaryContact == null) ? null : primaryCityState;
        }
        private set;
    }
    
    public String subjectCasePNR
    {
        get
        {
            if (subjectCase == null && initialized != true) Initialize();
            return (subjectCase == null || subjectCase.PNR__c == null) ? 'unknown' : subjectCase.PNR__c;
        }
        private set;
    }
    
    public String PrimaryNameFirstLast         
    { 
        get
        {
            if (primaryContact == null && initialized == false) Initialize();
            if (primaryContact == null) return 'Primary Is Null';
            PrimaryNameFirstLast = '' + primaryContact.FirstName;
            PrimaryNameFirstLast += primaryContact.MiddleName == null ? '' :
            (PrimaryNameFirstLast == '' ? null : ' ' + primaryContact.MiddleName);
                PrimaryNameFirstLast += primaryContact.LastName == null ? '' :
            (PrimaryNameFirstLast == null ? primaryContact.LastName : ' ' + primaryContact.LastName); 
                return PrimaryNameFirstLast;
        } 
        set; 
    }
    public String PrimaryNameLastFirst         
    { 
        get
        {
            if (primaryContact == null && initialized == false) Initialize();
            if (primaryContact == null) return 'Primary Is Null';
            PrimaryNameFirstLast = '' + primaryContact.LastName;
            PrimaryNameFirstLast += primaryContact.FirstName == null ? '' :
            (PrimaryNameFirstLast == null ? primaryContact.FirstName : ', ' + primaryContact.FirstName);
                PrimaryNameFirstLast += primaryContact.MiddleName == null ? '' :
            (PrimaryNameFirstLast == null ? null : ' ' + primaryContact.MiddleName);
                return PrimaryNameFirstLast;
        } 
        set; 
    }
    
    public String searchName
    {
        get { return '...'; }
        set;
    }
    
    // Boolean Mode Control Parameters
    public Boolean displayForCaseAndPNR     { get { return true; } set; }
    public Boolean displayForSearch         { get { return true; } set; }
    public Boolean displayForSearchWithPNR  { get { return true; } set; }
    
    public String                           sfBaseURL               { get; set; }
    public String                           mode                    { get; set; }
    public String                           topPanelMode            { get; set; }
    public Boolean                          showAccountPanel        { get; set; }
    public Boolean                          showRsrvFullPanel       
    { 
        get{ return (reservations.hasCase && primaryID != null) ? true : false; }
        private set; 
    }                    
    public Integer                          newContactIndex;
    private Map<Id,Account>                 queriedContacts;
    private set<Id>                         potentialContactIDs;
    
    // parameters
    public Boolean                          Chooser                 { get; set; }
    
    public Map<String,houseHoldAcctWrapper> accountsMap         // key = Account Name
    {
        get { if ( accountsMap == null ) accountsMap = new Map<String,houseHoldAcctWrapper>(); return accountsMap; }
        private set;
    }
    public Map<String,AccountListWrapper>   accountPartitions       { get; set; } 
    public List<AccountListWrapper>         accountLists            
    { 
        get 
        { 
            return accountPartitions == null ? null : accountPartitions.values();
        }
        private set;
    }                   
    public Id                               subjectCaseID           { get; set; }
    public Case                             subjectCase             { get; set; } 
    public Account                          subjectHousehold        { get; set; }    
    public List<contactDetailWrapper>       relatedContacts 
    { 
        get
        {
            return relatedContactsMap == null ?
                new List<contactDetailWrapper>() :
            relatedContactsMap.values();
        } 
        set; 
    }
    public List<contactDetailWrapper>       detachedContacts 
    { 
        get
        {
            return detachedContactsMap == null ?
                new List<contactDetailWrapper>() :
            detachedContactsMap.values();
        } 
        set; 
    }
    public Map<String,CaseContactRole>      theRoles                
    { 
        get 
        { 
            if (theRoles == null) theRoles = new Map<String,CaseContactRole>(); 
            return theRoles; 
        } 
        set; 
    }
    public Map<String,contactDetailWrapper> relatedContactsMap   { get; set; }
    public Map<String,contactDetailWrapper> detachedContactsMap  { get; set; }
    public String                           sortField            { get; set; }
    public String                           ContactforAcct       { get; set; }
    public String                           primary              { get; set; }
    public String                           removed              { get; set; }
    public String                           added                { get; set; }
    public String                           listSource           { get; set; }
    public SeaRchpanEl                      searchPanel          { get; set; }
    public String                           errorMessageHdr      { get; set; }
    public String                           errorMessageBody     { get; set; }
    public Boolean                          showErrorMessages    
    { 
        get
        {
            showErrorMessages = errorMessageHdr != null || errorMessageBody != null;
            if (showErrorMessages && errorMessageHdr == null) errorMessageHdr = 'ERROR!';
            return showErrorMessages;
        }
        private set; 
    }
    
    ////////////////////
    // member functions
    ////////////////////
    public void clearErrorMessages()
    {
        errorMessageHdr = errorMessageBody = null;
    }
    
    public void addErrorMessages(String hdr, String body)
    {
        if (errorMessageHdr == null) errorMessageHdr = hdr;
        if (errorMessageBody == null) errorMessageBody = body;
        else errorMessageBody += '\n' + body;
    }
    
    private void queryContacts()
    {
        if (relatedContactsMap == null) relatedContactsMap = new Map<String,contactDetailWrapper>();
        if (householdContactsMap == null) householdContactsMap = new Map<String,contactDetailWrapper>();
        if (potentialContactIDs == null) potentialContactIDs = new set<Id>();
        
        Set<String> idsForQuery = new Set<String>();
        idsForQuery.addAll(relatedContactsMap.keyset());
        idsForQuery.addAll(detachedContactsMap.keyset());
        for( Id contactID : potentialContactIDs ) if (contactID != null) idsForQuery.add(String.valueOf(contactID));
        queryContacts( idsForQuery );
    }
    
    public void queryContacts( set<String> idsForQuery )
    {
        if (idsForQuery != null) idsForQuery.remove(null);
        if (idsForQuery == null || idsForQuery.isEmpty()) return; 
        
        CWQuery queryContact = CWQuery.newQuery('Account').addAllFields();
        queryContact.add( 'id', new List<String>{'Id', 'Name'} );
        for(String anID : idsForQuery) 
        { 
            SkyFinderUtils.idTupple idINFO = SkyFinderUtils.validateID(anID);
            if ( !idINFO.isValid ) idsForQuery.remove(anID);
        }
        CWQuery.WhereClause theWhereClause = 
            queryContact.newANDWhereClause().isIN('id', new List<String>(idsForQuery))
            .newANDWhereClause('RecordTypeid = ' + SkyFinderUtils.passengerContactRecTypeString);
        queriedContacts = new Map<Id,Account>((List<Account>)queryContact.query());  // VNP remove unecessary dynamic query
        updateAccountMaps(queriedContacts);
    }
    
    private void updateAccountMaps( Map<ID,Account> theContacts )
    {
        for (Account aContact : theContacts.values())
        {
            if (aContact.Name == null) continue;
            accountsMap.put(aContact.Name, new houseHoldAcctWrapper( aContact.Name, aContact) );
        } 
    }
    
    private void updateContactMaps()
    {
        if( relatedContactsMap == null) relatedContactsMap = new Map<String,contactDetailWrapper>();
        if( detachedContactsMap == null) detachedContactsMap = new Map<String,contactDetailWrapper>();
        if (mode == 'Search') return;
        if (householdContactsMap == null) householdContactsMap = new Map<String,contactDetailWrapper>();
        if (queriedContacts == null) return;
        for( Account aContact : queriedContacts.values())
        {
            String myIndex = 'newContact' + newContactIndex;
            contactDetailWrapper newWrapper = 
                new contactDetailWrapper
                (
                    this, 
                    aContact, 
                    theRoles.get(String.valueof(aContact.Id)), 
                    subjectCase.AccountId, 
                    myIndex
                ); 
            
            if ( relatedContactsMap.keyset().contains(String.valueof(aContact.Id)) ) // TODO, this may be source of bug, key could also be loyalty number
            {
                relatedContactsMap.put( String.valueof(aContact.Id), newWrapper);
            }
            else detachedContactsMap.put(String.valueof(aContact.Id), newWrapper);
            if( householdContacts.keySet().contains(aContact.id) )
            {
                householdContactsMap.put( String.valueof(aContact.Id), newWrapper);
            }
            // VNP-need to verfiy 
        }        
    }
    
    private void updatePotentialIDs()
    {
        if (potentialContactIDs == null) 
        {
            potentialContactIDs = new set<ID>();
            return;
        }
        potentialContactIDs.addAll(householdContacts.keySet());
    }
    
    ////////////////////
    // action functions
    ////////////////////
    public void removeContact()
    {
        if (removed == null) return;
        contactDetailWrapper theRemoved = relatedContactsMap.remove(removed);
        
        if (theRemoved != null) 
        {
            detachedContactsMap.put(theRemoved.searchIndex, theRemoved);
            if (theRemoved.primary == true)
            {
                theRemoved.primary = false;
                if(!relatedContacts.isEmpty())
                {
                    primary = relatedContacts[0].searchIndex; 
                    relatedContacts[0].primary = true;
                }
            }
        }
    }
    
    public void addContact()
    {
        if (added == null) return;
        if (listSource == null) return;
        Map<String, contactDetailWrapper> theSource = tablesMaps.get(listSource);
        if(theSource == null) return;
        contactDetailWrapper theAdded = theSource.get(added);
        if (theAdded != null) 
        {
            relatedContactsMap.put(theAdded.searchIndex, theAdded);
            if (relatedContactsMap.size() == 1) // this lonely contact becomes the prmary
            {
                primary = theAdded.searchIndex; 
                theAdded.primary = true;
            }
            theAdded.possibleAccts = new AccountListWrapper(theAdded, this); 
            if (theAdded.possibleAccts != null) theAdded.possibleAccts.createLists();
        }
    }
    
    public void resetPrimary()
    {
        if (primary == null) return;
        
        for (contactDetailWrapper wrapper : relatedContactsMap.values()) 
        {
            wrapper.primary = false;
        }
        for (contactDetailWrapper wrapper : detachedContactsMap.values()) wrapper.primary = false;
        contactDetailWrapper newPrimary = relatedContactsMap.get(primary);
        if (newPrimary != null) newPrimary.primary = true;
        else 
        {
            if (!relatedContacts.isEmpty())  
            {
                primary = relatedContacts[0].subject.id; 
                relatedContacts[0].primary = true;
            }
        }
    }
    
    public void handleUsePrimaryChange()
    {
        // please refresh -- this looks like it does nothing, but it is used to rerender
    }
    public void refreshContacts()
    {
        updatePotentialIDs();
        queryContacts();
        updateContactMaps();
    }
    public void cancelChanges()
    {
        relatedContactsMap = new Map<String,contactDetailWrapper>();
        potentialContactIDs = null;
        if (detachedContactsMap == null) detachedContactsMap = new Map<String,contactDetailWrapper>();
        theRoles = new Map<String,CaseContactRole>();
        detachedContactsMap.putAll(relatedContactsMap);
        relatedContactsMap.put(subjectCase.ContactId, null);
        detachedContactsMap.remove(subjectCase.ContactId);
        for ( CaseContactRole aRole :
             [
                 SELECT CasesId, Role, ContactID
                 FROM CaseContactRole
                 WHERE CasesId = :subjectCaseID
             ])
        {
            theRoles.put(String.valueof(aRole.ContactID),aRole);
            relatedContactsMap.put(aRole.ContactID, null);
            detachedContactsMap.remove(aRole.ContactID);
        }
        updatePotentialIDs();
        queryContacts();
        updateContactMaps();
        searchPanel.resetSearch();
    }
    public void saveContacts()
    {
        if (theRoles != null) delete theRoles.values();
        theRoles = new Map<String,CaseContactRole>();
        List<Account> updateList = new List<Account>();
        Set<String> contactKeys = new Set<String>();
        Boolean validationPassed = true;
        Map<String,Account> theNewAccounts = SkyFinderUtils.createTheseAccounts(relatedContactsMap,accountsMap);
        for( String aContact : relatedContactsMap.keyset() )
        {
            Account relContact; 
            contactDetailWrapper relContactWrapper = relatedContactsMap.get(aContact);
            relContact = relatedContactsMap.get(aContact).subject;
            updateList.add( relContact );
        }
        Database.UpsertResult[] upsertResults = Database.upsert(updateList, false);
        for(Database.UpsertResult result : upsertResults)
        {
            if(!result.isSuccess()) 
            {
                // This inner loop should be very short
                for (Database.Error err : result.getErrors()) 
                { 
                    String errString = 'UpsertError:' + err.getStatusCode() + '-' + err.getMessage();
                    if (!err.getFields().isEmpty()) errString += '\n err.getFields()';
                    addErrorMessages('Error Creating or Updating Contacts', errString);
                } 
            }
        }
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> contactsToUpdate = new List<Account>();
        for (houseHoldAcctWrapper acct : accountsMap.values()) 
        { 
            if (acct.setPrimary()) 
            {
                accountsToUpdate.add(acct.household);
                if (acct.nameSource != null && acct.nameSource.Id!= null) contactsToUpdate.add(acct.nameSource); // 'if' may be redundant, setPrimary shouldn't return true
            }
        }
        try
        { 
            upsert contactsToUpdate;    // contacts must be upserted first to accomodate the account primary contact lookup filter
            upsert accountsToUpdate; 
        }
        catch( Exception e) 
        {
            addErrorMessages('Save Error!', 'Could not update Primary Contact for Accounts.');
        }
        for ( String aContact : relatedContactsMap.keyset() )
        {
            contactDetailWrapper relContactWrapper = relatedContactsMap.remove(aContact);
            Boolean validContactID = ( relContactWrapper.subject.id != null && SkyFinderUtils.validateID(relContactWrapper.subject.id).isValid );           
            relContactWrapper.searchIndex = validContactID ? String.valueOf(relContactWrapper.subject.id) : relContactWrapper.searchIndex;
            relatedContactsMap.put( relContactWrapper.searchIndex, relContactWrapper );
            if (!validContactID) continue;
            CaseContactRole aRole = new CaseContactRole();
            aRole.Role = relContactWrapper.roleObject == null ? 'Passenger' : 
            (relContactWrapper.roleObject.Role == null ? 'Passenger' : relContactWrapper.roleObject.Role);
                aRole.CasesId = subjectCase.Id;
            aRole.ContactId = relContactWrapper.subject.id;
            relContactWrapper.roleObject = aRole;
            theRoles.put( relContactWrapper.subject.id, aRole );
            if (relContactWrapper.primary == true) subjectCase.ContactId = relContactWrapper.subject.id;
        }
        try { insert theRoles.values(); }
        catch( Exception e) 
        {
            addErrorMessages('Save Error!', 'Unable to insert CaseContactRole. Passenger not added to case.');
        }
        if (subjectCase != null) 
        {
            try { update subjectCase; }
            catch( Exception e) { addErrorMessages('Update Error!', 'Could not update case ' + subjectCase.Id); }
        }
    } 
    
    
    
    
    
    ////////////////   
    // constructor
    ////////////////
    public SkyFinderMainController()
    {
        newContactIndex = 0;
        searchPanel = new SeaRchpanEl(newContactIndex++, this);  
        Initialize();    
    }
    
    public SkyFinderMainController(ApexPages.standardController stndrd)
    {
        sortingHeader = '';
        sfBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        showAccountPanel = false;
        Chooser = false;
        newContactIndex = 0;
        potentialContactIDs = new set<Id>();
        relatedContactsMap = new Map<String,contactDetailWrapper>();
        detachedContactsMap = new Map<String,contactDetailWrapper>();       
        relatedContacts = new List<contactDetailWrapper>();
        detachedContacts = new List<contactDetailWrapper>();
        theRoles = new Map<String,CaseContactRole>();
        searchPanel = new SeaRchpanEl(newContactIndex++, this);                    
        
        if (stndrd != null)
        {
            subjectCase = (Case)stndrd.getRecord();
        }
        else // treat this like a custom controller rather than an extension
        {
            subjectCaseID = ApexPages.currentPage().getParameters().get('id');
        }
        
        // this controller is used for the Contact Manager and the Contact Search page
        // for the search page there will be no case ID
        topPanelMode = 'CaseContactNoCase';
        if (subjectCaseID == null && subjectCase != null) subjectCaseID = subjectCase.Id;
        if (subjectCaseID == null) mode = 'Search';     //support the case search page
        else mode = 'Manage';
        
        Initialize();
        queryContacts();
        updateContactMaps();
        
    }
    public class contactDetailWrapper implements CWAccessible,Comparable 
    {
        // parameters
        public string fname                     { get; set; }
        public string lname                     { get; set; }
        public SkyFinderMainController ctrl     { get; set; }
        public Boolean primary                  { get; set; }
        public String  source                   { get; set; }
        
        public string SORT_BY { get; set; }
        public string SORT_Dir { get; set; }

        
        
        
         public  String sortableField='fname';
         public  String sortOrder='asc';  
        
         public Integer compareTo(Object compareTo) {
         

              contactDetailWrapper compWrap = (contactDetailWrapper)compareTo;
             
              //if(sortableField == 'fname'){     
              //if (fname == compWrap.fname) return 0;
            //  if (fname > compWrap.fname) return 1;
            
                     //system.debug('kiran - compWrap= ' + compWrap);
                     //system.debug('kiran - this = ' + this);
            
           /* if (fname!=null && compWrap !=null){
            system.debug('kiran - ' + fname + ':' + compWrap.fname);
                return fname.toLowerCase().compareTo(compWrap.fname.toLowerCase());
                }
                else return 0;*/
                
               
        
          if(SORT_BY != '' && SORT_BY != null)

        {
                //string colVal=SORT_BY;
                //system.debug('prashantbb ' + SORT_BY);
               if (SORT_BY!=null && compWrap !=null){
               
                    if(SORT_BY =='subject.LastName'){
                    
                    String lastName = (((contactDetailWrapper)compWrap).subject.LastName != null) ? ((contactDetailWrapper)compWrap).subject.LastName : '';
                    // For Ascending
                    if (SORT_Dir == 'asc')
                        return this.subject.LastName.toLowerCase().compareTo(lastName.toLowerCase());
                    // For Descending
                    else
                        return lastName.toLowerCase().compareTo(this.subject.LastName.toLowerCase() );
                   //   system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.LastName);
                   //   if(SORT_Dir ='desc'){
                  //       return subject.LastName != Null ? (subject.LastName.toLowerCase()).compareTo(compWrap.subject.LastName.toLowerCase()) :  1;
                  //    } 
                      
                    }
                    else if(SORT_BY =='subject.FirstName' && this.subject.FirstName!= null){
                      String firstname = (((contactDetailWrapper)compWrap).subject.FirstName!= null) ? ((contactDetailWrapper)compWrap).subject.FirstName: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.FirstName.toLowerCase().compareTo(firstname.toLowerCase());
                      // For Descending
                      else
                        return firstname.toLowerCase().compareTo(this.subject.FirstName.toLowerCase()); 
                    }
                    /*else if(SORT_BY =='subject.FirstName' && subject.FirstName != null && compWrap.subject.FirstName != null ){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.FirstName);
                      return subject.FirstName.toLowerCase().compareTo(compWrap.subject.FirstName.toLowerCase());
                    }
                    else if(SORT_BY =='searchEmail' && searchEmail != null && compWrap.searchEmail != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.searchEmail);
                      return searchEmail.toLowerCase().compareTo(compWrap.searchEmail.toLowerCase());
                    }
                    else if(SORT_BY =='searchPhone' && searchPhone != null && compWrap.searchPhone != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.searchPhone);
                      return searchPhone.toLowerCase().compareTo(compWrap.searchPhone.toLowerCase());
                    }
                    else if(SORT_BY =='subject.SkyMiles_Number__pc' && subject.SkyMiles_Number__pc != null && compWrap.subject.SkyMiles_Number__pc != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.SkyMiles_Number__pc);
                      return subject.SkyMiles_Number__pc.toLowerCase().compareTo(compWrap.subject.SkyMiles_Number__pc.toLowerCase());
                    }
                    else if(SORT_BY =='subject.Flying_Blue_Number__pc' && subject.Flying_Blue_Number__pc != null && compWrap.subject.Flying_Blue_Number__pc != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.Flying_Blue_Number__pc);
                      return subject.Flying_Blue_Number__pc.toLowerCase().compareTo(compWrap.subject.Flying_Blue_Number__pc.toLowerCase());
                    }
                    else if(SORT_BY =='subject.PersonMailingStreet' && subject.PersonMailingStreet != null && compWrap.subject.PersonMailingStreet != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.PersonMailingStreet);
                      return subject.PersonMailingStreet.toLowerCase().compareTo(compWrap.subject.PersonMailingStreet.toLowerCase());
                    }
                    else if(SORT_BY =='subject.PersonMailingCity' && subject.PersonMailingCity != null && compWrap.subject.PersonMailingCity != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.PersonMailingCity);
                      return subject.PersonMailingCity.toLowerCase().compareTo(compWrap.subject.PersonMailingCity.toLowerCase());
                    } 
                    else if(SORT_BY =='subject.PersonMailingState' && subject.PersonMailingState != null && compWrap.subject.PersonMailingState != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.PersonMailingState);
                      return subject.PersonMailingState.toLowerCase().compareTo(compWrap.subject.PersonMailingState.toLowerCase());
                    }
                    else if(SORT_BY =='subject.PersonMailingPostalCode' && subject.PersonMailingPostalCode != null && compWrap.subject.PersonMailingPostalCode != null){
                      system.debug('prashant - ' + SORT_BY+ ':' + compWrap.subject.PersonMailingPostalCode);
                      return subject.PersonMailingPostalCode.toLowerCase().compareTo(compWrap.subject.PersonMailingPostalCode.toLowerCase());
                    } 
                    */
                    else if(SORT_BY =='searchEmail' && this.searchEmail != null){
                      String sEmail = (((contactDetailWrapper)compWrap).searchEmail != null) ? ((contactDetailWrapper)compWrap).searchEmail : '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.searchEmail.toLowerCase().compareTo(sEmail.toLowerCase());
                      // For Descending
                      else
                        return sEmail.toLowerCase().compareTo(this.searchEmail.toLowerCase()); 
                    }
                    else if(SORT_BY =='searchPhone' && this.searchPhone!= null){
                      String sPhone = (((contactDetailWrapper)compWrap).searchPhone!= null) ? ((contactDetailWrapper)compWrap).searchPhone: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.searchPhone.toLowerCase().compareTo(sPhone.toLowerCase() );
                      // For Descending
                      else
                        return sPhone.toLowerCase().compareTo(this.searchPhone.toLowerCase()); 
                    }
                    else if(SORT_BY =='subject.SkyMiles_Number__pc' && this.subject.SkyMiles_Number__pc!= null){
                      system.debug('sky mile');
                      String skynumber = (((contactDetailWrapper)compWrap).subject.SkyMiles_Number__pc!= null) ? ((contactDetailWrapper)compWrap).subject.SkyMiles_Number__pc: '';
                      // For Ascending
                      if (SORT_Dir == 'asc'){
                         return this.subject.SkyMiles_Number__pc.compareTo(skynumber);
                      }
                      // For Descending
                      else{
                       return skynumber.compareTo(this.subject.SkyMiles_Number__pc); 
                       }
                    }
                    else if(SORT_BY =='subject.Flying_Blue_Number__pc' && this.subject.Flying_Blue_Number__pc!= null){
                      String flynumber = (((contactDetailWrapper)compWrap).subject.Flying_Blue_Number__pc!= null) ? ((contactDetailWrapper)compWrap).subject.Flying_Blue_Number__pc: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.Flying_Blue_Number__pc.compareTo(flynumber);
                      // For Descending
                      else
                        return flynumber.compareTo(this.subject.Flying_Blue_Number__pc); 
                    }
                    else if(SORT_BY =='subject.PersonMailingStreet' && this.subject.PersonMailingStreet!= null){
                      String street = (((contactDetailWrapper)compWrap).subject.PersonMailingStreet!= null) ? ((contactDetailWrapper)compWrap).subject.PersonMailingStreet: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.PersonMailingStreet.toLowerCase().compareTo(street.toLowerCase());
                      // For Descending
                      else
                        return street.toLowerCase().compareTo(this.subject.PersonMailingStreet.toLowerCase()); 
                    }
                    
                    else if(SORT_BY =='subject.PersonMailingCity' && this.subject.PersonMailingCity != null){
                      String city = (((contactDetailWrapper)compWrap).subject.PersonMailingCity != null) ? ((contactDetailWrapper)compWrap).subject.PersonMailingCity: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.PersonMailingCity.toLowerCase().compareTo(city.toLowerCase());
                      // For Descending
                      else
                        return city.toLowerCase().compareTo(this.subject.PersonMailingCity.toLowerCase()); 
                    }
                    else if(SORT_BY =='subject.PersonMailingState' && this.subject.PersonMailingState!= null){
                      String state = (((contactDetailWrapper)compWrap).subject.PersonMailingState!= null) ? ((contactDetailWrapper)compWrap).subject.PersonMailingState: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.PersonMailingState.toLowerCase().compareTo(state.toLowerCase());
                      // For Descending
                      else
                        return state.toLowerCase().compareTo(this.subject.PersonMailingState.toLowerCase()); 
                    }
                    else if(SORT_BY =='subject.PersonMailingPostalCode' && this.subject.PersonMailingPostalCode!= null){
                      String postal = (((contactDetailWrapper)compWrap).subject.PersonMailingPostalCode!= null) ? ((contactDetailWrapper)compWrap).subject.PersonMailingPostalCode: '';
                      // For Ascending
                      if (SORT_Dir == 'asc')
                        return this.subject.PersonMailingPostalCode.toLowerCase().compareTo(postal.toLowerCase());
                      // For Descending
                      else
                        return postal.toLowerCase().compareTo(this.subject.PersonMailingPostalCode.toLowerCase()); 
                    }
                    else if(SORT_BY =='Create/View Customer'){
                      Boolean showS = (((contactDetailWrapper)compWrap).showSelect) ? ((contactDetailWrapper)compWrap).showSelect: false;
                      // For Ascending
                      if (SORT_Dir == 'asc' && shows !=this.showSelect)
                        return 0;
                      // For Descending
                      else
                        return 1; 
                    }
                    else 
                     return 0;
                   
                }
                else return 0;
        } 
        
        else{
               /* system.debug('prashantcc ' + SORT_BY);
                if (subject.FirstName!=null && compWrap !=null){
                    //system.debug('prashant - ' + subject.FirstName + ':' + compWrap.subject.FirstName);
                    return subject.FirstName.toLowerCase().compareTo(compWrap.subject.FirstName.toLowerCase());
                }
                else return 0;*/
                    String firstname = (((contactDetailWrapper)compWrap).subject.FirstName!= null) ? ((contactDetailWrapper)compWrap).subject.FirstName: '';
                    // For Ascending
                    return this.subject.FirstName.toLowerCase().compareTo(firstname.toLowerCase() );
            }      
               
            
             
             // }
             
          //return null;
         }
        
        
        public String searchIndex               
        { 
            get
            { 
                if (searchIndex == null && subject != null)
                {
                    // There is a hierarchy of assignment:  contactID, loyaltynumber, unique string
                    searchIndex = subject.id;
                    if (searchIndex == null) searchIndex = subject.SkyMiles_Number__pc;
                    if (searchIndex == null) searchIndex = subject.Flying_Blue_Status__pc;
                    if (searchIndex == null) searchIndex = 'newContact' + ctrl.newContactIndex++;
                }
                return searchIndex; 
            } 
            set; 
        }
        public Boolean hasDropdown              
        {
            get
            {
                return (subject.Id == null && possibleAccts != null && !possibleAccts.dropdownList.isEmpty()) ? true : false; 
            }
            private set; 
        }
        public Boolean DropdownNotEmpty              
        {
            get
            {
                return (possibleAccts != null && !possibleAccts.dropdownList.isEmpty()) ? true : false; 
            }
            private set; 
        }
        public AccountListWrapper possibleAccts { get; set; }
        public Account subject                  { get; set; }
        public String selectedAccountName       { get; set; }
        public ID subjectAccountID              { get { return subject == null ? null : subject.Id; } set; }
        public String subjectAccountName        
        { 
            get 
            { 
                if (subjectAccountName == null) subjectAccountName = (subject == null) ? null : subject.name;
                return subjectAccountName;
            }
            set; 
        }
        public String AcctNameShort          
        {
            get 
            { 
                if (subjectAccountName == null) return null;
                
                List<String> nameParts = CWString.toList( CWString.split(subjectAccountName) );
                return nameParts.isEmpty() ? null : nameParts[0];
            }
            private set; 
        }
        
        public CaseContactRole roleObject   { get; set; }
        
        public String TicketNumber          { get; set; }
        public String PNR                   { get; set; }
        
        public Boolean hasContactID         { get {  return subject.Id == null ? false : true; } set; }
        public Boolean hasAccount           { get{ return subject.Id == null ? false : true; } set; }
        public Boolean showAcctName         { get{ return hasAccount; } set; }
        public Boolean isNewContact         { get{ return !hasContactID; } set; }
        public String searchGender          { get; set; }
        public String searchAddress         { get; set; }
        public String searchPhone           { get; set; }
        public String searchEmail           { get; set; }
        public Boolean IamSelected          { get; set; }
        public Boolean showSelect           { get{ return (IamSelected == false && hasContactID == false);} set; }
       //public Boolean showSelect           { get{ return (IamSelected == false);} set; }
        public Boolean showView             { get{ return (hasContactID == true);} set; }
        //public Boolean showCheck            { get{ return (IamSelected == true && hasContactID == false);} set; }
        public Boolean showCheck            { get{ return (IamSelected == true);} set; }
        public Boolean attached             
        { 
            get
            { 
                Boolean rval = false;
                if (subject != null && subject.Id != null) rval |= ctrl.relatedContactsMap.keyset().contains(subject.Id);
                rval |= ctrl.relatedContactsMap.keyset().contains(searchIndex);
                
                // this is a side effect, and generally not a best practice
                // but doing it this way synchronizes the relatedContactMap in an as needed way
                if (rval && !ctrl.relatedContactsMap.keyset().contains(searchIndex))
                {
                    contactDetailWrapper theRemoved = ctrl.relatedContactsMap.remove(subject.Id);
                    if (theRemoved != null) ctrl.relatedContactsMap.put(searchIndex,theRemoved);
                }
                
                return rval;
            } 
            private set; 
        }
        
        public String NameFirstLast         
        { 
            get
            {
                if (subject == null) return null;
                NameFirstLast = '' + subject.FirstName;
                NameFirstLast += subject.MiddleName == null ? '' :
                (NameFirstLast == '' ? null : ' ' + subject.MiddleName);
                    NameFirstLast += subject.LastName == null ? '' :
                (NameFirstLast == null ? subject.LastName : ' ' + subject.LastName);
                    return NameFirstLast;
            } 
            set; 
        }
        public String NameLastFirst         
        { 
            get
            {
                if (subject == null) return null;
                NameLastFirst = '' + subject.LastName;
                NameLastFirst += subject.FirstName == null ? '' :
                (NameLastFirst == null ? subject.FirstName : ', ' + subject.FirstName);
                    NameLastFirst += subject.MiddleName == null ? '' :
                (NameLastFirst == null ? null : ' ' + subject.MiddleName);
                    return NameLastFirst;
            } 
            set; 
        }
        
        ////////////////////////
        // implementation of the Accessible Interface
        //   -- should need only one of each of these functions for all fields on which to sort
        //   --
        ////////////////////////
        private Map<String,Type>    fieldTypes  = new Map<String,Type>  // can maybe simplify if always sorting on strings
        {
            'Primary'               =>  Boolean.class
                };
                    
                    public Type getFieldType( String fieldName )
                {
                    Type    theType     = fieldTypes.get( fieldName );
                    return theType != null ? theType : String.class;
                }
        
        public Object get( String fieldName )
        {
            return
                fieldName == 'Name'                 ?   NameLastFirst
                //            :   fieldName == 'Primary'              ?   primary
                :   fieldName == 'Address'              ?   searchAddress
                    :   fieldName == 'Phone'                ?   searchPhone
                        :   fieldName == 'Email'                ?   searchEmail
                            :   fieldName == 'Skymiles Status'      ?   subject.SkyMiles_Status__pc
                                :   fieldName == 'Flying Blue Status'   ?   subject.Flying_Blue_Status__pc
                                    :   fieldName == 'Account'              ?   (hasAccount ? subjectAccountName : '')
                                        :   fieldName == 'Skymiles'             ?   subject.SkyMiles_Number__pc
                                            :   fieldName == 'Flying Blue'          ?   subject.Flying_Blue_Number__pc
                                                :   fieldName == 'Role'                 ?   roleObject.Role
                                                    :   fieldName == 'Gender'               ?   searchGender
                                                        :   fieldName == 'DOB'                  ?   '@todo'
                                                            :                                       null;
        }
        
        ////////////////////////
        // wrapper constructors
        ////////////////////////
        
        public contactDetailWrapper( SkyFinderMainController controller, String newContactIndex )
        { 
            searchIndex = newContactIndex;
            ctrl = controller;
            subject = new Account( recordTypeId = skyfinderUtils.passengerContactRecType ); //'0120S0000004LRB' );
            if (roleObject == null) roleObject = new CaseContactRole(Role = 'Passenger');
            IamSelected = false;            
        }
        
        public contactDetailWrapper( SkyFinderMainController controller, Account subjectContact, CaseContactRole theRole, ID primaryID, String newContactIndex )
        {
            subject = subjectContact;
            IamSelected = false;
            ctrl = controller;
            roleObject = theRole == null ? new CaseContactRole(Role = 'Passenger') : theRole;
            if (primaryID != null && primaryID == subjectContact.id) primary = true;
            else primary = false;
            
            if (subjectContact != null) // to allow these to be null
            {    
                searchIndex = subjectContact.Id == null ? newContactIndex : String.valueof(subjectContact.Id);   
                if (searchAddress == null) setSearchAddress(subjectContact);
                if (searchGender == null) setSearchGender(subjectContact);
                //if (searchPhone == null) setSearchPhone(subjectContact);
            }
            else // clean up the null contact stored in subject
            {
                subject = new Account( recordTypeId = skyfinderUtils.passengerContactRecType );// '0120S0000004LRB' );
                searchIndex = newContactIndex;
            }
        }
        
        ////////////////////////
        // wrapper utilities
        ////////////////////////
        
        public Account updateContact( Account cnt )
        {
           
            subject = cnt;
            subject.PersonMailingStreet = string.valueof(cnt.get('PersonMailingStreet'));
            if (roleObject == null) roleObject = new CaseContactRole(Role = 'Passenger');
            return subject;
        }
        
        public void updateInformation(contactDetailWrapper additionalInfo)
        {
            Account Tsource = additionalInfo.subject;
            Account Tdestination = new Account( recordTypeId = skyfinderUtils.passengerContactRecType ); //'0120S0000004LRB' );
            mergeContacts( Tsource, Tdestination );
            if (subject.id == null) subject = Tdestination;
            else mergeContacts( Tdestination, subject );
        }
        
        public void setSearchAddress( Skymiles.MemberAddress theAddress )
        {
            if (theAddress == null || theAddress.person_acc == null || !theAddress.isValid) searchAddress = null;
            setSearchAddress( theAddress.person_acc ); 
        }
        
        public void setSearchAddress( Account theContact )
        {
            if (theContact == null) searchAddress = null;
            searchAddress = '';
            if (theContact.personMailingPostalCode != null) searchAddress += theContact.personMailingPostalCode;
            if(theContact.PersonMailingCountry != null) searchAddress += theContact.PersonMailingCountry;
            if (theContact.personMailingCity != null && theContact.personMailingState != null) searchAddress = (theContact.personMailingCity + ', ' + theContact.personMailingState + ' ') + searchAddress;
            else
            {
                if (theContact.personMailingCity != null) searchAddress = theContact.personMailingCity + (searchAddress == '' ? '' : ' ' + searchAddress);
                if (theContact.personMailingState != null) searchAddress = theContact.personMailingState + (searchAddress == '' ? '' : ' ' + searchAddress);
            }
            if (theContact.personMailingStreet != null) searchAddress = theContact.personMailingStreet + (searchAddress == '' ? '' : ', ' + searchAddress);
            //Boolean useSearchAddressOnSubject = true;
            //            if (useSearchAddressOnSubject)
            //            {
            if (subject.personMailingPostalCode == null) subject.personMailingPostalCode = theContact.personMailingPostalCode;
            if (subject.personMailingState == null) subject.personMailingState = theContact.personMailingState;
            if (subject.personMailingCity == null) subject.personMailingCity = theContact.personMailingCity;
            if (subject.personMailingStreet == null) subject.personMailingStreet = theContact.personMailingStreet;
            if (subject.PersonMailingCountry == null) subject.PersonMailingCountry = theContact.PersonMailingCountry;
            //            }
        }
        
        public void setSearchGender( Account searchContact )
        {
            system.debug('gender search --> '+searchContact+' , '+subject);
            String source = (searchContact == null || searchContact.Gender__pc == null) ? subject.Gender__pc : searchContact.Gender__pc;
            //Boolean useSearchGenderOnSubject = true;
            //            if (useSearchGenderOnSubject)
            //            {
            if (subject.Gender__pc == null && searchContact != null) subject.Gender__pc = searchContact.Gender__pc;  
            //            }
        }
        
        public void setSearchPhone( Skymiles.MemberPhone thePhone )
        {
            system.debug('phone value --> '+thePhone);
            if (thePhone == null || thePhone.person_acc == null || !thePhone.isValid) searchPhone = null;
            else searchPhone = thePhone.person_acc.phone;
            //Boolean useSearchPhoneOnSubject = true;
            //            if (useSearchPhoneOnSubject)
            //            {
            if (subject.phone == null && searchPhone != null) subject.phone = thePhone.person_acc.phone;  
            //            } 
        }
        
        public void setSearchEmail( Skymiles.MemberEmail theEmail )
        {
            system.debug('Email value --> '+theEmail);
            if (theEmail == null || theEmail.person_acc == null || !theEmail.isValid) searchEmail = null;
            else searchEmail = theEmail.person_acc.personemail;
            //Boolean useSearchEmailOnSubject = true;
            //            if (useSearchEmailOnSubject)
            //            {
            if (subject.personemail == null && searchEmail !=null) subject.personemail = theEmail.person_acc.personemail;  
            //            }
            
        }
        
        private void mergeContacts( Account source, Account destination )
        {
            
            for ( String fieldName : SkyFinderMainController.contactFields.keySet() )
            {
                if ( source.get(fieldName) == null ) continue;
                try
                {
                    destination.put(fieldName, source.get(fieldName)); 
                }
                catch( Exception e) { /* if thrown it is because this field is not editable, skip it and do the rest */}
            }
        }
       

        public CWQuery querySalesforce(Account searchPerson)
        {
           
            if (searchPerson == null) searchPerson = subject;
            
            Integer queryLimit = 10000;     // this is the max in CWQuery
            Schema.sObjectType contactSObjectType  = Account.getSObjectType();
            
            //change field set api name to person account field set api name
            CWQuery query = CWQuery.newQuery( contactSObjectType ).add( 'Id' ).addFieldSet( 'Account_Manager_Search_Fields' );
            //query.add( 'AccountID', new List<String>{'Id', 'Name'} );
            CWQuery.WhereClause whereClause = query.newANDWhereClause('RecordTypeid =' + SkyFinderUtils.passengerContactRecTypeString);// ' + '0120S0000004LRB');
            system.debug('flying blue number --> '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.firstName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.firstName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'FirstName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'FirstName_SoundEx__pc' ) )
                    )
                    .multiLike( 'FirstName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.middleName ) && CWSchema.isField( contactSObjectType, 'MiddleName' ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.MiddleName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'MiddleName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'MiddleName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.lastName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.lastName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'LastName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'LastName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.SkyMiles_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'SkyMiles_Number__pc', searchPerson.SkyMiles_Number__pc ) )
            {
                whereClause.add( 'SkyMiles_Number__pc = ' + CWString.quote( searchPerson.SkyMiles_Number__pc ) );
            }
            system.debug('value check --> '+contactSObjectType+' , '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.Flying_Blue_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'Flying_Blue_Number__pc', searchPerson.Flying_Blue_Number__pc ) )
            {
                whereClause.add( 'Flying_Blue_Number__pc = ' + CWString.quote( searchPerson.Flying_Blue_Number__pc ) );
            }
            
            if ( String.isNotBlank( searchPerson.personemail ) && CWFormatValidation.isValid( contactSObjectType, 'Email', searchPerson.personemail ) )
            {
                CWQuery.WhereClause emailWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Email )
                    {
                        emailWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.personemail ) );
                    }
                }
            }
            
            if ( String.isNotBlank( searchPerson.phone ) )
            {
                CWQuery.WhereClause phoneWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Phone )
                    {
                        phoneWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.phone ) );
                    }
                }
            }
            
            if  (   String.isNotBlank( searchPerson.personMailingCity )
                 ||  String.isNotBlank( searchPerson.personMailingState )
                 ||  String.isNotBlank( searchPerson.personMailingCountry )
                 ||  String.isNotBlank( searchPerson.personMailingPostalCode )
                )
            {
                CWQuery.WhereClause addressWhereClause = whereClause.newORWhereClause();
                //Added by HTL_Sandesh 04192017
                //for ( String address : new List<String>{ 'MailingAddress', 'OtherAddress' } )                
                for ( String address : new List<String>{ 'PersonMailingAddress', 'PersonOtherAddress' } )
                {
                    CWQuery.WhereClause detailsWhereClause = addressWhereClause.newANDWhereClause();
                    if ( String.isNotBlank( searchPerson.personMailingCity       ) ) detailsWhereClause.add( address.replace( 'Address', 'City'       ) + ' = ' + CWString.quote( searchPerson.personMailingCity       ) );
                    if ( String.isNotBlank( searchPerson.personMailingState      ) ) detailsWhereClause.add( address.replace( 'Address', 'State'      ) + ' = ' + CWString.quote( searchPerson.personMailingState      ) );
                    if ( String.isNotBlank( searchPerson.personMailingCountry    ) ) detailsWhereClause.add( address.replace( 'Address', 'Country'    ) + ' = ' + CWString.quote( searchPerson.personMailingCountry    ) );
                    if ( String.isNotBlank( searchPerson.personMailingPostalCode ) ) detailsWhereClause.add( address.replace( 'Address', 'PostalCode' ) + ' = ' + CWString.quote( searchPerson.personMailingPostalCode ) );
                }
            }
            
            CWQuery.WhereClause theWhereClause = query.getWhereClause();
            if (    theWhereClause == null || 
                String.isBlank(theWhereClause.toString()) ||
                theWhereClause.toString() == ('(RecordTypeid = ' + SkyFinderUtils.passengerContactRecTypeString + ')') ) return null; //('(RecordTypeid = ' + '0120S0000004LRB' + ')') ) return null;                       
            
            //End HTL_sandesh_4252017
            return query.setLimit( queryLimit );
        } 
        

        public CWQuery querySalesforce2(Account searchPerson,string SortCol, string sortOrder)
        {
            system.debug('sort order --> '+sortOrder);
            if (searchPerson == null) searchPerson = subject;
            
            Integer queryLimit = 10000;     // this is the max in CWQuery
            Schema.sObjectType contactSObjectType  = Account.getSObjectType();
            
            //change field set api name to person account field set api name
            CWQuery query = CWQuery.newQuery( contactSObjectType ).add( 'Id' ).addFieldSet( 'Account_Manager_Search_Fields' );
            //query.add( 'AccountID', new List<String>{'Id', 'Name'} );
            CWQuery.WhereClause whereClause = query.newANDWhereClause('RecordTypeid =' + SkyFinderUtils.passengerContactRecTypeString);// ' + '0120S0000004LRB');
            system.debug('flying blue number --> '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.firstName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.firstName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'FirstName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'FirstName_SoundEx__pc' ) )
                    )
                    .multiLike( 'FirstName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.middleName ) && CWSchema.isField( contactSObjectType, 'MiddleName' ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.MiddleName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'MiddleName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'MiddleName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.lastName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.lastName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'LastName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'LastName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.SkyMiles_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'SkyMiles_Number__pc', searchPerson.SkyMiles_Number__pc ) )
            {
                whereClause.add( 'SkyMiles_Number__pc = ' + CWString.quote( searchPerson.SkyMiles_Number__pc ) );
            }
            system.debug('value check --> '+contactSObjectType+' , '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.Flying_Blue_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'Flying_Blue_Number__pc', searchPerson.Flying_Blue_Number__pc ) )
            {
                whereClause.add( 'Flying_Blue_Number__pc = ' + CWString.quote( searchPerson.Flying_Blue_Number__pc ) );
            }
            
            if ( String.isNotBlank( searchPerson.personemail ) && CWFormatValidation.isValid( contactSObjectType, 'Email', searchPerson.personemail ) )
            {
                CWQuery.WhereClause emailWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Email )
                    {
                        emailWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.personemail ) );
                    }
                }
            }
            
            if ( String.isNotBlank( searchPerson.phone ) )
            {
                CWQuery.WhereClause phoneWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Phone )
                    {
                        phoneWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.phone ) );
                    }
                }
            }
            
            if  (   String.isNotBlank( searchPerson.personMailingCity )
                 ||  String.isNotBlank( searchPerson.personMailingState )
                 ||  String.isNotBlank( searchPerson.personMailingCountry )
                 ||  String.isNotBlank( searchPerson.personMailingPostalCode )
                )
            {
                CWQuery.WhereClause addressWhereClause = whereClause.newORWhereClause();
                //Added by HTL_Sandesh 04192017
                //for ( String address : new List<String>{ 'MailingAddress', 'OtherAddress' } )                
                for ( String address : new List<String>{ 'PersonMailingAddress', 'PersonOtherAddress' } )
                {
                    CWQuery.WhereClause detailsWhereClause = addressWhereClause.newANDWhereClause();
                    if ( String.isNotBlank( searchPerson.personMailingCity       ) ) detailsWhereClause.add( address.replace( 'Address', 'City'       ) + ' = ' + CWString.quote( searchPerson.personMailingCity       ) );
                    if ( String.isNotBlank( searchPerson.personMailingState      ) ) detailsWhereClause.add( address.replace( 'Address', 'State'      ) + ' = ' + CWString.quote( searchPerson.personMailingState      ) );
                    if ( String.isNotBlank( searchPerson.personMailingCountry    ) ) detailsWhereClause.add( address.replace( 'Address', 'Country'    ) + ' = ' + CWString.quote( searchPerson.personMailingCountry    ) );
                    if ( String.isNotBlank( searchPerson.personMailingPostalCode ) ) detailsWhereClause.add( address.replace( 'Address', 'PostalCode' ) + ' = ' + CWString.quote( searchPerson.personMailingPostalCode ) );
                }
            }
            
            CWQuery.WhereClause theWhereClause = query.getWhereClause();
            if (    theWhereClause == null || 
                String.isBlank(theWhereClause.toString()) ||
                theWhereClause.toString() == ('(RecordTypeid = ' + SkyFinderUtils.passengerContactRecTypeString + ')') ) return null; //('(RecordTypeid = ' + '0120S0000004LRB' + ')') ) return null;
                
           /*Added by anil*/
            system.debug('anil :-' + SortCol+' '+sortOrder);
            if(SortCol != null && string.isNotBlank(SortCol))
            {
                if(sortOrder == 'desc')query.orderByDescending(SortCol);
                else if(sortOrder == 'asc')query.orderByAscending(SortCol);
                else{
                    query.orderByAscending(SortCol);
                }
            }
            /*Added End*/
            
            //End HTL_sandesh_4252017
            return query.setLimit( queryLimit );
        } 
        
    
    }
    //////////////////
    // wrapper classes
    //      -- searchPanel
    //      -- AccountListWrapper
    //      -- idTupple
    //////////////////
    
    
    
    public class AccountListWrapper
    {
        private SkyFinderMainController controller;
        public contactDetailWrapper wrapper   { get; set; }
        public Account subject
        {
            get
            { 
                return wrapper.subject; 
            } 
            private set;
        }
        
        public String subjectName
        {
            get
            {
                String theName = '';
                theName += wrapper.subject.LastName;
                if (wrapper.subject.FirstName != null) 
                {
                    theName += ', ';
                    theName += wrapper.subject.MiddleName != null ?  wrapper.subject.FirstName + ' ' + wrapper.subject.MiddleName :
                    wrapper.subject.FirstName;
                }
                
                if ( subject.personMailingState != null || subject.personMailingStreet != null || subject.personMailingCity != null || subject.personMailingPostalCode != null)
                {
                    theName += ' | ';
                    String addressString = subject.personMailingStreet;
                    addressString = subject.personMailingCity == null ? addressString :
                    ( addressString == null ? subject.personMailingCity : addressString + ',' + subject.personMailingCity);
                        addressString = subject.personMailingState == null ? addressString :
                    ( addressString == null ? subject.personMailingState : addressString + ',' + subject.personMailingState);
                        addressString = subject.personMailingPostalCode == null ? addressString :
                    ( addressString == null ? subject.personMailingPostalCode : addressString + ',' + subject.personMailingPostalCode);
                        theName += addressString;
                }
                return theName;
            }
        }
        
        public List<SelectOption> dropdownList                  
        { 
            get
            {
                dropdownList = new List<SelectOption>(); // reset the list each time, because the map may have been altered
                if (controller.accountsMap == null) return dropdownList;
                for ( String key : controller.accountsMap.keySet() )   // key is the account name, value is the account id if it has one, 'new' if it doesn't
                {
                    dropdownList.add(new SelectOption(key,key));
                }
                return dropdownList;
            } 
            set; 
        }
        
        public AccountListWrapper( contactDetailWrapper wrp, SkyFinderMainController ctrlr)
        {
            if (wrp == null || ctrlr == null) return;
            wrapper = wrp;
            controller = ctrlr;
        }
        
        //Dont think this will be used as we will create person account
        public void createLists()
        {
            Integer queryLimit = 1000;
            Integer usefulListSize = 5;
            CWQuery queryAccount = CWQuery.newQuery('Account').addAllFields();
            CWQuery.WhereClause topWhereClause = queryAccount.newANDWhereClause('RecordType.DeveloperName = \'Household\'');
            topWhereClause.add('IsPlaceholder__c = false');
            CWQuery.WhereClause theWhereClause = topWhereClause.newORWhereClause();
            Account dummy = new Account();
            dummy.BillingStreet = wrapper.subject.personMailingStreet == null ? '%' : wrapper.subject.personMailingStreet;
            dummy.BillingPostalCode = wrapper.subject.personMailingPostalCode == null ? '%' : wrapper.subject.personMailingPostalCode;
            String wherePiece = AccountHandler.computeName( wrapper.subject.LastName, dummy );
            theWhereClause.add('Name LIKE \'' + wherePiece + '\'');
            queryAccount.setLimit( queryLimit );
            Map<Id,account> foundAccounts = new Map<Id,account>((List<Account>)queryAccount.query());
            if (foundAccounts.keyset().size() > usefulListSize || 
                ((foundAccounts.keyset().size() > 1) && dummy.BillingStreet == '%' && dummy.BillingPostalCode == '%'))
            {
                // so if this is a LastName, No Street, No PostalCode case we don't want all of the  <LastName | No Street | No Postal Codes> 
                //      in our dropdown, but if the last name is unusually enough to match an account exactly, then we want to add that one.
                //  also, if our search simply returns too many choices then this isn't a helpful, don't add these    
                foundAccounts = new Map<Id,account>(); // this list is too large to be useful
            }
            
            if (controller.accountsMap == null ) controller.accountsMap = new Map<String,houseHoldAcctWrapper>();
            
            // reconstruct the name (without the wild cards) so that this is always an option in the dropdown
            dummy.BillingStreet = wrapper.subject.personMailingStreet == '%' ? null : wrapper.subject.personMailingStreet;
            dummy.BillingPostalCode = wrapper.subject.personMailingPostalCode == '%' ? null : wrapper.subject.personMailingPostalCode;
            String computedAccountName = 
                AccountHandler.computeName( CWString.toTitleCase(wrapper.subject.LastName), dummy ); // used as controller.accountsMap key
            if(computedAccountName != null) controller.accountsMap.put( computedAccountName, new houseHoldAcctWrapper(computedAccountName, wrapper.subject) );                           
            
            // add in the household account
            if (controller.subjectHousehold != null && controller.subjectHousehold.id != null)
            {
                controller.accountsMap.put( controller.subjectHousehold.name, 
                                           new houseHoldAcctWrapper(controller.subjectHousehold.name, controller.subjectHousehold.Primary_Contact__c) );
            }
            
            // add in the account names that mostly match that are found in the database
            for (Account acct : foundAccounts.values() )
            {            
                controller.accountsMap.put(acct.Name, new houseHoldAcctWrapper(acct.Name, acct.id));
            }
        }        
    }
    
    public class searchPanel
    {
        public string SortCol ='';
      
        public SkyFinderUtils.pagingStruct pagingControl        { get; set; }
        private SkyFinderMainController controller;
        private Integer commonIndex;                            // should be unique for each searchPanel
        private Integer localIndex;                             // new contacts have map keys that are "newContactX.y", .y is the localIndex
        public Boolean render
        { 
            get 
            { 
                List<contactDetailWrapper> searchResults = organizeSearchResults();  
                render = !searchResults.isEmpty(); //&& !showMessages; 
                return render;
            } 
            private set; 
        }
        public Boolean searched                                 { get { if (searched == null) searched = false; return searched;} set; }  // used to show the create button only after a search is performed
        public Boolean showCreate                               
        { 
            get 
            { 
                if (showCreate == null) showCreate = false;
                if (!showCreate) showCreate |= searched; 
                return showCreate; 
            } 
            private set; 
        }
        public Boolean showMessages                             { get { return searched && (messageHdr != null && !hideShowMessageOverride);} private set;}
        public String messageHdr                                { get; set; }
        public String messageBody                               { get; set; }
        public contactDetailWrapper searchInfo                  { get; set; }
        public Boolean hideShowMessageOverride                  { get; set; } 
        
        //  containing the segregated results of all of the searched services
        // replace getSearchResults with a walk of this map
        // create searchResultsList from this map
        private Map<String, contactDetailWrapper> skymilesResults;
        private Map<String, contactDetailWrapper> fBlueResults;
        private Map<String, contactDetailWrapper> salesforceResults;
        private Map<String, contactDetailWrapper> ticketResults;
        public Map<String, contactDetailWrapper> pnrResults;
        public Map<String, contactDetailWrapper> pnrHistorical;
        public integer  searchResultsListSize     
        { 
            get 
            { 
                List<contactDetailWrapper> searchResults = organizeSearchResults();
                return searchResults.size(); 
            } 
            set; 
        }
        public List<contactDetailWrapper> searchResultsList     
        { 
            get 
            { 
                List<contactDetailWrapper> searchResults = organizeSearchResults();
                return searchResults == null ? null : searchResults; 
            } 
            set; 
        }
        public List<contactDetailWrapper> pnrResultsList
        {
            get
            {
                if (pnrResultsList != null) return pnrResultsList;
                pnrResultsList = new List<contactDetailWrapper>();
                if (pnrResults != null) pnrResultsList.addAll(pnrResults.values());
                if (pnrHistorical != null) pnrResultsList.addAll(pnrHistorical.values());
                return pnrResultsList;
            }
            set;
        }
        public String selected                                  { get; set; }
        public String nextSelected                              { get; set; }
        
        ////////////////////////
        // searchPanel constructors
        ////////////////////////
        
        public searchPanel(Integer externalIndex, SkyFinderMainController parent) 
        { 
            controller = parent; 
            localIndex = 0;
            commonIndex = externalIndex;
            String searchContactIndex = 'newContact' + commonIndex + (0.1 * localIndex++);
            searchInfo = new contactDetailWrapper(parent, searchContactIndex);
            clearResults();
        }
        
        ////////////////////////
        // searchPanel utilites
        ////////////////////////
        private List<contactDetailWrapper> organizeSearchResults()
        {
            Map<String,contactDetailWrapper> searchResults = new Map<String,contactDetailWrapper>();
            if (salesforceResults != null) { searchResults.putAll(salesforceResults); }
            if (ticketResults != null) { searchResults.putAll(ticketResults); }
            if (pnrResults != null) { searchResults.putAll(pnrResults); }
            if (pnrHistorical != null) { searchResults.putAll(pnrHistorical); }
            if (skymilesResults != null) { searchResults.putAll(skymilesResults); }
            if (fBlueResults != null) { searchResults.putAll(fBlueResults); }
            return searchResults.values();
        }
        
        public void clearSearch()
        {
            String searchContactIndex = 'newContact' + commonIndex + (0.1 * localIndex++);
            searchInfo = new contactDetailWrapper(controller, searchContactIndex);
        }
        
        public void clearResults()
        {
            skymilesResults = new Map<String, contactDetailWrapper>();
            fBlueResults = new Map<String, contactDetailWrapper>();
            salesforceResults = new Map<String, contactDetailWrapper>();
            ticketResults = new Map<String, contactDetailWrapper>();
            pnrResults = new Map<String, contactDetailWrapper>();
            pnrHistorical = new Map<String, contactDetailWrapper>();
            searched = false;
            messageBody = messageHdr = null;
            
            
        }
        
        public void hideSearchMessages()
        {
            hideShowMessageOverride = true;
        }
        public void resetSearch()
        {
            clearSearch();
            clearResults();
        }
        //VNP- need to check
        public Account transferAccountId{get;set;}
        public void createContact()
        {            
            transferAccountId = new account();
            String acctName;
            String acctID;
            Account household;
            if (controller.accountsMap == null) controller.accountsMap = new Map<String,houseHoldAcctWrapper>();

            /*if (searchInfo.subject.Id == null)  // TODO : or if this is a placeholder account (shouldn't be in dropdown)
            {
                Account dummy = new Account();
                dummy.BillingStreet = searchInfo.subject.PersonMailingStreet;
                dummy.BillingPostalCode = searchInfo.subject.PersonMailingPostalCode;
                String nameString = AccountHandler.computeName( searchInfo.subject.LastName, dummy );

                if (searchInfo.selectedAccountName == null)
                {
                    household = new Account( Name = nameString, RecordTypeId = skyfinderUtils.householdAccountRecType );
                    // this is not in a try catch, if this throws an exception, an developer should fix it
                    insert household;
                    acctID = household.id;
                    acctName = nameString;
                }
                else
                {
                    houseHoldAcctWrapper hWrapper = controller.accountsMap.get(searchInfo.selectedAccountName);
                    acctId = hWrapper == null ? null : hWrapper.accountId;
                    household = hWrapper.household;
                    acctName = searchInfo.selectedAccountName;
                    if (acctId == null)
                    {
                        household = new Account( Name = acctName, RecordTypeId = skyfinderUtils.householdAccountRecType );
                        // this is not in a try catch, if this throws an exception, an developer should fix it
                        insert household;
                        acctID = household.id;                        
                    }
                }
                searchInfo.subject.Id = acctID;
            }*/

           try
            {
               //Start--Code changed by Htl_Sandesh_12/04/2017
               //Added code to check if contact already available in contact object to resolve null-reference
               upsert searchInfo.subject; //Commented by sandesh to fix view contact issue.
               transferAccountId = searchInfo.subject;
               system.debug('id check --> '+searchInfo.subject.id+'  '+searchInfo.subject);           
               if ( searchInfo.subject.Id != null ) 
               {
                   searchInfo.showSelect = false;
                   System.Debug('Sandesh--searchInfo.subject.SkyMiles_Number__c' + searchInfo.subject.SkyMiles_Number__pc);
                   if([select SkyMiles_Number__pc FROM Account where SkyMiles_Number__pc =: searchInfo.subject.SkyMiles_Number__pc].size() > 0 )
                   {//DoNothing
                   }
                   else
                   {
                   household.Primary_Contact__c = searchInfo.subject.Id;
                   upsert household;
                 
                   }
               }
               system.debug('Sandesh--Upsert for household done');
            }
            catch(Exception e)
            {
                // if thrown it is likely because there is an existing contact with same skymiles number 
                controller.addErrorMessages('Save Error!', e.getMessage());
                if (acctName != null) controller.accountsMap.put(acctName, new houseHoldAcctWrapper(acctName, acctID) );
                if (searchInfo.possibleAccts == null)
                    searchInfo.possibleAccts = new AccountListWrapper(searchInfo, controller);
                searchInfo.possibleAccts.createLists();
                return;
            }
            
            contactDetailWrapper myWrapper = new contactDetailWrapper
            (
                controller, 
                searchInfo.subject, 
                new CaseContactRole(Role = 'Passenger', CasesId = controller.subjectCaseID, ContactID = searchInfo.subject.Id), 
                controller.subjectCase.ContactId, 
                'newContact' + controller.newContactIndex +0.1 
            );
            controller.newContactIndex++;
            controller.relatedContactsMap.put(searchInfo.subject.Id, myWrapper);
            controller.createdContactsMap.put(searchInfo.subject.Id, myWrapper);            
            if (acctName != null) controller.accountsMap.put(acctName, new houseHoldAcctWrapper(acctName, acctID));
            if (searchInfo.possibleAccts == null)
                searchInfo.possibleAccts = new AccountListWrapper(myWrapper, controller);
            searchInfo.possibleAccts.createLists();
            myWrapper.subjectAccountName = acctName;    // or I can query the contact
            
            
            /*       
            //Added by Sandesh_4262017
            //clearSearch();
            //resetSearch();
            searchInfo.subject.FirstName=string.isNotBlank(strfname)  ? strfname : Null ;
            searchInfo.subject.LastName=string.isNotBlank(strLname)  ? strLname : Null ;
            searchInfo.fname = string.isNotBlank(strfname)  ? strfname : Null ;
            searchInfo.lname = string.isNotBlank(strLname)  ? strLname : Null ;
            searchInfo.subject.PersonMailingCity = string.isNotBlank(strPersonMailingCity)  ? strPersonMailingCity : Null ;
            searchInfo.subject.PersonMailingState = string.isNotBlank(strPersonMailingState)  ? strPersonMailingState : Null ;
            searchInfo.subject.PersonMailingPostalCode = string.isNotBlank(strPersonMailingPostalCode)  ? strPersonMailingPostalCode : NULL ;
            searchInfo.subject.personEmail = string.isNotBlank(strpersonEmail)  ? strpersonEmail : Null ;
            searchInfo.subject.phone = string.isNotBlank(strphone)  ? strphone : Null ;
            searchInfo.subject.SkyMiles_Number__pc = string.isNotBlank(strSkyMilesNumber)  ? strSkyMilesNumber : Null ;
            searchInfo.subject.Flying_Blue_Number__pc = string.isNotBlank(strFlying_BlueNumber)  ? strFlying_BlueNumber : Null ;
            search();
           */
            //End by Sandesh_4262017
        }
        
        private contactDetailWrapper getSearchResults( String myIndex)
        {
            contactDetailWrapper rval = null;
            if (myIndex == null) return rval;
            if (skymilesResults.keyset().contains(myIndex))     return skymilesResults.get(myIndex);
            if (fBlueResults.keyset().contains(myIndex))        return fBlueResults.get(myIndex);
            if (salesforceResults.keyset().contains(myIndex))   return salesforceResults.get(myIndex);
            if (ticketResults.keyset().contains(myIndex))       return ticketResults.get(myIndex);
            if (pnrResults.keyset().contains(myIndex))          return pnrResults.get(myIndex);
            if (pnrHistorical.keyset().contains(myIndex))       return pnrHistorical.get(myIndex);
            return rval;
        }
        
        //Added by Sandesh_4262017
        public String strfname,strLname,strPersonMailingCity,strPersonMailingState,strPersonMailingPostalCode,strpersonEmail,strphone,strSkyMilesNumber,strFlying_BlueNumber;
        
        public void AcceptContactforCreate() // merges the search result into the search information in prep for saving
        {      
           
            //Added by Sandesh_4262017
            /*
            strfname = string.isNotBlank(searchInfo.fname) ? searchInfo.fname : '';
            strLname = string.isNotBlank(searchInfo.lname) ? searchInfo.lname : '';
            strPersonMailingCity = string.isNotBlank(searchInfo.subject.PersonMailingCity) ? searchInfo.subject.PersonMailingCity : '';
            
            System.debug('strPersonMailingCity-sandesh' + searchInfo.subject.PersonMailingCity + '-Fname-' + searchInfo.fname + '-LName' +  searchInfo.lname);
            strPersonMailingState = string.isNotBlank(searchInfo.subject.PersonMailingState) ? searchInfo.subject.PersonMailingState : '';
            strPersonMailingPostalCode = string.isNotBlank(searchInfo.subject.PersonMailingPostalCode) ? searchInfo.subject.PersonMailingPostalCode : '';
            strpersonEmail = string.isNotBlank(searchInfo.subject.personEmail) ? searchInfo.subject.personEmail : '';
            strphone = string.isNotBlank(searchInfo.subject.phone) ? searchInfo.subject.phone : '';
            strSkyMilesNumber = string.isNotBlank(searchInfo.subject.SkyMiles_Number__pc) ? searchInfo.subject.SkyMiles_Number__pc : '';
            strFlying_BlueNumber = string.isNotBlank(searchInfo.subject.Flying_Blue_Number__pc) ? searchInfo.subject.Flying_Blue_Number__pc : '';
            */
            //End by Sandesh_4262017
           
            // This function is called by the select action in the search results of the CreateContact page
            if (nextSelected == null || controller == null ) return;
            contactDetailWrapper oldFound;
            contactDetailWrapper found;
            if (selected != null) oldFound = getSearchResults( selected );
            found = getSearchResults( nextSelected );
            
            if (found == null) return;
            found.IamSelected = true;
            if (oldFound != null) oldFound.IamSelected = false;
            controller.showAccountPanel = true;   
            controller.relatedContactsMap = new Map<String,contactDetailWrapper>(); // this list should always be empty for the create page
            controller.relatedContactsMap.put(nextSelected, found);  // because this function is only used by the create contact page
            searchInfo.fname = found.subject.FirstName;
            searchInfo.lname = found.subject.LastName;
            searchInfo.updateInformation(found); // this puts the search result information into the panel
            
            if (found.possibleAccts == null) found.possibleAccts = new AccountListWrapper(found, controller);
            found.possibleAccts.createLists();
            
            // to support the create contacts page
            if (searchInfo.possibleAccts == null) searchInfo.possibleAccts = new AccountListWrapper(searchInfo, controller);  
            searchInfo.possibleAccts.createLists();
            
            selected = nextSelected;
            
            createContact();
            found.subject = transferAccountId;
            system.debug('id found --> '+found.subject.id);
            clearSearch();
            
        
        }
        
        public void AcceptContact()  // moves the selected wrapper into the Related Contacts List
        {
            
            if (selected == null || controller == null || controller.relatedContactsMap == null ) return;
            contactDetailWrapper found = getSearchResults(selected);
            
            if (found == null) return;
            found.IamSelected = true;
            // TODO : this and the controller addContact do the same thing, could call the same static function?
            if (controller.mode != 'Search'  && controller.topPanelMode != 'CaseContactNoCase')
            {
                controller.relatedContactsMap.put(selected, found);
                if (controller.relatedContactsMap.size() == 1) // this lonely contact becomes the prmary
                {
                    controller.primary = found.searchIndex; 
                    found.primary = true;
                }
            }
            
            found.possibleAccts = new AccountListWrapper(found, controller);
            if (found.possibleAccts != null) found.possibleAccts.createLists();
        }
        
       
        
        public Map<String,String> makePNRCallout()  
        {
            System.debug('Sandesh-Phone Call--makePNRCallout');
            Map<String,String> returnSet = new Map<String,String>(); // key is Skymiles Number, value is Flying Blue
            system.debug('pnr number --> '+searchInfo.PNR);
            if (searchInfo == null || searchInfo.PNR == null  || searchInfo.PNR == '') return returnSet;
            system.debug('inside loop');
            PNR.Lookup aPnr = new PNR.Lookup();
            
            if (aPnr == null) return returnSet;
            PNR.MemberInformation found = Test.isRunningTest() ? null : aPnr.find(searchInfo.PNR);
            
            if (found == null || found.travelers == null || found.travelers.isEmpty()) return returnSet;
            
            
            for( String index : found.travelers.keySet() )
            {
                Account member = found.travelers.get(index);
                String ticketNumber = found.Tickets.get(index);
                if (member == null) continue;
                Account usefulContact;
                String wrapperIndex = 'newContact' + commonIndex + (0.1 * localIndex++);
                Skymiles.MemberInformation skymilesResult;
                
                if (member.SkyMiles_Number__pc != null)
                {
                    Skymiles.Lookup theSMsearch = new Skymiles.Lookup();    
                    wrapperIndex = member.SkyMiles_Number__pc;
                    if (member.Flying_Blue_Number__pc != null)
                    {
                        returnSet.put(member.SkyMiles_Number__pc, member.Flying_Blue_Number__pc);
                    }
                    theSMsearch.setSkyMilesNumber(member.SkyMiles_Number__pc);
                    
                    skymilesResult = theSMsearch.find();
                }
                if (skymilesResult != null && skymilesResult.person_acc != null) usefulContact = skymilesResult.person_acc;                
                
                // TODO FlyingBlue.Lookup theFBsearch = new FlyingBlue.Lookup();
                // FlyingBlue.MemberInformation flyingBlueResult;
                if (member.Flying_Blue_Number__pc != null)
                {
                    if (member.SkyMiles_Number__pc == null) wrapperIndex = member.Flying_Blue_Number__pc;
                    Skymiles.FlyingBlueMember fbService = new Skymiles.FlyingBlueMember();
                    SkyMiles.MemberInformation memberInfo = fbService.getMember(member.Flying_Blue_Number__pc);
                    if (memberInfo != null) usefulContact = memberInfo.person_acc;                    
                }
                // TODO for both FlyingBlue and Skymiles, non Contact information like email and gender are being dropped
                
                Ticketing.Lookup tck = new Ticketing.Lookup();
                Ticketing.MemberInformation tckMember = tck.find(ticketNumber); // TODO may need to use LastNameNumber
                if (tckMember != null && tckMember.person_acc != null )
                {
                    if (usefulContact == null) usefulContact = tckMember.person_acc;
                    else
                    {
                        if ( usefulContact.FirstName == null) 
                            usefulContact.FirstName = tckMember.person_acc.FirstName;
                        if ( usefulContact.MiddleName == null) usefulContact.MiddleName = tckMember.person_acc.MiddleName;
                        if ( usefulContact.LastName == null) usefulContact.LastName = tckMember.person_acc.LastName;
                        if ( usefulContact.Salutation == null) usefulContact.Salutation = tckMember.person_acc.Salutation;
                        if ( usefulContact.Suffix == null)  usefulContact.Suffix = tckMember.person_acc.Suffix;
                        if ( usefulContact.SkyMiles_Number__pc == null)  usefulContact.SkyMiles_Number__pc = tckMember.person_acc.SkyMiles_Number__pc;
                        if ( usefulContact.Flying_Blue_Number__pc == null)  usefulContact.Flying_Blue_Number__pc = tckMember.person_acc.Flying_Blue_Number__pc;
                    }
                }
                
                if (usefulContact != null) 
                {
                    if ( member.FirstName == null) member.FirstName = usefulContact.FirstName;
                    if ( member.MiddleName == null) member.MiddleName = usefulContact.MiddleName;
                    if ( member.LastName == null) member.LastName = usefulContact.LastName;
                    if ( member.Salutation == null) member.Salutation = usefulContact.Salutation;
                    if ( member.Suffix == null)  member.Suffix = usefulContact.Suffix;
                    if ( member.SkyMiles_Number__pc == null)  member.SkyMiles_Number__pc = usefulContact.SkyMiles_Number__pc;
                    if ( member.Flying_Blue_Number__pc == null)  member.Flying_Blue_Number__pc = usefulContact.Flying_Blue_Number__pc;
                }
                
                contactDetailWrapper theWrapper = new contactDetailWrapper(controller, wrapperIndex);
                theWrapper.updateContact( member );
                theWrapper.TicketNumber = ticketNumber; // TODO may need to use LastNameNumber
                theWrapper.PNR = found.PNR;
                
                pnrResults.put(wrapperIndex, theWrapper);
                theWrapper.source = 'PNR';
            }
            return returnSet;
        }
        
        public Map<String,String> makeTicketingCallout()
        {
            Map<String,String> returnSet = new Map<String,String>(); // key is Skymiles Number, value is Flying Blue
            system.debug('searchInfo.TicketNumber' + searchInfo.TicketNumber);
            if (searchInfo.TicketNumber == null || searchInfo.TicketNumber == '') return returnSet;
            
            Ticketing.Lookup tck = new Ticketing.Lookup();
            Ticketing.MemberInformation result = Test.isRunningTest() ?
                new Ticketing.MemberInformation() :
            tck.find(searchInfo.TicketNumber);
            if (result == null || result.Person_acc == null) return returnSet;
            String searchContactIndex = 'newContact' + commonIndex + (0.1 * localIndex++);
            contactDetailWrapper theWrapper = new contactDetailWrapper(controller, searchContactIndex);
            theWrapper.updateContact( result.Person_acc );
            if (result.Person_acc.SkyMiles_Number__pc != null) 
            {
                searchContactIndex = result.Person_acc.SkyMiles_Number__pc;
                if (result.Person_acc.Flying_Blue_Number__pc != null) returnSet.put(searchContactIndex,result.Person_acc.Flying_Blue_Number__pc);
            }
            theWrapper.TicketNumber = result.TicketNumber;
            //String myIndex = 'newContact' + searchContactIndex;
            ticketResults.put(searchContactIndex, theWrapper);
            theWrapper.source = 'TKT';
            if (theWrapper.subject.SkyMiles_Number__pc != null) returnSet.put(theWrapper.subject.SkyMiles_Number__pc,searchContactIndex); 
            return returnSet;     
        }
        
        public Map<String,String> makeLoyaltyCallout(Set<String> excluded)
        { 
            System.Debug('makeLoyaltyCallout excluded: '+ excluded);
            Map<String,String> returnSet = new Map<String,String>(); // key is Loyalty Number, value is index
            
            if ((searchInfo.subject.SkyMiles_Number__pc != null && searchInfo.subject.SkyMiles_Number__pc != '') ||
                (searchInfo.subject.Flying_Blue_Number__pc != null && searchInfo.subject.Flying_Blue_Number__pc != ''))
            {
                System.Debug('search with SM number --> '+searchInfo.subject.SkyMiles_Number__pc);
                List<String> SkymilesNumbers = CWString.toList(CWString.split(searchInfo.subject.SkyMiles_Number__pc));
                for( String aNumber : SkyMilesNumbers)
                {
                    if (excluded.contains(aNumber)) continue;
                    Skymiles.Lookup theSearch = new Skymiles.Lookup();
                    theSearch.setSkyMilesNumber(aNumber);
                    Skymiles.MemberInformation result = Test.isRunningTest() ?
                        null :
                    theSearch.find();
                    system.debug('Check for loyalty address'+theSearch);
                    system.debug('checkForAddress'+result);
                    if (result == null || result.person_acc == null) continue;
                    contactDetailWrapper theWrapper = new contactDetailWrapper(controller, aNumber);
                    result.person_acc.SkyMiles_Number__pc = aNumber;
                    theWrapper.updateContact( result.person_acc );
                    theWrapper.setSearchAddress(result.addresses == null || result.addresses.isEmpty() ? null : result.addresses[0].person_acc);
                    theWrapper.setSearchGender(result.person_acc == null ? null : result.person_acc);
                    if((result.emails.size() > 0) &&  (result.emails[0].person_acc.PersonEmail != null))
                    {
                        theWrapper.searchEmail = result.emails[0].person_acc.PersonEmail;
                        theWrapper.subject.personEmail = result.emails[0].person_acc.PersonEmail;
                    }
                    //start
                    if((result.phones.size() > 0) && (result.phones[0].person_acc.Phone != null)){
                        theWrapper.searchPhone = result.phones[0].person_acc.Phone;
                        theWrapper.subject.phone = result.phones[0].person_acc.Phone;
                    }
                    //end
                    
                    skymilesResults.put(aNumber, theWrapper);
                    theWrapper.source = 'SM';
                    //                    if (theWrapper.subject.Flying_Blue_Number__pc != null) returnSet.put(aNumber, theWrapper.subject.Flying_Blue_Number__pc); 
                    returnSet.put(aNumber, theWrapper.subject.Flying_Blue_Number__pc); 
                }
                List<String> FlyingBlueNumbers = CWString.toList(CWString.split(searchInfo.subject.Flying_Blue_Number__pc));
                system.debug('loyaltynumbers are'+ FlyingBlueNumbers.size());
                for( String aNumber : FlyingBlueNumbers)
                {
                    system.debug('before continue --> '+aNumber);
                    if (excluded.contains(aNumber)) continue;
                    system.debug('After continue');
                    Skymiles.FlyingBlueMember fbmember = new Skymiles.FlyingBlueMember();
                    SkyMiles.MemberInformation memberInfo = fbmember.getMember(aNumber);
                    system.debug('fb# Response is'+memberInfo );
                    if (memberInfo == null) continue;
                    contactDetailWrapper theWrapper = new contactDetailWrapper(controller, aNumber);
                    memberInfo.person_acc.Flying_Blue_Number__pc = aNumber;
                    system.debug('address info --> '+memberInfo);
                    
                    theWrapper.updateContact( memberInfo.person_acc );
                    theWrapper.setSearchAddress(memberInfo.addresses == null || memberInfo.addresses.isEmpty() ? null : memberInfo.addresses[0].person_acc);
                    theWrapper.setSearchGender(memberInfo.person_acc == null ? null : memberInfo.person_acc);
                    if((memberInfo.emails[0].person_acc.PersonEmail != null)&&(memberInfo.emails.size()>0))
                    {
                        theWrapper.searchEmail = memberInfo.emails[0].person_acc.PersonEmail;
                        theWrapper.subject.personEmail = memberInfo.emails[0].person_acc.PersonEmail;
                    }
                    if((memberInfo.phones[0].person_acc.Phone != null)&&(memberInfo.phones.size()>0)){
                        theWrapper.searchPhone = memberInfo.phones[0].person_acc.Phone;
                        theWrapper.subject.phone = memberInfo.phones[0].person_acc.Phone;
                    }
                    if(memberInfo.person_acc != null)
                    {
                        if(memberInfo.person_acc.Lifetime_Miles__pc != null)theWrapper.subject.Lifetime_Miles__pc = memberInfo.person_acc.Lifetime_Miles__pc;
                        if(memberInfo.person_acc.X360_Customer__pc != null)theWrapper.subject.X360_Customer__pc = memberInfo.person_acc.X360_Customer__pc;
                        /*if(memberInfo.person_acc.X360_Customer__pc != null){
                          if(memberInfo.person_acc.X360_Customer__pc.tolowercase() =='yes')
                           theWrapper.subject.X360_Customer__pc ='360';
                          else
                           theWrapper.subject.X360_Customer__pc = 'No';
                        }*/
                    }
                    skymilesResults.put(aNumber, theWrapper);
                    theWrapper.source = 'FB';
                    //                    if (theWrapper.subject.SkyMiles_Number__pc != null) returnSet.put(aNumber, theWrapper.subject.SkyMiles_Number__pc);                
                    returnSet.put(aNumber, theWrapper.subject.SkyMiles_Number__pc);
                }
            } 
            else
            {
                System.Debug('search demographics');
                Skymiles.Search theSearch = new Skymiles.Search();
                String safeFirstName = searchInfo.subject.FirstName == null ? null : searchInfo.subject.FirstName.left(9); // TODO this is done in Skymiles?
                theSearch.setFirstName(safeFirstName);
                system.debug('safeFirstName-sandesh-'+ safeFirstName);
                //theSearch.setFirstName('Robert');
                //theSearch.setMiddleName(searchInfo.subject.MiddleName);
                theSearch.setLastName(searchInfo.lname);
              theSearch.setCity('New York'); 
                system.debug('safeNameis'+safeFirstName+searchInfo.subject.LastName);
                system.debug('fnLn'+searchInfo.fname+searchInfo.lname);
                //theSearch.setLastName('Jones');
               if (searchInfo.subject.PersonMailingPostalCode!= null)   // TODO this is done in Skymiles?
                {
                    String safePostalCode = searchInfo.subject.PersonMailingPostalCode;
                    if (safePostalCode.length() != 5)
                    {
                        if (safePostalCode.length() == 9 && !safePostalCode.contains('-')) 
                        {
                            safePostalCode = safePostalCode.left(5) + '-' + safePostalCode.right(4);
                        }
                        if (safePostalCode.length() != 10) safePostalCode = null;
                    }
                    theSearch.setPostalCode(safePostalCode);    
                } 
                
                if (searchInfo.subject.PersonMailingCountry == '' || searchInfo.subject.PersonMailingCountry == null || searchInfo.subject.PersonMailingCountry == 'USA' || searchInfo.subject.PersonMailingCountry == 'United States')
                {
                    theSearch.setCountry('US');
                }
                else theSearch.setCountry(searchInfo.subject.PersonMailingCountry);
                if (searchInfo.subject.PersonMailingState != null && searchInfo.subject.PersonMailingState != '' && searchInfo.subject.PersonMailingState.length() == 2) theSearch.setState( searchInfo.subject.PersonMailingState );
                theSearch.setTicketNumber(searchInfo.TicketNumber);
                system.debug('searchInfo.TicketNumber 2 :-' + searchInfo.TicketNumber);
                //Added by Sandesh 4242017
                if(searchInfo.subject.phone!=null)
                theSearch.setPhone(searchInfo.subject.phone);
                else
                    searchInfo.subject.phone='';
                if(searchInfo.subject.personemail!=null)
                theSearch.setEmail(searchInfo.subject.personemail);
                else
                    searchInfo.subject.personemail='';
                system.debug('sandesh searchInfo.Phone :-' + searchInfo.subject.phone);
                system.debug('sandesh searchInfo.Email  :-' + searchInfo.subject.personemail);
                //End by Sandesh 4242017
                //modified by Daniel Llewellyn 7/16/2016 to allow for maximum results per search.
                List<Skymiles.MemberInformation> results = new List<Skymiles.MemberInformation>();
                //  commented by venkata
                system.debug('Limits.getCallouts() :-' + Limits.getCallouts());
                system.debug('Limits.getLimitCallouts() :- ' + Limits.getLimitCallouts());
                system.debug('results.size() :-' + results.size());
system.debug('SkyFinderUtils.searchReturnLimit  :- '  +SkyFinderUtils.searchReturnLimit);            
                while(theSearch.hasMore && !Test.isRunningTest() && results.size() <= SkyFinderUtils.searchReturnLimit && Limits.getCallouts() < Limits.getLimitCallouts())
                {
                     system.debug('fetching callout'+theSearch);
                    List<Skymiles.MemberInformation> nextBatch = theSearch.find();
                    system.debug('next batch value --> '+nextBatch);
                    if(nextBatch != null) {
                        //  system.debug('\n\n\n\n------------------------------ Got next search result batch of size ' + nextBatch.size());
                        system.debug(nextBatch);
                        results.addAll(nextBatch); 
                        
                    }
                    else{
                        //         system.debug('\n\n\n\n------------------------------ No more results. Breaking search loop');
                        break;
                    }    
                    
                    
                }
                
                //  system.debug('\n\n\n\n------------------------------ Result list size is: ' + results.size());
                
                if (results == null) return returnSet;
                
                for (Skymiles.MemberInformation result : results) 
                {
                    String searchContactIndex = 'newContact' + commonIndex + (0.1 * localIndex++);
                    contactDetailWrapper theWrapper = new contactDetailWrapper(controller, searchContactIndex);
                    if (result == null || result.Person_acc == null) continue;  // likely a status 500 situation
                    theWrapper.updateContact( result.Person_acc );
                    
                    theWrapper.setSearchGender(result.Person_acc);
                    theWrapper.setSearchAddress(result.addresses == null || result.addresses.isEmpty() ? null : result.addresses[0]);
                    theWrapper.setSearchPhone(result.phones == null || result.phones.isEmpty() ? null : result.phones[0]);
                    theWrapper.setSearchEmail(result.emails == null || result.emails.isEmpty() ? null : result.emails[0]);
                    //Added by sandesh-10-Apr-2017
                    // System.Debug('Email: '+ result.emails);
                    
                    theWrapper.source = 'SM';
                    //                    if (result.Flying_Blue_Number__pc != null) returnSet.put(result.SkyMiles_Number__pc, result.Flying_Blue_Number__pc);
                    returnSet.put(result.Person_acc.SkyMiles_Number__pc, result.Person_acc.Flying_Blue_Number__pc);
                    if (result.Person_acc.Flying_Blue_Number__pc != null) searchContactIndex = result.Person_acc.Flying_Blue_Number__pc;
                    if (result.Person_acc.SkyMiles_Number__pc != null) searchContactIndex = result.Person_acc.SkyMiles_Number__pc;
                    theWrapper.searchIndex = searchContactIndex;
                    
                    
                    skymilesResults.put(theWrapper.searchIndex, theWrapper);
                    //  system.debug('json of thewrapper ::  '+JSON.serialize(theWrapper) );
                    
                } 
                system.debug('the Wrapper value total is'+skymilesResults.values());
            }
            string mapObj = JSON.serialize(returnSet);
            system.debug('the wrapperis: '+mapObj );
            return returnSet;           
        }       
        
        public void search()
        {
            hideShowMessageOverride = false;
            string sortOrder = 'desc';
            /*Start added by Anil for PHX 846*/
            if((searchInfo.fname !=null && searchInfo.fname !='') && (searchInfo.lname ==null || searchInfo.lname ==''))
            {
                controller.addErrorMessages('Search Error!', 'Please enter Last Name');                 
                 return;
             }
             else if((searchInfo.subject.PersonMailingState !=null && searchInfo.subject.PersonMailingState!='') && (searchInfo.lname ==null || searchInfo.lname ==''))
              {
                  controller.addErrorMessages('Search Error!', 'Please enter Last Name');                 
                  return; 
             }
            /*End added by Anil for PHX 846*/                                                                
            

            controller.clearCreatedContact();
            clearResults();  // design decision was made to clear previous results before each search
            
            
            //Added by HTL-Sandesh-26042017
            system.debug('Fname-' + searchInfo.fname + 'LName-' + searchInfo.lname);
            
            if(searchInfo.lname != null)searchInfo.subject.lastName = searchInfo.lname;
            if(searchInfo.fname != null)searchInfo.subject.FirstName = searchInfo.fname;
            Set<String> LoyaltyNumbers = new Set<String>();
            system.debug('check value');
            Map<String,String> foundLoyalty =  makePNRCallout();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values());
            LoyaltyNumbers.addAll(pnrResults.keyset());
            System.Debug('search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + pnrResults.keyset().size());
            Map<String,Account> found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            
            SkyFinderUtils.replaceWithQueriedContact( found, pnrResults);
            
            foundLoyalty = makeTicketingCallout();    // PNR makes the ticketing callout for its result
            LoyaltyNumbers = new Set<String>();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values()); 
            LoyaltyNumbers.addAll(ticketResults.keyset());
            System.Debug('Loyalty search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + ticketResults.keyset().size());
            found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            SkyFinderUtils.replaceWithQueriedContact( found, ticketResults);
            
            foundLoyalty = makeLoyaltyCallout(foundLoyalty.keyset());
            LoyaltyNumbers = new Set<String>();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values());
            LoyaltyNumbers.addAll(skymilesResults.keyset());
            System.Debug('Sky Miles search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + skymilesResults.keyset().size());
            System.Debug('skymilesResults-' +skymilesResults);
            found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            SkyFinderUtils.replaceWithQueriedContact( found, skymilesResults);
            
            

            /*Code updated by Anil*/
            CWQuery searchQuery = searchInfo.querySalesforce2(null,SortCol,sortOrder); //CWQuery searchQuery = searchInfo.querySalesforce(null); 
           
           
            
            system.debug('SOQL Query is---  ' + searchQuery );
            if (searchQuery != null)
            {
                List<Account> results = (List<Account>)searchQuery.query();
                for( Account aResult : results )
                {
                    
                    String searchContactIndex = String.valueOf(aResult.Id);
                    salesforceResults.put(searchContactIndex, new contactDetailWrapper(controller, aResult, null, null, searchContactIndex)); 
                }
                
                system.debug('salesforceResults MAP iS::::::: ' + salesforceResults);
                
            } 
            
            messageBody = messageHdr = null;
            // TODO - put in support for service timeout or non search criteria related error
            if (searchResultsList == null || searchResultsList.isEmpty()) 
            {
                messageHdr = 'No Results Found';
                messageBody = 'No results match your search criteria, Please create a Customer record manually'; 
            }
            else
            {
            //Added below code HTL_sandesh For 1332 
            clearSearch();
            }
            
            system.debug('searchResultsList.size()' + searchResultsList.size());
            
              //searchresults.sort('phone');
            //Daniel Llewellyn - 6/15/2016
            
            /* if (searchResultsList != null && searchResultsList.size() >= SkyFinderUtils.searchReturnLimit)   
//if (searchResultsList == null)
{
messageHdr = 'Too Many Results';
messageBody = 'Please refine your search and try again.';
}  */    
            searched = true;  
            //searchResultsList.sort();// add by prashant
            List<ContactDetailWrapper> ss=searchResultsList;
            ss.sort();
            
            pagingControl = new SkyFinderUtils.pagingStruct( 'Result', ss);   
           
        }
        
    
        
        public void searchme(string mySortCol,string sortOrder)
        {
            hideShowMessageOverride = false;
            /*Start added by Anil for PHX 846*/
            if((searchInfo.fname !=null && searchInfo.fname !='') && (searchInfo.lname ==null || searchInfo.lname ==''))
            {
                controller.addErrorMessages('Search Error!', 'Please enter Last Name');                 
                 return;
             }
             else if((searchInfo.subject.PersonMailingState !=null && searchInfo.subject.PersonMailingState!='') && (searchInfo.lname ==null || searchInfo.lname ==''))
              {
                  controller.addErrorMessages('Search Error!', 'Please enter Last Name');                 
                  return; 
             }
            /*End added by Anil for PHX 846*/                                                                
            

            
            controller.clearCreatedContact();
            clearResults();   // design decision was made to clear previous results before each search
            //Added by HTL-Sandesh-26042017
            system.debug('Fname-' + searchInfo.fname + 'LName-' + searchInfo.lname);
            
            if(searchInfo.lname != null)searchInfo.subject.lastName = searchInfo.lname;
            if(searchInfo.fname != null)searchInfo.subject.FirstName = searchInfo.fname;
            Set<String> LoyaltyNumbers = new Set<String>();
            system.debug('check value');
            Map<String,String> foundLoyalty =  makePNRCallout();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values());
            LoyaltyNumbers.addAll(pnrResults.keyset());
            System.Debug('search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + pnrResults.keyset().size());
            Map<String,Account> found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            
            SkyFinderUtils.replaceWithQueriedContact( found, pnrResults);
            
            foundLoyalty = makeTicketingCallout();    // PNR makes the ticketing callout for its result
            LoyaltyNumbers = new Set<String>();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values()); 
            LoyaltyNumbers.addAll(ticketResults.keyset());
            System.Debug('Loyalty search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + ticketResults.keyset().size());
            found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            SkyFinderUtils.replaceWithQueriedContact( found, ticketResults);
            
            foundLoyalty = makeLoyaltyCallout(foundLoyalty.keyset());
            LoyaltyNumbers = new Set<String>();
            LoyaltyNumbers.addAll(foundLoyalty.keyset()); //LoyaltyNumbers.addAll(foundLoyalty.values());
            LoyaltyNumbers.addAll(skymilesResults.keyset());
            System.Debug('Sky Miles search count : ' + LoyaltyNumbers.size() + foundLoyalty.size() + skymilesResults.keyset().size());
            found = SkyFinderUtils.queryForMatchingContact( LoyaltyNumbers );
            
            
            SkyFinderUtils.replaceWithQueriedContact( found, skymilesResults);
            
            //SortCol='PersonMailingCity';
            CWQuery searchQuery = searchInfo.querySalesforce2(null,mySortCol,sortOrder);
           
           
            
            system.debug('SOQL Query is---  ' + searchQuery );
            if (searchQuery != null)
            {
                
                List<Account> results = (List<Account>)searchQuery.query();
                for( Account aResult : results )
                {
                    
                    String searchContactIndex = String.valueOf(aResult.Id);
                    salesforceResults.put(searchContactIndex, new contactDetailWrapper(controller, aResult, null, null, searchContactIndex)); 
                }
                
                system.debug('salesforceResults MAP iS::::::: ' + salesforceResults);
                
            } 
            
            messageBody = messageHdr = null;
            // TODO - put in support for service timeout or non search criteria related error
            if (searchResultsList == null || searchResultsList.isEmpty()) 
            {
                messageHdr = 'No Results Found';
                messageBody = 'No results match your search criteria, Please create a Customer record manually'; 
            }

            searched = true;  
            pagingControl = new SkyFinderUtils.pagingStruct( 'Result', searchResultsList); 
            
            
        }
        
    }
    
    
    
    //Not sure if this will be used as we will work with social account
    public class houseHoldAcctWrapper
    {
        public Account                 nameSource      { get; set; }
        public String                  accountName     { get; set; }
        public Account                 household       { get; set; }    // the account whose primary contact is the namesource
        public ID                      accountID       { get; set; }    // the account that the Contact (namesource) looks up to   
        public set<ID>                 contactMembers  
        {
            get
            {
                if (contactMembers == null) contactMembers = new set<ID>();
                return contactMembers; 
            }
            private set;
        } 
        
        public houseHoldAcctWrapper( String acctName, Account theContact )
        {
            accountName = acctName;
            nameSource = theContact;
            if(nameSource != null && nameSource.ID != null) accountID = nameSource.ID;
        }
        
        public houseHoldAcctWrapper( String acctName, Id acctID )
        {
            accountID = acctID;
            accountName = acctName;
        }         
        
        public void addContactMember( Account aMember )
        {
            if (aMember == null || aMember.Id == null) return;
            contactMembers.add(aMember.Id);
        }
        
        public void setAccount( Account acct )
        {
            if (acct == null) return;
            this.household = acct;
        }
        
        public Boolean setPrimary()
        {
            if (this.household == null || this.household.id == null || nameSource == null || nameSource.Id == null) return false;
            if (nameSource.ID != null && nameSource.ID != this.household.id)
            {
                // We have a potential lookup filter validation error, because the contact that created this account
                //   was set by the user to look up to a different account
                if (!contactMembers.isEmpty()) // choose a different contact as the primary contact
                {
                    this.household.Primary_Contact__c = (new List<Id>(contactMembers))[0];
                    return true;
                }
                return false;  
            }
            
            this.household.Primary_Contact__c = nameSource.Id;
            accountID = nameSource.ID = this.household.id;
            return true;
        }
    }
    
    
    
    //Code added for redirection -- vinay 6th
    public pagereference contactRedirect()
    {
        string IdValue = string.valueof(System.currentPageReference().getParameters().get('contactId'));
        string url = '/'+IdValue ;
        pagereference pageref = new pagereference(url);
        pageref.setRedirect(false);
        return pageref;
        
    }
    
    //code added to clear contact - vinay 7th april
    public void clearCreatedContact()
    {
        createdContactsMap = new Map<String, contactDetailWrapper>();
        createdContactsList = new List<contactDetailWrapper>();
        hasCreatedContacts = false;
    }
    
   
            
     //Added by HTL_Sandesh-4252017
    
    public string ColHeader { get; set; }
    public string ColumnName { get; set; } 
    //Added by HTL_sandesh_4252017
    public string SortFeild { get; set; } 
    public String messageBody                               { get; set; }
    public String messageHdr                                { get; set; }
    
    public SkyFinderUtils.pagingStruct pagingControl        { get; set; }
    public Account subject                  { get; set; }
   
   public String sortDir {
        // To set a Direction either in ascending order or descending order.
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;}
        set;
    } 
    
    public string sortingHeader{get;set;}
    
    //Added by Amol-PHX-27
     public string sortableField{get;set;}
     public string sortOrder{get;set;}
     public string previoussortfield{get;set;}
    
    public void toggleSort()
    {
         
    //List<contactDetailWrapper>  searchResultsList = new List<contactDetailWrapper>(); //commented line kiran
    ColHeader = ApexPages.currentpage().getparameters().get('sortingHeader').trim();
    system.debug('sortDir --> '+sortDir+' '+ColHeader);
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    //System.debug('Togglesort Invoked');
     //ColHeader = ApexPages.currentpage().getparameters().get('ParamVal');
    //System.debug('sandesh-ColHeader' + ColHeader);  
    ColumnName='';  
    if(ColHeader!=null || String.isNotEmpty(ColHeader))
     {
            if(ColHeader=='Last Name')
            ColumnName='subject.LastName';
            else if(ColHeader=='First Name')
            ColumnName='subject.FirstName';
            else if(ColHeader=='Email address')
            ColumnName='searchEmail';   
            else if(ColHeader=='Phone number')
            ColumnName='searchPhone';  
            else if(ColHeader=='SkyMIles number')
            ColumnName='subject.SkyMiles_Number__pc';   
            else if(ColHeader=='FB #')
            ColumnName='subject.Flying_Blue_Number__pc';   
            else if(ColHeader=='Address')
            ColumnName='subject.PersonMailingStreet';   
            else if(ColHeader=='City')
            ColumnName='subject.PersonMailingCity';   
            else if(ColHeader=='State')
            ColumnName='subject.PersonMailingState';   
            else if(ColHeader=='Postal Code')
            ColumnName='subject.PersonMailingPostalCode';
            else if(ColHeader=='Create/View Customer')
            ColumnName='Create/View Customer';
               
            
     }
                
        //system.debug('Before Search + --> '+ColumnName);
       //Added by Amol-PHX-27
         
      /*  if(previoussortfield == sortableField){
            sortorder='desc';
            previoussortfield=null;
        }
        else{
            sortorder='asc';            
            previoussortfield=sortableField;
        }
        System.debug('sortableField:::'+ColumnName);
        System.debug('sortOrder::'+sortDir);
        
        */
       // contactDetailWrapper.sortableField = ColumnName;
       // contactDetailWrapper.sortorder = sortDir;        
       
        
       
       //  searchPanel.searchme(ColumnName,sortDir);

         //system.debug('kiran - ' + searchpanel.searchResultsList.size());       
        // system.debug('kiran - ' + searchpanel.searchResultsList[0].NameLastFirst);
        // searchpanel.searchResultsList.sort();   //modified line kiran 
         //pagingControl = new SkyFinderUtils.pagingStruct( 'Result', searchpanel.searchResultsList); 
        // system.debug('kiran - ' + searchpanel.searchResultsList.size());   
        // system.debug('kiran - ' + searchpanel.searchResultsList[0].NameLastFirst);

        
        //system.debug('After Search --> '+sortDir);
        //sortBy == SORT_BY.ByFirstName;
        if(searchpanel.searchResultsList.size()>0){
         for(ContactDetailWrapper cdw:searchpanel.searchResultsList){
           cdw.SORT_BY= ColumnName;
           cdw.SORT_Dir = sortDir;
           
         }
         //SORT_BY= 'ByLastName';
       //searchpanel.searchResultsList.sort();
       system.debug('after sort' + ColumnName);
         
        List<ContactDetailWrapper> aa= searchpanel.searchResultsList;
        aa.sort();
        searchpanel.searchResultsList=aa;
        
         pagingControl = new SkyFinderUtils.pagingStruct( 'Result', aa);
         searchpanel.pagingControl =pagingControl ;
        }
         
        
     /*
            CWQuery sortQuery = SortSalesforce(null,ColumnName);
            SkyfinderMainController controller;
            System.debug('sandesh-ColumnName' + ColumnName);
            
             if (sortQuery != null)
            {
                List<Account> results = (List<Account>)sortQuery .query();
                for( Account aResult : results )
                {
                    
                    String searchContactIndex = String.valueOf(aResult.Id);
                    salesforceResults.put(searchContactIndex, new contactDetailWrapper(controller, aResult, null, null, searchContactIndex)); 
                }
                
              //  system.debug('salesforceResults MAP iS::::::: ' + salesforceResults);
                
            } 
            
            messageBody = messageHdr = null;
            // TODO - put in support for service timeout or non search criteria related error
            if (searchResultsList == null || searchResultsList.isEmpty()) 
            {
                messageHdr = 'No Results Found';
                messageBody = 'No results match your search criteria, you may create a Account manually'; 
            }
            
            
            //searched = true;  
            pagingControl = new SkyFinderUtils.pagingStruct( 'Result', searchResultsList); 
           */ 
    
    }
        /*
        
         public CWQuery SortSalesforce(Account searchPerson, String SortCol)
        {
           
            if (searchPerson == null) searchPerson = subject;
            
            Integer queryLimit = 10000;     // this is the max in CWQuery
            Schema.sObjectType contactSObjectType  = Account.getSObjectType();
            
            //change field set api name to person account field set api name
            CWQuery query = CWQuery.newQuery( contactSObjectType ).add( 'Id' ).addFieldSet( 'Account_Manager_Search_Fields' );
            //query.add( 'AccountID', new List<String>{'Id', 'Name'} );
            CWQuery.WhereClause whereClause = query.newANDWhereClause('RecordTypeid =' + SkyFinderUtils.passengerContactRecTypeString);// ' + '0120S0000004LRB');
            system.debug('flying blue number --> '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.firstName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.firstName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'FirstName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'FirstName_SoundEx__pc' ) )
                    )
                    .multiLike( 'FirstName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.middleName ) && CWSchema.isField( contactSObjectType, 'MiddleName' ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.MiddleName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'MiddleName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'MiddleName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.lastName ) )
            {
                List<String>        nameStrings     = CWString.toList( CWString.split( searchPerson.lastName ) );
                
                whereClause.newORWhereClause()
                    .isIn
                    (   'LastName_SoundEx__pc',
                     CWSoundex.encode( nameStrings, CWSchema.getFieldLength( contactSObjectType, 'LastName_SoundEx__pc' ) )
                    )
                    .multiLike( 'LastName', nameStrings );
            }
            
            if ( String.isNotBlank( searchPerson.SkyMiles_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'SkyMiles_Number__pc', searchPerson.SkyMiles_Number__pc ) )
            {
                whereClause.add( 'SkyMiles_Number__pc = ' + CWString.quote( searchPerson.SkyMiles_Number__pc ) );
            }
            system.debug('value check --> '+contactSObjectType+' , '+searchPerson.Flying_Blue_Number__pc);
            if ( String.isNotBlank( searchPerson.Flying_Blue_Number__pc ) && CWFormatValidation.isValid( contactSObjectType, 'Flying_Blue_Number__pc', searchPerson.Flying_Blue_Number__pc ) )
            {
                whereClause.add( 'Flying_Blue_Number__pc = ' + CWString.quote( searchPerson.Flying_Blue_Number__pc ) );
            }
            
            if ( String.isNotBlank( searchPerson.personemail ) && CWFormatValidation.isValid( contactSObjectType, 'Email', searchPerson.personemail ) )
            {
                CWQuery.WhereClause emailWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Email )
                    {
                        emailWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.personemail ) );
                    }
                }
            }
            
            if ( String.isNotBlank( searchPerson.phone ) )
            {
                CWQuery.WhereClause phoneWhereClause = whereClause.newORWhereClause();
                for ( String fieldName : contactFields.keySet() )
                {
                    if ( CWSchema.getDescribeFieldResult( contactFields.get( fieldName ) ).getType() == Schema.DisplayType.Phone )
                    {
                        phoneWhereClause.add( fieldName + ' = ' + CWString.quote( searchPerson.phone ) );
                    }
                }
            }
            
            if  (   String.isNotBlank( searchPerson.personMailingCity )
                 ||  String.isNotBlank( searchPerson.personMailingState )
                 ||  String.isNotBlank( searchPerson.personMailingCountry )
                 ||  String.isNotBlank( searchPerson.personMailingPostalCode )
                )
            {
                CWQuery.WhereClause addressWhereClause = whereClause.newORWhereClause();
                //Added by HTL_Sandesh 04192017
                //for ( String address : new List<String>{ 'MailingAddress', 'OtherAddress' } )                
                for ( String address : new List<String>{ 'PersonMailingAddress', 'PersonOtherAddress' } )
                {
                    CWQuery.WhereClause detailsWhereClause = addressWhereClause.newANDWhereClause();
                    if ( String.isNotBlank( searchPerson.personMailingCity       ) ) detailsWhereClause.add( address.replace( 'Address', 'City'       ) + ' = ' + CWString.quote( searchPerson.personMailingCity       ) );
                    if ( String.isNotBlank( searchPerson.personMailingState      ) ) detailsWhereClause.add( address.replace( 'Address', 'State'      ) + ' = ' + CWString.quote( searchPerson.personMailingState      ) );
                    if ( String.isNotBlank( searchPerson.personMailingCountry    ) ) detailsWhereClause.add( address.replace( 'Address', 'Country'    ) + ' = ' + CWString.quote( searchPerson.personMailingCountry    ) );
                    if ( String.isNotBlank( searchPerson.personMailingPostalCode ) ) detailsWhereClause.add( address.replace( 'Address', 'PostalCode' ) + ' = ' + CWString.quote( searchPerson.personMailingPostalCode ) );
                }
            }
            
            CWQuery.WhereClause theWhereClause = query.getWhereClause();
            if (    theWhereClause == null || 
                String.isBlank(theWhereClause.toString()) ||
                theWhereClause.toString() == ('(RecordTypeid = ' + SkyFinderUtils.passengerContactRecTypeString + ')') ) return null; //('(RecordTypeid = ' + '0120S0000004LRB' + ')') ) return null;
                
           if(SortCol != null && string.isNotBlank(SortCol))
            {
            query.orderByDescending(SortCol);
            }
            
            
            return query.setLimit( queryLimit );
        } 
        
        */
        //End HTL_Sandesh-4252017
    
}