/*******************************************************//**

@class      Ticketing

@brief      Ticketing Utility Class

	This class abstracts the information returned from the
	SOA_TicketingProcess.TicketingProcess_EP service.

@author		Janeen Anderson   (LiquidHub.JDA)

@version	2016-02-15  LiquidHub.JDA
	Created.

@see	PNRTest

	(c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class Ticketing 
{
	/*******************************************************
				MemberInformation class

	This class contains all of the (useful) information returned
	by a call to the LoyaltyMember service "RetrieveMaster" or
	"Search" operations.
	*******************************************************/	

	public class MemberInformation
	{
		public Dom.Document	response;								//
		public Account  person_acc				{ get; private set; }	////Contact to Account
		public String	PNR					{ get; set; }			//
		public String  ticketNumber			{ get; set; }			//
    	public String Carrier             	{ get; set; }
    	public String Origin             	{ get; set; }
    	public String DepartureDate       	{ get; set; }
	}

	/*******************************************************
				Lookup class

	This class makes the SOA call and the find function 
	returns a list of MemberInformation classes, one for
	each traveler on the PNR.
	*******************************************************/

	public class Lookup
	{
		private SOA_TicketingProcess.TicketingProcess_EP service;

		public Lookup()
		{
			service = new SOA_TicketingProcess.TicketingProcess_EP();
		}

		public MemberInformation find( String ticketNumber )
		{
			SOA_TicketingProcess.ArchivedTicketRequestParamsType theTicket = new SOA_TicketingProcess.ArchivedTicketRequestParamsType();
			theTicket.TicketReqParams = new SOA_TicketingProcess.TicketReqParamsType();
			theTicket.TicketReqParams.TicketNumber = ticketNumber;
			SOA_TicketingProcess.ArchivedTicketRequestParamsType request = new SOA_TicketingProcess.ArchivedTicketRequestParamsType();
			request.TicketReqParams = theTicket.TicketReqParams;
			SOA_TicketingProcess.RetrieveArchivedResponseType response = 
				service.RetrieveArchived( new List<SOA_TicketingProcess.ArchivedTicketRequestParamsType>{ request } );

			if ( response == null || response.ArchivedTicketResponse == null || response.ArchivedTicketResponse.isEmpty() ) return null;
			SOA_TicketingProcess.ArchivedTicketType ticketResponse = response.ArchivedTicketResponse[0].ArchivedTicket == null || response.ArchivedTicketResponse[0].ArchivedTicket.isEmpty() ? 
				null : response.ArchivedTicketResponse[0].ArchivedTicket[0];
			if ( ticketResponse == null ) return null;

			MemberInformation traveler = new MemberInformation();
			if ( ticketResponse.BkgRecLocator != null && !ticketResponse.BkgRecLocator.isEmpty() ) 
				traveler.PNR = ticketResponse.BkgRecLocator[0].bkgRecLocator;
			traveler.ticketNumber = ticketNumber;
			traveler.person_acc = new Account();
			String firstAndMiddle = ticketResponse == null ? null : ticketResponse.PsngrInfo.FirstNm;
			List<String> namePieces = firstAndMiddle == null ? null : firstAndMiddle.split( ' ' );
			traveler.person_acc.FirstName = namePieces == null || namePieces.isEmpty() ? null : namePieces[0];
			traveler.person_acc.MiddleName = namePieces == null || namePieces.size() < 2 ? null : namePieces[1];
			traveler.person_acc.LastName = firstAndMiddle == null ? null : ticketResponse.PsngrInfo.LastNm;

			traveler.response = new Dom.Document();
			return traveler;
		}
	}
}