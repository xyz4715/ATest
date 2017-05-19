/*******************************************************//**

@class		CWPartition

@brief		CW Core Partition Class

	This class represents a partitioning of a collection of
	sObjects.  Used for grouping sObjects into lists of
	similar records.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-03-04	LiquidHub.GHA
	Created.
@version	2015-03-19	LiquidHub.GHA
	Added 'isEmpty', 'values', 'putKey' and 'getKey' methods.
@version	2015-05-18	LiquidHub.GHA
	Fixed 'put', 'getKey' and 'FieldValue.getKey' methods to be null-safe.
@version	2016-08-24	LiquidHub.GHA
	Added 'remove' method.

@see		CWPartitionTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWPartition
{
	/***********************************************************
						members
	***********************************************************/

	private Map<Object,List<sObject>>	thePartition;
	private CWKeyFunction				theKeyFunction;

	/***********************************************************
					CWPartition constructors

	All CWPartition constructors require a CWKeyFunction, except
	for the ones that take a field name - they create a default
	CWKeyFunction that uses the value of that field as the key.
	You can specify an optional collection of records, which will
	be added to the partition.  If present, the collection of
	records is the first parameter.
	***********************************************************/

	public CWPartition( CWKeyFunction keyFunction )
	{
		thePartition	= new Map<Object,List<sObject>>();
		theKeyFunction	= keyFunction;
	}

	public CWPartition( CWIterable inputRecords, CWKeyFunction keyFunction )
	{
		this( keyFunction );
		put( inputRecords );
	}

	public CWPartition( List<sObject> inputRecords, CWKeyFunction keyFunction )
	{
		this( keyFunction );
		put( (Iterable<sObject>) inputRecords );
	}

	public CWPartition( String fieldName )
	{
		this( new FieldValue( fieldName ) );
	}

	public CWPartition( CWIterable inputRecords, String fieldName )
	{
		this( inputRecords, new FieldValue( fieldName ) );
	}

	public CWPartition( List<sObject> inputRecords, String fieldName )
	{
		this( inputRecords, new FieldValue( fieldName ) );
	}

	/***********************************************************
					isEmpty method

	Returns true if the partition has no keys.
	***********************************************************/

	public Boolean isEmpty()
	{
		return thePartition.isEmpty();
	}

	/***********************************************************
					keySet method

	Returns the keyset of this partition.
	***********************************************************/

	public Set<Object> keySet()
	{
		return thePartition.keySet();
	}

	/***********************************************************
					containsKey method

	Returns true if the partition contains the specified key.
	***********************************************************/

	public Boolean containsKey( Object key )
	{
		return thePartition.containsKey( key );
	}

	/***********************************************************
					values method

	Returns the values (list of lists) of this partition.
	***********************************************************/

	public List<List<sObject>> values()
	{
		return thePartition.values();
	}

	/***********************************************************
						get method

	Returns the list of records that corresponds to the given key,
	or null, if there is no list for the key.
	***********************************************************/

	public List<sObject> get( Object theKey )
	{
		return thePartition.get( theKeyFunction != null ? theKey : (Object) null );
	}

	/***********************************************************
						put methods

	Insert the given record(s) into the partition.
	***********************************************************/

	public void put( sObject record )
	{
		if ( record == null ) return;

		Object key = theKeyFunction != null ? theKeyFunction.getKey( record ) : (Object) null;
		putKey( key );
		thePartition.get( key ).add( record );
	}

	private void put( Iterable<sObject> inputRecords )
	{
		if ( inputRecords == null ) return;

		Iterator<sObject> theIterator = inputRecords.Iterator();
		while ( theIterator.hasNext() ) put( theIterator.next() );
	}

	public void put( CWIterable inputRecords )
	{
		put( (Iterable<sObject>) inputRecords );
	}

	public void put( List<sObject> inputRecords )
	{
		put( (Iterable<sObject>) inputRecords );
	}

	/***********************************************************
						remove method

	Removes the given key from the partition and returns its list.
	***********************************************************/

	public List<sObject> remove( Object theKey )
	{
		return thePartition.remove( theKey );
	}

	/***********************************************************
						putKey method

	If the given key does not already exist, inserts an empty list
	for that key.
	***********************************************************/

	public void putKey( Object key )
	{
		if ( !thePartition.containsKey( key ) ) thePartition.put( key, new List<sObject>() );
	}

	/***********************************************************
						getKey method

	Returns a record's key value.
	***********************************************************/

	public Object getKey( sObject record )
	{
		return record != null && theKeyFunction != null ? theKeyFunction.getKey( record ) : null;
	}

	/***********************************************************
					FieldValue key function
	***********************************************************/

	private class FieldValue extends CWKeyFunction
	{
		String	theFieldName;

		public FieldValue( String fieldName )
		{
			theFieldName = fieldName;
		}

		public override Object getKey( sObject record )
		{
			return CWCollection.extractField( record, theFieldName );
		}
	}
}