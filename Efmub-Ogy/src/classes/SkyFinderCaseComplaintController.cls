public class SkyFinderCaseComplaintController {

       

    public Id caseId {get;set;}
    
    public String            newComplaintDescription { get; set; }
    public String            newComplaintLocation    { get; set; }
    public String            newFlightLegId          { get; set; }
    public String            newFlightLegAirport     { get; set; }
    public String            complaintCodeId         { get; set; }
    public string            responsiblePerson       { get; set; }
    public Boolean           hasCaseId               { get; set; }
    public String            caseNumber              { get; set; }
    public String            topCaseId               { get; set; }
    public Boolean           hasPnr                  { get; set; }
    public String            pnr                     { get; set; }
    public Boolean           hasContactName          { get; set; }
    public String            contactName             { get; set; }
    public String            contactId               { get; set; }
    public Boolean           hasComplaintCity        { get; set; }
    public String            complaintCity           { get; set; }
    public Boolean           hasSkyMilesNumber       { get; set; }
    public String            skyMilesNumber          { get; set; }
    public Boolean           isDotCase               { get; set; }
    public Boolean           isDisabilityCase        { get; set; }
    public Case_Complaint__c caseComplaint           { get; set; }
    private map<string,string> nameDisplayMap        { get; set; }
    public List<Complaint>   attachedComplaints      { get; set; }
    public Boolean           isSpecialPsrCase        { get; set; }
    public map<string,set<string>> level2Mapping    {get; set;}
    public map<string,set<string>> level3Mapping    {get; set;}
    public map<string,set<string>> level4Mapping    {get; set;}
    public set<string> level1 {get; set;}
    public map<string,id> complantCodeIdMap   {get;set;}
    public string level1Value {get;set;}
    public boolean lev1 {get; set;}
    public boolean lev2 {get;set;}
    public boolean lev3 {get;set;}
    public boolean lev4 {get; set;}
    public string lev5 {get; set;}
    public map<string,string> complaintCodeDescription{get;set;} 
    public map<string,string> codeId{get; set;}
    public string searchType{get;set;}
    public set<string> level2val{get;set;}
    public set<string> level3val{get;set;}
    public set<string> level4val{get;set;}
    public static string flightId{get;set;}
    public string receivedId{get;set;}
    public string flightName{get;set;}
    public string respId {get;set;}
    public string dotDiabilityCode {get; set;}
    public map<string,string> disabilityCodeMap{get;set;}
    
    public list<SelectOption> disabilityCode
    {
        get
        {
            if(disabilityCode != null) return disabilityCode;
            disabilityCode = new list<SelectOption>();
            for(Complaint_Code__c cc : [select id,Display_Name__c,name from Complaint_Code__c where recordtype.developername = 'Dot_Disability' and Level_1__c = 'No Level 1'])
            {
                disabilityCode.add(new SelectOption(cc.id,cc.Name));
            }
            for(Complaint_Code__c cc : [select id,Display_Name__c from Complaint_Code__c where recordtype.developername = 'Dot_Disability' and Level_1__c != 'No Level 1'])
            {
                disabilityCode.add(new SelectOption(cc.id,cc.Display_Name__c));
            }
            return disabilityCode;
        }
        private set;
    }
    public List<SelectOption> airportCodes
    {
        get
        {
            if (airportCodes != null) return airportCodes;
            airportCodes = new List<SelectOption>();
            /*for(Complaint_city__c airportCode : [
                SELECT   Id, FASSMBASE__c,name
                FROM     Complaint_city__c  ORDER BY name limit 1000
               
            ]) {
                airportCodes.add(new SelectOption(airportCode.name+' - '+airportCode.FASSMBASE__c,airportCode.name+' - '+airportCode.FASSMBASE__c));
            }*/
            for(Airport_Code__c airportCode : [
                SELECT   Id, IATA_Code__c, ICAO_Code__c, Full_Name__c, City__c, State__c, Country__c
                FROM     Airport_Code__c
                WHERE    IATA_Code__c != Null AND IATA_Code__c != ''
                ORDER BY IATA_Code__c
            ]) {
                airportCodes.add(new SelectOption(airportCode.IATA_Code__c, airportCode.IATA_Code__c + ' - ' + /* airportCode.ICAO_Code__c + ' - ' + */ airportCode.Full_Name__c + ' - ' + airportCode.City__c + (airportCode.State__c == Null ? '' : ', ' + airportCode.State__c) + ' ' + airportCode.Country__c));
            }
            return airportCodes;
        }
        private set;
    }
    public List<SelectOption> airportCodes1
    {
        get
        {
         //if (airportCodes != null) return airportCodes;
            airportCodes = new List<SelectOption>();
            for(Complaint_city__c airportCode : [
                SELECT   Id, FASSMBASE__c,name
                FROM     Complaint_city__c  ORDER BY name offset 1000
               
            ]) {
                airportCodes.add(new SelectOption(airportCode.name+' - '+airportCode.FASSMBASE__c,airportCode.name+' - '+airportCode.FASSMBASE__c));
            }
            return airportCodes;
        }
        private set;
    }
    
    public boolean displayResp{get; set;}
    public String RType{get; set;}
    // --- core functions --------------------------------------

    public SkyFinderCaseComplaintController() {
        idValue='';
        respId = '';
        dotDiabilityCode = '';
        disabilityCodeMap = new map<string,string>();
        responsiblePerson = '';
        displayPopup = false;
        flightId = '';
        receivedId = '';
        displayResp = false;
        level2val = new set<string>();
        level3val = new set<string>();
        level4val = new set<string>();
        nameDisplayMap = new map<string,string>();
        level2Mapping = new map<string,set<string>>();
        level3Mapping = new map<string,set<string>>();
        level4Mapping = new map<string,set<string>>();
        complaintCodeDescription = new map<string,string>();
        codeId = new map<string,string>();
        level1 = new set<string>();
        searchType = 'searchComplainCode';
        selectedLevel1 = '';
        selectedLevel2 = '';
        selectedLevel3 = '';
        selectedLevel4 = '';
        isDisabilityCase = false;
        level = '';
        selectedValue = '';
        lev2 = false;
        lev3 = false;
        lev4 = false;
        lev5 = 'false';
        isDotCase = false;
        isSpecialPsrCase = false;
        if(!String.isBlank(ApexPages.currentPage().getParameters().get('caseid'))) {
        system.debug('In case loop' + ApexPages.currentPage().getParameters().get('caseid'));
            caseId = ApexPages.currentPage().getParameters().get('caseid');
        }
        if(!String.isBlank(ApexPages.currentPage().getParameters().get('id'))) {
                system.debug('In case loop' + ApexPages.currentPage().getParameters().get('id'));
            caseId = ApexPages.currentPage().getParameters().get('id');
        }
        System.debug('xxx = ' + caseId);
        List<String> recordTypeNamesToInclude = new List<String>();
        if(isSpecialPsrCase) {
            recordTypeNamesToInclude.add('Special PSR');
        } else {
            recordTypeNamesToInclude.add('Delta');
        }
        if(isDotCase) {
            recordTypeNamesToInclude.add('DOT');
        }
        if(isDisabilityCase)
        {
            recordTypeNamesToInclude.add('DOT Disability');
        }
        for(Complaint_Code__c complaintCode : [
            SELECT   Id, Type__c,Name, Level_1__c, Level_2__c, Level_3__c, Level_4__c, Keywords__c, Display_Name__c, Possible_Complaint_Locations__c, Description__c, Disability_Code_Required__c
            FROM     Complaint_Code__c
            WHERE    Active__c = true
            ORDER BY Type__c, Level_1__c
        ]) 
        {
            
            nameDisplayMap.put(complaintCode.Display_Name__c.replaceAll( '\\s+', ''),complaintCode.Name.trim());
        }
        

        hasCaseId         = False;
        hasPnr            = false;
        hasContactName    = False;
        hasComplaintCity  = False;
        hasSkyMilesNumber = False;

        for(Case theCase : [
            SELECT Id,
                   //RecordType.DeveloperName, //commented by anil
                   CaseNumber,
                   PNR__c,
                   Contact.Name,
                   Contact.Id,
                   Complaint_City__c,
                   Contact.SkyMiles_Number__c,recordtype.developername
            FROM   Case
            WHERE  Id = :caseId
        ]) {
            hasCaseId         = true;
            topCaseId         = theCase.Id;
            caseNumber        = theCase.caseNumber;

            hasPnr            = !String.isBlank(theCase.PNR__c);
            pnr               = theCase.PNR__c;

            hasContactName    = !String.isBlank(theCase.Contact.Name);
            contactName       = theCase.Contact.Name;
            contactId         = theCase.Contact.Id;

            hasComplaintCity  = !String.isBlank(theCase.Complaint_City__c);
            complaintCity     = theCase.Complaint_City__c;

            hasSkyMilesNumber = !String.isBlank(theCase.Contact.SkyMiles_Number__c);
            skyMilesNumber    = theCase.Contact.SkyMiles_Number__c;
            
           Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
           if(p.Name == 'DOT Coordinator'){
           isDotCase =true; //isDotCase         = theCase.RecordType.DeveloperName == 'DOT'; //Commented by Anil
           isDisabilityCase = true;
           }
           if(p.Name == 'Disability Coordinator')isDisabilityCase = true;
           if(p.Name == 'Special PSR')isSpecialPsrCase  = true;
           //isSpecialPsrCase  = theCase.RecordType.DeveloperName == 'Special_PSR'?true:false; //Commented by Anil
        }
        
        for(Complaint_Code__c cc : [select id,Display_Name__c from Complaint_Code__c where recordtype.developername = 'Dot_Disability' and Level_1__c != 'No Level 1'])
            {
                disabilityCodeMap.put(cc.Display_Name__c,cc.id);
            }
        for(Complaint_Code__c cc : [select id,Display_Name__c,name from Complaint_Code__c where recordtype.developername = 'Dot_Disability' and Level_1__c = 'No Level 1'])
            {
                disabilityCodeMap.put(cc.name,cc.id);
            }

        caseComplaint = new Case_Complaint__c();
        resetComplaints();
        prepareData();
    }

    public class Complaint {
        public Id       id                     { get; set; }
        public String   complaintDescription   { get; set; }
        public String   complaintId            { get; set; }
        public String   complaintLocation      { get; set; }
        public String   flightLegId            { get; set; }
        public String   flightLegName          { get; set; }
        public String   flightName             { get; set; }
        public String   airport                { get; set; }
        public String   createdBy              { get; set; }
        public String   createdOn              { get; set; }
        public Boolean  canDelete              { get; set; }
        public string   OperatedFlightNumber   { get; set; }
        public string   ComplaintCity          { get; set; }
        public string   responsibleParty       { get; set; }
    }




    public void resetComplaints() {
        Set<Id> flightLegIds = new Set<Id>();
        for(Case_Complaint__c caseComplaint : [
            SELECT Id, Flight_Leg__c
            FROM   Case_Complaint__c
            WHERE  Case__c = :caseId AND Case__c != Null
        ]) {
            flightLegIds.add(caseComplaint.Flight_Leg__c);

            if(isSpecialPsrCase) {
                newFlightLegId = caseComplaint.Flight_Leg__c;
            }
        }

        attachedComplaints = new List<Complaint>();
        for(Case_Complaint__c databaseComplaint : [
            SELECT   Id,
                     Complaint_Code__c,
                     Complaint_Code__r.Display_Name__c,
                     Complaint_Location__c,
                     Flight_Leg__c,
                     Flight_Leg__r.Name,
                     Airport__c,
                     CreatedBy.Name,Complaint_City__c ,Responsible_Party__c,Flight_Leg__r.OperatingFlightNumber__c,Flight_Leg__r.OperatingAirlineCode__c,
                     CreatedDate,
                     Complaint_Code__r.UserRecordAccess.HasReadAccess
            FROM     Case_Complaint__c
            WHERE    Case__c = :caseId AND Case__c != Null AND Complaint_Code__c != Null
            //ORDER BY Flight_Leg__r.ScheduledDepartureTime__c NULLS FIRST //commented by anil            
        ]) {
            Complaint internalComplaint = new Complaint();

            internalComplaint.id                     = databaseComplaint.Id;
            internalComplaint.complaintId            = databaseComplaint.Complaint_Code__c;
            internalComplaint.complaintDescription   = databaseComplaint.Complaint_Code__r.Display_Name__c;
            internalComplaint.complaintLocation      = databaseComplaint.Complaint_Location__c == Null ? '' : databaseComplaint.Complaint_Location__c;
            internalComplaint.flightLegId            = databaseComplaint.Flight_Leg__c;
            internalComplaint.flightLegName          = databaseComplaint.Flight_Leg__r.Name;
            internalComplaint.airport                = databaseComplaint.Airport__c;
            internalComplaint.createdBy              = databaseComplaint.CreatedBy.Name;
            internalComplaint.createdOn              = String.valueOf(databaseComplaint.CreatedDate);
            internalComplaint.canDelete              = databaseComplaint.Complaint_Code__r.UserRecordAccess.HasReadAccess;
            if(!string.isBlank(databaseComplaint.Flight_Leg__r.Name)){
            internalComplaint.OperatedFlightNumber   = databaseComplaint.Flight_Leg__r.OperatingFlightNumber__c == null ? (databaseComplaint.Flight_Leg__r.Name).split(' ')[0] : (databaseComplaint.Flight_Leg__r.OperatingAirlineCode__c+databaseComplaint.Flight_Leg__r.OperatingFlightNumber__c);
            }
            internalComplaint.ComplaintCity          = databaseComplaint.Complaint_City__c;
            internalComplaint.responsibleParty       = databaseComplaint.Responsible_Party__c;

            attachedComplaints.add(internalComplaint);
        }
    }

    // --- get select lists ----------------------------------------------------
    
    public List<List<SelectOption>> getComplaintCodesList2() {
        List<List<SelectOption>> complaintCodesList = new List<List<SelectOption>>();
        if(isSpecialPsrCase) {
            complaintCodesList.add(getComplaintCodes2('Special PSR', ''));
        } else {
            complaintCodesList.add(getComplaintCodes2('Delta',       'AND Level_1__c <  \'Policies\' '));
            complaintCodesList.add(getComplaintCodes2('Delta',       'AND Level_1__c = \'Policies\' '));
            complaintCodesList.add(getComplaintCodes2('Delta',       'AND Level_1__c > \'Policies\' '));
        }
        if(isDotCase) {
            complaintCodesList.add(getComplaintCodes2('DOT',         'AND Level_1__c <  \'Flight Problems\' '));
            complaintCodesList.add(getComplaintCodes2('DOT',         'AND Level_1__c = \'Flight Problems\' '));
            complaintCodesList.add(getComplaintCodes2('DOT',         'AND Level_1__c > \'Flight Problems\' '));
        }
        /*if(isDisabilityCase)
        {
           complaintCodesList.add(getComplaintCodes2('DOT Disability', '')); 
        }
        */
        
        return complaintCodesList;
    }
    
    
    public List<SelectOption> getComplaintCodes2(String type, String condition) {
        List<SelectOption> complaintCodes = new List<SelectOption>();
        system.debug('condition --> '+type+' '+condition);
        for(Complaint_Code__c complaintCode : Database.query(
              'SELECT   Id, Display_Name__c, Possible_Complaint_Locations__c '
            + 'FROM     Complaint_Code__c '
            + 'WHERE    Type__c = \'' + type + '\' ' + condition
            + 'ORDER BY Type__c, Level_1__c, Level_2__c, Level_3__c, Level_4__c'
        )) {
           // Commented by Amol 11052017 - Removed possible complaint location
           // complaintCodes.add(new SelectOption(complaintCode.Id, complaintCode.Display_Name__c + '\n' + (complaintCode.Possible_Complaint_Locations__c == Null ? '' : complaintCode.Possible_Complaint_Locations__c)));
              complaintCodes.add(new SelectOption(complaintCode.Id, complaintCode.Display_Name__c ));
        }

        return complaintCodes;
    }
    
    
    
    public List<SelectOption> getComplaintLocations() {
        List<SelectOption> complaintLocations = new List<SelectOption>();

        complaintLocations.add(new SelectOption('', '-- please select --'));
        //Commented by Anil
        //if(isSpecialPsrCase || isDotCase) {
        if(isSpecialPsrCase) {
        
        }
        else{
            if(!string.isBlank(newComplaintDescription) && (nameDisplayMap.keyset().contains(newComplaintDescription.replaceAll( '\\s+', '')))){
            string nameValue = (string)nameDisplayMap.get(newComplaintDescription.replaceAll( '\\s+', ''));
            system.debug('nameValue --> '+nameValue+ '  '+nameDisplayMap.keyset().size()+'  '+newComplaintDescription);
            list<Complaint_Code__c> complaint = [select id,Type__c from Complaint_Code__c where name = :nameValue.trim()];
            string TypeValue = complaint[0].Type__c;
            if(TypeValue != 'DOT'){
            for(Complaint_Locations__c complaintlocation : [
            SELECT   Name
            FROM     Complaint_Locations__c
            ORDER BY Name
            ]) {
                complaintLocations.add(new SelectOption(complaintlocation.Name.trim(), complaintlocation.Name));
            } 
            }
          }
        }
        // Commented by Amol 11052017 
        
        
        return complaintLocations;
    }

    public List<SelectOption> getFlightLegs() {
        List<SelectOption> flightLegs = new List<SelectOption>();

        flightLegs.add(new SelectOption('', '-- none --'));
        for(Flight_Leg__c flightLeg : [
            SELECT   Id, Name
            FROM     Flight_Leg__c
            WHERE    Id IN (SELECT Flight__c FROM Case_Flight_Detail__c WHERE case__c = :caseId)
            ORDER BY Name
        ]) {
            flightLegs.add(new SelectOption(flightLeg.Id, flightLeg.Name));
        }
        
        return flightLegs;
    }

    public List<SelectOption> getAirportLocations() {
        List<SelectOption> airportLocations = new List<SelectOption>();

        airportLocations.add(new SelectOption('',          '-- none --'));
        airportLocations.add(new SelectOption('Departure', 'Departure'));
        airportLocations.add(new SelectOption('Arrival',   'Arrival'));

        return airportLocations;
    }

    // --- button callbacks ----------------------------------------------------
    
    public PageReference clickAddComplaint() {
        system.debug('newComplaintDescription --> '+newComplaintDescription);
        displayPopup = false;
        if(selectedLevel1 != '' && selectedLevel2 != '' && selectedLevel3 != '' && searchType == 'BrowseCategories'){
            list<Complaint_Code__c> comp = [select id,Display_Name__c from Complaint_Code__c where Level_1__c = :selectedLevel1 and Level_2__c = :selectedLevel2 and Level_3__c = :selectedLevel3];
            newComplaintDescription = comp[0].Display_Name__c;
        }
        if(String.isBlank(newComplaintDescription)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A complaint code is required'));
            return Null;
        }
        if(String.isBlank(caseComplaint.Complaint_City__c))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A complaint city is required'));
            return Null;
        }
        if(String.isBlank(flightName))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A flight is required'));
            return Null;
        }
        list<string> city = caseComplaint.Complaint_City__c.split(' - ');
        system.debug('city check -> '+city[0]);
        list<Airport_Code__c> cc = [select id,name,IATA_Code__c from Airport_Code__c where IATA_Code__c = :city[0]];
        if((cc.size() == 0)||(string.isBlank(caseComplaint.Complaint_City__c)))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The complaint city enter is invalid'));
            return Null;
        }
        if(!nameDisplayMap.keyset().contains(newComplaintDescription.replaceAll( '\\s+', '')))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid complaint code'));
            return Null;
        }
        List<String> keys = newComplaintDescription.split('\\|');
        system.debug('selected Value --> '+Keys+'  '+dotDiabilityCode);
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(keys[1].contains('Special Service') && string.isblank(dotDiabilityCode)&&((profileName == 'DOT Coordinator')||(profileName == 'Disability Coordinator')))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The DOT Disability Code is required'));
            return Null;
        }
        /*List<Complaint_Code__c> codes = [
            SELECT Id, Type__c, Possible_Complaint_Locations__c, Disability_Code_Required__c
            FROM   Complaint_Code__c
            WHERE  Name = :keys[1].trim()
        ];*/
        //code added to create map if empty -- start
        system.debug('checking --> '+nameDisplayMap.keyset());
            
        //code added to create map if empty -- end
        system.debug('newComplaintDescription 2--> '+newComplaintDescription+'abc');
        system.debug('nameDisplayMap size :-   '+ nameDisplayMap.keyset().contains(newComplaintDescription.replaceAll( '\\s+', '')));
        system.debug(' vale check --> '+nameDisplayMap.get(string.valueof(newComplaintDescription.replaceAll( '\\s+', ''))));
        
        for(string str:nameDisplayMap.keyset())
        {system.debug('map check --> '+str);}
        string nameValue = (string)nameDisplayMap.get(newComplaintDescription.replaceAll( '\\s+', ''));
        
        system.debug(' Name value --> '+nameValue);
        
        List<Complaint_Code__c> codes = [
            SELECT Id, Type__c, Possible_Complaint_Locations__c, Disability_Code_Required__c
            FROM   Complaint_Code__c
            WHERE  Name = :nameValue.trim()
        ];
        
        
        /*Start added by anil for PHX 1126*/
        String complaint_code = codes[0].Id;
        
        system.debug('Anil 1--> '+complaint_code);
        system.debug('Anil 2--> '+caseId);
        
        List<Case_Complaint__c> Case_Comp_codes = [
            SELECT Id
            FROM   Case_Complaint__c
            WHERE  Complaint_Code__c  = :complaint_code and Case__c = :caseId
        ];
        
        if(Case_Comp_codes.size() > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Not allowed to Duplicate DOT disability Code to a Case' + newComplaintDescription + '"'));
            return Null;
        }
        /*End */
        
        if(codes.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unknown complaint code "' + newComplaintDescription + '"'));
            return Null;
        }
        if(codes.size() > 1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ambiguous complaint code'));
            return Null;
        }

        /*if(!String.isBlank(codes[0].Possible_Complaint_Locations__c) && String.isBlank(newComplaintLocation)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Complaint location is required for this complaint code'));
            return Null;
        }*/
      /*  if(codes[0].Disability_Code_Required__c && String.isBlank(caseComplaint.Disability_Group__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Disability group is required for this complaint code'));
            return Null;
        }
        if(codes[0].Disability_Code_Required__c && String.isBlank(caseComplaint.Disability_Code__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Disability code is required for this complaint code'));
            return Null;
        }
        if(codes[0].Disability_Code_Required__c && caseComplaint.Disability_Code__c == 'Other' && String.isBlank(caseComplaint.Disability_Code_Other_Reason__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A reason is required for this disability code'));
            return Null;
        }
        */
        if(codes[0].Disability_Code_Required__c && caseComplaint.Complaint_City__c != 'unknown' && String.isBlank(caseComplaint.Complaint_City__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter complaint city'));
            return Null;
        }
        List<Case_Complaint__c> caseComplaintsWithFlightLeg = [
            SELECT Id
            FROM   Case_Complaint__c
            WHERE  Case__c = :caseId AND Flight_Leg__c = :newFlightLegId AND Complaint_Code__c = NULL
        ];
        
        if(caseComplaintsWithFlightLeg.isEmpty()) {
            insert new Case_Complaint__c(
                Case__c                         = caseId,
                Complaint_Code__c               = codes[0].Id,
                Complaint_City__c               = caseComplaint.Complaint_City__c,
                Responsible_Party__c            = caseComplaint.Responsible_Party__c,
                Complaint_Location__c           = newComplaintLocation,
                Flight_Leg__c                   = newFlightLegId,
                Airport__c                      = newFlightLegAirport,
                Cabin_Class__c                  = strCabinClass,
                Operating_Carrier__c            = caseComplaint.Operating_Carrier__c,
                DOT_Disability_Code__c          = string.isblank(dotDiabilityCode) ? null : disabilityCodeMap.get(dotDiabilityCode),
                Disability_Group__c             = codes[0].Disability_Code_Required__c ? caseComplaint.Disability_Group__c : Null,
                Disability_Code__c              = codes[0].Disability_Code_Required__c ? caseComplaint.Disability_Code__c  : Null,
                Disability_Code_Other_Reason__c = codes[0].Disability_Code_Required__c && caseComplaint.Disability_Code__c == 'Other' ? caseComplaint.Disability_Code_Other_Reason__c  : Null
            );
        } else {
            update new Case_Complaint__c(
                Id                              = caseComplaintsWithFlightLeg[0].Id,
                Case__c                         = caseId,
                Complaint_Code__c               = codes[0].Id,
                Complaint_City__c               = caseComplaint.Complaint_City__c,
                Responsible_Party__c            = caseComplaint.Responsible_Party__c,
                Complaint_Location__c           = newComplaintLocation,
                Flight_Leg__c                   = newFlightLegId,
                DOT_Disability_Code__c          = string.isblank(dotDiabilityCode) ? null : disabilityCodeMap.get(dotDiabilityCode),
                Airport__c                      = newFlightLegAirport,
                Cabin_Class__c                  = strCabinClass,
                Operating_Carrier__c            = caseComplaint.Operating_Carrier__c,
                Disability_Group__c             = codes[0].Disability_Code_Required__c ? caseComplaint.Disability_Group__c : Null,
                Disability_Code__c              = codes[0].Disability_Code_Required__c ? caseComplaint.Disability_Code__c  : Null,
                Disability_Code_Other_Reason__c = codes[0].Disability_Code_Required__c && caseComplaint.Disability_Code__c == 'Other' ? caseComplaint.Disability_Code_Other_Reason__c  : Null
            );
        }

        caseComplaint.Disability_Group__c   = Null;
        caseComplaint.Disability_Code__c    = Null;
        caseComplaint.Responsible_Party__c  = Null;
        caseComplaint.Complaint_Location__c = Null;
        caseComplaint.Complaint_City__c = Null;
        caseComplaint.Operating_Carrier__c = Null;
        strCabinClass = null;
        resetComplaints();

        newComplaintDescription = Null;
        newComplaintLocation    = Null;
        newFlightLegId          = Null;
        newFlightLegAirport     = Null;
        receivedId = '';
        flightName = '';
        searchType = 'searchComplainCode';
        responsiblePerson = '';
        dotDiabilityCode = '';
        return Null;
    }

    public PageReference clickResetComplaint() {
        newComplaintDescription = Null;
        newComplaintLocation    = Null;
        newFlightLegId          = Null;
        newFlightLegAirport     = Null;
        responsiblePerson  = '';
        caseComplaint.Operating_Carrier__c = Null;
        strCabinClass = null;
        return Null;
    }

    public PageReference clickRemoveComplaint() {
        displayPopup = false;
        if(String.isBlank(complaintCodeId)) {
            return Null;
        }

        List<Case_Complaint__c> caseComplaintsWithComplaintCodeId = [
            SELECT Id, Flight_Leg__c
            FROM   Case_Complaint__c
            WHERE  Id = :complaintCodeId
        ];
        if(caseComplaintsWithComplaintCodeId.isEmpty()) {
            return Null;
        }
        /*List<Case_Complaint__c> caseComplaintsWithSameFlightLeg = [
            SELECT Id
            FROM   Case_Complaint__c
            WHERE  Case__c = :caseId AND Flight_Leg__c = :caseComplaintsWithComplaintCodeId[0].Flight_Leg__c
        ];

        if(caseComplaintsWithSameFlightLeg.size() == 1) {
            update new Case_Complaint__c(
                Id                    = caseComplaintsWithSameFlightLeg[0].Id,
                Complaint_Code__c     = Null,
                Complaint_City__c     = Null,
                Responsible_Party__c  = Null,
                Complaint_Location__c = Null,
                Airport__c            = Null,
                Disability_Group__c   = Null,
                Disability_Code__c    = Null
            );
        } */
        else {
            delete new Case_Complaint__c (
                Id = complaintCodeId
            );
        }

        caseComplaint.Disability_Group__c   = Null;
        caseComplaint.Disability_Code__c    = Null;
        caseComplaint.Responsible_Party__c  = Null;
        caseComplaint.Complaint_Location__c = Null;
        resetComplaints();

        return Null;
    }

    // --- tree version ------------------------------------------

    public class TreeNode {
        public String         label              { get; set; }
        public String         hover              { get; set; }
        public String         display            { get; set; }
        public String         locations          { get; set; }
        public String         id                 { get; set; }
        public Boolean        isDeltaCode        { get; set; }
        public Boolean        showDisabilityCode { get; set; }
        public integer        HierarchyLevel     { get; set; }
        public List<TreeNode> children           { get; set; }

        public TreeNode(Integer depth, Complaint_Code__c complaintCode) {
            Boolean levelZeroIsBlank   = String.isBlank(complaintCode.Type__c);
            Boolean levelOneIsBlank    = String.isBlank(complaintCode.Level_1__c);
            Boolean levelTwoIsBlank    = String.isBlank(complaintCode.Level_2__c);
            Boolean levelThreeIsBlank  = String.isBlank(complaintCode.Level_3__c);
            Boolean levelFourIsBlank   = String.isBlank(complaintCode.Level_4__c);

            String label = depth == 0 ? complaintCode.Type__c
                         : depth == 1 ? complaintCode.Level_1__c
                         : depth == 2 ? complaintCode.Level_2__c
                         : depth == 3 ? complaintCode.Level_3__c
                         :              complaintCode.Level_4__c;

                         
            HierarchyLevel = depth == 0 ? 0
                         : depth == 1 ? 1
                         : depth == 2 ? 2
                         : depth == 3 ? 3
                         :              4;
            Boolean showHover = depth == 0 ? false
                              : depth == 1 ? (!levelOneIsBlank &&  levelTwoIsBlank &&  levelThreeIsBlank && levelFourIsBlank)
                              : depth == 2 ? (!levelOneIsBlank && !levelTwoIsBlank &&  levelThreeIsBlank && levelFourIsBlank)
                              : depth == 3 ? (!levelOneIsBlank && !levelTwoIsBlank && !levelThreeIsBlank && levelFourIsBlank)
                              :              true;

            this.label              = String.isBlank(label) ? '' : (showHover ? '' : '+ ') + label.escapeHtml4() + (showHover && !String.isBlank(complaintCode.Keywords__c) ? (' | ' + complaintCode.Keywords__c) : '');
            this.hover              = showHover && !String.isBlank(complaintCode.Description__c) ? complaintCode.Description__c.escapeHtml4().replace('\r\n', ' ').replace('\r', ' ').replace('\n', ' ') : Null;
            this.display            = showHover ? complaintCode.Display_Name__c : Null; // escapeHtml4().replace('\r\n', '<br/>')
            this.locations          = complaintCode.Possible_Complaint_Locations__c;
            this.showDisabilityCode = complaintCode.Disability_Code_Required__c;
            this.isDeltaCode        = complaintCode.Type__c == 'Delta';
            this.id                 = id;
            this.children           = new List<TreeNode>();
        }
    }
 
    public String getDataJson() {
        return Json.serialize(getData());
    }

    public List<TreeNode> getData() {
        List<TreeNode> complaintCodes = new List< TreeNode >();

        Complaint_Code__c previous = Null;
        String previousType       = Null;
        String previousLevelOne   = Null;
        String previousLevelTwo   = Null;
        String previousLevelThree = Null;
        String previousLevelFour  = Null;

        TreeNode previousTypeNode       = Null;
        TreeNode previousLevelOneNode   = Null;
        TreeNode previousLevelTwoNode   = Null;
        TreeNode previousLevelThreeNode = Null;
        TreeNode previousLevelFourNode  = Null;

        List<String> recordTypeNamesToInclude = new List<String>();
        if(isSpecialPsrCase) {
            recordTypeNamesToInclude.add('Special PSR');
        } else {
            recordTypeNamesToInclude.add('Delta');
        }
        if(isDotCase) {
            recordTypeNamesToInclude.add('DOT');
        }
        if(isDisabilityCase)
        {
            recordTypeNamesToInclude.add('DOT Disability');
        }

        for(Complaint_Code__c complaintCode : [
            SELECT   Id, Type__c,Name, Level_1__c, Level_2__c, Level_3__c, Level_4__c, Keywords__c, Display_Name__c, Possible_Complaint_Locations__c, Description__c, Disability_Code_Required__c, UserRecordAccess.HasReadAccess
            FROM     Complaint_Code__c
            WHERE    Active__c = true AND Type__c IN :recordTypeNamesToInclude
            ORDER BY Type__c, Level_1__c
        ]) 
        {
            if(complaintCode.Display_Name__c == 'Dot Disability | 146 | Unsatisfactory Information | Vision & Hearing Impaired | | |')
            {
                system.debug('i am there '+ complaintCode.Display_Name__c);
            }
            //nameDisplayMap.put(complaintCode.Display_Name__c,complaintCode.Name);
            
            if(!complaintCode.UserRecordAccess.HasReadAccess) {
                continue;
            }

            if(previousType != complaintCode.Type__c) {
                previousTypeNode = new TreeNode(0, complaintCode);
                complaintCodes.add(previousTypeNode);

                previousLevelOneNode = new TreeNode(1, complaintCode);
                previousTypeNode.children.add(previousLevelOneNode);

                previousLevelTwoNode = new TreeNode(2, complaintCode);
                previousLevelOneNode.children.add(previousLevelTwoNode);

                previousLevelThreeNode = new TreeNode(3, complaintCode);
                previousLevelTwoNode.children.add(previousLevelThreeNode);

                previousLevelFourNode = new TreeNode(4, complaintCode);
                previousLevelThreeNode.children.add(previousLevelFourNode);
            } else if(previousLevelOne != complaintCode.Level_1__c) {
                previousLevelOneNode = new TreeNode(1, complaintCode);
                previousTypeNode.children.add(previousLevelOneNode);

                previousLevelTwoNode = new TreeNode(2, complaintCode);
                previousLevelOneNode.children.add(previousLevelTwoNode);

                previousLevelThreeNode = new TreeNode(3, complaintCode);
                previousLevelTwoNode.children.add(previousLevelThreeNode);

                previousLevelFourNode = new TreeNode(4, complaintCode);
                previousLevelThreeNode.children.add(previousLevelFourNode);
            } else if(previousLevelTwo != complaintCode.Level_2__c) {
                previousLevelTwoNode = new TreeNode(2, complaintCode);
                previousLevelOneNode.children.add(previousLevelTwoNode);

                previousLevelThreeNode = new TreeNode(3, complaintCode);
                previousLevelTwoNode.children.add(previousLevelThreeNode);

                previousLevelFourNode = new TreeNode(4, complaintCode);
                previousLevelThreeNode.children.add(previousLevelFourNode);
            } else if(previousLevelThree != complaintCode.Level_3__c) {
                previousLevelThreeNode = new TreeNode(3, complaintCode);
                previousLevelTwoNode.children.add(previousLevelThreeNode);

                previousLevelFourNode = new TreeNode(4, complaintCode);
                previousLevelThreeNode.children.add(previousLevelFourNode);
            } else {
                previousLevelFourNode = new TreeNode(4, complaintCode);
                previousLevelThreeNode.children.add(previousLevelFourNode);
            }

            previousType       = complaintCode.Type__c;
            previousLevelOne   = complaintCode.Level_1__c;
            previousLevelTwo   = complaintCode.Level_2__c;
            previousLevelThree = complaintCode.Level_3__c;
        }
        
        return complaintCodes;
    }
    //code added - start
    public string level2JSON{get; set;}
    public void prepareData()
    {
        List<String> recordTypeNamesToInclude = new List<String>();
       // map<string,string> level4Description = new map<string,string>();
        if(isSpecialPsrCase) {
            recordTypeNamesToInclude.add('Special PSR');
        } else {
            recordTypeNamesToInclude.add('Delta');
        }
       /* if(isDotCase) {
            recordTypeNamesToInclude.add('DOT');
        }*/
        
        for(Complaint_Code__c complaintCode : [
            SELECT   Id, Name, Type__c, Level_1__c, Level_2__c, Level_3__c, Level_4__c, Keywords__c, Display_Name__c, Possible_Complaint_Locations__c, Description__c, Disability_Code_Required__c, UserRecordAccess.HasReadAccess
            FROM     Complaint_Code__c
            WHERE    Active__c = true AND Type__c IN :recordTypeNamesToInclude ORDER BY Level_1__c])
        {
            level1.add(complaintCode.Level_1__c);
            string keyValue = complaintCode.Level_1__c+' '+complaintCode.Level_2__c+' '+complaintCode.Level_3__c;
            
        }
      
    }
    //code added - end
    public String selectedValue {get; set;}
    public string selectedLevel1{get;set;}
    public string selectedLevel2{get;set;}
    public string selectedLevel3{get;set;}
    public string selectedLevel4{get;set;}
    public string level{get;set;}
    public string description{get;set;}
    public PageReference levelSetting() {
         List<String> recordTypeNamesToInclude = new List<String>();
       // map<string,string> level4Description = new map<string,string>();
        if(isSpecialPsrCase) {
            recordTypeNamesToInclude.add('Special PSR');
        } else {
            recordTypeNamesToInclude.add('Delta');
        }
         description = '';
         if(level == 'level1')
         {
             level2val = new set<string>();
             selectedLevel1 = selectedValue;
             lev5 = 'false';
             lev2=true;
             list<Complaint_Code__c> cc = [select id,Level_2__c from Complaint_Code__c where Level_1__c = :selectedValue AND Active__c = true AND Type__c IN :recordTypeNamesToInclude ORDER BY Level_2__c];
             for(Complaint_Code__c c : cc)
             {
                level2val.add(c.Level_2__c); 
             }
            // if(level2Mapping.get(selectedLevel1).size()>0){
            if(cc.size()>0){
             lev2=true;
             lev3 = false;
             lev4 = false;
             }
           
         }
         if(level == 'level2')
         {
             level3val = new set<string>();
             lev3=false;
             lev5 = 'false';
             selectedLevel2 = selectedValue;
             list<Complaint_Code__c> cc = [select id,Level_3__c from Complaint_Code__c where Level_1__c = :selectedLevel1 and Level_2__c = :selectedLevel2 AND Active__c = true AND Type__c IN :recordTypeNamesToInclude ORDER BY Level_3__c];
             for(Complaint_Code__c c : cc)
             {
                level3val.add(c.Level_3__c); 
             }
             //if(level3Mapping.get(selectedLevel2+' '+selectedLevel1).size()>0){
             if(level3val.size()>0){
             lev3=true;
             lev4 = false;
             }
             
         }
         if(level == 'level3')
         {
             level4val = new set<string>();
             selectedLevel3 = selectedValue;
             list<Complaint_Code__c> cc = [select id,Level_4__c,Description__c from Complaint_Code__c where Level_1__c = :selectedLevel1 and Level_2__c = :selectedLevel2 and Level_3__c = :selectedLevel3 AND Active__c = true AND Type__c IN :recordTypeNamesToInclude ORDER BY Level_4__c];
             for(Complaint_Code__c c : cc)
             {
                if((c.Level_4__c != null) && (c.Level_4__c != ''))level4val.add(c.Level_4__c);
                
                
             }
             lev4=false;
             lev5 = 'false';
             system.debug(level4val + ' '+level4val.size());
             if(level4val.size()>0)
             {
             lev4=true;
             }
             else{
             description = cc[0].Description__c;
             if(description != '')lev5 = 'lev4';
             else{
                lev5 = 'Not True';  
             }
              
             }
            
         }
         
         if(level == 'level4')
         {
             lev5 = 'false';
             list<Complaint_Code__c> cc = [select id,Level_4__c,Description__c from Complaint_Code__c where Level_1__c = :selectedLevel1 and Level_2__c = :selectedLevel2 and Level_3__c = :selectedLevel3 and Level_4__c = :selectedValue AND Active__c = true AND Type__c IN :recordTypeNamesToInclude];
             description = cc[0].Description__c;
             if(description != '')lev5 = 'true';
             else{
                lev5 = 'Not True';  
             }
           
         }
         
        return null;
    }
    
    public void selectCode()
    {
        system.debug(selectedLevel1 + ' '+selectedLevel2 +' '+selectedLevel3);
        list<Complaint_Code__c> comp = [select id,Display_Name__c from Complaint_Code__c where Level_1__c = :selectedLevel1 and Level_2__c = :selectedLevel2 and Level_3__c = :selectedLevel3];
        newComplaintDescription = comp[0].Display_Name__c;
        system.debug('value check --> '+newComplaintDescription);
    }
    
    //Section for popups -- start
    public boolean displayPopup{get;set;}
    public static string idValue{get;set;}
    public void displayPopup(){
        displayPopup = true;
       
    }
    public void assignValue(){
        system.debug('value id check'+receivedId);
        displayPopup=false;
        if(receivedId != 'noValue'){
            Flight_Leg__c fg = [select id,Name from Flight_Leg__c where id = :receivedId];
            flightName = fg.name;
            newFlightLegId = receivedId;
        }
    }
    public void displayResponsible()
    {
        displayResp = true;
    }
    public void assignResponsible()
    {
        system.debug('responsible person check --> '+respId);
        displayResp = false;
        if(respId != 'noValue')
        {
            system.debug('id value --> '+respId);
            list<Account> acc = [select id, name from account where id = :respId];
            caseComplaint.Responsible_Party__c = acc[0].name;
            responsiblePerson = acc[0].name;
        }
    }
 
    public string strCabinClass {get; set;}    
    
    public List<SelectOption> getCabinClass()
    {
        List<SelectOption> CabinClass = new List<SelectOption>();
        CabinClass.add(new SelectOption('', '--None--'));
        system.debug('anil:- ' + caseComplaint.Operating_Carrier__c);
        
        if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '0K' || String.valueOf(caseComplaint.Operating_Carrier__c) ==  '0U')
        {
            CabinClass.add(new SelectOption('First','First'));
            CabinClass.add(new SelectOption('Coach','Coach'));
        }
        
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '2J'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '2M'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '2T'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '2V'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '3D'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '3M'){
    CabinClass.add(new SelectOption('First','First'));
    CabinClass.add(new SelectOption('Coach','Coach'));
}
        
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '4J'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '4L'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '5G'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '5J'){
    CabinClass.add(new SelectOption('First','First'));
    CabinClass.add(new SelectOption('Coach','Coach'));
}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '7H')
{CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '8G'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '8M'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '8U'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9B'){CabinClass.add(new SelectOption('Main Cabin','Main Cabin'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9E'){CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('First','First'));}
        
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9J'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9K'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
        
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9L'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
        
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9N'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9U'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  '9W'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'A3'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'A5'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'A6'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'A7'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'A9'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AB'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AC'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AF'){CabinClass.add(new SelectOption('La Première','La Première'));
                                                                CabinClass.add(new SelectOption('Economy','Economy'));
                                                               }
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AF'){CabinClass.add(new SelectOption('Business','Business'));
                                                                CabinClass.add(new SelectOption('Premium Economy','Premium Economy'));
                                                               }
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AH'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AI'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AM'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AP'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AR'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AS'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AT'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AV'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AY'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'AZ'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'B2'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'B3'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'B6'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'B8'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BD'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BR'){CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BT'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BW'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'BW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CB'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CI'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CM'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CO'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CP'){CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CX'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CY'){CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'CZ'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'D3'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DB'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DJ'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DL'){
    CabinClass.add(new SelectOption('First','First'));
    CabinClass.add(new SelectOption('Main Cabin','Main Cabin'));
    CabinClass.add(new SelectOption('Business','Business'));
    CabinClass.add(new SelectOption('Comfort Plus','Comfort Plus'));
}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DL'){CabinClass.add(new SelectOption('Preferred Paid Seat','Preferred Paid Seat'));
                                                                CabinClass.add(new SelectOption('Basic Economy','Basic Economy'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DPJ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'DY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'E4'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ED'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EI'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EK'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EL'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ET'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EV'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EV'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EW'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'EY'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'F7'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'F8'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'F9'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FB'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FI'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FL'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FV'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'FZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'G3'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'G7'){CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GE'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GF'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GQ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'GX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HM'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HP'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HV'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'HY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IB'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IC'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IG'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IN'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IR'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IT'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'IY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'J2'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'J7'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JE'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JJ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JL'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JL'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JM'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JP'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JU'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'JY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KC'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KE'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KE'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KL'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KL'){CabinClass.add(new SelectOption('Economy Comfort','Economy Comfort'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KL'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KL'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KQ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KU'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KW'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'KX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'L2'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'L8'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LG'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LH'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LO'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LR'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LY'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'LZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ME'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ME'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MH'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ML'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MP'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MQ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MS'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MU'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'MZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'N6'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'N7'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'N8'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'N8'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'N8'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ND'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NH'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NL'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NZ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'NZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OC'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OE'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OH'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OH'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OO'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OO'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OS'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OU'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OV'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OZ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'OZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PL'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PL'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PR'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PS'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'PZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QF'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QI'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QR'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'QZ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'R3'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RG'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RG'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RJ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RO'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RP'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RP'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'RV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'S2'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'S5'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'S5'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'S5'){CabinClass.add(new SelectOption('Business','Business'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SA'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SA'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SD'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SH'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SN'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SQ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SU'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SV'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SW'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SY'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'SY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TG'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TK'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TN'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TP'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TR'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'TZ'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'U8'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UL'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UM'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UP'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'US'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UU'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UX'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'UY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'V3'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VA'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VC'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VG'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VK'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VN'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VS'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));
                                                                CabinClass.add(new SelectOption('Premium Economy','Premium Economy'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VV'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VW'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'VX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WB'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WF'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WN'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WN'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WO'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WP'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WQ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WS'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WS'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WY'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'WY'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XE'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XJ'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XJ'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XK'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XK'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'XT'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YI'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YM'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YV'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YX'){CabinClass.add(new SelectOption('First','First'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'YX'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'Z2'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ZK'){CabinClass.add(new SelectOption('First','First'));
                                                                CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ZV'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ZW'){CabinClass.add(new SelectOption('Coach','Coach'));}
if(String.valueOf(caseComplaint.Operating_Carrier__c) ==  'ZX'){CabinClass.add(new SelectOption('Coach','Coach'));}
         return CabinClass;
    }
    
}