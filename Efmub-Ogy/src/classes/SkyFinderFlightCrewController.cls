public class SkyFinderFlightCrewController {
// input properties
	public String EmployeeIdentifier		{ get; set; }
	public List<String> EmployeeColumns 	{ get; set; }
	public employeeWrapper found 			{ get; set; }
	public Boolean hasID					
	{ 
		get { return found == null || found.theContact == null || found.theContact.Id == null ? false : true; } 
		private set;
	}
	public Boolean hasResponse				{ get{ return found == null ? false : true; } set; }
	public Boolean showNothingFound			{ get; set; }
	public Boolean showCreateButton			
	{ 
		get
		{ 
			return (hasResponse && found.theContact != null && found.theContact.id == null) ? true : false;
		} 
		set; 
	}
	public String nothingFoundMsg			{ get{ return 'No Employee Found for ';} private set; }
	private ID EmployeeRecordTypeId;

	// controller
	public SkyFinderFlightCrewController() 
	{
		showNothingFound = false;
		EmployeeRecordTypeId = CWSchema.getRecordTypeId('Contact', 'Employee');
		EmployeeColumns = new List<String>{ 'Name', 'Dept Num' };
	}

	// action functions
	public void clear() { found = null; EmployeeIdentifier = ''; }

	public void makeEmployeeCallout()
	{
        system.debug('EmployeeRecordTypeId--' + EmployeeRecordTypeId);
		if (EmployeeIdentifier == null || EmployeeIdentifier == '' || !EmployeeIdentifier.isNumeric() || EmployeeIdentifier.length() != 9)
		{ 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please enter an Employee Number (9 digits)'));
        	return;
		} 
		
		// search salesforce first
		List<Account> theEmployees = 
		[
			SELECT id, Name, FirstName, LastName, MiddleName, Employee_Member_Id_Number__pc
			FROM Account 
			WHERE Employee_Member_Id_Number__pc = :EmployeeIdentifier AND RecordTypeId = :EmployeeRecordTypeId
			LIMIT 1
		];
		Account subject;
		if (!theEmployees.isEmpty())
		{
			subject = theEmployees[0];
			found = new employeeWrapper(subject, this);
			return;
		}

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
        system.debug('THEDATA--Sandesh' + theData);
	}

	public void createEmployee()
	{
		if (found == null || found.theContact == null || found.theContact.Id != null) return;
		System.debug('found.theContact.Id--' + found.theContact.Id);
		List<Account> deltaAccounts = [SELECT id FROM Account WHERE FASsmBase__c = 'DL' AND RecordType.DeveloperName = 'Entity'];
		if (deltaAccounts.isEmpty())
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Delta Account is missing.  Can not create Employee'));
        	return;			
		}
		Account deltaAccount = deltaAccounts[0];
		//found.theContact.AccountID = deltaAccount.Id;
		found.theContact.ID = deltaAccount.Id;
		found.theContact.RecordTypeId = EmployeeRecordTypeId;
		upsert found.theContact;
	}

	public class employeeWrapper
	{
		public Account 	theContact			{ get; set; }
		public String 	nameLastFirst 		
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

		public String 		FADeptNb 		{ get; set; }

		public employeeWrapper( SOA_Directory.EmployeeInfoType response, SkyFinderFlightCrewController cntrlr )
		{
			//theContact = new Contact(RecordTypeId = cntrlr.EmployeeRecordTypeId);
			theContact = new Account(RecordTypeId = cntrlr.EmployeeRecordTypeId);
			theContact.FirstName = CWString.toTitleCase(response.FirstName);
			theContact.LastName = CWString.toTitleCase(response.LastName);
			theContact.Employee_Member_Id_Number__pc = cntrlr.EmployeeIdentifier; 
			//theContact.FADeptNb__c = FADeptNb = response.DepartmentNumber;
		}

		public employeeWrapper( Account subject, SkyFinderFlightCrewController cntrlr  )
		{
			theContact = subject;
			if (theContact == null || cntrlr == null ) return;
			//FADeptNb = theContact.FADeptNb__c;
		}
	}
}