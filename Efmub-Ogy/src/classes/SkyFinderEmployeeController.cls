/*******************************************************//**

@class      SkyFinderEmployeeController

@brief      

  This class abstracts the information returned from the
  SOA_Employee service.

@author     Janeen Anderson   (LiquidHub.JDA)

@version    2016-05-02  LiquidHub.JDA
  Created.

@see        

  (c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

  This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class SkyFinderEmployeeController 
{
    // input properties
    public String EmployeeIdentifier        { get; set; }
    public List<String> EmployeeColumns     { get; set; }
    public employeeWrapper found            { get; set; }
    public employeeWrapper foundSearched    { get; set; }
    public list<employeeWrapper> crewList   { get; set; }
    public string selectedId                { get; set; }
    public Boolean hasID                    
    { 
        get { return found == null || found.theContact == null || found.theContact.Id == null ? false : true; } 
        private set;
    }
    public Boolean hasResponse              { get{ return found == null ? false : true; } set; }
    public Boolean showNothingFound         { get; set; }
    public Boolean showCreateButton         
    { 
        get
        { 
            return (hasResponse && found.theContact != null && found.theContact.id == null) ? true : false;
        } 
        set; 
    }
    public String nothingFoundMsg           { get{ return 'No Employee Found for ';} private set; }
    private ID EmployeeRecordTypeId;
    public string flightIdValue{get; set;}
    // controller
    public SkyFinderEmployeeController() 
    {
        flightIdValue = '';
        selectedId = '';
        showNothingFound = false;
        flightIdValue = ApexPages.currentPage().getParameters().get('flightId');
        EmployeeRecordTypeId = CWSchema.getRecordTypeId('Account', 'PersonAccount');
        EmployeeColumns = new List<String>{ 'Action','Name', 'Dept Num' };
        crewList = new list<employeeWrapper>();
        searchEmployees();
    }

    // action functions
    public void clear() { found = null; EmployeeIdentifier = ''; }

    public void makeEmployeeCallout()
    {
        if (EmployeeIdentifier == null || EmployeeIdentifier == '' || !EmployeeIdentifier.isNumeric() || EmployeeIdentifier.length() != 9)
        { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please enter an Employee Number (9 digits)'));
            return;
        } 
        
        searchEmployees();
    }
    
    public void searchEmployees()
    {
        // search salesforce first
        list<Account> theEmployees = new list<Account>();
        if(!string.isBlank(EmployeeIdentifier)){
            theEmployees = 
            [
                SELECT id, Name, FirstName, LastName, MiddleName, Employee_Member_Id_Number__pc , FADeptNb__pc
                FROM Account 
                WHERE Employee_Member_Id_Number__pc = :EmployeeIdentifier //AND RecordTypeId = :EmployeeRecordTypeId
                LIMIT 1
            ];
        }
        else{
            set<id> accountId = new set<id>();
            for(Flight_Staff__c fs : [select id,Account__c from Flight_Staff__c where Flight_Leg_Flight_Crew__c = :flightIdValue])
            {
                accountId.add(fs.Account__c);
            }
            if(accountId.size() > 0)
            {
                theEmployees = 
                [
                    SELECT id, Name, FirstName, LastName, MiddleName, Employee_Member_Id_Number__pc , FADeptNb__pc
                    FROM Account 
                    WHERE Id IN :accountId //AND RecordTypeId = :EmployeeRecordTypeId
                    
                ];
            }
            
        }
        
        Account subject;
        if (!theEmployees.isEmpty())
        {
            for(Account acc:theEmployees){
            subject = acc;
            found = new employeeWrapper(subject, this);
            crewList.add(found);
            }
            return;
        }
        if(!string.isBlank(EmployeeIdentifier)){
            SOA_Directory.DirectoryServicePT_EP service = new SOA_Directory.DirectoryServicePT_EP();
            SOA_Directory.RetrieveEmployeeInfoResponse_element response = service.RetrieveEmployeeInfo( EmployeeIdentifier );
            SOA_Directory.EmployeeInfoType theData;
            if (response == null || response.EmployeeInfo == null)
            {
                showNothingFound = true;
                return;
            }
            theData = response.EmployeeInfo;
            found = new employeeWrapper(theData, this);
            
            upsert found.theContact;
            foundSearched = new employeeWrapper(found.theContact, this);
            crewList.add(foundSearched);
        }
    }

    /*public void createEmployee()
    {
        if (found == null || found.theContact == null || found.theContact.Id != null) return;

        List<Account> deltaAccounts = [SELECT id FROM Account WHERE FASsmBase__c = 'DL' AND RecordType.DeveloperName = 'Entity'];
        if (deltaAccounts.isEmpty())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Delta Account is missing.  Can not create Employee'));
            return;         
        }
        Account deltaAccount = deltaAccounts[0];
        found.theContact.AccountID = deltaAccount.Id;
        found.theContact.RecordTypeId = EmployeeRecordTypeId;
        upsert found.theContact;
    }*/

    public class employeeWrapper
    {
        public Account  theContact          { get; set; }
        public String   nameLastFirst       
        { 
            get
            {
                if (nameLastFirst == null)
                {
                    if (theContact == null) nameLastFirst = '';
                    else
                    {
                        nameLastFirst = theContact.LastName;
                        if (nameLastFirst != null && theContact.FirstName != null) nameLastFirst += ', ' + theContact.FirstName;
                        else nameLastFirst = nameLastFirst == null ? theContact.FirstName : nameLastFirst;
                        if (nameLastFirst != null && theContact.MiddleName != null) nameLastFirst += ' ' + theContact.MiddleName;
                        else nameLastFirst = nameLastFirst == null ? theContact.MiddleName : nameLastFirst;
                    }                   
                }
                return nameLastFirst;
            } 
            set; 
        }

        public String       FADeptNb        { get; set; }
        public string personId {get; set;}

        public employeeWrapper( SOA_Directory.EmployeeInfoType response, SkyFinderEmployeeController cntrlr )
        {
            theContact = new Account(RecordTypeId = cntrlr.EmployeeRecordTypeId);
            theContact.FirstName = CWString.toTitleCase(response.FirstName);
            theContact.LastName = CWString.toTitleCase(response.LastName);
            theContact.Employee_Member_Id_Number__pc = cntrlr.EmployeeIdentifier; 
            theContact.FADeptNb__pc = FADeptNb = response.DepartmentNumber;
            theContact.Flight_Crew_from_Apex__c = true;
        }

        public employeeWrapper( Account subject, SkyFinderEmployeeController cntrlr  )
        {
            theContact = subject;
            if (theContact == null || cntrlr == null ) return;
            personId = subject.id;
           // FADeptNb = theContact.FADeptNb__pc;
           FADeptNb = theContact.Employee_Member_Id_Number__pc;
        }
    }
    public void assignRespId()
    {
        system.debug('id check --> '+selectedId);
    }
}