public class SkyFinderFlightLegController {
    
    public Id                                   caseId                 { get; set; }
    public Boolean                              initialized            { get; set; }
    public Boolean                              hasCaseId              { get; set; }   
    public Case                                 flightLegCase          { get; set; }
    public Set<String>                          attachedFlightLegNames;
    public String          selectedFlightLegName  { get; set; } 
    public List<FlightLegUtils.Flightleg> pnrFlightLegList
    { 
        get{ return pnrFltsMap == null || pnrFltsMap.isEmpty() ? new List<FlightLegUtils.Flightleg>() : pnrFltsMap.values(); } 
        set; 
    }
    public Boolean         hasPNRFlightLegs       { get{ return pnrFlightLegList == null || pnrFlightLegList.isEmpty() ? false : true; } set; }
    public List<SelectOption> airlineCodes
    {
        get
        {
            if (airlineCodes != null) return airlineCodes;
            airlineCodes = new List<SelectOption>();

            for(Airline_Code__c airlineCode : [
                SELECT   Id, IATA_Code__c, ICAO_Code__c, Name, Country__c
                FROM     Airline_Code__c
                WHERE    IATA_Code__c != Null AND IATA_Code__c != ''
                ORDER BY Sort_Order__c NULLS LAST, IATA_Code__c
            ]) {
                airlineCodes.add(new SelectOption(airlineCode.IATA_Code__c, airlineCode.IATA_Code__c + ' - ' + /* airlineCode.ICAO_Code__c + ' - ' + */ airlineCode.Name + ' - ' + airlineCode.Country__c));
            }

            return airlineCodes;
        }
        private set;
    }

    public List<SelectOption> airportCodes
    {
        get
        {
            if (airportCodes != null) return airportCodes;
            airportCodes = new List<SelectOption>();
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

     public List<FlightLegUtils.Flightleg> potentialFlightLegs
    { 
        get{ return potFltsMap == null || potFltsMap.isEmpty() ? new List<FlightLegUtils.Flightleg>() : potFltsMap.values(); } 
        set; 
    }
    public Boolean  hasPotentialFlightLegs { get{ return potentialFlightLegs == null || potentialFlightLegs.isEmpty() ? false : true; } set; }
    public FlightLegUtils.searchParameters      params                
    { 
        get
        { 
            if (params == null) params = new FlightLegUtils.searchParameters();
            return params;
        }
        set; 
    }
     public List<FlightLegUtils.Complaint> attachedComplaints     
    { 
        get{ return atthdCmpltsMap == null || atthdCmpltsMap.isEmpty() ? new List<FlightLegUtils.Complaint>() : atthdCmpltsMap.values(); } 
        set; 
    }
    
    public list<Flight_Leg__c> attachedFlights{get;set;}
     public Map<String,FlightLegUtils.Flightleg> potFltsMap          // key is FlightLegName     
    { 
        get
        {
            if(potFltsMap == null ) potFltsMap = new Map<String,FlightLegUtils.Flightleg>();
            return potFltsMap;
        } 
        set;
    } 
     public Map<String,FlightLegUtils.Complaint> atthdCmpltsMap      // key is FlightLegName
    { 
        get
        {
            if(atthdCmpltsMap == null) atthdCmpltsMap = new Map<String,FlightLegUtils.Complaint>();
            return atthdCmpltsMap;
        } 
        set;
    }
    public Map<String,FlightLegUtils.Flightleg> pnrFltsMap         // key is FlightLegName      
    { 
        get
        {
            if(pnrFltsMap == null ) pnrFltsMap = new Map<String,FlightLegUtils.Flightleg>();
            return pnrFltsMap;
        } 
        set; 
    }   
    public List<String>    collumnNames           { get; set; }
    public SkyFinderFlightLegController() 
    {
        caseId = ApexPages.currentPage().getParameters().get('id');
        idCheck = 'check';
        initialized = false;
        hasCaseId = false;
        
                // TODO: now query all of the fields
        if(caseId != null)
        {
            List<case> theCases =
            ([
                SELECT id, Subject, CaseNumber, Reason, PNR__c,
                    ContactId, AccountId
                FROM case
                WHERE id = :caseId
            ]);
            if (!theCases.isEmpty()) 
            {
                flightLegCase = theCases[0];
                hasCaseId = true;
            }
        }

        params.Task = new Task();
        params.PNR = flightLegCase == null ? null : flightLegCase.PNR__c;

        if(!String.isBlank(caseId)) 
        {
            /*if(!String.isBlank(params.PNR)) 
            {
                clickSearch();
            }
            */
            if (potFltsMap != null) pnrFltsMap = potFltsMap.clone();        // with ondemand parameter, should never be null
            else pnrFltsMap = new Map<String, FlightLegUtils.Flightleg>();

            potFltsMap = new Map<String, FlightLegUtils.Flightleg>();
            params.PNR = null;
        }
        collumnNames = new List<String>{ '', 'Flight', 'Schd Dep', 'Dep City', 'Schd Arr', 'Arr City', '# Of Cases', 'Alerts'};
        resetFlightLegs();
    }
    
     public void resetFlightLegs() {
        Set<Id> flightLegIds = new Set<Id>();
        attachedFlights = new list<Flight_Leg__c>();
        Map<Id,Set<Id>> CaseCountMap = new Map<Id,Set<Id>>(); //Map<FlightLedId,Set<CaseId>>
        Map<Id,Decimal> CompensationTotal = new Map<Id,Decimal>();
        Map<String,Id> complaintsNameToId = new Map<String,Id>();  //Map<FightLegName,Flight_Leg__c>

        attachedFlightLegNames = new Set<String>();
        String caseIDCompare = caseId == null ? '' : 'Case__c = \'' + caseId + '\' AND ';
        String whereClause = caseIDCompare + 'Case__c != Null';
        /*for(Case_Complaint__c complaint : FlightLegUtils.queryCaseComplaints(whereClause)) 
        {
            if (complaint.Flight_Leg__c == null) continue; // caseComplaints might not have a flightLeg
            if (atthdCmpltsMap == null) atthdCmpltsMap = new Map<String,FlightLegUtils.Complaint>();            
            atthdCmpltsMap.put(complaint.Flight_Leg__r.Name,FlightLegUtils.convertCaseComplaintFromDatabaseToInternal(complaint));
            flightLegIds.add(complaint.Flight_Leg__c);
            attachedFlightLegNames.add(complaint.Flight_Leg__r.Name);
            complaintsNameToId.put(complaint.Flight_Leg__r.Name,complaint.Flight_Leg__c);
        }*/
        set<id> flghtId = new set<id>();
        for(Case_Flight_Detail__c cfg : [select id,Flight__c from Case_Flight_Detail__c where Case__c = :caseId])
        {
            flghtId.add(cfg.Flight__c);
        }
        if(flghtId.size() > 0)
        {
            attachedFlights = [select id,name,FlightNumber__c,ScheduledDepartureTime__c,ScheduledArrivalTime__c,DepartureAirport__c,ArrivalAirport__c from Flight_Leg__c where id IN :flghtId];
        }

        Set<ID> CasesSuperSet = new Set<ID>(); 
        whereClause = 'Case__c != null';
        if (!flightLegIds.isEmpty()) whereClause += ' AND Flight_Leg__c != null AND Flight_Leg__c IN ' + FlightLegUtils.setIDtoString(flightLegIds); //Flight_Leg__c IN :flightLegIds AND Case__c != Null

        for(Case_Complaint__c complaint : FlightLegUtils.queryCaseComplaints(whereClause))
        {
            CasesSuperSet.add(complaint.Case__c);
            Set<Id> theCases = CaseCountMap.get(complaint.Flight_Leg__c);
            if (theCases == null) theCases = new Set<Id>();
            theCases.add(complaint.Case__c);
            CaseCountMap.put(complaint.Flight_Leg__c,theCases);
        }

        for(FlightLegUtils.Complaint aComp : attachedComplaints)
        {
            Id flID = complaintsNameToId.get(aComp.flightName);
            Set<Id> theCases = CaseCountMap.get(flID);
            aComp.caseCount = theCases == null ? 0 : theCases.size();
            aComp.compAvg = 0;
        }
    }
    public void clickSearch()
    {
        initialized = true;
        system.debug('clickSearch-in --> '+params.Carrier+' '+params.FlightNumber+' '+params.Task.ActivityDate);
        boolean flag1 = cityCheck(params.Destination);
        boolean flag2 = cityCheck(params.Origin);
        system.debug('validation done');
        if(String.isBlank(params.PNR) && (String.isBlank(params.Carrier) || String.isBlank(params.FlightNumber) || params.Task.ActivityDate == Null)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Search must include either a PNR or a carrier, flight number, and date.'));
            return;
        }
        if(flag1 && !string.isBlank(params.Destination))
        {
            system.debug('inside if');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter valid origin/destination'));
            return;
        }
        if(flag2 && !string.isBlank(params.Origin))
        {
            system.debug('inside else');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter valid origin/destination'));
            return;
        }

        Set<Id> flightLegIds = new Set<Id>();
        /*if (attachedFlightLegNames == null) attachedFlightLegNames = new Set<String>();
        String caseIDCompare = caseId == null ? '' : 'Case__c = \'' + caseId + '\' AND ';
        String whereClause = caseIDCompare + 'Case__c != Null';
        whereClause += ' AND Flight_Leg__c != Null'; // skip caseComplaints without a flightLeg

        for( Case_Complaint__c caseComplaint : FlightLegUtils.queryCaseComplaints( whereClause ) )
        {
            flightLegIds.add(caseComplaint.Flight_Leg__c);
            attachedFlightLegNames.add(caseComplaint.Flight_Leg__r.Name);
        }
        */
        Map <String,FlightLegUtils.Flightleg> searchResults = new Map<String,FlightLegUtils.Flightleg>();   // Key is Flightleg Name
        system.debug('pnr value --> '+params.PNR);
        if(String.isNotBlank(params.PNR)) {
            
            searchResults.putAll(FlightLegUtils.doCalloutsPnr(params.PNR));
        } else if(String.isNotBlank(params.Carrier) && String.isNotBlank(params.FlightNumber) && params.Task.ActivityDate != Null) {
            system.debug('else-executed');
            searchResults.putAll(FlightLegUtils.doCalloutsDetails(params));
            system.debug('else-Completed');
        }

        resetFlightLegs();  // TODO : do I need to do this here?
        // loop by index because these are ordered ??  TODO:  order means nothing here -- set index in doCallout calls
        for(Integer i = 0; i < searchResults.values().size(); i++) {
            system.debug('crew check --> '+searchResults.values()[i].crew);
            searchResults.values()[i].index = i;
            searchResults.values()[i].attached = attachedFlightLegNames.contains(searchResults.values()[i].name);
            if (searchResults.values()[i].name != null) potFltsMap.put(searchResults.values()[i].name, searchResults.values()[i]);
            // if the order is important, the map loses it, because the page display will
            // iterate over the values in arbitrary order
        }

        //  This counts the number of unique cases associated with each flight leg
        Map<Id, Integer> flightlegCaseCountsMap = new Map<Id, Integer>(); // <flightleg id, case count>

        if (potFltsMap != null && !potFltsMap.isEmpty())
        {
            CWQuery caseCountsQuery  = CWQuery.newAggregateQuery('Case_Complaint__c').countDistinct('Case__c','numCases').groupBy('Flight_Leg__c');
            caseCountsQuery.newWhereClause().isIn('Flight_Leg__r.Name',new List<String>(potFltsMap.keySet()));
            for ( AggregateResult result : caseCountsQuery.aggregateQuery() )
            {
                flightlegCaseCountsMap.put((Id) result.get('Flight_Leg__c'), (Integer) result.get('numCases'));
                //Id      thisFlightLegId     = (Id) result.get('Flight_Leg__c');
                //Integer hasThisManyCases    = (Integer) result.get('numCases');
            }

            CWQuery queryFlightLeg = CWQuery.newQuery('Flight_Leg__c').addAllFields();
            queryFlightLeg.newORWhereClause().isIN('Name', new List<String>( potFltsMap.keyset() ));
            for (Flight_Leg__c foundFlightLeg : (List<Flight_Leg__c>)queryFlightLeg.query())
            {
                FlightLegUtils.FlightLeg internal = potFltsMap.get(foundFlightLeg.Name);
                if (internal == null) continue; // shouldn't happen
                internal.id = foundFlightLeg.id;
                internal.flightleg = foundFlightLeg;
                internal.caseCount = flightlegCaseCountsMap.get(foundFlightLeg.id) != null ?
                                        flightlegCaseCountsMap.get(foundFlightLeg.id) : 0;
                FlightLegUtils.Complaint theComplaint = atthdCmpltsMap.get(foundFlightLeg.Name);
                if (theComplaint != null) theComplaint.caseCount = internal.caseCount;
            }
        }
        else // nothing found
        {
            // the initialized flag prevents the error message on page load
            // the clickSearch function is called to find the flights attached to the PNR on page load
            if (initialized) ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No Matches Found for Search'));
        }
        initialized = true;
        return;
    }
    
    public boolean cityCheck(string cityName)
    {
        boolean flag = true;
        system.debug('city name --> '+cityName);
        list<string> str = cityName.split(' - ');
        list<Airport_Code__c > airport = [select id,IATA_Code__c, name from Airport_Code__c  where IATA_Code__c = :str[0]];
        if(airport.size() > 0)flag = false;
        return flag;
    }
    public string idCheck{get;set;}
    public string casecomplaint{get;set;}
    public void AcceptContactforCreate()    // function to be used on 'SkyFinder Console landed' version of this page
    {
        
        casecomplaint = '';
        system.debug('flight name --> '+selectedFlightLegName+'  '+params.Task.ActivityDate+'  '+params.Destination+'  '+params.Origin);
        if (String.isBlank(selectedFlightLegName)) return;   
        
       FlightLegUtils.flightLeg pnrSelectedFlightLeg = pnrFltsMap.get(selectedFlightLegName);
       FlightLegUtils.flightLeg potSelectedFlightLeg = potFltsMap.get(selectedFlightLegName);
       
       list<Flight_Leg__c> flighLegs = new list<Flight_Leg__c>();
       flighLegs = [select id,name,ActualDepartureTime__c from Flight_Leg__c where Name = :selectedFlightLegName and ActualDepartureTime__c = :potSelectedFlightLeg.ActualDepartureTime and ActualArrivalTime__c = :potSelectedFlightLeg.ActualArrivalTime];
       id toBeAttached;
       
       if(flighLegs.size() == 0){
           system.debug('flighLegs :-' + flighLegs.size());
        toBeAttached = FlightLegUtils.saveFlightLeg(potSelectedFlightLeg == null ? pnrSelectedFlightLeg : potSelectedFlightLeg);
       }
       else{
           system.debug('flighLegs else part:-');
           toBeAttached = flighLegs[0].id;
       }
       // Id toBeAttached = FlightLegUtils.saveFlightLeg(potSelectedFlightLeg == null ? pnrSelectedFlightLeg : potSelectedFlightLeg);
       /* if (toBeAttached == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Unable to Create Flightleg'));
            return;
        }
        */
        system.debug('id value --> '+toBeAttached);
        idCheck = toBeAttached;
        system.debug('id value --> '+idCheck );
        
        if(caseId == Null) return;  // this is true if we got to this page via skyfinder and there is no case -- we are done
        Case_Flight_Detail__c csf = new Case_Flight_Detail__c(Case__c = caseId,Flight__c=toBeAttached);
        insert csf;
        if((params.PNR != null)&&(params.PNR != ''))
        {
            PNR__c pnr = new PNR__c(Case__c = caseId,Record_Locator__c = params.PNR, Flight_Leg__c = toBeAttached);
            insert pnr;
        }
        Flight_Leg__c fg = [select id,name,FlightNumber__c,ScheduledDepartureTime__c,ScheduledArrivalTime__c,DepartureAirport__c,ArrivalAirport__c from Flight_Leg__c where id = :toBeAttached];
        attachedFlights.add(fg);
        casecomplaint = ApexPages.currentPage().getParameters().get('caseComplaint');
        system.debug('casecomplaint --> '+casecomplaint);
        if(!string.isblank(casecomplaint))
        {
            Case_Complaint__c cc = new Case_Complaint__c(id=casecomplaint,Flight_Leg__c = toBeAttached);
            update cc;
        }
        // Handle attaching to the case
        // check to see whether this is already attached, and if not ... attach it
        /*List<Case_Complaint__c> Junctions = 
        [
            SELECT Id, Case__c, Flight_Leg__c,Flight_Leg__r.Alerts__c
            FROM   Case_Complaint__c
            WHERE  Case__c = :caseId AND Flight_Leg__c = :toBeAttached
        ];*/
      /*  List<Case_Complaint__c> Junctions = 
        [
            SELECT Id, Case__c, Flight_Leg__c
            FROM   Case_Complaint__c
            WHERE  Case__c = :caseId AND Flight_Leg__c = :toBeAttached
        ];
        Case_Complaint__c newComplaintObj;
        if (Junctions.isEmpty()) newComplaintObj = new Case_Complaint__c(Case__c = caseId, Flight_Leg__c = toBeAttached);
        else newComplaintObj = Junctions[0];
        upsert newComplaintObj;
        //Query the complaint to get the needed fields -- TODO : move this into the convert function?
        String whereClause = 'Id = \'' + newComplaintObj.id + '\'';
        List<Case_Complaint__c> queriedComplaint = FlightLegUtils.queryCaseComplaints(whereClause); // WHERE   Id = :newComplaintObj.id
System.Debug('C whereClause ' + whereClause);
/*
        [
            SELECT   Id, Flight_Leg__c,
                     Complaint_Code__r.Display_Name__c,
                     Complaint_Location__c,
                     Flight_Leg__r.Name,
                     Flight_Leg__r.MarketingAirlineCode__c,
                     Flight_Leg__r.OperatingAirlineCode__c,
                     Flight_Leg__r.FlightNumber__c,
                     Flight_Leg__r.DepartureAirport__c,
                     Flight_Leg__r.ArrivalAirport__c,
                     Flight_Leg__r.ScheduledDepartureTime__c,
                     Flight_Leg__r.ScheduledArrivalTime__c,
                     Flight_Leg__r.ActualDepartureTime__c,
                     Flight_Leg__r.ActualArrivalTime__c,
                     Flight_Leg__r.InTime__c,
                     Flight_Leg__r.OutTime__c,
                     Flight_Leg__r.OffTime__c,
                     Flight_Leg__r.OnTime__c,
                     Flight_Leg__r.LegMileage__c,
                     Flight_Leg__r.Alerts__c
            FROM     Case_Complaint__c
            WHERE   Id = :newComplaintObj.id 
        ];
*//*
        if (queriedComplaint.isEmpty()) return;
        FlightLegUtils.Complaint complaintInternal = FlightLegUtils.convertCaseComplaintFromDatabaseToInternal(queriedComplaint[0]);
        Boolean complaintUpdated = false;
        if (complaintInternal != null) atthdCmpltsMap.put(selectedFlightLegName, complaintInternal);
        if (potSelectedFlightLeg != null) 
        {
            potSelectedFlightLeg.attached = true;
            potSelectedFlightLeg.caseCount = potSelectedFlightLeg.caseCount == null ? 1 : potSelectedFlightLeg.caseCount++;
            complaintInternal.caseCount = potSelectedFlightLeg.caseCount;
            complaintUpdated = true;
        }
        if (pnrSelectedFlightLeg != null)
        {
            pnrSelectedFlightLeg.attached = true;
            pnrSelectedFlightLeg.caseCount = pnrSelectedFlightLeg.caseCount == null ? 1 : pnrSelectedFlightLeg.caseCount++;
            if (!complaintUpdated) complaintInternal.caseCount = pnrSelectedFlightLeg.caseCount;
        } 
        */
    }
    
    public void clickCreateManuallyFlightLeg()
    {
               
        if(String.isBlank(params.Carrier) || String.isBlank(params.Origin) || String.isBlank(params.Destination) || (params.Task.ActivityDate == null)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Creating a Flight Leg manually requires a Marketing carrier,origin, destination, date.'));
            return;
        }
        
         /*Start Added by Anil to check origin and destination in valid*/
        
        boolean flag1 = cityCheck(params.Destination);
        boolean flag2 = cityCheck(params.Origin);
        system.debug('validation done');
        
        if(flag1 && !string.isBlank(params.Destination))
        {
            system.debug('inside if');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter valid origin/destination'));
            return;
        }
        if(flag2 && !string.isBlank(params.Origin))
        {
            system.debug('inside else');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter valid origin/destination'));
            return;
        }
        
        /*End*/
        

        Date d = params.Task.ActivityDate;
        String departureDate = '';
        if(d != null){
         departureDate = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).format('yyyy-MM-dd');
        }
        String name = FlightLegUtils.makeUniqueName(params.Carrier.left(2), params.FlightNumber, departureDate, params.Origin.left(3), params.Destination.left(3));
        
        Flight_Leg__c flightLeg = new Flight_Leg__c();
        flightLeg.Name                      = name;
        flightLeg.MarketingAirlineCode__c   = params.Carrier.left(2);
        flightLeg.OperatingAirlineCode__c   = params.Carrier.left(2);  
        flightLeg.FlightNumber__c           = FlightLegUtils.makeFourDigits(params.FlightNumber);       
        flightLeg.OperatingFlightNumber__c  = FlightLegUtils.makeFourDigits(params.FlightNumber);
        flightLeg.DepartureAirport__c       = params.Origin.left(3);
        flightLeg.ArrivalAirport__c         = params.Destination.left(3);
        flightLeg.ScheduledDepartureTime__c = departureDate;
        flightLeg.Created_Manually__c       = true;
        insert flightLeg;

        Case_Complaint__c caseComplaint = new Case_Complaint__c();
        caseComplaint.Case__c = caseId;
        caseComplaint.Flight_Leg__c = flightLeg.Id;
        insert caseComplaint;
        
        FlightLegUtils.FlightLeg flg = new FlightLegUtils.FlightLeg();
        flg.name = name;
        flg.DepartureAirport = params.Origin.left(3);
        flg.ArrivalAirport = params.Destination.left(3);
        flg.ScheduledDepartureTime = departureDate;
        flg.MarketingAirlineCode = params.Carrier.left(2);
        flg.OperatingAirlineCode = params.Carrier.left(2); 
        flg.FlightNumber = FlightLegUtils.makeFourDigits(params.FlightNumber);
        flg.OperatingFlightNumber = FlightLegUtils.makeFourDigits(params.FlightNumber);
        potFltsMap.put(flightLeg.Name,flg);
        system.debug('value check --> '+potFltsMap);
        resetFlightLegs();
    }
    public void clearSearch()
    {
        potFltsMap = new Map<String, FlightLegUtils.FlightLeg>();
        params = new FlightLegUtils.searchParameters();   
        params.Task = new Task();
        params.PNR = flightLegCase == null ? null : flightLegCase.PNR__c;       
//      params.Task.ActivityDate = null;
//      Render_OperCarrier = false;
    }
     public void clickRemoveFlightLeg() {
        if(String.isBlank(selectedFlightLegName)) return;
        list<Case_Flight_Detail__c> csf = [select id from Case_Flight_Detail__c where Flight__c = :selectedFlightLegName and Case__c = :caseId];
        delete csf;
        integer i = 0;
        for(Flight_Leg__c fl:attachedFlights)
        {
            if(fl.id == selectedFlightLegName)
                break;
        }
        attachedFlights.remove(i);
        /*FlightLegUtils.Complaint theComplaint = atthdCmpltsMap.remove(selectedFlightLegName);
        FlightLegUtils.FlightLeg potFlight = potFltsMap.get(selectedFlightLegName);
        FlightLegUtils.FlightLeg pnrFlight = pnrFltsMap.get(selectedFlightLegName);
        ID potFlightID = potFlight == null ? null : potFlight.id;
        ID pnrFlightID = pnrFlight == null ? null : pnrFlight.id;
        SkyFinderUtils.idTupple myID = SkyFinderUtils.validateID( theComplaint.Id );

        if(theComplaint != null && theComplaint.Id != null && myID.isValid && myID.myType == Case_Complaint__c.sObjectType) 
        { 
            delete new Case_Complaint__c (Id = theComplaint.Id);
        }

        // clean up any other complaints that attach this flightLeg to this case
        Map<Id, Case_Complaint__c> complaintDanglers = new Map<Id, Case_Complaint__c>
        (
            [
                SELECT id 
                FROM Case_Complaint__c 
                WHERE (Flight_Leg__c = :pnrFlightID OR Flight_Leg__c = :potFlightID) AND Flight_Leg__c != null AND Case__c = :caseId
            ]
        );
        delete complaintDanglers.values();
        
        // mark it as not attached
        if (potFlight != null) 
        {
            potFlight.attached = false;
            potFlight.caseCount--;
        }
        if (pnrFlight != null) 
        {
            pnrFlight.attached = false;
            pnrFlight.caseCount--;
        }*/
    }

}