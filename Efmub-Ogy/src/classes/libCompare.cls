/*******************************************************//**

@class		CWCompare

@brief		CW Core Compare Class

	This class implements a generic comparison mechanism.

@author	 Glyn Anderson (LiquidHub.GHA)

@version	2013-11-10	LiquidHub.GHA
	Created as part of CWSorter.
@version	2014-08-07	LiquidHub.GHA
	Added 'isComparable' and 'compare' methods.
@version	2014-09-24	LiquidHub.GHA
	Moved from CWSorter into CWCompare.
@version	2014-10-17	LiquidHub.GHA
	Added 'compare' methods for sObjects and CWObjects.
	Added 'equals' methods.
@version	2014-12-16	LiquidHub.GHA
	Fixed bug in compare of unknown types.
@version	2015-12-29	LiquidHub.GHA
	Generalized support for CWObjects to any class that
	implements the CWAccessible interface.

@see		CWCompareTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWCompare
{
	/*******************************************************
					Null Comparison values
	*******************************************************/

	private static final Integer	NULL_IS_SMALL				= -1;
	private static final Integer	NULL_IS_LARGE				=  1;
	private static final Integer	DEFAULT_NULL_COMPARISON		= NULL_IS_SMALL;

	public static Integer	nullIsSmall()	{ return NULL_IS_SMALL; }
	public static Integer	nullIsLarge()	{ return NULL_IS_LARGE; }

	/*******************************************************
					isComparable method
	*******************************************************/

	public static Boolean isComparable( Type theType )
	{
		return
			theType != null
		&&	(	CWType.isOrdered( theType )
			||	theType == Id.class
			||	theType == String.class
			||	theType == Boolean.class
			);
	}

	/*******************************************************
						compare methods

	These methods compare two objects of a known Type.
	'compareNullIsSmall' compares such that 'null' is less
	than any non-null value.	'compareNullIsLarge' compares
	such that 'null' is greater than any non-null value.
	*******************************************************/

	public static Integer compare( Type theType, Object objectA, Object objectB, Integer nullComparison )
	{
		if ( nullComparison == null ) nullComparison = DEFAULT_NULL_COMPARISON;

		if ( theType == null														)	return null;
		if ( objectA != null && objectB != null && objectA instanceof Comparable	)	return ((Comparable) objectA).compareTo( objectB );
		if ( objectA == objectB || !isComparable( theType )							)	return 0;
		if ( objectA == null && objectB != null										)	return nullComparison;
		if ( objectA != null && objectB == null										)	return -nullComparison;

		return
		(	theType == Id		.class		?	((String)objectA).compareTo( (String)objectB )
		:	theType == String	.class		?	((String)objectA).compareTo( (String)objectB )
		:	theType == Date		.class		?	((Date)		objectA >	(Date)		objectB	? 1 : -1)
		:	theType == DateTime	.class		?	((DateTime)	objectA >	(DateTime)	objectB	? 1 : -1)
		:	theType == Decimal	.class		?	((Decimal)	objectA >	(Decimal)	objectB	? 1 : -1)
		:	theType == Double	.class		?	((Double)	objectA >	(Double)	objectB	? 1 : -1)
		:	theType == Integer	.class		?	((Integer)	objectA >	(Integer)	objectB	? 1 : -1)
		:	theType == Long		.class		?	((Long)		objectA >	(Long)		objectB	? 1 : -1)
		:	theType == Time		.class		?	((Time)		objectA >	(Time)		objectB	? 1 : -1)
		:	theType == Boolean	.class		?	((Boolean)	objectA							? 1 : -1)	:	0
		);
	}

	public static Integer compare( Type theType, Object objectA, Object objectB )
	{
		return compare( theType, (Object) objectA, (Object) objectB, (Integer) null );
	}

	public static Integer compareNullIsSmall( Type theType, Object objectA, Object objectB )
	{
		return compare( theType, (Object) objectA, (Object) objectB, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( Type theType, Object objectA, Object objectB )
	{
		return compare( theType, (Object) objectA, (Object) objectB, NULL_IS_LARGE );
	}

	/*******************************************************
						compare methods

	These methods compare two objects of unknown Types.	Their
	Types are determined before comparing.	If they are not the
	same Type, compare returns null.
	*******************************************************/

	public static Integer compare( Object objectA, Object objectB, Integer nullComparison )
	{
		Type	typeA	= CWType.getPrimitiveType( objectA );
		Type	typeB	= CWType.getPrimitiveType( objectB );

		return
			typeA == null && typeB == null						?	0
		:	typeA != null && typeB != null && typeA != typeB	?	null
		:	typeA != null										?	compare( typeA, objectA, objectB, nullComparison )
		:															compare( typeB, objectA, objectB, nullComparison );
	}

	public static Integer compare( Object objectA, Object objectB )
	{
		return compare( (Object) objectA, (Object) objectB, (Integer) null );
	}

	public static Integer compareNullIsSmall( Object objectA, Object objectB )
	{
		return compare( (Object) objectA, (Object) objectB, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( Object objectA, Object objectB )
	{
		return compare( (Object) objectA, (Object) objectB, NULL_IS_LARGE );
	}

	/*******************************************************
						compare methods

	These methods compare the values of a field from two sObjects,
	when the field type is known.
	*******************************************************/

	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName, Integer nullComparison )
	{
		return compare
		(	theType,
			objectA != null ? objectA.get( fieldName ) : null,
			objectB != null ? objectB.get( fieldName ) : null,
			nullComparison
		);
	}

	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName )
	{
		return compare( theType, (sObject) objectA, (sObject) objectB, fieldName, (Integer) null );
	}

	public static Integer compareNullIsSmall( Type theType, sObject objectA, sObject objectB, String fieldName )
	{
		return compare( theType, (sObject) objectA, (sObject) objectB, fieldName, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( Type theType, sObject objectA, sObject objectB, String fieldName )
	{
		return compare( theType, (sObject) objectA, (sObject) objectB, fieldName, NULL_IS_LARGE );
	}

	/*******************************************************
						compare methods

	These methods compare the values of a field from two sObjects,
	when the field type is unknown.
	*******************************************************/

	public static Integer compare( sObject objectA, sObject objectB, String fieldName, Integer nullComparison )
	{
		return compare
		(	objectA != null ? objectA.get( fieldName ) : null,
			objectB != null ? objectB.get( fieldName ) : null,
			nullComparison
		);
	}

	public static Integer compare( sObject objectA, sObject objectB, String fieldName )
	{
		return compare( (sObject) objectA, (sObject) objectB, fieldName, (Integer) null );
	}

	public static Integer compareNullIsSmall( sObject objectA, sObject objectB, String fieldName )
	{
		return compare( (sObject) objectA, (sObject) objectB, fieldName, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( sObject objectA, sObject objectB, String fieldName )
	{
		return compare( (sObject) objectA, (sObject) objectB, fieldName, NULL_IS_LARGE );
	}

	/*******************************************************
						compare methods

	These methods compare the values of a field from two CWAccessible
	objects when the field type is known.
	*******************************************************/

	public static Integer compare( Type theType, CWAccessible objectA, CWAccessible objectB, String fieldName, Integer nullComparison )
	{
		return compare
		(	theType,
			objectA != null ? objectA.get( fieldName ) : null,
			objectB != null ? objectB.get( fieldName ) : null,
			nullComparison
		);
	}

	public static Integer compare( Type theType, CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( theType, (CWAccessible) objectA, (CWAccessible) objectB, fieldName, (Integer) null );
	}

	public static Integer compareNullIsSmall( Type theType, CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( theType, (CWAccessible) objectA, (CWAccessible) objectB, fieldName, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( Type theType, CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( theType, (CWAccessible) objectA, (CWAccessible) objectB, fieldName, NULL_IS_LARGE );
	}

	/*******************************************************
						compare methods

	These methods compare the values of a field from two CWAccessible
	objects when the field type is unknown.
	*******************************************************/

	public static Integer compare( CWAccessible objectA, CWAccessible objectB, String fieldName, Integer nullComparison )
	{
		return compare
		(	objectA != null ? objectA.get( fieldName ) : null,
			objectB != null ? objectB.get( fieldName ) : null,
			nullComparison
		);
	}

	public static Integer compare( CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( (CWAccessible) objectA, (CWAccessible) objectB, fieldName, (Integer) null );
	}

	public static Integer compareNullIsSmall( CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( (CWAccessible) objectA, (CWAccessible) objectB, fieldName, NULL_IS_SMALL );
	}

	public static Integer compareNullIsLarge( CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return compare( (CWAccessible) objectA, (CWAccessible) objectB, fieldName, NULL_IS_LARGE );
	}

	/*******************************************************
						equals methods

	These methods compare the two values for equality.
	*******************************************************/

	public static Boolean equals( Object objectA, Object objectB )
	{
		return objectA == objectB;
	}

	public static Boolean equals( sObject objectA, sObject objectB, String fieldName )
	{
		return equals
		(	(Object) (objectA != null ? objectA.get( fieldName ) : null),
			(Object) (objectB != null ? objectB.get( fieldName ) : null)
		);
	}

	public static Boolean equals( CWAccessible objectA, CWAccessible objectB, String fieldName )
	{
		return equals
		(	(Object) (objectA != null ? objectA.get( fieldName ) : null),
			(Object) (objectB != null ? objectB.get( fieldName ) : null)
		);
	}
}