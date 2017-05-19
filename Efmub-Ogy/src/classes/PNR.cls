/*******************************************************//**

@class      PNR

@brief      PNR Utility Class

  This class abstracts the information returned from the
  SOA_LPNRCommon service.

@author     Janeen Anderson   (LiquidHub.JDA)

@version    2016-02-15  LiquidHub.JDA
  Created.

@see        PNRTest

  (c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

  This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/
public without sharing class PNR 
{

    /*******************************************************
        MemberInformation class
        This class contains all of the (useful) information returned
        by a call to the LoyaltyMember service "RetrieveMaster" or
        "Search" operations.
        *******************************************************/    
    public class MemberInformation
    {
        public Dom.Document  response;
        public Map<String,Account>  travelers  { get; private set; }  // key is string value of list index //Contact to Account
    public Map<String,String> Tickets     { get; set; } // key is the same as for travelers
    public String PNR                     { get; set; }
    public String Carrier                 { get; set; }
    public String Origin                  { get; set; }
    public String DepartureDate           { get; set; }

    public MemberInformation() 
    { 
      travelers = new Map<String,Account>();//Contact to Account
      Tickets = new Map<String,String>();
    }
    }

  /*******************************************************
        Lookup class
    This class makes the SOA call and the find function 
    returns a list of MemberInformation classes, one for
    each traveler on the PNR.
    *******************************************************/
  public class Lookup
  {
    private SOA_PNRCommon.PnrCommon_EP service;
    
    public Lookup( )
    {
       service = new SOA_PNRCommon.PnrCommon_EP();
    }

    public SOA_PNRCommon.PnrType retrieve( String PNR )
    {
      SOA_PNRCommon.RetrieveInfoType request = new SOA_PNRCommon.RetrieveInfoType();
      request.PassengerInfo = new SOA_PNRCommon.PassengerInfoType();
      system.debug('pnr -->'+PNR);
      request.PassengerInfo.RecordLocator = PNR;
      SOA_PNRCommon.PnrType response = service.Retrieve_x(request);
      if (response == null) return null;
      return response;
    }

    public MemberInformation find( String PNR )
    {
      MemberInformation returnVal;

      SOA_PNRCommon.PnrType response = retrieve( PNR );
      if (response == null) return returnVal;
      returnVal = new MemberInformation();

      Integer numSegments = response.SegmentAdditionalInfo == null ? 0 : response.SegmentAdditionalInfo.size();
      Integer numTickets = response.TicketInformation == null ? 0 : response.TicketInformation.size();
      Integer numTravelers = response.Passenger == null ? 0 : response.Passenger.size();

      if (numTickets == 0) 
      {
        return returnVal;
      }
      
      returnVal.response = new Dom.Document();
      returnVal.PNR = PNR;
      returnVal.Carrier = response.SegmentAdditionalInfo[0].OperatingCarrierCode;
      returnVal.Origin = response.SegmentAdditionalInfo[0].DeparturePoint;
      returnVal.DepartureDate = (response.SegmentAdditionalInfo[0].FirstLegDepartureDate == null ? '' : response.SegmentAdditionalInfo[0].FirstLegDepartureDate)  
            + (response.SegmentAdditionalInfo[0].FlightLegDepartureYear == null ? '' : response.SegmentAdditionalInfo[0].FlightLegDepartureYear)
            + (response.SegmentAdditionalInfo[0].DepartureTime == null ? '' : '-' + response.SegmentAdditionalInfo[0].DepartureTime);

      
      for(Integer i = 0; i < numTravelers; i++)
      {
        if (response.Passenger[i] == null) continue;
        if (i < numTickets) returnVal.Tickets.put(response.TicketInformation[i].FirstNameNumber, response.TicketInformation[i].TicketNumber);
        Account aTraveler = new Account();//Contact to Account
        returnVal.travelers.put(String.valueof(i), aTraveler);
        aTraveler.FirstName = response.Passenger[i].FirstName;
        aTraveler.LastName = response.Passenger[i].LastName;
        aTraveler.Suffix = response.Passenger[i].Suffix;
        aTraveler.Salutation = response.Passenger[i].Title;
        Boolean hasFrequentFlyer = (response.FrequentFlyer != null && response.FrequentFlyer.size() > i) ? true : false;
        if (hasFrequentFlyer && response.FrequentFlyer[i] != null && response.FrequentFlyer[i].AirlineCode == 'DL' )
        {
          aTraveler.SkyMiles_Number__pc = response.FrequentFlyer[i].AccountNumber;
        }
        if (hasFrequentFlyer && response.FrequentFlyer[i] != null && response.FrequentFlyer[i].AirlineCode == 'AF' )
        {
          aTraveler.Flying_Blue_Number__pc = response.FrequentFlyer[i].AccountNumber;
        }
      }        
      return returnVal;
    }
  }
}