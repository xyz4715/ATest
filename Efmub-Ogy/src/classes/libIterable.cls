/*******************************************************//**

@class		CWIterable

@brief		CW Core Iterable Class

	This class provides a nestable version of Iterable that can
	filter and transform elements using a lazy evaluation scheme.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-02-22	LiquidHub.GHA
	Created.
@version	2014-02-22	LiquidHub.GHA
	Added the 'toList_<type>' methods.
@version	2014-08-07	LiquidHub.GHA
	Made Type optional in 'toList' method.
@version	2014-09-17	LiquidHub.GHA
	Removed wrapping CWIterables with CWPredicates in all of the
	'toList_<type>' methods in favor of catching type conversion
	errors in 'toList'.

@see		CWIterableTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWIterable implements Iterable<Object>
{
	/*******************************************************
						members
	*******************************************************/

	protected Iterable<Object>	theIterable;		//	the source (nested) Iterable
	protected CWPredicate		thePredicate;		//	a predicate used to filter the source Iterable
	protected List<CWFunction>	list_Functions;		//	functions applied to transform each element

	/*******************************************************
				CWIterable constructors

	CWIterable objects must wrap another Iterable object.
	They may optionally have a predicate (used to filter objects
	from the nested Iterable) and/or a list of functions (used
	to transform objects from the nested Iterable).
	*******************************************************/

	public CWIterable( Iterable<Object> anIterable, CWPredicate aPredicate, List<CWFunction> functions )
	{
		theIterable		= anIterable;
		thePredicate	= aPredicate;
		list_Functions	= functions;
	}

	public CWIterable( Iterable<Object> anIterable, CWPredicate aPredicate, CWFunction aFunction )
	{
		this( anIterable, aPredicate, new List<CWFunction>{ aFunction } );
	}

	public CWIterable( Iterable<Object> anIterable, CWPredicate aPredicate )
	{
		this( anIterable, aPredicate, new List<CWFunction>() );
	}

	public CWIterable( Iterable<Object> anIterable, List<CWFunction> functions )
	{
		this( anIterable, (CWPredicate) null, functions );
	}

	public CWIterable( Iterable<Object> anIterable, CWFunction aFunction )
	{
		this( anIterable, (CWPredicate) null, new List<CWFunction>{ aFunction } );
	}

	public CWIterable( Iterable<Object> anIterable )
	{
		this( anIterable, (CWPredicate) null, new List<CWFunction>() );
	}

	/*******************************************************
					test method

	This method applies the predicate to the given object.
	*******************************************************/

	private Boolean test( Object theObject )
	{
		return CWPredicate.test( thePredicate, theObject );
	}

	/*******************************************************
					transform method

	This method applies all functions to the given object.
	*******************************************************/

	private Object transform( Object theObject )
	{
		return CWFunction.transform( list_Functions, theObject );
	}

	/*******************************************************
					toList methods

	These methods put the elements returned by this CWIterable
	into a List.  The optional parameter, 'maxSize', specifies
	the maximum number of elements to be put into the List.
	*******************************************************/

	private List<Object> toList( String method, Type theType, Integer maxSize )
	{
		if ( theType == null ) theType = Object.class;

		List<Object> list_Objects = (List<Object>) Type.forName( 'List<' + theType.getName() + '>' ).newInstance();

		Integer				size		= 0;
		Iterator<Object>	theIterator	= Iterator();

		while ( (maxSize == null || size < maxSize) && theIterator.hasNext() )
		{
			try
			{
				list_Objects.add( theIterator.next() );
				size++;
			}
			catch ( Exception theException )
			{
				CWException.error( 'An error occurred in CWIterable.' + method + '.', theException );
			}
		}
		return list_Objects;
	}

	public List<Object> toList( Type theType, Integer maxSize )
	{
		return toList( 'toList', theType, (Integer) null );
	}

	public List<Object> toList( Type theType )
	{
		return toList( theType, (Integer) null );
	}

	public List<Object> toList( Integer maxSize )
	{
		return toList( (Type) null, maxSize );
	}

	public List<Object> toList()
	{
		return toList( (Type) null, (Integer) null );
	}

	public static List<Object> toList( CWIterable theIterable, Type theType, Integer maxSize )
	{
		return theIterable != null ? theIterable.toList( theType, maxSize ) : null;
	}

	public static List<Object> toList( CWIterable theIterable, Type theType )
	{
		return toList( theIterable, theType, (Integer) null );
	}

	public static List<Object> toList( CWIterable theIterable, Integer maxSize )
	{
		return toList( theIterable, (Type) null, maxSize );
	}

	public static List<Object> toList( CWIterable theIterable )
	{
		return toList( theIterable, (Type) null, (Integer) null );
	}

	/*******************************************************
					toList_Blob methods

	These methods put the elements returned by this CWIterable
	into a List of Blobs.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Blob> toList_Blob( Integer maxSize )
	{
		return (List<Blob>) this.toList( 'toList_Blob', Blob.class, maxSize );
	}

	public List<Blob> toList_Blob()
	{
		return toList_Blob( (Integer) null );
	}

	public static List<Blob> toList_Blob( CWIterable theIterable, Integer maxSize )
	{
		return (List<Blob>) (theIterable != null ? theIterable.toList_Blob( maxSize ) : null);
	}

	public static List<Blob> toList_Blob( CWIterable theIterable )
	{
		return toList_Blob( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Boolean methods

	These methods put the elements returned by this CWIterable
	into a List of Booleans.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Boolean> toList_Boolean( Integer maxSize )
	{
		return (List<Boolean>) this.toList( 'toList_Boolean', Boolean.class, maxSize );
	}

	public List<Boolean> toList_Boolean()
	{
		return toList_Boolean( (Integer) null );
	}

	public static List<Boolean> toList_Boolean( CWIterable theIterable, Integer maxSize )
	{
		return (List<Boolean>) (theIterable != null ? theIterable.toList_Boolean( maxSize ) : null);
	}

	public static List<Boolean> toList_Boolean( CWIterable theIterable )
	{
		return toList_Boolean( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Date methods

	These methods put the elements returned by this CWIterable
	into a List of Dates.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Date> toList_Date( Integer maxSize )
	{
		return (List<Date>) this.toList( 'toList_Date', Date.class, maxSize );
	}

	public List<Date> toList_Date()
	{
		return toList_Date( (Integer) null );
	}

	public static List<Date> toList_Date( CWIterable theIterable, Integer maxSize )
	{
		return (List<Date>) (theIterable != null ? theIterable.toList_Date( maxSize ) : null);
	}

	public static List<Date> toList_Date( CWIterable theIterable )
	{
		return toList_Date( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_DateTime methods

	These methods put the elements returned by this CWIterable
	into a List of DateTimes.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<DateTime> toList_DateTime( Integer maxSize )
	{
		return (List<DateTime>) this.toList( 'toList_DateTime', DateTime.class, maxSize );
	}

	public List<DateTime> toList_DateTime()
	{
		return toList_DateTime( (Integer) null );
	}

	public static List<DateTime> toList_DateTime( CWIterable theIterable, Integer maxSize )
	{
		return (List<DateTime>) (theIterable != null ? theIterable.toList_DateTime( maxSize ) : null);
	}

	public static List<DateTime> toList_DateTime( CWIterable theIterable )
	{
		return toList_DateTime( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Decimal methods

	These methods put the elements returned by this CWIterable
	into a List of Decimals.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Decimal> toList_Decimal( Integer maxSize )
	{
		return (List<Decimal>) this.toList( 'toList_Decimal', Decimal.class, maxSize );
	}

	public List<Decimal> toList_Decimal()
	{
		return toList_Decimal( (Integer) null );
	}

	public static List<Decimal> toList_Decimal( CWIterable theIterable, Integer maxSize )
	{
		return (List<Decimal>) (theIterable != null ? theIterable.toList_Decimal( maxSize ) : null);
	}

	public static List<Decimal> toList_Decimal( CWIterable theIterable )
	{
		return toList_Decimal( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Double methods

	These methods put the elements returned by this CWIterable
	into a List of Doubles.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Double> toList_Double( Integer maxSize )
	{
		return (List<Double>) this.toList( 'toList_Double', Double.class, maxSize );
	}

	public List<Double> toList_Double()
	{
		return toList_Double( (Integer) null );
	}

	public static List<Double> toList_Double( CWIterable theIterable, Integer maxSize )
	{
		return (List<Double>) (theIterable != null ? theIterable.toList_Double( maxSize ) : null);
	}

	public static List<Double> toList_Double( CWIterable theIterable )
	{
		return toList_Double( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Integer methods

	These methods put the elements returned by this CWIterable
	into a List of Integers.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Integer> toList_Integer( Integer maxSize )
	{
		return (List<Integer>) this.toList( 'toList_Integer', Integer.class, maxSize );
	}

	public List<Integer> toList_Integer()
	{
		return toList_Integer( (Integer) null );
	}

	public static List<Integer> toList_Integer( CWIterable theIterable, Integer maxSize )
	{
		return (List<Integer>) (theIterable != null ? theIterable.toList_Integer( maxSize ) : null);
	}

	public static List<Integer> toList_Integer( CWIterable theIterable )
	{
		return toList_Integer( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Long methods

	These methods put the elements returned by this CWIterable
	into a List of Longs.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Long> toList_Long( Integer maxSize )
	{
		return (List<Long>) this.toList( 'toList_Long', Long.class, maxSize );
	}

	public List<Long> toList_Long()
	{
		return toList_Long( (Integer) null );
	}

	public static List<Long> toList_Long( CWIterable theIterable, Integer maxSize )
	{
		return (List<Long>) (theIterable != null ? theIterable.toList_Long( maxSize ) : null);
	}

	public static List<Long> toList_Long( CWIterable theIterable )
	{
		return toList_Long( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Object methods

	These methods put the elements returned by this CWIterable
	into a List of Objects.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Object> toList_Object( Integer maxSize )
	{
		return (List<Object>) this.toList( 'toList_Object', Object.class, maxSize );
	}

	public List<Object> toList_Object()
	{
		return toList_Object( (Integer) null );
	}

	public static List<Object> toList_Object( CWIterable theIterable, Integer maxSize )
	{
		return (List<Object>) (theIterable != null ? theIterable.toList_Object( maxSize ) : null);
	}

	public static List<Object> toList_Object( CWIterable theIterable )
	{
		return toList_Object( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_SObject methods

	These methods put the elements returned by this CWIterable
	into a List of SObjects.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<SObject> toList_SObject( Integer maxSize )
	{
		return (List<SObject>) this.toList( 'toList_SObject', SObject.class, maxSize );
	}

	public List<SObject> toList_SObject()
	{
		return toList_SObject( (Integer) null );
	}

	public static List<SObject> toList_SObject( CWIterable theIterable, Integer maxSize )
	{
		return (List<SObject>) (theIterable != null ? theIterable.toList_SObject( maxSize ) : null);
	}

	public static List<SObject> toList_SObject( CWIterable theIterable )
	{
		return toList_SObject( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_String methods

	These methods put the elements returned by this CWIterable
	into a List of Strings.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<String> toList_String( Integer maxSize )
	{
		return (List<String>) this.toList( 'toList_String', String.class, maxSize );
	}

	public List<String> toList_String()
	{
		return toList_String( (Integer) null );
	}

	public static List<String> toList_String( CWIterable theIterable, Integer maxSize )
	{
		return (List<String>) (theIterable != null ? theIterable.toList_String( maxSize ) : null);
	}

	public static List<String> toList_String( CWIterable theIterable )
	{
		return toList_String( theIterable, (Integer) null );
	}

	/*******************************************************
					toList_Time methods

	These methods put the elements returned by this CWIterable
	into a List of Times.  The optional parameter, 'maxSize',
	specifies the maximum number of elements to be put into
	the List.
	*******************************************************/

	public List<Time> toList_Time( Integer maxSize )
	{
		return (List<Time>) this.toList( 'toList_Time', Time.class, maxSize );
	}

	public List<Time> toList_Time()
	{
		return toList_Time( (Integer) null );
	}

	public static List<Time> toList_Time( CWIterable theIterable, Integer maxSize )
	{
		return (List<Time>) (theIterable != null ? theIterable.toList_Time( maxSize ) : null);
	}

	public static List<Time> toList_Time( CWIterable theIterable )
	{
		return toList_Time( theIterable, (Integer) null );
	}

	/*******************************************************
					Iterator method

	This method implements the Iterable interface.  It returns
	a CWIterator instance associated with this CWIterable.
	*******************************************************/

	public virtual Iterator<Object> Iterator()
	{
		return new CWIterator( this, theIterable != null ? theIterable.Iterator() : null );
	}

	/*******************************************************
					CWIterator class

	This private class implements the Iterator for CWIterable.
	It is only used internally to CWIterable.
	*******************************************************/

	private class CWIterator implements Iterator<Object>
	{
		/***************************************************
						members
		***************************************************/

		private CWIterable			theIterable;	//	the CWIterable we iterate
		private Iterator<Object>	theIterator;	//	the Iterator of the nested Iterable
		private Boolean				haveObject;		//	true if we have an Object ready to return
		private Object				theObject;		//	the Object to be returned by 'next()'

		/***************************************************
					CWIterator constructor
		***************************************************/

		private CWIterator( CWIterable anIterable, Iterator<Object> anIterator )
		{
			theIterable	= anIterable;
			theIterator	= anIterator;
			haveObject	= false;
		}

		/***************************************************
						hasNext method

		This method implments the Iterator interface.  It
		returns 'true' if this Iterator can supply another
		Object.  This applies the predicate, if any, to filter
		Objects from the nested Iterable.
		***************************************************/

		public Boolean hasNext()
		{
			if ( theIterator == null ) return false;

			if ( haveObject ) return true;

			while ( theIterator.hasNext() )
			{
				theObject = theIterator.next();
				if ( theIterable.test( theObject ) )
				{
					haveObject = true;
					return true;
				}
			}
			return false;
		}

		/***************************************************
						next method

		This method implments the Iterator interface.  It
		returns the next Object from the CWIterable, or 'null'
		if there is none.  This applies the CWIterable's
		funciton(s), if any.
		***************************************************/

		public Object next()
		{
			if ( !hasNext() ) return null;

			haveObject = false;

			return theIterable.transform( theObject );
		}
	}
}