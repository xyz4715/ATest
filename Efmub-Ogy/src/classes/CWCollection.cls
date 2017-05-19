/*******************************************************//**

@class		CWCollection

@brief		CW Core Collection Class

	This class provides utility methods for creating and manipulating
	collections of sObjects and sObject fields.

	listOf<type>s methods
	---------------------

	The listOf<type>s family of methods take a list of sObjects and
	a field name and return a list of the corresponding field values
	from all of the sObjects in the list.  Validation is done to
	ensure that the field is of a type appropriate for the method
	used.

	setOf<type>s methods
	---------------------

	The setOf<type>s family of methods take a list of sObjects and
	a field name and return a set of the corresponding field values
	from all of the sObjects in the list.  Validation is done to
	ensure that the field is of a type appropriate for the method
	used.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2013-11-14	LiquidHub.GHA
	Created.
@version	2014-02-03	LiquidHub.GHA
	Fixed listOfLongs and listOfIntegers.
@version	2014-02-04	LiquidHub.GHA
	Incorporated CWException error handling.
@version	2014-03-03	LiquidHub.GHA
	Added 'extractField' methods.
@version	2014-11-07	LiquidHub.GHA
	Added 'listOfSObjects' methods.
@version	2014-11-07	LiquidHub.GHA
	Added 'isNotEmpty' methods.
@version	2015-05-18	LiquidHub.GHA
	Fixed bug with 'extractParent' method.

@todo	Incorporate CWIterable
@todo	Modify 'validateArguments' to support getSObjects

@see		CWCollectionTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWCollection
{
	/***********************************************************
					isEmpty/isNotEmpty methods

	This returns true if the given list is null or empty.
	***********************************************************/

	public static Boolean isEmpty( List<Object> theList )
	{
		return theList == null || theList.isEmpty();
	}

	public static Boolean isNotEmpty( List<Object> theList )
	{
		return theList != null && !theList.isEmpty();
	}

	/***********************************************************
				validateArguments methods (private)

	This verifies that there is a list of records and a set of
	field names, and that each field name can be represented by
	the destination type.
	***********************************************************/

	private static Boolean validateArguments( List<sObject> list_Records, Set<String> set_fieldNames, Type objectType )
	{
		if ( list_Records == null || set_fieldNames == null || objectType == null )
		{
			CWException.error( 'CWCollection.validateArguments: Missing argument(s).' );
			return false;
		}

		Set<Schema.SOAPType> set_SOAPTypes = CWType.getSOAPTypes( objectType );

		if ( set_SOAPTypes == null )
		{
			CWException.error( 'CWCollection.validateArguments: No available SOAPType.' );
			return false;
		}

		Schema.sObjectType sObjectType = list_Records.getSObjectType();

		for ( String fieldName : set_fieldNames )
		{
			Schema.SOAPType soapType = CWSchema.getFieldSOAPType( sObjectType, fieldName );

			if ( soapType == null || !set_SOAPTypes.contains( soapType ) )
			{
				CWException.error
				(	'CWCollection.validateArguments: Incompatible field \'' + fieldName + '\':\n'
				+	'Field SOAPType = ' + (soapType == null ? 'NULL' : soapType.name()) + '\n'
				+	'Target Type = ' + objectType.getName()
				);
				return false;
			}
		}

		return true;
	}

	private static Boolean validateArguments( List<sObject> list_Records, String fieldName, Type objectType )
	{
		return validateArguments( list_Records, new Set<String>{ fieldName }, objectType );
	}

	/***********************************************************
				listOf<type>s methods

	These methods extract the values of the specified field from
	the list of records, and return a list of the specified type.
	Null values are excluded from the returned list.  If the field
	is not of the correct type, the method will return null.
	***********************************************************/

	private static List<Object> listOfObjects( List<sObject> list_Records, String fieldName, Type objectType )
	{
		if ( !validateArguments( list_Records, fieldName, objectType ) ) return null;

		List<Object> list_Objects = (List<Object>) Type.forName( 'List<' + objectType.getName() + '>' ).newInstance();

		for ( sObject aRecord : list_Records )
		{
			try
			{
				Object fieldValue = aRecord.get( fieldName );
				if ( fieldValue != null ) list_Objects.add( fieldValue );
			}
			catch ( Exception e )
			{
				return (List<Object>) CWException.errorNull( 'CWCollection.listOfObjects: Error on field \'' + fieldName + '\' of record\n' + String.valueOf( aRecord ), e );
			}
		}

		return list_Objects;
	}
	
	private static List<Object> listOfSObjects( List<sObject> list_Records, String referenceName, Type objectType )
	{
		//ValidateArguments doesn't currently support getSObjects. Relying on dev to pass proper reference for now
		//if ( !validateArguments( list_Records, fieldName, objectType ) ) return null;

		List<Object> list_Objects = (List<Object>) Type.forName( 'List<' + objectType.getName() + '>' ).newInstance();

		for ( sObject aRecord : list_Records )
		{
			try
			{
				Object fieldValue = aRecord.getSObject( referenceName );
				if ( fieldValue != null ) list_Objects.add( fieldValue );
			}
			catch ( Exception e )
			{
				return (List<Object>) CWException.errorNull( 'CWCollection.listOfSObjects: Error on reference \'' + referenceName + '\' of record\n' + String.valueOf( aRecord ), e );
			}
		}

		return list_Objects;
	}

	/***	Object		***/
	public static List<Object> listOfObjects( List<sObject> list_Records, String fieldName )
	{
		return (List<Object>) listOfObjects( list_Records, fieldName, Object.class );
	}
	
	/***	SObject		***/
	public static List<SObject> listOfSObjects( List<sObject> list_Records, String referenceName )
	{
		return (List<SObject>) listOfSObjects( list_Records, referenceName, SObject.class );
	}

	/***	Boolean		***/
	public static List<Boolean> listOfBooleans( List<sObject> list_Records, String fieldName )
	{
		return (List<Boolean>) listOfObjects( list_Records, fieldName, Boolean.class );
	}

	/***	Date		***/
	public static List<Date> listOfDates( List<sObject> list_Records, String fieldName )
	{
		return (List<Date>) listOfObjects( list_Records, fieldName, Date.class );
	}

	/***	DateTime	***/
	public static List<DateTime> listOfDateTimes( List<sObject> list_Records, String fieldName )
	{
		return (List<DateTime>) listOfObjects( list_Records, fieldName, DateTime.class );
	}

	/***	Decimal		***/
	public static List<Decimal> listOfDecimals( List<sObject> list_Records, String fieldName )
	{
		return (List<Decimal>) listOfObjects( list_Records, fieldName, Decimal.class );
	}

	/***	Double		***/
	public static List<Double> listOfDoubles( List<sObject> list_Records, String fieldName )
	{
		return (List<Double>) listOfObjects( list_Records, fieldName, Double.class );
	}

	/***	Id			***/
	public static List<Id> listOfIDs( List<sObject> list_Records, String fieldName )
	{
		return (List<Id>) listOfObjects( list_Records, fieldName, Id.class );
	}

	/***	Integer		***/
	public static List<Integer> listOfIntegers( List<sObject> list_Records, String fieldName )
	{
		return CWType.toInteger( listOfDoubles( list_Records, fieldName ) );
	}

	/***	Long		***/
	public static List<Long> listOfLongs( List<sObject> list_Records, String fieldName )
	{
		return CWType.toLong( listOfDoubles( list_Records, fieldName ) );
	}

	/***	String		***/
	public static List<String> listOfStrings( List<sObject> list_Records, String fieldName )
	{
		return (List<String>) listOfObjects( list_Records, fieldName, String.class );
	}

	/***	Time		***/
	public static List<Time> listOfTimes( List<sObject> list_Records, String fieldName )
	{
		return (List<Time>) listOfObjects( list_Records, fieldName, Time.class );
	}


	/***********************************************************
				extractField methods

	These methods extract the values of the specified field from
	the list of records, and return a list of the specified type.
	Null values are excluded from the returned list.  If the field
	is not of the correct type, the method will return null.
	***********************************************************/

	public static Object extractField( sObject record, String fieldName )
	{
		List<String> fieldPath = CWString.split( fieldName, '\\.' ).toList_String();
		if ( record == null || isEmpty( fieldPath ) ) return null;

		try
		{
			sObject theRecord = record;
			while ( fieldPath.size() > 1 )
			{
				theRecord = theRecord.getSObject( fieldPath.remove( 0 ) );
				if ( theRecord == null ) return null;
			}
			return theRecord.get( fieldPath.get( 0 ) );
		}
		catch ( Exception theException )
		{
			return CWException.errorNull
			(	'CWCollection.extractField: Error accessing field ('
			+	CWSchema.getSObjectName( record ) + '.' + fieldName + ').',
				theException
			);
		}
	}

	private class ExtractField extends CWKeyFunction
	{
		String	theFieldName;

		public ExtractField( String fieldName )
		{
			theFieldName = fieldName;
		}

		public override Object getKey( sObject record )
		{
			return extractField( record, theFieldName );
		}
	}

	private static CWIterable extractField( Iterable<sObject> inputRecords, String fieldName )
	{
		return new CWIterable( (Iterable<Object>) inputRecords, new CWType.IsSObject(), new ExtractField( fieldName ) );
	}

	public static CWIterable extractField( CWIterable inputRecords, String fieldName )
	{
		return extractField( (Iterable<sObject>) inputRecords, fieldName );
	}

	public static CWIterable extractField( List<sObject> inputRecords, String fieldName )
	{
		return extractField( (Iterable<sObject>) inputRecords, fieldName );
	}

	public static CWIterable extractField( Set<sObject> inputRecords, String fieldName )
	{
		return extractField( (Iterable<sObject>) inputRecords, fieldName );
	}

	/***********************************************************
				extractParent methods

	These methods extract the specified parent records from the
	list of records, and return a list of those records.
	Null values are excluded from the returned list.  If an invalid
	parent relationship name is given, the method will return null.
	***********************************************************/

	public static sObject extractParent( sObject record, String parentRelationshipName )
	{
		List<String> parentRelationshipPath = CWString.split( parentRelationshipName, '\\.' ).toList_String();
		if ( record == null || isEmpty( parentRelationshipPath ) ) return null;

		try
		{
			sObject theRecord = record;
			while ( !parentRelationshipPath.isEmpty() )
			{
				theRecord = theRecord.getSObject( parentRelationshipPath.remove( 0 ) );
				if ( theRecord == null ) return null;
			}
			return theRecord;
		}
		catch ( Exception theException )
		{
			return (sObject) CWException.errorNull
			(	'CWCollection.extractParent: Error accessing parent record ('
			+	CWSchema.getSObjectName( record ) + '.' + parentRelationshipName + ').',
				theException
			);
		}
	}

	private class ExtractParent extends CWKeyFunction
	{
		String	theParentRelationshipName;

		public ExtractParent( String parentRelationshipName )
		{
			theParentRelationshipName = parentRelationshipName;
		}

		public override Object getKey( sObject record )
		{
			return extractParent( record, theParentRelationshipName );
		}
	}

	private static CWIterable extractParent( Iterable<sObject> inputRecords, String parentRelationshipName )
	{
		return new CWIterable( (Iterable<Object>) inputRecords, new ExtractParent( parentRelationshipName ) );
	}

	public static CWIterable extractParent( CWIterable inputRecords, String parentRelationshipName )
	{
		return extractParent( (Iterable<sObject>) inputRecords, parentRelationshipName );
	}

	public static CWIterable extractParent( List<sObject> inputRecords, String parentRelationshipName )
	{
		return extractParent( (Iterable<sObject>) inputRecords, parentRelationshipName );
	}

	public static CWIterable extractParent( Set<sObject> inputRecords, String parentRelationshipName )
	{
		return extractParent( (Iterable<sObject>) inputRecords, parentRelationshipName );
	}


	/***********************************************************
						setOf<type>s methods
	***********************************************************/

	/***	Object		***/
	public static Set<Object> setOfObjects( List<sObject> list_Records, String fieldName )
	{
		List<Object> list_Objects = listOfObjects( list_Records, fieldName );
		return list_Objects != null ? new Set<Object>( list_Objects ) : null;
	}

	/***	Boolean		***/
	public static Set<Boolean> setOfBooleans( List<sObject> list_Records, String fieldName )
	{
		List<Boolean> list_Booleans = listOfBooleans( list_Records, fieldName );
		return list_Booleans != null ? new Set<Boolean>( list_Booleans ) : null;
	}

	/***	Date		***/
	public static Set<Date> setOfDates( List<sObject> list_Records, String fieldName )
	{
		List<Date> list_Dates = listOfDates( list_Records, fieldName );
		return list_Dates != null ? new Set<Date>( list_Dates ) : null;
	}

	/***	DateTime	***/
	public static Set<DateTime> setOfDateTimes( List<sObject> list_Records, String fieldName )
	{
		List<DateTime> list_DateTimes = listOfDateTimes( list_Records, fieldName );
		return list_DateTimes != null ? new Set<DateTime>( list_DateTimes ) : null;
	}

	/***	Decimal		***/
	public static Set<Decimal> setOfDecimals( List<sObject> list_Records, String fieldName )
	{
		List<Decimal> list_Decimals = listOfDecimals( list_Records, fieldName );
		return list_Decimals != null ? new Set<Decimal>( list_Decimals ) : null;
	}

	/***	Double		***/
	public static Set<Double> setOfDoubles( List<sObject> list_Records, String fieldName )
	{
		List<Double> list_Doubles = listOfDoubles( list_Records, fieldName );
		return list_Doubles != null ? new Set<Double>( list_Doubles ) : null;
	}

	/***	Id			***/
	public static Set<Id> setOfIDs( List<sObject> list_Records, String fieldName )
	{
		List<Id> list_IDs = listOfIDs( list_Records, fieldName );
		return list_IDs != null ? new Set<Id>( list_IDs ) : null;
	}

	/***	Integer		***/
	public static Set<Integer> setOfIntegers( List<sObject> list_Records, String fieldName )
	{
		List<Integer> list_Integers = listOfIntegers( list_Records, fieldName );
		return list_Integers != null ? new Set<Integer>( list_Integers ) : null;
	}

	/***	Long		***/
	public static Set<Long> setOfLongs( List<sObject> list_Records, String fieldName )
	{
		List<Long> list_Longs = listOfLongs( list_Records, fieldName );
		return list_Longs != null ? new Set<Long>( list_Longs ) : null;
	}

	/***	String		***/
	public static Set<String> setOfStrings( List<sObject> list_Records, String fieldName )
	{
		List<String> list_Strings = listOfStrings( list_Records, fieldName );
		return list_Strings != null ? new Set<String>( list_Strings ) : null;
	}

	/***	Time		***/
	public static Set<Time> setOfTimes( List<sObject> list_Records, String fieldName )
	{
		List<Time> list_Times = listOfTimes( list_Records, fieldName );
		return list_Times != null ? new Set<Time>( list_Times ) : null;
	}

	/***********************************************************
					mapRecords method
	***********************************************************/
/*
	public static Map<Object,sObject> mapRecords( List<sObject> list_Records, String keyField )
	{
		if ( !validateArguments( list_Records, keyField, Object.class ) ) return null;

		if ( keyField == 'Id' ) return new Map<Object,sObject>( list_Records );

		try
		{
			Map<Object,sObject> map_Records = new Map<Object,sObject>();

			for ( sObject aRecord : list_Records )
			{
				Object key = aRecord != null ? aRecord.get( keyField ) : null;
				if ( key != null ) map_Records.put( key, aRecord );
			}

			return map_Records;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,sObject> mapRecords( Map<Object,sObject> map_Records, String keyField )
	{
		return map_Records != null ? mapRecords( map_Records.values(), keyField ) : null;
	}
//*/
	/***********************************************************
					mapFields method
	***********************************************************/
/*
	public static Map<Object,Object> mapFields( List<sObject> list_Records, String keyField, String valueField )
	{
		if ( !validateArguments( list_Records, new Set<String>{ keyField, valueField }, Object.class ) ) return null;

		try
		{
			Map<Object,Object> map_Fields = new Map<Object,Object>();

			for ( sObject aRecord : list_Records )
			{
				Object key = aRecord != null ? aRecord.get( keyField ) : null;
				if ( key != null ) map_Fields.put( key, aRecord.get( valueField ) );
			}

			return map_Fields;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,Object> mapFields( Map<Object,sObject> map_Records, String keyField, String valueField )
	{
		return map_Records != null ? mapFields( map_Records.values(), keyField, valueField ) : null;
	}
//*/
	/***********************************************************
					groupRecords method
	***********************************************************/
/*
	public static Map<Object,List<sObject>> groupRecords( List<sObject> list_Records, String keyField )
	{
		if ( !validateArguments( list_Records, keyField, Object.class ) ) return null;

		try
		{
			Map<Object,List<sObject>> map_Records = new Map<Object,List<sObject>>();

			for ( sObject aRecord : list_Records )
			{
				Object key = aRecord != null ? aRecord.get( keyField ) : null;
				if ( key == null ) continue;
				if ( !map_Records.containsKey( key ) )
				{
					map_Records.put( key, new List<sObject>() );
				}
				map_Records.get( key ).add( aRecord );
			}

			return map_Records;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,List<sObject>> groupRecords( Map<Object,sObject> map_Records, String keyField )
	{
		return map_Records != null ? groupRecords( map_Records.values(), keyField ) : null;
	}
//*/
	/***********************************************************
					groupFields method
	***********************************************************/
/*
	public static Map<Object,Set<Object>> groupFields( List<sObject> list_Records, String keyField, String valueField )
	{
		if ( !validateArguments( list_Records, new Set<String>{ keyField, valueField }, Object.class ) ) return null;

		try
		{
			Map<Object,Set<Object>> map_Fields = new Map<Object,Set<Object>>();

			for ( sObject aRecord : list_Records )
			{
				Object key = aRecord != null ? aRecord.get( keyField ) : null;
				if ( key == null ) continue;
				if ( !map_Fields.containsKey( key ) )
				{
					map_Fields.put( key, new Set<Object>() );
				}
				map_Fields.get( key ).add( aRecord.get( valueField ) );
			}

			return map_Fields;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,Set<Object>> groupFields( Map<Object,sObject> map_Records, String keyField, String valueField )
	{
		return map_Records != null ? groupFields( map_Records.values(), keyField, valueField ) : null;
	}
//*/
	/***********************************************************
					groupFieldsInLists method
	***********************************************************/
/*
	public static Map<Object,List<Object>> groupFieldsInLists( List<sObject> list_Records, String keyField, String valueField )
	{
		if ( !validateArguments( list_Records, new Set<String>{ keyField, valueField }, Object.class ) ) return null;

		try
		{
			Map<Object,List<Object>> map_Fields = new Map<Object,List<Object>>();

			for ( sObject aRecord : list_Records )
			{
				Object key = aRecord != null ? aRecord.get( keyField ) : null;
				if ( key == null ) continue;
				if ( !map_Fields.containsKey( key ) )
				{
					map_Fields.put( key, new List<Object>() );
				}
				map_Fields.get( key ).add( aRecord.get( valueField ) );
			}

			return map_Fields;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,List<Object>> groupFieldsInLists( Map<Object,sObject> map_Records, String keyField, String valueField )
	{
		return map_Records != null ? groupFieldsInLists( map_Records.values(), keyField, valueField ) : null;
	}
//*/
	/***********************************************************
					filterRecords method
	***********************************************************/
/*
	public static List<sObject> filterRecords( List<sObject> list_Records, String filterField, Set<Object> set_fieldValues )
	{
		if ( !validateArguments( list_Records, filterField, Object.class ) || set_fieldValues == null ) return null;

		try
		{
			List<sObject> list_FilteredRecords = new List<sObject>();

			for ( sObject aRecord : list_Records )
			{
				if ( aRecord != null && set_fieldValues.contains( aRecord.get( filterField ) ) )
				{
					list_FilteredRecords.add( aRecord );
				}
			}

			return list_FilteredRecords;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static List<sObject> filterRecords( Map<Object,sObject> map_Records, String filterField, Set<Object> set_fieldValues )
	{
		return map_Records != null ? filterRecords( map_Records.values(), filterField, set_fieldValues ) : null;
	}

	public static List<sObject> filterRecords( List<sObject> list_Records, String filterField, Object fieldValue )
	{
		return filterRecords( list_Records, filterField, new Set<Object>{ fieldValue } );
	}

	public static List<sObject> filterRecords( Map<Object,sObject> map_Records, String filterField, Object fieldValue )
	{
		return map_Records != null ? filterRecords( map_Records.values(), filterField, new Set<Object>{ fieldValue } ) : null;
	}
//*/
	/***********************************************************
					countRecords method
	***********************************************************/
/*
	public static Integer countRecords( List<sObject> list_Records, String fieldName, Set<Object> set_fieldValues )
	{
		if ( !validateArguments( list_Records, fieldName, Object.class ) || set_fieldValues == null ) return null;

		try
		{
			Integer recordCount = 0;

			for ( sObject aRecord : list_Records )
			{
				if ( set_fieldValues.contains( aRecord.get( fieldName ) ) ) recordCount++;
			}

			return recordCount;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Integer countRecords( List<sObject> list_Records, String fieldName, Object fieldValue )
	{
		return countRecords( list_Records, fieldName, new Set<Object>{ fieldValue } );
	}
//*/
	/***********************************************************
						sum methods
	***********************************************************/
/*
	public static Decimal sum( List<Decimal> list_Decimals )
	{
		if ( list_Decimals == null ) return null;

		Decimal sum = 0;
		for ( Decimal value : list_Decimals ) sum += value;
		return sum;
	}

	public static Double sum( List<Double> list_Doubles )
	{
		if ( list_Doubles == null ) return null;

		Double sum = 0.0;
		for ( Double value : list_Doubles ) sum += value;
		return sum;
	}

	public static Integer sum( List<Integer> list_Integers )
	{
		if ( list_Integers == null ) return null;

		Integer sum = 0;
		for ( Integer value : list_Integers ) sum += value;
		return sum;
	}

	public static Long sum( List<Long> list_Longs )
	{
		if ( list_Longs == null ) return null;

		Long sum = 0;
		for ( Long value : list_Longs ) sum += value;
		return sum;
	}
//*/
	/***********************************************************
						sumOf... methods
	***********************************************************/
/*
	public static Decimal sumOfDecimals( List<sObject> list_Records, String fieldName )
	{
		return sum( listOfDecimals( list_Records, fieldName ) );
	}

	public static Map<String,Decimal> sumOfDecimal( List<sObject> list_Records, Set<String> set_FieldNames )
	{
		Map<String,Decimal> map_Sums = new Map<String,Decimal>();

		for ( String fieldName : set_FieldNames )
		{
			Decimal sum = sumOfDecimals( list_Records, fieldName );
			if ( sum != null ) map_Sums.put( fieldName, sum );
		}

		return map_Sums;
	}

	public static Double sumOfDoubles( List<sObject> list_Records, String fieldName )
	{
		return sum( listOfDoubles( list_Records, fieldName ) );
	}

	public static Map<String,Double> sumOfDoubles( List<sObject> list_Records, Set<String> set_FieldNames )
	{
		Map<String,Double> map_Sums = new Map<String,Double>();

		for ( String fieldName : set_FieldNames )
		{
			Double sum = sumOfDoubles( list_Records, fieldName );
			if ( sum != null ) map_Sums.put( fieldName, sum );
		}

		return map_Sums;
	}

	public static Integer sumOfIntegers( List<sObject> list_Records, String fieldName )
	{
		return sum( listOfIntegers( list_Records, fieldName ) );
	}

	public static Map<String,Integer> sumOfIntegers( List<sObject> list_Records, Set<String> set_FieldNames )
	{
		Map<String,Integer> map_Sums = new Map<String,Integer>();

		for ( String fieldName : set_FieldNames )
		{
			Integer sum = sumOfIntegers( list_Records, fieldName );
			if ( sum != null ) map_Sums.put( fieldName, sum );
		}

		return map_Sums;
	}

	public static Long sumOfLongs( List<sObject> list_Records, String fieldName )
	{
		return sum( listOfLongs( list_Records, fieldName ) );
	}

	public static Map<String,Long> sumOfLongs( List<sObject> list_Records, Set<String> set_FieldNames )
	{
		Map<String,Long> map_Sums = new Map<String,Long>();

		for ( String fieldName : set_FieldNames )
		{
			Long sum = sumOfIntegers( list_Records, fieldName );
			if ( sum != null ) map_Sums.put( fieldName, sum );
		}

		return map_Sums;
	}
//*/
	/***********************************************************
						invert method
	***********************************************************/
/*
	public static Map<Object,Object> invert( Map<Object,Object> theMap )
	{
		if ( theMap == null ) return null;

		try
		{
			Map<Object,Object> invertedMap = new Map<Object,Object>();

			for ( Object aKey : theMap.keySet() )
			{
				Object aValue = theMap.get( aKey );
				if ( aValue != null ) invertedMap.put( aValue, aKey );
			}

			return invertedMap;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,Set<Object>> invert( Map<Object,Set<Object>> theMap )
	{
		if ( theMap == null ) return null;

		try
		{
			Map<Object,Set<Object>> invertedMap = new Map<Object,Set<Object>>();

			for ( Object aKey : theMap.keySet() )
			{
				Set<Object> values = theMap.get( aKey );
				if ( values == null ) continue;
				for ( Object aValue : values )
				{
					if ( !invertedMap.containsKey( aValue ) )
					{
						invertedMap.put( aValue, new Set<Object>() );
					}
					invertedMap.get( aValue ).add( aKey );
				}
			}

			return invertedMap;
		}
		catch ( Exception e )
		{
			return null;
		}
	}

	public static Map<Object,List<Object>> invert( Map<Object,List<Object>> theMap )
	{
		if ( theMap == null ) return null;

		try
		{
			Map<Object,List<Object>> invertedMap = new Map<Object,List<Object>>();

			for ( Object aKey : theMap.keySet() )
			{
				List<Object> values = theMap.get( aKey );
				if ( values == null ) continue;
				for ( Object aValue : values )
				{
					if ( !invertedMap.containsKey( aValue ) )
					{
						invertedMap.put( aValue, new List<Object>() );
					}
					invertedMap.get( aValue ).add( aKey );
				}
			}

			return invertedMap;
		}
		catch ( Exception e )
		{
			return null;
		}
	}
//*/
}