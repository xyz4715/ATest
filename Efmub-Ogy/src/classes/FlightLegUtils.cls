public without sharing class FlightLegUtils{
    
     public static String complaintFields;
     public static Map<String,String> mapFromMonthNumberToMonthName = new Map<String,String> { 
      '01'=>'JAN',
      '02'=>'FEB',
      '03'=>'MAR',
      '04'=>'APR',
      '05'=>'MAY',
      '06'=>'JUN',
        '07'=>'JUL',
        '08'=>'AUG',
        '09'=>'SEP',
        '10'=>'OCT',
        '11'=>'NOV',
        '12'=>'DEC' 
    };
     public static final Map<String, Integer> mapFromMonthAbbreviationToNumber = new Map<String, Integer> 
    {
        'JAN' =>  1,
        'FEB' =>  2,
        'MAR' =>  3,
        'APR' =>  4,
        'MAY' =>  5,
        'JUN' =>  6,
        'JUL' =>  7,
        'AUG' =>  8,
        'SEP' =>  9,
        'OCT' => 10,
        'NOV' => 11,
        'DEC' => 12
    };
    public static final Map<Integer, String> mapFromNumberToMonthAbbreviation = new Map<Integer, String> 
    {
        1  => 'JAN',
        2  => 'FEB',
        3  => 'MAR',
        4  => 'APR',
        5  => 'MAY',
        6  => 'JUN',
        7  => 'JUL',
        8  => 'AUG',
        9  => 'SEP',
        10 => 'OCT',
        11 => 'NOV',
        12 => 'DEC'
    };
     public static Map<String, String> mapFromMonthNameToMonthNumber = new Map<String, String> {
        'JAN' => '01',
        'FEB' => '02',
        'MAR' => '03',
        'APR' => '04',
        'MAY' => '05',
        'JUN' => '06',
        'JUL' => '07',
        'AUG' => '08',
        'SEP' => '09',
        'OCT' => '10',
        'NOV' => '11',
        'DEC' => '12'
    };
    
    public static String toString(DateTime dt) {
        if(dt == Null)
            return Null;

        return dt.format('yyyy-MM-dd hh:mm');
    }
     public static String setIDtoString( Set<Id> theIDs )
    {
        String idString;
        if (theIDs == null) return idString;
        for( Id anID : theIDs )
        {
            if (idString == null) idString = '(';
            else idString += ',';
            idString += '\'' + anID + '\'';
        }
        idString += ')';
        return idString;
    }

    
    public static String toString(SOA_FlightDetails.LocalDateTime ldt) {
        if(ldt == Null)
            return Null;

        return ldt.DateTimeString.replace('T', ' ').left(16) + ' ' + toTimeZone(ldt.GmtOffset); // dt.format('yyyy-MM-dd hh:mm GMT-X');
    }
    
     public static String toTimeZone(String secondsString) {
        if(secondsString == null) {
            return Null;
        }

        Integer minutesInteger = Integer.valueOf(secondsString) / 60;
        Integer hours = minutesInteger / 60;
        Integer minutes = minutesInteger - hours * 60;
        return 'GMT-' + ((minutes == 0) ? (String.valueOf(hours)) : (hours + ':' + minutes));
    }
     public static Integer toInteger(String i) {
        if(i == Null)
            return Null;

        return Integer.valueOf(i);
    }

    public static Integer toInteger(Double d) {
        if(d == Null)
            return Null;

        return Integer.valueOf(d);
    }
    public static String toMealCode(SOA_FlightDetails.MealCodesByCabinClass[] mealCodes, String cabinClass) {
        if(mealCodes == Null)
            return Null;

        for(SOA_FlightDetails.MealCodesByCabinClass mealCode : mealCodes) {
            if(cabinClass != 'OTHER' && mealCode.CabinClass == cabinClass)
                return mealCode.MealCode;
            if(cabinClass == 'OTHER' && mealCode.CabinClass != 'F' && mealCode.CabinClass != 'J' && mealCode.CabinClass != 'Y')
                return mealCode.MealCode;
        }
        return Null;
    }
    
    public static List<FlightMember> extractFlightMembersFromCrewList(SOA_CrwListWS.crwListByFltRspn response) {
        List<FlightMember> flightMembers = new List<FlightMember>();

        if(response != Null && response.flt != Null && response.flt.crw != Null) {
            for(SOA_CrwListWS.crwFltVo flightMemberXml : response.flt.crw) {
                FlightMember flightMemberInternal = convertFlightMemberFromXmlToInternal(flightMemberXml);
                doEmployeeCallout(flightMemberInternal);
                flightMembers.add(flightMemberInternal);
            }
        }

        return flightMembers;
    }
     public static FlightMember convertFlightMemberFromXmlToInternal(SOA_CrwListWS.crwFltVo flightMemberXml) 
    {
        FlightMember flightMemberInternal = new FlightMember();

        flightMemberInternal.id         = Null;                                  // Id
        flightMemberInternal.firstName  = toName(flightMemberXml.mbrPsptNm, 1);  // String
        flightMemberInternal.middleName = toName(flightMemberXml.mbrPsptNm, 2);  // String
        flightMemberInternal.lastName   = toName(flightMemberXml.mbrPsptNm, 0);  // String
        flightMemberInternal.mbrIdNb    = flightMemberXml.mbrIdNb;               // String
        flightMemberInternal.mbrNm      = flightMemberXml.mbrNm;                 // String
        flightMemberInternal.mbrTypCd   = flightMemberXml.mbrTypCd;              // String
        flightMemberInternal.mbrPsptNm  = flightMemberXml.mbrPsptNm;             // String
        flightMemberInternal.pstnCd     = flightMemberXml.pstnCd;                // String
//        flightMemberInternal.rotnBegDt  = toDateTime(flightMemberXml.rotnBegDt); // DateTime
        flightMemberInternal.rotnDupNb  = flightMemberXml.rotnDupNb;             // String
        flightMemberInternal.rotnNb     = flightMemberXml.rotnNb;                // String
        flightMemberInternal.rotnPstnCd = flightMemberXml.rotnPstnCd;            // String

        return flightMemberInternal;
    }
     public static void doEmployeeCallout(FlightMember member) {
        SOA_Employee.Employee_EP doer = new SOA_Employee.Employee_EP();
        SOA_Employee.HRDataResponseType response = doer.RetrieveHRData(member.mbrIdNb);
        if(response != Null) {
            if(response.HRData != Null && !response.HRData.isEmpty()) {
                member.BsAssgn    = response.HRData[0].BsAssgn;
                member.EmplDt     = response.HRData[0].EmplDt;
                member.EmplFrstNm = response.HRData[0].EmplFrstNm;
                member.EmplLstNm  = response.HRData[0].EmplLstNm;
                member.EmplMidNm  = response.HRData[0].EmplMidNm;
                member.FADeptNb   = response.HRData[0].FADeptNb;
                member.FAFsmBase  = response.HRData[0].FAFsmBase;
                member.FAFsmId    = response.HRData[0].FAFsmId;
                member.MgrFrstNm  = response.HRData[0].MgrFrstNm;
                member.MgrLstNm   = response.HRData[0].MgrLstNm;
                member.MgrNb      = response.HRData[0].MgrNb;
                member.SnrtyDt    = response.HRData[0].SnrtyDt;
                member.SnrtyNb    = response.HRData[0].SnrtyNb;
            }
        }
    }
    public static String toName(String fullName, Integer component) {
        if(String.isBlank(fullName))
            return Null;

        List<String> comma = fullName.split(',');
        if(component == 0) {
            return comma[0].trim();
        }

        List<String> space = comma.size() > 1 ? comma[1].trim().split(' ') : new List<String>();
        if(space.size() > component - 1) {
            return space[component - 1];
        }

        return Null;
    }
    
     public static String makeFourDigits(String flightNumber) 
    {
        return flightNumber == Null       ? '0000'
             : flightNumber.length() == 0 ? '0000'
             : flightNumber.length() == 1 ?  '000' + flightNumber
             : flightNumber.length() == 2 ?   '00' + flightNumber
             : flightNumber.length() == 3 ?    '0' + flightNumber
             :                                       flightNumber;
    }

    public static String makeThreeDigits(String flightNumber) 
    {
        return flightNumber == Null       ? '000'
             : flightNumber.length() == 0 ? '000'
             : flightNumber.length() == 1 ?  '00' + flightNumber
             : flightNumber.length() == 2 ?   '0' + flightNumber
             :                                      flightNumber;
    }
     public static Date extractDate(String dateTimeString) 
    {
        List<String> pieces = dateTimeString.split(' ');    // actually, no ... TODO, does this want to be splitting on any amount of white space?
        return Date.valueOf(pieces[0]);
    }
    
    
    
     public static Map<String,Flightleg> doCalloutsDetails(searchParameters params) // key is FlightLeg Name
    {
      // if (params == null) return;  //  TODO if this is null, I have a bug upstream that needs fixing
System.debug('B:callout flight details: ' + params.airlineCode + ' ' + params.flightNumber + ' ' + params.departureDate + ' ' + params.origin);
System.debug('B:callout flight details: ' + params.Task == null ? 'TASK is null' : 'params.Task.ActivityDate' );

        SOA_FlightDetails.Flight flight = new SOA_FlightDetails.Flight();
        flight.AirlineCode            = params.AirlineCode;
        flight.FlightNumber           = params.flightNumber;
        flight.FlightLegDepartureDate = params.Task == null || params.Task.ActivityDate == null ?  // TODO : sort out the real date, to make sure the flight legs aren't being dropped
            makeLocalDateTime(params.departureDate) : makeLocalDateTime(params.Task.ActivityDate);
        SOA_FlightDetails.Flight[] flights = new List<SOA_FlightDetails.Flight>{flight};

        SOA_FlightDetails.RequestInfoTypeTpfssc RequestInfo = new SOA_FlightDetails.RequestInfoTypeTpfssc();
        RequestInfo.ApplicationId = 'CU';

        SOA_FlightDetails.FlightDetails_EP flightDetails = new SOA_FlightDetails.FlightDetails_EP();
        SOA_FlightDetails.FlightLegDetailsResponseType results = flightDetails.RetrieveDetails(flights, requestInfo);
        
        system.debug('results-FL' + results);
        
        List<Flightleg> extracted = FlightLegUtils.extractFlightLegsFromDetails(results, params);
        Map<String,Flightleg> returnMap = new Map<String,Flightleg>();        
        updateFlightLegsFromFlightInformation(extracted, params);
       updateFlightLegsWithDelayCodes(extracted);
        for (FlightLeg flt : extracted) returnMap.put(flt.name, flt);
        return returnMap;
    }
    
        public static List<FlightLegUtils.Flightleg> ExtractFlightLegsFromDetails(SOA_FlightDetails.FlightLegDetailsResponseType response, searchParameters params) 
    {
        List<FlightLegUtils.Flightleg> flightLegs = new List<FlightLegUtils.Flightleg>();
List<List<String>> compValues = new List<List<String>>();
        if(response != Null && response.flightData != Null) {
            for(SOA_FlightDetails.FlightInfo flight : response.FlightData) {
                if(flight.flightLeg != Null) {
                    for(SOA_FlightDetails.FlightLegData flightLeg : flight.flightLeg) {
                        if(String.isNotBlank(params.carrier) && flight.AirlineCode != FlightLegUtils.getCodeFromString(params.carrier)) {
                            continue;  
                        }
                        if(String.isNotBlank(params.FlightNumber) && flight.FlightNumber != params.FlightNumber) {
                            continue;
                        }
                        // TODO: complete this!!! -- will have to match with formatting and OR with departureDate
                        if(params.Task.ActivityDate != Null && !compareDates(params.Task.ActivityDate,flightLeg.ScheduledDepartureTime.DateTimeString.left(10)) ||
                          params.DepartureDate != Null && !compareDates(params.DepartureDate,flightLeg.ScheduledDepartureTime.DateTimeString.left(10))) {
                            continue;
                        }
                        if(String.isNotBlank(params.origin) && flightLeg.DepartureAirport != FlightLegUtils.getCodeFromString(params.origin)) {
                            continue;  // this seems to guarantee an empty return
                        }
compValues.add(new List<String>{params.origin, FlightLegUtils.getCodeFromString(params.origin), flightLeg.DepartureAirport});
                      FlightLegUtils.FlightLeg flightLegInternal = FlightLegUtils.convertFlightLegFromXmlToInternal(flightLeg, flight.AirlineCode, flight.FlightNumber);
                        flightLegInternal.crew = FlightLegUtils.fetchCrewMembers(flightLegInternal);
                        flightLegs.add(flightLegInternal);
                    }
                }
            }
        }
System.Debug('compValues\n' + compValues);
        return flightLegs;
    }
    
    public static String LightningFriendlyDateTime( DateTime dt )
    {
        if (dt == null) return '';
        String ampm = dt.hour() > 12 ? 'PM' : 'AM';
        Integer hour = dt.hour() > 12 ? dt.hour() - 12 : dt.hour();
        return dt.day() + dt.month() + dt.year() + ' ' + hour + ':' + dt.minute() + ampm;
    }

    public static String LightningFriendlyDateTime( String dt )  // incoming format is 'yyyy-mm-dd hh:mm GMT-x'
    {
        if (dt == null) return '';
        
        List<String> pieces = CWString.toList(CWString.split(dt));
        Boolean hasTime = (pieces.size() > 1 && pieces[1].contains(':')) ? true : false;
        String dayString = '';
        String timeString = '';
        if (hasTime)
        {
            List<String> timePieces = CWString.toList(CWString.split(pieces[1],':'));
            Boolean pm = Integer.valueof(timePieces[0]) > 12 ? true : false; 
            timeString += pm ? '' + (Integer.valueof(timePieces[0]) - 12) : timePieces[0];
            timeString += ':' + timePieces[1] + (pm ? 'PM' : 'AM');
        }        
        List<String> dayPieces = CWString.toList(CWString.split(pieces[0],'-'));        
        if (dayPieces.size() > 2) dayString +=  '' + dayPieces[2] + mapFromMonthNumberToMonthName.get(dayPieces[1]) + dayPieces[0].right(2) + ' ';
        else dayString += dayPieces[0];
        return dayString + timeString;
    }
    
     public static SOA_FlightDetails.LocalDateTime makeLocalDateTime(Date d) {
        if(d == Null) {
            return Null;
        }

        SOA_FlightDetails.LocalDateTime localDateTime = new SOA_FlightDetails.LocalDateTime();
        localDateTime.DateTimeFormat = 'YYYY-MM-DD';
        localDateTime.DateTimeString = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).format('YYYY-MM-dd');
//        localDateTime.GmtOffset      = '5'; // TODO shouldn't this be the offset of the airport?, does it matter
        return localDateTime;
    }
    
    public static String getCodeFromString(String airlineString) {
        if(airlineString == Null)
            return Null;

        String trimmedAirline = airlineString.trim();   // start of Janeen's changes

        Integer locationOfSpace = trimmedAirline.indexOf(' ');
        if (locationOfSpace == -1) return trimmedAirline; // no spaces, we are done
        if(locationOfSpace <= 1)  
            return Null;

        return trimmedAirline.substring(0, locationOfSpace);
    }
    
    public static Boolean compareDates(Date inputDate, String xmlSchedDepTime)
    {
        String formattedInput = format(inputDate, 'yyyy-MM-dd');
        String formattedXMLDate = xmlSchedDepTime.trim().left(10);

        
System.Debug('compareDates ' + inputDate + ' ' + xmlSchedDepTime);
System.Debug('compareDates formatted ' + formattedInput + ' ' + formattedXMLDate);
        
        if (formattedInput != formattedXMLDate) return false;
        return true;
    }

    
     public static void updateFlightLegsWithDelayCodes(List<FlightLeg> flightLegs) 
    {
        for(FlightLeg flightLeg : flightLegs) {
            system.debug('value check --> '+flightLeg);
            doCalloutDetailsWithAircraft(flightLeg);
        }
    }
    
    // diffed ith Dev 2
    // TODO remove the fake data that comes in with the ternary
    public static SOA_FlightInformation.RetrieveResponseType doCalloutsInformation(searchParameters srcParams) 
    {
        SOA_FlightInformation.FlightRequestParamsType params = new SOA_FlightInformation.FlightRequestParamsType();
        params.AirlineCode   = srcParams.airlineCode;  // == Null ? 'DL' : airlineCode;
        params.FlightNumber  = srcParams.flightNumber; // == Null ? '172' : flightNumber;   // '2036';  // '2232';  // '1991';
//        params.Origin        = 'LAX';   // 'MSP';
//        params.Destination   = 'ATL';   // 'ATL'
        params.DepartureDate = srcParams.Task == null || srcParams.Task.ActivityDate == null ?
          FlightLegUtils.format(srcParams.DepartureDate) :
          FlightLegUtils.format(srcParams.Task.ActivityDate); // == Null ? '08MAR' : FlightLegUtils.format(departureDate); //'07MAR'; // '08MAR'; // '02Mar'; // '11Feb';
        
        SOA_FlightInformation.RequestInfoType info = new SOA_FlightInformation.RequestInfoType();
        info.AppChannelName = 'Concord';
        info.ApplicationId  = 'CU';
        info.TransactionId  = 'test123';
        system.debug('before callout');
        SOA_FlightInformation.FlightInformation_EP doer = new SOA_FlightInformation.FlightInformation_EP();
        SOA_FlightInformation.RetrieveResponseType result = doer.Retrieve_x(new List<SOA_FlightInformation.FlightRequestParamsType>{params}, info);
        system.debug('after callout --> '+result);
        return result;
    }
    
    public static void updateFlightLegsFromFlightInformation(List<Flightleg> flightLegs, searchParameters params) 
    {
        SOA_FlightInformation.RetrieveResponseType response = doCalloutsInformation(params);
        for(Flightleg flightLeg : flightLegs) {
            updateFlightLegFromFlightInformation(flightLeg, response);
        }
    }
    
     public static void updateFlightLegFromFlightInformation(Flightleg flightLeg, SOA_FlightInformation.RetrieveResponseType response) 
    {
        if(response != Null) {
            if(response.FlightLeg != Null) {
                for(Integer i = 0; i < response.FlightLeg.size(); i++) {
                    if(flightLeg.DepartureAirport == response.FlightLeg[i].BoardCity) {
                        flightLeg.BoardCity                              = response.FlightLeg[i].BoardCity;
                        flightLeg.BoardCityCancelledIndicator            = response.FlightLeg[i].BoardCityCancelledIndicator == Null ? False : response.FlightLeg[i].BoardCityCancelledIndicator;
                        flightLeg.EquipmentType                          = response.FlightLeg[i].EquipmentType;
                        flightLeg.FlagstopIndicator                      = response.FlightLeg[i].FlagstopIndicator == Null ? False : response.FlightLeg[i].FlagstopIndicator;
                        flightLeg.InflightDateAdjustmentForArrivalTime   = response.FlightLeg[i].InflightDateAdjustmentForArrivalTime;
                        flightLeg.InflightDateAdjustmentForDepartureTime = response.FlightLeg[i].InflightDateAdjustmentForDepartureTime;
                        flightLeg.EstimatedTimeOfArrival                 = response.FlightLeg[i].EstimatedTimeOfArrival;
                        flightLeg.EstimatedTimeOfDeparture               = response.FlightLeg[i].EstimatedTimeOfDeparture;
                        flightLeg.Mileage                                = response.FlightLeg[i].Mileage;
                        flightLeg.ETATimeIsEstimated                     = response.FlightLeg[i].ETATimeIsEstimated;
                        flightLeg.ETDTimeIsEstimated                     = response.FlightLeg[i].ETDTimeIsEstimated;
                        flightLeg.OriginOfStub                           = response.FlightLeg[i].OriginOfStub;
                    }
                }
            }
            if(response.FlightRemarks != Null) {
                List<FlightRemark> remarks = new List<FlightRemark>();
                for(Integer i = 0; i < response.FlightRemarks.size(); i++) {
                    if(flightLeg.DepartureAirport == response.FlightRemarks[i].CityCode || flightLeg.ArrivalAirport == response.FlightRemarks[i].CityCode || String.isBlank(response.FlightRemarks[i].CityCode)) {
                        FlightRemark remark = new FlightRemark();
                        remark.RemarksText                      = response.FlightRemarks[i].RemarksText; 
                        remark.CityCode                         = response.FlightRemarks[i].CityCode;
                        remark.FlightHistoryExistsIndicator     = response.FlightRemarks[i].FlightHistoryExistsIndicator;
                        remark.CompositeFlightNoOpIndicator     = response.FlightRemarks[i].CompositeFlightNoOpIndicator;
                        remark.CompositeFlightStubbedIndicator  = response.FlightRemarks[i].CompositeFlightStubbedIndicator;
                        remark.CompositeFlightFlagstopIndicator = response.FlightRemarks[i].CompositeFlightFlagstopIndicator;
                        remark.DecisionRemarkIndicator          = response.FlightRemarks[i].DecisionRemarkIndicator;
                        remark.PermanentRemarkIndicator         = response.FlightRemarks[i].PermanentRemarkIndicator;
                        remarks.add(remark);
                    }
                }
                flightLeg.remarks = remarks;
            }
        }
    }
    
     public static FlightLeg convertFlightLegFromXmlToInternal(SOA_FlightDetails.FlightLegData flightLegData, String flightMarketingCarrier, String flightNumber) 
    {
        FlightLeg flightLeg = new FlightLeg();

        flightLeg.name                         = makeUniqueName(flightLegData, flightMarketingCarrier, flightNumber);       // String
        flightLeg.MarketingAirlineCode         = flightMarketingCarrier;
        flightLeg.OperatingAirlineCode         = flightLegData.OperatingAirlineCode;                // String
        flightLeg.FlightNumber                 = flightNumber;                                      // String
        //flightLeg.FlightNumber                   = flightLegData.FlightNumber;
        flightLeg.DepartureAirport             = flightLegData.DepartureAirport;                    // String
        flightLeg.ArrivalAirport               = flightLegData.ArrivalAirport;                      // String

        flightLeg.ScheduledDepartureGmtTime    = toString(flightLegData.ScheduledDepartureGmtTime); // DateTime  
        flightLeg.ScheduledDepartureTime       = toString(flightLegData.ScheduledDepartureTime);    // LocalDateTime 
        flightLeg.ScheduledArrivalGmtTime      = toString(flightLegData.ScheduledArrivalGmtTime);   // DateTime
        flightLeg.ScheduledArrivalTime         = toString(flightLegData.ScheduledArrivalTime);      // LocalDateTime
        flightLeg.EstimatedDepartureGmtTime    = toString(flightLegData.EstimatedDepartureGmtTime); // DateTime
        flightLeg.EstimatedDepartureTime       = toString(flightLegData.EstimatedDepartureTime);    // LocalDateTime
        flightLeg.EstimatedArrivalGmtTime      = toString(flightLegData.EstimatedArrivalGmtTime);   // DateTime
        flightLeg.EstimatedArrivalTime         = toString(flightLegData.EstimatedArrivalTime);      // LocalDateTime
        flightLeg.ActualDepartureGmtTime       = toString(flightLegData.ActualDepartureGmtTime);    // DateTime
        flightLeg.ActualDepartureTime          = toString(flightLegData.ActualDepartureTime);       // LocalDateTime
        flightLeg.ActualArrivalTime            = toString(flightLegData.ActualArrivalTime);         // LocalDateTime
        flightLeg.ActualArrivalGmtTime         = toString(flightLegData.ActualArrivalGmtTime);      // DateTime

        flightLeg.DepartureGmtDifference       = flightLegData.DepartureGmtDifference;              // Integer
        flightLeg.DepartureStateCode           = flightLegData.DepartureStateCode;                  // Integer
        flightLeg.ArrivalGmtDifference         = flightLegData.ArrivalGmtDifference;                // Integer
        flightLeg.ArrivalStateCode             = flightLegData.ArrivalStateCode;                    // Integer

        flightLeg.OnTime                       = toString(flightLegData.OnTime);                    // LocalDateTime
        flightLeg.InTime                       = toString(flightLegData.InTime);                    // LocalDateTime
        flightLeg.OutTime                      = toString(flightLegData.OutTime);                   // LocalDateTime
        flightLeg.OffTime                      = toString(flightLegData.OffTime);                   // LocalDateTime

        flightLeg.DepartureGateId              = flightLegData.DepartureGateId;                     // String
        flightLeg.ArrivalGateId                = flightLegData.ArrivalGateId;                       // String

        flightLeg.LegMileage                   = flightLegData.LegMileage;                          // Integer
        flightLeg.ElapsedTime                  = toInteger(flightLegData.ElapsedTime);              // Double
        flightLeg.AccumulatedTime              = toInteger(flightLegData.AccumulatedTime);          // Double
        flightLeg.IndustryStandardAircraftCode = flightLegData.IndustryStandardAircraftCode;        // String
        flightLeg.DeltaAircraftCode            = flightLegData.DeltaAircraftCode;                   // String
        flightLeg.ShipNumber                   = flightLegData.ShipNumber;                          // Integer
        flightLeg.FlightTypeCode               = flightLegData.FlightTypeCode;                      // String
        flightLeg.MovieIndicator               = flightLegData.MovieIndicator;                      // String
        flightLeg.GreatCircleMileage           = flightLegData.GreatCircleMileage;                  // Integer
        flightLeg.ScopeIndicator               = flightLegData.ScopeIndicator;                      // Boolean
        flightLeg.LegReturnIndicator           = flightLegData.LegReturnIndicator;                  // Boolean
        flightLeg.TakeoffNumber                = flightLegData.TakeoffNumber;                       // Integer

        flightLeg.MealCodeForFCabin            = toMealCode(flightLegData.MealCodes, 'F');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForFCabinDesc        = toMealCode(flightLegData.MealCodes, 'F');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForJCabin            = toMealCode(flightLegData.MealCodes, 'J');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForJCabinDesc        = toMealCode(flightLegData.MealCodes, 'J');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForYCabin            = toMealCode(flightLegData.MealCodes, 'Y');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForYCabinDesc        = toMealCode(flightLegData.MealCodes, 'Y');          // MealCodesByCabinClass[]
        flightLeg.MealCodeForOtherCabin        = toMealCode(flightLegData.MealCodes, 'OTHER');      // MealCodesByCabinClass[]
        flightLeg.MealCodeForOtherCabinDesc    = toMealCode(flightLegData.MealCodes, 'OTHER');      // MealCodesByCabinClass[]

        /*flightLeg.airlineDescription           = getAirlineDescription(flightMarketingCarrier);
        flightLeg.departureAirportDescription  = getAirportDescription(flightLegData.DepartureAirport);
        flightLeg.arrivalAirportDescription    = getAirportDescription(flightLegData.ArrivalAirport);
        flightLeg.departureDelay               = getDifference(flightLegData.ScheduledDepartureGmtTime, flightLegData.ActualDepartureGmtTime);
        flightLeg.arrivalDelay                 = getDifference(flightLegData.ScheduledArrivalGmtTime, flightLegData.ActualArrivalGmtTime);
        flightLeg.scheduledDuration            = getDifference(flightLegData.ScheduledDepartureGmtTime, flightLegData.ScheduledArrivalGmtTime);
        flightLeg.actualDuration               = getDifference(flightLegData.ActualDepartureGmtTime, flightLegData.ActualArrivalGmtTime);
        */
        return flightLeg;
    }
    
     public static void doCalloutDetailsWithAircraft(FlightLeg flightLeg) {
        SOA_FlightDetails.RetrieveDetailsWithAircraftRequestType request = new SOA_FlightDetails.RetrieveDetailsWithAircraftRequestType();
        request.AirlineCode      = flightLeg.MarketingAirlineCode;   // 'DL'; // 
        request.FlightNumber     = flightLeg.FlightNumber;           // '74'; // 
        request.FlightOriginDate =  flightLeg.ScheduledDepartureTime.left(10);
 System.Debug('request.FlightOriginDate ' + request.FlightOriginDate);
        //request.FlightOriginDate = DateTime.newInstance(originDate.year(), originDate.month(), originDate.Day(), 0, 0, 0).format('YYY-MM-DD'); //'2016-04-11'; // 
        //request.FlightOriginDate = '2016-04-11'; // TODO put in originDate


        if(flightLeg.delayCodes == Null) {
            flightLeg.delayCodes = new FlightDelay[]{};
        }

        SOA_FlightDetails.FlightDetails_EP doer = new SOA_FlightDetails.FlightDetails_EP();
        SOA_FlightDetails.RetrieveDetailsWithAircraftResponseType response = doer.RetrieveDetailsWithAircraft(request);
        system.debug('response check --> '+response);
        if(response != Null) {
            
            if(response.FlightData != Null) {  // SOA_FlightDetails.FlightDataType flightData : 
                if(response.FlightData.FlightLegData != Null) {
                    for(SOA_FlightDetails.FlightLegDataType flightLegData : response.FlightData.FlightLegData) {
system.debug('before value');                     
                     flightLeg.cancelIndicator               = flightLegData.CancelIndicator;
                        flightLeg.flightCancellationReasonCode  = flightLegData.FlightCancellationReasonCode;

                    flightLeg.actualInTimestamp             = flightLegData.ActualInTimestamp;
                    flightLeg.actualOnTimestamp             = flightLegData.ActualOnTimestamp;
                    flightLeg.actualOutTimestamp            = flightLegData.ActualOutTimestamp;
                    flightLeg.actualOffTimestamp            = flightLegData.ActualOffTimestamp;
                    flightLeg.actualInGMTTimestamp          = flightLegData.ActualInGMTTimestamp;
                    flightLeg.actualOnGMTTimestamp          = flightLegData.ActualOnGMTTimestamp;
                    flightLeg.actualOutGMTTimestamp         = flightLegData.ActualOutGMTTimestamp;
                    flightLeg.actualOffGMTTimestamp         = flightLegData.ActualOffGMTTimestamp;

                    flightLeg.scheduleArrivalTimestamp      = flightLegData.ScheduleArrivalTimestamp;
                    flightLeg.scheduleDepartureTimestamp    = flightLegData.ScheduleDepartureTimestamp;
                    flightLeg.scheduleArrivalGMTTimestamp   = flightLegData.ScheduleArrivalGMTTimestamp;
                    flightLeg.scheduleDepartureGMTTimestamp = flightLegData.ScheduleDepartureGMTTimestamp;
                flightLeg.OperatingFlightNumber         = flightLegData.OperationalFlightNumber;
system.debug('before value 1');
                        if(flightLegData.DepartureAirportCode == flightLeg.DepartureAirport && flightLegData.FlightLegDelay != Null) {
                            system.debug('checking');
                            for(SOA_FlightDetails.FlightLegDelayType flightLegDelay : flightLegData.FlightLegDelay) {
                                system.debug('checking 1');
                                FlightDelay internalDelayCode = new FlightDelay();
                                internalDelayCode.DelayGMTTimestamp                               = flightLegDelay.DelayGMTTimestamp;
                               // internalDelayCode.DelayRemarkText                                 = flightLegDelay.DelayRemarkText.left(CWSchema.getFieldLength('Delay_Code__c', 'DelayRemarkText__c'));
                                internalDelayCode.EstimatedDelayMinuteCount                       = flightLegDelay.EstimatedDelayMinuteCount;
                                internalDelayCode.FirstAlternateDepartureDelayMinuteCount         = flightLegDelay.FirstAlternateDepartureDelayMinuteCount;
                                internalDelayCode.FirstAlternateDepartureDelayReasonCode          = flightLegDelay.FirstAlternateDepartureDelayReasonCode;
                                internalDelayCode.FirstAlternateDepartureDelayResponsibilityCode  = flightLegDelay.FirstAlternateDepartureDelayResponsibilityCode;
                                internalDelayCode.MakeUpDepartureDelayMinuteCount                 = flightLegDelay.MakeUpDepartureDelayMinuteCount;
                                internalDelayCode.MakeUpDepartureDelayReasonCode                  = flightLegDelay.MakeUpDepartureDelayReasonCode;
                                internalDelayCode.MakeUpDepartureDelayResponsibilityCode          = flightLegDelay.MakeUpDepartureDelayResponsibilityCode;
                                internalDelayCode.PrimaryDepartureDelayMinuteCount                = flightLegDelay.PrimaryDepartureDelayMinuteCount;
                                internalDelayCode.PrimaryDepartureDelayReasonCode                 = flightLegDelay.PrimaryDepartureDelayReasonCode;
                                internalDelayCode.PrimaryDepartureDelayResponsibilityCode         = flightLegDelay.PrimaryDepartureDelayResponsibilityCode;
                                internalDelayCode.SecondAlternateDepartureDelayMinuteCount        = flightLegDelay.SecondAlternateDepartureDelayMinuteCount;
                                internalDelayCode.SecondAlternateDepartureDelayReasonCode         = flightLegDelay.SecondAlternateDepartureDelayReasonCode;
                                internalDelayCode.SecondAlternateDepartureDelayResponsibilityCode = flightLegDelay.SecondAlternateDepartureDelayResponsibilityCode;
                                flightLeg.delayCodes.add(internalDelayCode);
                            }
                        }
                    }
                }
            }
        }
    }
     public static String makeUniqueName(SOA_FlightDetails.FlightLegData flightLegXml, String flightMarketingCarrier, String flightNumber) 
    {
        return makeUniqueName(flightMarketingCarrier, makeFourDigits(flightNumber), flightLegXml.ScheduledDepartureTime.DateTimeString.left(10), flightLegXml.DepartureAirport, flightLegXml.ArrivalAirport); 
    }

    public static String makeUniqueName(String flightMarketingCarrier, String flightNumber, String flightDate, String origin, String destination) 
    {
        return flightMarketingCarrier.touppercase() + makeFourDigits(flightNumber) + ' ' + flightDate + ' ' + origin + ' ' + destination; 
    }
    
    public static String format(Date d) 
    {
        if (d == null) return null;
        return DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).format('ddMMM');
    }

    // new function
    public static String format(Date d, String theFormat) 
    {
        if (d == null || theFormat == null) return null;
        return DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).format(theFormat);
    }
    
     public static List<FlightMember> fetchCrewMembers(Flightleg flightLegInternal) 
    {
        SOA_CrwListWS.crwListByFltRspn response = doCalloutsCrew(flightLegInternal.OperatingAirlineCode, flightLegInternal.FlightNumber, flightLegInternal.DepartureAirport, flightLegInternal.ArrivalAirport, extractDate(flightLegInternal.ScheduledDepartureGMTTime));
        List<FlightMember> crewMembers = extractFlightMembersFromCrewList(response);
        system.debug('crew members --> '+crewMembers);
        return crewMembers;
    }
    
    // compared with Dev2
    public static SOA_CrwListWS.crwListByFltRspn doCalloutsCrew(String carrier, String flightNumber, String originAirport, String destinationAirport, Date flightDate) 
    {
        SOA_CrwListWS.crwListByFltReq request = new SOA_CrwListWS.crwListByFltReq();

        request.crrCd      = carrier;                                          
        request.fltNb      = flightNumber;                                 
        request.origArptCd = originAirport;                       
        request.destArptCd = destinationAirport;               
        request.fltDt      = DateTime.newInstance(flightDate, Time.newInstance(12, 0, 0, 0)).format('yyyy/MM/dd');
//System.Debug('Request for doCalloutsCrews\n' + request);
        SOA_CrwListWS.CrwListServicePort doer = new SOA_CrwListWS.CrwListServicePort();
        SOA_CrwListWS.crwListByFltRspn result = doer.getCrwByFlt(request);
//System.Debug('A:Result from doCalloutsCrews\n' + result);
//System.Debug('B:Result from doCalloutsCrews\n' + JSON.serializePretty(result));
        return result;
    }

     public static List<Case_Complaint__c> queryCaseComplaints( string whereClause )
    {
        if (complaintFields == null)
        {
            complaintFields = '';
            complaintFields += 'Id, Flight_Leg__c,Case__c,';
            complaintFields += 'Complaint_Code__r.Display_Name__c,';
            complaintFields += 'Complaint_Location__c,';
            complaintFields += 'Flight_Leg__r.Name,';
            complaintFields += 'Flight_Leg__r.MarketingAirlineCode__c,';
            complaintFields += 'Flight_Leg__r.OperatingAirlineCode__c,';
            complaintFields += 'Flight_Leg__r.FlightNumber__c,';
            complaintFields += 'Flight_Leg__r.DepartureAirport__c,';
            complaintFields += 'Flight_Leg__r.ArrivalAirport__c,';
            complaintFields += 'Flight_Leg__r.ScheduledDepartureTime__c,';
            complaintFields += 'Flight_Leg__r.ScheduledArrivalTime__c,';
            complaintFields += 'Flight_Leg__r.ActualDepartureTime__c,';
            complaintFields += 'Flight_Leg__r.ActualArrivalTime__c,';
            complaintFields += 'Flight_Leg__r.InTime__c,';
            complaintFields += 'Flight_Leg__r.OutTime__c,';
            complaintFields += 'Flight_Leg__r.OffTime__c,';
            complaintFields += 'Flight_Leg__r.OnTime__c,';
            complaintFields += 'Flight_Leg__r.LegMileage__c,';
            complaintFields += 'Flight_Leg__r.Alerts__c';
        }

        if (whereClause == null) return new List<Case_Complaint__c>();
        String queryString = 'SELECT ' + complaintFields + ' FROM Case_Complaint__c WHERE ' + whereClause;
        queryString += ' ORDER BY Flight_Leg__r.ScheduledDepartureTime__c NULLS FIRST';
        List<Case_Complaint__c> complaintsList = Database.Query(queryString);
        return complaintsList;
    }

    
    public class searchParameters
  {  
      public String          Carrier          { get; set; }
      public String          FlightNumber     { get; set; }
      public String          OperatingFlightNumber     { get; set; }//added by anil
      public String          Origin           { get; set; }
      public String          Destination      { get; set; }
      public Task            Task             { get; set; }
      public String          PNR              { get; set; }
      public Date            DepartureDate  { get; set; }
      public String       airlineCodeOverride;    // null unless explicitly overwritten
      public String        airlineCode      
      { 
        get{ return (String.isBlank(airlineCodeOverride) ? getCodeFromString(Carrier) : airlineCodeOverride); }
        set; 
      }
      // if doCalloutsDetails ( which is called by clickSearch in the Controller and ExtractFlightLegsFromPnr)
      //  if called from the controller it will be passed in a searchParameters with controller parameters holding page input
      //  if called from ExtractFlightLegsFromPnr airlineCodeOverride holds the origin value from the Pnr segment
  }
  
  public class Complaint 
    {
        public Id      id                     { get; set; }
        public Integer caseCount              { get{ return (caseCount == null || caseCount == 0) ? null : caseCount; } set; }
        public string operatingFlightNumber {get; set;}
        public Decimal compAvg                { get; set; }
        public String  compAvgString                
        { 
            get
            {
                compAvgString = '';
                if (compAvg != null && compAvg > 0) compAvgString += ('$' + (Math.round(compAvg * 100.0))/100.0);
                return compAvgString;
            }
            set; 
        }

        public String  complaintDescription   { get; set; }
        public String  complaintLocation      { get; set; }

        public Id      flightID               { get; set; }
        public Boolean hasFlightID            { get {return flightID == null ? false : true; } set; }
        public String  flightName             { get; set; }
        public Flight_Leg__c flightLeg        { get; set; }
        public String  marketingAirlineCode   { get; set; }
        public String  operatingAirlineCode   { get; set; }
        public String  departureAirport       { get; set; }
        public String  arrivalAirport         { get; set; }
        public String  flightNumber           { get; set; }
        //public String  LightningFltNumber     { get { return operatingAirlineCode + ' ' + FlightNumber; } set; }
        public String  LightningFltNumber     { get { return operatingAirlineCode + ' ' + operatingFlightNumber; } set; }
        public String  outTime                { get; set; }
        public String  inTime                 { get; set; }
        public String  offTime                { get; set; }
        public String  onTime                 { get; set; }
        public String  actualArrivalTime      { get; set; }
        public String  actualDepartureTime    { get; set; }
        public String  scheduledArrivalTime   { get; set; }
        public String  LightningArrivalTime   { get{ return FlightLegUtils.LightningFriendlyDateTime(scheduledArrivalTime); } set; }
        public String  scheduledDepartureTime { get; set; }
        public String  LightningDepartureTime { get{ return FlightLegUtils.LightningFriendlyDateTime(scheduledDepartureTime); } set; }
        public String  mileage                { get; set; }
    }

  public class FlightMember 
    {
        public Id       id         { get; set; }

        public String   firstName  { get; set; }
        public String   middleName { get; set; }
        public String   lastName   { get; set; }

        public String   mbrIdNb    { get; set; }
        public String   mbrNm      { get; set; }
        public String   mbrTypCd   { get; set; }
        public String   mbrPsptNm  { get; set; }
        public String   pstnCd     { get; set; }
//        public DateTime rotnBegDt  { get; set; }
        public String   rotnDupNb  { get; set; }
        public String   rotnNb     { get; set; }
        public String   rotnPstnCd { get; set; }

        public String   BsAssgn    { get; set; }
        public String   EmplDt     { get; set; }
        public String   EmplFrstNm { get; set; }
        public String   EmplLstNm  { get; set; }
        public String   EmplMidNm  { get; set; }
        public String   FADeptNb   { get; set; }
        public String   FAFsmBase  { get; set; }
        public String   FAFsmId    { get; set; }
        public String   MgrFrstNm  { get; set; }
        public String   MgrLstNm   { get; set; }
        public String   MgrNb      { get; set; }
        public String   SnrtyDt    { get; set; }
        public String   SnrtyNb    { get; set; }
        
        public String   city       { get; set; }  // orig dev2
        public String   supervisor { get; set; }  // orig dev2
    }
    
    public class FlightRemark 
    {
        public String  RemarksText                      { get; set; }
        public String  CityCode                         { get; set; }
        public Boolean FlightHistoryExistsIndicator     { get; set; }
        public Boolean CompositeFlightNoOpIndicator     { get; set; }
        public Boolean CompositeFlightStubbedIndicator  { get; set; }
        public Boolean CompositeFlightFlagstopIndicator { get; set; }
        public Boolean DecisionRemarkIndicator          { get; set; }
        public Boolean PermanentRemarkIndicator         { get; set; }
    }

    public class FlightFactsInfo 
    {
        public Boolean NoDisplayableFactsItems { get; set; }
        public Integer FactsItemNumber         { get; set; }
        public String FactsText                { get; set; }
    }
    
     public class FlightDelay 
    {
        public String   DelayGMTTimestamp                               { get; set; }
        public String   DelayRemarkText                                 { get; set; }
        public String   EstimatedDelayMinuteCount                       { get; set; }
        public String   FirstAlternateDepartureDelayMinuteCount         { get; set; }
        public String   FirstAlternateDepartureDelayReasonCode          { get; set; }
        public String   FirstAlternateDepartureDelayResponsibilityCode  { get; set; }
        public String   MakeUpDepartureDelayMinuteCount                 { get; set; }
        public String   MakeUpDepartureDelayReasonCode                  { get; set; }
        public String   MakeUpDepartureDelayResponsibilityCode          { get; set; }
        public String   PrimaryDepartureDelayMinuteCount                { get; set; }
        public String   PrimaryDepartureDelayReasonCode                 { get; set; }
        public String   PrimaryDepartureDelayResponsibilityCode         { get; set; }
        public String   SecondAlternateDepartureDelayMinuteCount        { get; set; }
        public String   SecondAlternateDepartureDelayReasonCode         { get; set; }
        public String   SecondAlternateDepartureDelayResponsibilityCode { get; set; }
    }
    
    //Wrapper for flight info
     public class FlightLeg 
    {
        public String  ComplaintDescription         { get; set; }  // orig dev 2
        public String  ComplaintLocation            { get; set; }  // orig dev 2

        public Id      id                           { get; set; }
        public Boolean hasFlightID                { get {return id == null ? false : true; } set; }
        public Flight_Leg__c flightLeg              { get; set; }
//        public Case_Complaint__c complaint          { get; set; }
        public Integer index                        { get; set; }
        public String  name                         { get; set; }
        public String  error                        { get; set; }
        public Integer caseCount                    { get{ return (caseCount == null || caseCount == 0) ? null : caseCount; } set; }
        public String  alertString                  { get; set; }
        public Decimal compAvg                      { get; set; }
        public String  compAvgString                
        { 
            get
            {
                compAvgString = '';
                if (compAvg != null && compAvg > 0) compAvgString += ('$' + (Math.round(compAvg * 100.0))/100.0);
                return compAvgString;
            }
            set; 
        }
        public Boolean showCheck                    { get; set; }

        public String  MarketingAirlineCode         { get; set; }
        public String  OperatingAirlineCode         { get; set; }
        public String  DepartureAirport             { get; set; }
        public String  ArrivalAirport               { get; set; }

        public String  ScheduledDepartureGMTTime    { get; set; }
        public String  ScheduledDepartureTime       { get; set; }
        public String  LightningDepartureTime       { get{ return FlightLegUtils.LightningFriendlyDateTime(ScheduledDepartureTime); } set; }


        public String  ScheduledArrivalGMTTime      { get; set; }
        public String  ScheduledArrivalTime         { get; set; }
        public String  LightningArrivalTime         { get{ return FlightLegUtils.LightningFriendlyDateTime(ScheduledArrivalTime); } set; }

        public String  EstimatedDepartureGMTTime    { get; set; }
        public String  EstimatedDepartureTime       { get; set; }
        public String  EstimatedArrivalGMTTime      { get; set; }
        public String  EstimatedArrivalTime         { get; set; }
        public String  ActualDepartureGMTTime       { get; set; }
        public String  ActualDepartureTime          { get; set; }
        public String  ActualArrivalGMTTime         { get; set; }
        public String  ActualArrivalTime            { get; set; }

        public Integer DepartureGMTDifference       { get; set; }
        public Integer ArrivalGMTDifference         { get; set; }

        public String  InTime                       { get; set; }
        public String  OutTime                      { get; set; }
        public String  OffTime                      { get; set; }
        public String  OnTime                       { get; set; }

        public String  DepartureGateID              { get; set; }
        public String  ArrivalGateID                { get; set; }
        public Integer DepartureStateCode           { get; set; }
        public Integer ArrivalStateCode             { get; set; }

        public String  DeltaAircraftCode            { get; set; }
        public Integer ElapsedTime                  { get; set; }
        public String  FlightNumber                 { get; set; }
        public String  OperatingFlightNumber        { get; set; }
        public String  LightningFltNumber           
        { 
            get 
            { 
                return (operatingAirlineCode == null ? 
                                MarketingAirlineCode.touppercase() : 
                                operatingAirlineCode.touppercase()) + ' ' + (operatingFlightNumber == null ? FlightNumber : operatingFlightNumber); 
            } 
            set; 
        }
        
        public String  FlightTypeCode               { get; set; }
        public Integer GreatCircleMileage           { get; set; }
        public String  IndustryStandardAircraftCode { get; set; }
        public Integer LegMileage                   { get; set; }
        public Boolean LegReturnIndicator           { get; set; }
        public String  MovieIndicator               { get; set; }
        public Integer AccumulatedTime              { get; set; }
        public Boolean ScopeIndicator               { get; set; }
        public Integer ShipNumber                   { get; set; }
        public Integer TakeoffNumber                { get; set; }

        public String  MealCodeForFCabin            { get; set; }
        public String  MealCodeForFCabinDesc        { get; set; }
        public String  MealCodeForJCabin            { get; set; }
        public String  MealCodeForJCabinDesc        { get; set; }
        public String  MealCodeForYCabin            { get; set; }
        public String  MealCodeForYCabinDesc        { get; set; }
        public String  MealCodeForOtherCabin        { get; set; }
        public String  MealCodeForOtherCabinDesc    { get; set; }

        public FlightMember[] crew                  { get; set; }
        public FlightRemark[] remarks               { get; set; }
        public FlightDelay[]  delayCodes            { get; set; }

        public Boolean attached                     { get; set; }
        public String  hoverInformation             { get; set; }
        public String  airlineDescription           { get; set; }
        public String  departureAirportDescription  { get; set; }
        public String  arrivalAirportDescription    { get; set; }
        public String  departureDelay               { get; set; }
        public String  arrivalDelay                 { get; set; }
        public String  scheduledDuration            { get; set; }
        public String  actualDuration               { get; set; }

        public String  cancelIndicator              { get; set; }
        public String  flightCancellationReasonCode { get; set; }

        // --- Flight Information Fields
        public String  BoardCity                              { get; set; }
        public Boolean BoardCityCancelledIndicator            { get; set; }
        public String  EquipmentType                          { get; set; }
        public Boolean FlagstopIndicator                      { get; set; }
        public String  InflightDateAdjustmentForArrivalTime   { get; set; }
        public String  InflightDateAdjustmentForDepartureTime { get; set; }
        public String  EstimatedTimeOfArrival                 { get; set; }
        public String  EstimatedTimeOfDeparture               { get; set; }
        public Integer Mileage                                { get; set; }
        public Boolean ETATimeIsEstimated                     { get; set; }
        public Boolean ETDTimeIsEstimated                     { get; set; }
        public String  OriginOfStub                           { get; set; }

    public String  ActualInTimestamp                      { get; set; }
    public String  ActualOnTimestamp                      { get; set; }
    public String  ActualOutTimestamp                     { get; set; }
    public String  ActualOffTimestamp                     { get; set; }
    public String  ActualInGMTTimestamp                   { get; set; }
    public String  ActualOnGMTTimestamp                   { get; set; }
    public String  ActualOutGMTTimestamp                  { get; set; }
    public String  ActualOffGMTTimestamp                  { get; set; }

    public String  ScheduleArrivalTimestamp               { get; set; }
    public String  ScheduleDepartureTimestamp             { get; set; }
    public String  ScheduleArrivalGMTTimestamp            { get; set; }
    public String  ScheduleDepartureGMTTimestamp          { get; set; }
    }
    
    public static Id saveFlightLeg(FlightLeg flightLeg) 
    {
    if (flightLeg == null) 
    {
      return null;
    }
    skyFinderUtils.idTupple myIDTupple = skyFinderUtils.validateID( flightLeg.id );
    if (myIDTupple.isValid && myIDTupple.myType == Flight_Leg__c.sObjectType) return flightLeg.id;

        flightLeg.id = null;  // just in case it passed above because it wasn't valid but isn't blank
        Flight_Leg__c flightLegDb = convertFlightLegFromInternalToDatabase(flightLeg);
        insert flightLegDb;
        system.debug('crew check');
        // --- create a new flight leg
        if(flightLeg.crew != Null) {
            system.debug('crew check 1');
            Map<String, Account> mapFromFlightMemberNumberToContact = new Map<String, Account>();
            for(FlightMember member : flightLeg.crew) {
                if(String.isNotBlank(member.mbrIdNb)) {
                    mapFromFlightMemberNumberToContact.put(member.mbrIdNb, Null);
                }
            }
            
            system.debug('crew check');
            for(Account Account : [
                SELECT Id, Employee_Member_Id_Number__pc
                FROM   Account
                WHERE  Employee_Member_Id_Number__pc IN :mapFromFlightMemberNumberToContact.keySet()
            ]) {
                mapFromFlightMemberNumberToContact.put(Account.Employee_Member_Id_Number__pc, Account);
            }
            
            system.debug('crew check');
            List<Account> contactsToInsert = new List<Account>();
            set<id> crew = new set<id>();
            for(FlightMember member : flightLeg.crew) {
                if(mapFromFlightMemberNumberToContact.get(member.mbrIdNb) == Null) {
                    Account newContact = makeNewContact(member);
                    newContact.Flight_Crew_from_Apex__c = true;
                    //mapFromFlightMemberNumberToContact.put(member.mbrIdNb, newContact);
                    contactsToInsert.add(newContact);
                }
                
            }
            //insert contactsToInsert;
            set<id> personAccount = new set<id>();
            Database.SaveResult[] srList = database.insert(contactsToInsert,false);
            for (Database.SaveResult sr : srList)
            {   system.debug('sr value --> '+sr);
                if(sr.isSuccess())
                {
                    system.debug('inside if');
                    personAccount.add(sr.getId());
                }
            }
            system.debug('account ids --> '+personAccount);
            for(Account crewAdded : [select id,Employee_Member_Id_Number__pc from account where id IN :personAccount])
            {
                mapFromFlightMemberNumberToContact.put(crewAdded.Employee_Member_Id_Number__pc,crewAdded);
            }
            
            system.debug(' before flight crew check');
            List<Flight_Staff__c> flightStaffToInsert = new List<Flight_Staff__c>();
            for(FlightMember member : flightLeg.crew) {
                system.debug('member value --> '+member);
                if(mapFromFlightMemberNumberToContact.get(member.mbrIdNb).Id != null){
                    Flight_Staff__c newFlightMember = convertFlightStaffFromInternalToDatabase(flightLegDb.Id, member, mapFromFlightMemberNumberToContact.get(member.mbrIdNb).Id);
                    flightStaffToInsert.add(newFlightMember);
                }
            }
            system.debug('flight staff --> '+flightStaffToInsert.size());
            insert flightStaffToInsert;
            //Database.SaveResult[] srList1 = database.insert(flightStaffToInsert,false);
            
        }

        if(flightLeg.delayCodes != Null) {
            List<Delay_Code__c> delayCodesToInsert = new List<Delay_Code__c>();
            for(FlightDelay delayCode : flightLeg.delayCodes) {
                Delay_Code__c newDelayCode = convertDelayCodeFromInternalToDatabase(flightLegDb.Id, delayCode);
                delayCodesToInsert.add(newDelayCode);
            }
            insert delayCodesToInsert;
        }
        flightLeg.id = flightLegDb.Id;
        return flightLegDb.Id;
        // TODO count cases and compute compensation for newly attached flightleg
    }
    
     public static Flight_Leg__c convertFlightLegFromInternalToDatabase(FlightLeg flightLeg) {
        Flight_Leg__c flightLegDb = new Flight_Leg__c();

        flightLegDb.Name                             = flightLeg.name;
        flightLegDb.MarketingAirlineCode__c          = flightLeg.MarketingAirlineCode;
        flightLegDb.OperatingAirlineCode__c          = flightLeg.OperatingAirlineCode;
        flightLegDb.FlightNumber__c                  = makeFourDigits(flightLeg.flightNumber);
        flightLegDb.OperatingFlightNumber__c         = makeFourDigits(flightLeg.flightNumber); //makeFourDigits(flightLeg.OperatingFlightNumber);
        flightLegDb.DepartureAirport__c              = flightLeg.DepartureAirport;
        flightLegDb.ArrivalAirport__c                = flightLeg.ArrivalAirport;
        flightLegDb.OperlArlnCd__c                   = flightLeg.OperatingAirlineCode;
        flightLegDb.OperlArlnNbr__c                  = flightLeg.OperatingFlightNumber;

        flightLegDb.ScheduledDepartureGmtTime__c     = flightLeg.ScheduledDepartureGmtTime;
        flightLegDb.ScheduledDepartureTime__c        = flightLeg.ScheduledDepartureTime;
        flightLegDb.ScheduledArrivalGmtTime__c       = flightLeg.ScheduledArrivalGmtTime;
        flightLegDb.ScheduledArrivalTime__c          = flightLeg.ScheduledArrivalTime;
        flightLegDb.EstimatedDepartureGmtTime__c     = flightLeg.EstimatedDepartureGmtTime;
        flightLegDb.EstimatedDepartureTime__c        = flightLeg.EstimatedDepartureTime;
        flightLegDb.EstimatedArrivalGmtTime__c       = flightLeg.EstimatedArrivalGmtTime;
        flightLegDb.EstimatedArrivalTime__c          = flightLeg.EstimatedArrivalTime;
        flightLegDb.ActualDepartureGmtTime__c        = flightLeg.ActualDepartureGmtTime;
        flightLegDb.ActualDepartureTime__c           = flightLeg.ActualDepartureTime;
        flightLegDb.ActualArrivalTime__c             = flightLeg.ActualArrivalTime;
        flightLegDb.ActualArrivalGmtTime__c          = flightLeg.ActualArrivalGmtTime;

        flightLegDb.DepartureGmtDifference__c        = String.valueOf(flightLeg.DepartureGmtDifference);
        flightLegDb.DepartureStateCode__c            = String.valueOf(flightLeg.DepartureStateCode);
        flightLegDb.ArrivalGmtDifference__c          = String.valueOf(flightLeg.ArrivalGmtDifference);
        flightLegDb.ArrivalStateCode__c              = String.valueOf(flightLeg.ArrivalStateCode);

        flightLegDb.OnTime__c                        = flightLeg.OnTime;
        flightLegDb.InTime__c                        = flightLeg.InTime;
        flightLegDb.OutTime__c                       = flightLeg.OutTime;
        flightLegDb.OffTime__c                       = flightLeg.OffTime;
        system.debug('value leg mileage --> '+flightLeg.LegMileage);
        flightLegDb.LegMileage__c                    = flightLeg.LegMileage;
        flightLegDb.ElapsedTime__c                   = String.valueOf(flightLeg.ElapsedTime);
        flightLegDb.AccumulatedTime__c               = String.valueOf(flightLeg.AccumulatedTime);
        flightLegDb.IndustryStandardAircraftCode__c  = flightLeg.IndustryStandardAircraftCode;
        flightLegDb.DeltaAircraftCode__c             = flightLeg.DeltaAircraftCode;
        flightLegDb.ShipNumber__c                    = String.valueOf(flightLeg.ShipNumber);
        flightLegDb.FlightTypeCode__c                = flightLeg.FlightTypeCode;
        flightLegDb.DepartureGateId__c               = flightLeg.DepartureGateId;
        flightLegDb.ArrivalGateId__c                 = flightLeg.ArrivalGateId;
        flightLegDb.MovieIndicator__c                = flightLeg.MovieIndicator;
        flightLegDb.GreatCircleMileage__c            = flightLeg.GreatCircleMileage;
        flightLegDb.ScopeIndicator__c                = flightLeg.ScopeIndicator;
        flightLegDb.LegReturnIndicator__c            = flightLeg.LegReturnIndicator;
        flightLegDb.TakeoffNumber__c                 = flightLeg.TakeoffNumber;

        flightLegDb.MealCodeForFCabin__c             = flightLeg.MealCodeForFCabin;
        flightLegDb.MealCodeForFCabinDesc__c         = flightLeg.MealCodeForFCabinDesc;
        flightLegDb.MealCodeForJCabin__c             = flightLeg.MealCodeForJCabin;
        flightLegDb.MealCodeForJCabinDesc__c         = flightLeg.MealCodeForJCabinDesc;
        flightLegDb.MealCodeForYCabin__c             = flightLeg.MealCodeForYCabin;
        flightLegDb.MealCodeForYCabinDesc__c         = flightLeg.MealCodeForYCabinDesc;
        flightLegDb.MealCodeForOtherCabin__c         = flightLeg.MealCodeForOtherCabin;
        flightLegDb.MealCodeForOtherCabinDesc__c     = flightLeg.MealCodeForOtherCabinDesc;

        flightLegDb.Departure_Delay__c               = flightLeg.departureDelay;
        flightLegDb.Arrival_Delay__c                 = flightLeg.arrivalDelay;
        flightLegDb.Scheduled_Duration__c            = flightLeg.scheduledDuration;
        flightLegDb.Actual_Duration__c               = flightLeg.actualDuration;
        flightLegDb.CancelIndicator__c               = flightLeg.cancelIndicator;
        flightLegDb.FlightCancellationReasonCode__c  = flightLeg.flightCancellationReasonCode;

        flightLegDb.BoardCity__c                              = flightLeg.BoardCity;
        flightLegDb.BoardCityCancelledIndicator__c            = flightLeg.BoardCityCancelledIndicator == Null ? False : flightLeg.BoardCityCancelledIndicator;
        flightLegDb.EquipmentType__c                          = flightLeg.EquipmentType;
        flightLegDb.FlagstopIndicator__c                      = flightLeg.FlagstopIndicator == Null ? False : flightLeg.FlagstopIndicator;
//      flightLegDb.InflightDateAdjustmentForArrivalTime__c   = flightLeg.InflightDateAdjustmentForArrivalTime;
//      flightLegDb.InflightDateAdjustmentForDepartureTime__c = flightLeg.InflightDateAdjustmentForDepartureTime;
//      flightLegDb.EstimatedTimeOfArrival__c                 = flightLeg.EstimatedTimeOfArrival;
//      flightLegDb.EstimatedTimeOfDeparture__c               = flightLeg.EstimatedTimeOfDeparture;
        flightLegDb.Mileage__c                                = flightLeg.Mileage;
//      flightLegDb.ETATimeIsEstimated__c                     = flightLeg.ETATimeIsEstimated;
//      flightLegDb.ETDTimeIsEstimated__c                     = flightLeg.ETDTimeIsEstimated;
//      flightLegDb.OriginOfStub__c                           = flightLeg.OriginOfStub;

      flightLegDb.ActualInTimestamp__c             = flightLeg.actualInTimestamp;
      flightLegDb.ActualOnTimestamp__c             = flightLeg.actualOnTimestamp;
      flightLegDb.ActualOutTimestamp__c            = flightLeg.actualOutTimestamp;
      flightLegDb.ActualOffTimestamp__c            = flightLeg.actualOffTimestamp;
      flightLegDb.ActualInGMTTimestamp__c          = flightLeg.actualInGMTTimestamp;
        flightLegDb.ActualOnGMTTimestamp__c          = flightLeg.actualOnGMTTimestamp;
      flightLegDb.ActualOutGMTTimestamp__c         = flightLeg.actualOutGMTTimestamp;
      flightLegDb.ActualOffGMTTimestamp__c         = flightLeg.actualOffGMTTimestamp;

      flightLegDb.ScheduleArrivalTimestamp__c      = flightLeg.scheduleArrivalTimestamp;
        flightLegDb.ScheduleDepartureTimestamp__c    = flightLeg.scheduleDepartureTimestamp;
        flightLegDb.ScheduleArrivalGMTTimestamp__c   = flightLeg.scheduleArrivalGMTTimestamp;
        flightLegDb.ScheduleDepartureGMTTimestamp__c = flightLeg.scheduleDepartureGMTTimestamp;
        
        return flightLegDb;
    }
    
     public static Account makeNewContact(FlightMember flightMember) 
    {
        return new Account(
            RecordTypeId                 = SkyFinderUtils.contactEmployeeRecordType.Id,
           // Account                      = SkyFinderUtils.deltaAccount,
            FirstName                    = flightMember.firstName,
            LastName                     = flightMember.lastName,
            Employee_Member_Id_Number__pc = flightMember.mbrIdNb
            
        );
    }
    
    public static Delay_Code__c convertDelayCodeFromInternalToDatabase(Id flightLegId, FlightDelay internalDelayCode) {
        Delay_Code__c databaseDelayCode = new Delay_Code__c();
        
        databaseDelayCode.Flight_Leg__c                               = flightLegId;
        /*databaseDelayCode.DelayGMTTimestamp__c                        = internalDelayCode.DelayGMTTimestamp;
        databaseDelayCode.DelayRemarkText__c                          = internalDelayCode.DelayRemarkText;
        databaseDelayCode.EstimatedDelayMinuteCount__c                = internalDelayCode.EstimatedDelayMinuteCount;
        databaseDelayCode.FirstAlternateDepartureDelayMinuteCount__c  = internalDelayCode.FirstAlternateDepartureDelayMinuteCount;
        databaseDelayCode.FirstAlternateDepartureDelayReasonCode__c   = internalDelayCode.FirstAlternateDepartureDelayReasonCode;
        databaseDelayCode.FirstAlternateDepartureDelayResponsibili__c = internalDelayCode.FirstAlternateDepartureDelayResponsibilityCode;
        databaseDelayCode.MakeUpDepartureDelayMinuteCount__c          = internalDelayCode.MakeUpDepartureDelayMinuteCount;
        databaseDelayCode.MakeUpDepartureDelayReasonCode__c           = internalDelayCode.MakeUpDepartureDelayReasonCode;
        databaseDelayCode.MakeUpDepartureDelayResponsibilityCode__c   = internalDelayCode.MakeUpDepartureDelayResponsibilityCode;
        databaseDelayCode.PrimaryDepartureDelayMinuteCount__c         = internalDelayCode.PrimaryDepartureDelayMinuteCount;
        databaseDelayCode.PrimaryDepartureDelayReasonCode__c          = internalDelayCode.PrimaryDepartureDelayReasonCode;
        databaseDelayCode.PrimaryDepartureDelayResponsibilityCode__c  = internalDelayCode.PrimaryDepartureDelayResponsibilityCode;
        databaseDelayCode.SecondAlternateDepartureDelayMinuteCount__c = internalDelayCode.SecondAlternateDepartureDelayMinuteCount;
        databaseDelayCode.SecondAlternateDepartureDelayReasonCode__c  = internalDelayCode.SecondAlternateDepartureDelayReasonCode;
        databaseDelayCode.SecondAlternateDepartureDelayResponsibil__c = internalDelayCode.SecondAlternateDepartureDelayResponsibilityCode;
        databaseDelayCode.PrimaryDepartureDelayCodeDefinition__c      = getDelayCodeIdForDelayCodeName(internalDelayCode.PrimaryDepartureDelayReasonCode         + internalDelayCode.PrimaryDepartureDelayResponsibilityCode);
        databaseDelayCode.FirstAlternateDelayCodeDefinition__c         = getDelayCodeIdForDelayCodeName(internalDelayCode.FirstAlternateDepartureDelayReasonCode  + internalDelayCode.FirstAlternateDepartureDelayResponsibilityCode);
        databaseDelayCode.SecondAlternateDelayCodeDefinition__c       = getDelayCodeIdForDelayCodeName(internalDelayCode.SecondAlternateDepartureDelayReasonCode + internalDelayCode.SecondAlternateDepartureDelayResponsibilityCode);
        */
        return databaseDelayCode;
    }
    
    public static Complaint convertCaseComplaintFromDatabaseToInternal(Case_Complaint__c databaseComplaint) 
    {
        Complaint internalComplaint = new Complaint();
        internalComplaint.operatingFlightNumber =  databaseComplaint.Flight_Leg__r.OperatingFlightNumber__c;
        internalComplaint.flightLeg              = databaseComplaint.Flight_Leg__r != null ? databaseComplaint.Flight_Leg__r : new Flight_Leg__c();
        internalComplaint.id                     = databaseComplaint.id;
        internalComplaint.complaintDescription   = databaseComplaint.Complaint_Code__r.Display_Name__c;
        internalComplaint.complaintLocation      = databaseComplaint.Complaint_Location__c == Null ? '' : databaseComplaint.Complaint_Location__c;
        internalComplaint.flightID               = databaseComplaint.Flight_Leg__c;
        internalComplaint.flightName             = databaseComplaint.Flight_Leg__r.Name;
        internalComplaint.actualArrivalTime      = databaseComplaint.Flight_Leg__r.ActualArrivalTime__c;
        internalComplaint.actualDepartureTime    = databaseComplaint.Flight_Leg__r.ActualDepartureTime__c;
        internalComplaint.marketingAirlineCode   = databaseComplaint.Flight_Leg__r.MarketingAirlineCode__c;
        internalComplaint.operatingAirlineCode   = databaseComplaint.Flight_Leg__r.OperatingAirlineCode__c;
        internalComplaint.departureAirport       = databaseComplaint.Flight_Leg__r.DepartureAirport__c;
        internalComplaint.flightNumber           = databaseComplaint.Flight_Leg__r.FlightNumber__c;
        
        internalComplaint.inTime                 = databaseComplaint.Flight_Leg__r.InTime__c;
        internalComplaint.mileage                = String.valueOf(databaseComplaint.Flight_Leg__r.LegMileage__c);
        internalComplaint.offTime                = databaseComplaint.Flight_Leg__r.OffTime__c;
        internalComplaint.onTime                 = databaseComplaint.Flight_Leg__r.OnTime__c;
        internalComplaint.arrivalAirport         = databaseComplaint.Flight_Leg__r.ArrivalAirport__c;
        internalComplaint.outTime                = databaseComplaint.Flight_Leg__r.OutTime__c;
        internalComplaint.scheduledArrivalTime   = databaseComplaint.Flight_Leg__r.ScheduledArrivalTime__c;
        internalComplaint.scheduledDepartureTime = databaseComplaint.Flight_Leg__r.ScheduledDepartureTime__c;
        
        return internalComplaint;
    }
    
    //pnr calluot
     public static Map<String,Flightleg> DoCalloutsPnr(String pnr) 
    {
        PNR.Lookup aPnr = new PNR.Lookup();
        if (aPnr == null) return null;
        Map<String,Flightleg> flightLegs = ExtractFlightLegsFromPnr(aPnr.retrieve(pnr));
        return flightLegs;
    }
    
      public static Map<String,FlightLegUtils.FlightLeg> ExtractFlightLegsFromPnr(SOA_PNRCommon.PnrType response) // key is FlightLeg Name
    {
        //List<FlightLegUtils.FlightLeg> flightLegs = new List<FlightLegUtils.FlightLeg>();
        Map<String,FlightLegUtils.FlightLeg> flightLegs = new Map<String,FlightLegUtils.FlightLeg>();
        if(response != Null && response.SegmentDl != Null) 
        {
            for(SOA_PNRCommon.SegmentDl_element segment : response.SegmentDl) 
            {
                //String airlineCode  = segment.AirlineCode;
                //String flightNumber = segment.FlightNumber;
                //Date departureDate  = FlightLegUtils.getDate(segment.DepartureDate, segment.SegmentDepartureYear);
                //String origin = segment.DeparturePoint;

                searchParameters data = new searchParameters();
                data.airlineCodeOverride    = segment.AirlineCode;
                data.FlightNumber           = makeFourDigits(segment.FlightNumber);
                data.OperatingFlightNumber =  makeFourDigits(segment.FlightNumber);
                data.DepartureDate          = getDate(segment.DepartureDate, segment.SegmentDepartureYear);
                data.Origin                 = segment.DeparturePoint;

                Map<String,Flightleg> deltaReturn = doCalloutsDetails(data);
                flightLegs.putAll(deltaReturn);
                if (deltaReturn == null || deltaReturn.isEmpty()) // not found in Delta, try AirFrance
                {
                    FlightLeg airFranceFlightLeg = doAirFranceCallout(data);
                    flightLegs.put(airFranceFlightLeg.Name, airFranceFlightLeg);
                }
            }
        }
        return flightLegs;
    }
    public static Date getDate(String dayMonthString, String yearString) 
    {
        Integer day   = Integer.valueOf(dayMonthString.left(dayMonthString.length() - 3));
        Integer month = FlightLegUtils.mapFromMonthAbbreviationToNumber.get(dayMonthString.right(3));
        Integer year  = 2000 + Integer.valueOf(yearString);
        return Date.newInstance(year, month, day);
    }
     public static FlightLeg doAirFranceCallout( searchParameters params)
    {
        FlightLeg newFlightLeg = new FlightLeg();
        //  public String CodCie;       // Carrier Code
        //  public String NumVol;       // Flight Number
        //  public String DatDepTU;     // Departure Date 
        //  public String DatDepLO;     // Departure Date Local
        //  public String EscDep;       // Origin
        //  public String EscDes;       // Destination

        SOA_AirFranceFlight.RQT_element RQT = new SOA_AirFranceFlight.RQT_element();
        RQT.CodCie = params.airlineCode;
        RQT.NumVol = params.FlightNumber;
        // Departure Dates:  DatDepLO (Local) and DatDepTU (not local -- probably GMT)
        // The service wants one and only one of these, all departure and arrival dates should be
        // local to the airport, so ... using the local one
        RQT.DatDepLO = dateToFranceDate(params.DepartureDate);
        RQT.EscDep = String.isBlank(params.Origin) ? null : params.Origin;     
        //RQT.EscDes -- dont send the destination

        SOA_AirFranceFlight.S04112_PTEndpoint1 doer = new SOA_AirFranceFlight.S04112_PTEndpoint1();
        SOA_AirFranceFlight.S04112_OUT_element results = doer.invoke(RQT);
        if(results == Null) return newFlightLeg;

        newFlightLeg.LegReturnIndicator = false;
        newFlightLeg.ScopeIndicator = false;

        if(results.Exception_x != Null) {
            if(results.Exception_x.ErrCode != Null) {
                newFlightLeg.error = results.Exception_x.ErrCode + ' ' + results.Exception_x.ErrMsg;
            }
        }
        if(results.VolPrev != Null) {
            newFlightLeg.MarketingAirlineCode   = results.VolPrev.CiePrev;
            newFlightLeg.FlightNumber           = results.VolPrev.NumVolPrev;
            newFlightLeg.ScheduledDepartureTime = dateFromFranceToUs(results.VolPrev.DatVolPrev);
            newFlightLeg.DepartureAirport       = results.VolPrev.ParcPrev == Null ? '' : results.VolPrev.ParcPrev.left(3);
            newFlightLeg.ArrivalAirport         = results.VolPrev.ParcPrev == Null ? '' : results.VolPrev.ParcPrev.right(3);
            newFlightLeg.Name                   = makeUniqueName(newFlightLeg.MarketingAirlineCode,
                                                                 makeThreeDigits(newFlightLeg.FlightNumber),
                                                                 newFlightLeg.ScheduledDepartureTime,
                                                                 newFlightLeg.DepartureAirport,
                                                                 newFlightLeg.ArrivalAirport);
            newFlightLeg.attached               = False;

            newFlightLeg.airlineDescription           = getAirlineDescription(newFlightLeg.MarketingAirlineCode);
            newFlightLeg.departureAirportDescription  = getAirportDescription(newFlightLeg.DepartureAirport);
            newFlightLeg.arrivalAirportDescription    = getAirportDescription(newFlightLeg.ArrivalAirport);

            if(results.VolPrev.Prev != Null) {
                for(SOA_AirFranceFlight.Prev_element prev : results.VolPrev.Prev) {
//                        newFlightLeg.FlightNumber = prev.TypePrev;
//                        newFlightLeg.FlightNumber = prev.CieProPrev;
System.Debug('prev.CieProPrev ' + prev.CieProPrev);
                        newFlightLeg.operatingAirlineCode = prev.CieOpePrev;
System.Debug('newFlightLeg.operatingAirlineCode ' + newFlightLeg.operatingAirlineCode);
//                        newFlightLeg.FlightNumber = prev.NVolOpePrev;
                }
            }
        }
        if(results.VolReal != Null) {
//                newFlightLeg.MarketingAirlineCode   = results.VolReal.CieReal;
//                newFlightLeg.FlightNumber           = results.VolReal.NumVolReal;
//                newFlightLeg.ScheduledDepartureTime = results.VolReal.DatVolReal;
//                newFlightLeg.DepartureAirport       = results.VolReal.ParcReal == Null ? '' : results.VolReal.ParcReal.left(3);
//                newFlightLeg.ArrivalAirport         = results.VolReal.ParcReal == Null ? '' : results.VolReal.ParcReal.right(3);
            if(results.VolReal.Real != Null) {
                for(SOA_AirFranceFlight.Real_element real : results.VolReal.Real) {
//                        newFlightLeg.FlightNumber = real.TypeReal;
//                        newFlightLeg.FlightNumber = real.CieProReal;
//                        newFlightLeg.FlightNumber = real.CieOperReal;
//                        newFlightLeg.FlightNumber = real.NVolOpeReal;
//                        newFlightLeg.OperatingAirlineCode = real.CieOperReal;
                    if(real.Entite != Null) {
//                            newFlightLeg.FlightNumber  = real.Entite.EntiteResp;
                    }
                    if(real.Delai != Null) {
                        for(SOA_AirFranceFlight.Delai_element delai : real.Delai) {
                            addDelayCode(newFlightLeg, 'Delay ' + delai.DelaiRetardD + ' minutes');
                        }
                    }
                    if(real.Cause != Null) {
                        for(SOA_AirFranceFlight.Cause_element cause : real.Cause) {
                            addDelayCode(newFlightLeg, 'Delay ' + cause.CodeCause + ' ' + Cause.CodeIata + ' ' + Cause.LibelleCauseR);
                        }
                    }
                    if(real.Annulation != Null) {
                        addDelayCode(newFlightLeg, 'Cancellation ' + real.Annulation.DelaiRetard + ' ' + real.Annulation.CodeAnnul + ' ' + real.Annulation.LibelleCauseA);
                    }
                    if(real.Irreg != Null) {
                        for(SOA_AirFranceFlight.Irreg_element irreg : real.Irreg) {
                            addRemark(newFlightLeg, 'Irregularity ' + irreg.IrregVol);
                        }
                    }
                }
            }
        }
        return newFlightLeg;       
    }
    public static String dateToFranceDate(date theDate) 
    {
        String yearString = String.valueof(theDate.year());
        String monthString = mapFromNumberToMonthAbbreviation.get(theDate.month());
        String dayString = String.valueof(theDate.day());
        if (dayString.length() == 1) dayString = '0' + dayString;
        String rval = dayString + monthString + yearString;
        return rval;
    }
     public static String dateFromFranceToUs(String frenchDate) 
    {
        if(String.isBlank(frenchDate) || frenchDate.length() < 9) {
            return Null;
        }        
        return frenchDate.subString(5, 9) + '-' + mapFromMonthNameToMonthNumber.get(frenchDate.subString(2, 5)) + '-' + frenchDate.subString(0, 2);
    }
    public static String getAirlineDescription(String airlineCode) {
        for(Airline_Code__c airlineCodeRecord : [
            SELECT   Id, IATA_Code__c, Name, Country__c
            FROM     Airline_Code__c
            WHERE    IATA_Code__c = :airlineCode
        ]) {
            return airlineCode + ' - ' + airlineCodeRecord.Name + ' - ' + airlineCodeRecord.Country__c;
        }

        return airlineCode;
    }
     public static String getAirportDescription(String airportCode) {
        Airport_Code__c airportCodeRecord = Airport_Code__c.getInstance(airportCode);
        if(airportCodeRecord == Null)
            return airportCode;
        return airportCode + ' - ' + airportCodeRecord.Full_Name__c + ' - ' + airportCodeRecord.City__c + (airportCodeRecord.State__c == Null ? '' : ', ' + airportCodeRecord.State__c) + ' ' + airportCodeRecord.Country__c;
    }
    public static void addDelayCode(FlightLeg flightLeg, String text) {
        if(flightLeg.delayCodes == Null) {
            flightLeg.delayCodes = new List<FlightDelay>();
        }
        FlightDelay delayCode = new FlightDelay();
        delayCode.DelayRemarkText = text + '\n';
        flightLeg.delayCodes.add(delayCode);
    }
    public static void addRemark(FlightLeg flightLeg, String text) 
    {
        if(flightLeg.remarks == Null) {
            flightLeg.remarks = new List<FlightRemark>();
        }
        FlightRemark remark = new FlightRemark();
        remark.remarksText = text + '\n';
        flightLeg.remarks.add(remark);
    }
    
     public static Flight_Staff__c convertFlightStaffFromInternalToDatabase(Id flightLegId, FlightMember flightMemberInternal, Id contactId) {
        Flight_Staff__c flightMemberDatabase = new Flight_Staff__c(
            Flight_Leg_Flight_Crew__c = flightLegId,
            Account__c                = contactId,
            mbrIdNb__c                = flightMemberInternal.mbrIdNb,
            mbrNm__c                  = flightMemberInternal.mbrNm,
            mbrTypCd__c               = flightMemberInternal.mbrTypCd,
            mbrPsptNm__c              = flightMemberInternal.mbrPsptNm,
            pstnCd__c                 = flightMemberInternal.pstnCd,
//            rotnBegDt__c              = flightMemberInternal.rotnBegDt,
            rotnDupNb__c              = flightMemberInternal.rotnDupNb,
            rotnNb__c                 = flightMemberInternal.rotnNb,
            rotnPstnCd__c             = flightMemberInternal.rotnPstnCd,

            BsAssgn__c                = flightMemberInternal.BsAssgn,
            EmplDt__c                 = flightMemberInternal.EmplDt,
//            EmplFrstNm__c             = flightMemberInternal.EmplFrstNm,
//            EmplLstNm__c              = flightMemberInternal.EmplLstNm,
//            EmplMidNm__c              = flightMemberInternal.EmplMidNm,
            FADeptNb__c               = flightMemberInternal.FADeptNb,
            FAFsmBase__c              = flightMemberInternal.FAFsmBase,
            FAFsmId__c                = flightMemberInternal.FAFsmId,
            MgrFrstNm__c              = flightMemberInternal.MgrFrstNm,
            MgrLstNm__c               = flightMemberInternal.MgrLstNm,
            MgrNb__c                  = flightMemberInternal.MgrNb,
            SnrtyDt__c                = flightMemberInternal.SnrtyDt,
            SnrtyNb__c                = flightMemberInternal.SnrtyNb
        );

        return flightMemberDatabase;
    }
}