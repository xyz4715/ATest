/*******************************************************//**

@class		AccountHandler

@brief		Trigger Handler for Accounts

	This class is called by the Account trigger to manage Accounts.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-12-01	LiquidHub.GHA
	Created.

@see		Account (trigger)
@see		AccountHandlerTest

	(c)2015-2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

public without sharing class AccountHandler implements CWTrigger.Handler
{
	public static List<String>	contactFieldsUsedOnAccount	= new List<String>
	{	'LastName',
		'MailingStreet', 'MailingCity', 'MailingState', 'MailingPostalCode', 'MailingCountry',
		'OtherStreet',   'OtherCity',   'OtherState',   'OtherPostalCode',   'OtherCountry'
	};

	/*******************************************************
						properties
	*******************************************************/

	private Id		householdRecordTypeId
	{
		get
		{
			if ( householdRecordTypeId == null )
			{
				householdRecordTypeId = CWSchema.getRecordTypeId( 'Account', 'Household' );
			}
			return householdRecordTypeId;
		}
		private set;
	}

	/*******************************************************
						beforeTrigger
	*******************************************************/

	public void beforeTrigger( CWTrigger theTrigger )
	{
		theTrigger.flag		= true;			//	prevent re-triggering on these records

		if ( theTrigger.isDelete ) return;

		CWFormatValidation.validate( theTrigger );

		List<Id>	householdAccountIds		= new List<Id>();
		List<Id>	primaryContactIds		= new List<Id>();

		for ( Account record : (List<Account>) theTrigger.list_Records )
		{
			if ( record.RecordTypeId != householdRecordTypeId || record.IsPlaceholder__c ) continue;

			if ( record.Id != null ) householdAccountIds.add( record.Id );
			if ( record.Primary_Contact__c != null ) primaryContactIds.add( record.Primary_Contact__c );
		}

		CWQuery	primaryContactQuery	= CWQuery.newQuery( 'Contact' ).add( contactFieldsUsedOnAccount );
		primaryContactQuery.newWhereClause().isIn( primaryContactIds );
		Map<Id,Contact>	primaryContactMap	= new Map<Id,Contact>( (List<Contact>) primaryContactQuery.query() );

		CWQuery	accountQuery		= CWQuery.newQuery( 'Account' );
		accountQuery.newSubquery( 'Contacts' ).add( contactFieldsUsedOnAccount ).orderByAscending( 'CreatedDate' ).setLimit( 1 );
		accountQuery.newWhereClause().isIn( householdAccountIds );

		for ( Account relatedData : (List<Account>) accountQuery.query() )
		{
			Account	account		= (Account) theTrigger.map_Records.get( relatedData.Id );

			Contact	contact		=
				account.Primary_Contact__c != null				?	primaryContactMap.get( account.Primary_Contact__c )
			:	!CWCollection.isEmpty( relatedData.Contacts )	?	relatedData.Contacts[0]
			:														null;

			if ( contact == null ) continue;

			account.BillingStreet		= contact.MailingStreet;
			account.BillingCity			= contact.MailingCity;
			account.BillingState		= contact.MailingState;
			account.BillingPostalCode	= contact.MailingPostalCode;
			account.BillingCountry		= contact.MailingCountry;

			account.ShippingStreet		= contact.OtherStreet;
			account.ShippingCity		= contact.OtherCity;
			account.ShippingState		= contact.OtherState;
			account.ShippingPostalCode	= contact.OtherPostalCode;
			account.ShippingCountry		= contact.OtherCountry;

			account.Name				= computeName( contact.LastName, account );
		}

		CWSoundex.encode
		(	theTrigger,
			new Map<String,String>{ 'Name' => 'Name_SoundEx__c' }
		);
	}

	/*******************************************************
						afterTrigger
	*******************************************************/

	public void afterTrigger( CWTrigger theTrigger )
	{
		theTrigger.flag		= true;			//	prevent re-triggering on these records

		//	nothing to do here yet...
	}

	/*******************************************************
					computeName method
	*******************************************************/

	public static String computeName( String lastName, Account record )
	{
		String	surname	=
			String.isNotBlank( lastName )		?	lastName
		:	'<No Last Name>';

		String	street	=
			String.isNotBlank( record.BillingStreet )		?	record.BillingStreet.substringBefore( '\n' )
		:	String.isNotBlank( record.ShippingStreet )		?	record.ShippingStreet.substringBefore( '\n' )
		:	'<No Street>';

		String	postalCode	=
			String.isNotBlank( record.BillingPostalCode )		?	record.BillingPostalCode
		:	String.isNotBlank( record.ShippingPostalCode )		?	record.BillingPostalCode
		:	'<No Postal Code>';

		return String.join( new List<String>{ surname, street, postalCode, 'Household' }, ' | ' );
	}
}