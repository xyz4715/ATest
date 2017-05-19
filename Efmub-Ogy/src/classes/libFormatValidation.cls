/*******************************************************//**

@class		CWFormatValidation

@brief		CW Format Validation Class

	Utility class for validating field formats.  These methods work
	in conjunction with the CWFormatValidation__c custom setting.
	The end user may specify formats (as reqular expressions) for
	specific object/field combinations.  They also specify the error
	message to be displayed if a field is not formatted properly.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-07-29	LiquidHub.GHA
	Created.

@see		CWFormatValidationTest

	(c)2015-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWFormatValidation
{
	//	names of the fields in the CWFieldValidation custom setting
	private static final String		objectNameField			= 'Object_Name__c',
									fieldNameField			= 'Field_Name__c',
									regularExpressionField	= 'Regular_Expression__c',
									errorMessageField		= 'Error_Message__c';

	/*******************************************************
				formatValidations property
	*******************************************************/

	private static Map<String,Map<String,CWFormatValidation__c>>	formatValidations
	{
		get
		{
			if ( formatValidations == null )
			{
				formatValidations = new Map<String,Map<String,CWFormatValidation__c>>();

				for ( CWFormatValidation__c validation : CWFormatValidation__c.getAll().values() )
				{
					String	sObjectName	= (String) validation.get( objectNameField );
					if ( !formatValidations.containsKey( sObjectName ) ) formatValidations.put( sObjectName, new Map<String,CWFormatValidation__c>() );
					formatValidations.get( sObjectName ).put( (String) validation.get( fieldNameField ), validation );
				}
			}
			return formatValidations;
		}
		private set;
	}

	/*******************************************************
						isValid methods

	These methods take an sObject specification, a field name,
	and a value and return true if the value is in a valid format
	for the specified field.

	A value is valid if it matches the regular expression given
	in the Field_Validation__c custom setting instance for the
	field or if there is no Field_Validation__c custom setting
	instance (implying that any format is acceptable).

	A null value is valid only if the field is Nillable.
	*******************************************************/

	private static Boolean isValid( CWFormatValidation__c validation, String fieldValue )
	{
		return validation == null || Pattern.matches( (String) validation.get( regularExpressionField ), fieldValue );
	}

	public static Boolean isValid( String sObjectName, String fieldName, String fieldValue )
	{
		if ( !CWSchema.isField( sObjectName, fieldName ) ) return false;

		if ( fieldValue == null ) return CWSchema.getDescribeFieldResult( sObjectName, fieldName ).isNillable();

		Map<String,CWFormatValidation__c>	objectValidations	= formatValidations.get( sObjectName );
		CWFormatValidation__c				validation			= objectValidations != null ? objectValidations.get( fieldName ) : null;

		return isValid( validation, fieldValue );
	}

	public static Boolean isValid( Schema.sObjectType sObjectType, String fieldName, String fieldValue )
	{
		return isValid( CWSchema.getSObjectName( sObjectType ), fieldName, fieldValue );
	}

	public static Boolean isValid( Schema.DescribeSObjectResult sObjectResult, String fieldName, String fieldValue )
	{
		return isValid( CWSchema.getSObjectName( sObjectResult ), fieldName, fieldValue );
	}

	public static Boolean isValid( sObject anSObject, String fieldName, String fieldValue )
	{
		return isValid( CWSchema.getSObjectName( anSObject ), fieldName, fieldValue );
	}

	public static Boolean isValid( Id sObjectId, String fieldName, String fieldValue )
	{
		return isValid( CWSchema.getSObjectName( sObjectId ), fieldName, fieldValue );
	}

	/*******************************************************
						isValid methods

	This version of 'isValid' takes a record and a field name
	and validates the value of that field stored in the record.
	*******************************************************/

	public static Boolean isValid( sObject record, String fieldName )
	{
		return CWSchema.isField( record, fieldName ) && isValid( record, fieldName, (String) record.get( fieldName ) );
	}

	/*******************************************************
						validate method

	This method validates any field that has a CWFormatValidation__c
	custom setting instance and that has changed across all of the
	records in a CWTrigger object.

	Any invalid fields have the format validation error applied.
	*******************************************************/

	public static void validate( CWTrigger theTrigger )
	{
		if ( theTrigger.isDelete ) return;

		String								sObjectName			= CWSchema.getSObjectName( theTrigger.sObjectType );
		Map<String,CWFormatValidation__c>	objectValidations	= formatValidations.get( sObjectName );
		if ( objectValidations == null ) return;

		for ( String fieldName : objectValidations.keySet() )
		{
			if ( !CWSchema.isField( sObjectName, fieldName ) ) continue;

			CWFormatValidation__c	validation		= objectValidations.get( fieldName );

			for ( sObject record : theTrigger.newList )
			{
				String	fieldValue	= (String) record.get( fieldName );

				if	(	theTrigger.hasChanged( record, fieldName )
					&&	(	fieldValue != null
						?	!isValid( validation, fieldValue )
						:	!CWSchema.getDescribeFieldResult( sObjectName, fieldName ).isNillable()
						)
					)
				{
					record.addError( (String) validation.get( errorMessageField ) );
				}
			}
		}
	}
}