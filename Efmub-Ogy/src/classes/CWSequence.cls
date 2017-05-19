/*******************************************************//**

@class		CWSequence

@brief		CW Core Sequence Class

	This class implements a generic mechanism for sequencing records.  Use this
	class to maintain an integer sequence among related records.

	For example, you have a custom object, My_Object__c, which is a child of
	another custom object, Parent_Object__c.  My_Object__c has two fields
	of interest, Display_Order__c (a Number), and Parent_Object__c (a Lookup
	to the parent record).  You would like the values in the Display_Order__c
	field to be unique, starting with '1' and incrementing by 1, with no gaps,
	with the children of each parent object maintaining their own sequence.

	From within the My_Object__c afterTrigger handler, call:

	update CWSequence.sequence( theTrigger, 'Display_Order__c', 'Parent_Object__c' );

	The CWSequence.sequence method will find all My_Object__c records for
	which the Display_Order__c field has changed, and update the Display_Order__c
	fields of all of their sibling records.  It returns a list of records that
	have been modified (hence the 'update' in the example).  It works properly for
	all events: insert, update, delete and undelete.

	The records in each sequence don't have to be siblings.  You can have a sequence
	for every picklist value, or a sequence for every date, etc.  Just replace
	'Parent_Object__c' with the name of the field that paritions the records into
	different sequences.  To have one global sequence across all records, omit
	the partition field name altogether:

	update CWSequence.sequence( theTrigger, 'Display_Order__c' );

	If you need to perform the sequencing operation outside of a trigger, you can
	pass in a list of records (or a single record) instead of a CWTrigger instance:

	List<My_Object__c>	recordsWithNewDisplayOrder	= new List<My_Object__c>();
	...
	update CWSequence.sequence( recordsWithNewDisplayOrder, 'Display_Order__c', 'Parent_Object__c' );

	For this to work, all the records in the list must have an Id (i.e. already be
	inserted in the database).  The sequencing will work as it would within an
	update trigger.  The code assumes that all records passed in have a new sequence
	value.

	How the Sequence Numbers are Computed
	=====================================

	The sequence numbers of the records passed into the sequence method are
	preserved, unless they conflict with each other, or unless that would leave
	a gap in the sequence.  When two or more passed-in records conflict, the
	first encountered takes precedence and subsequent records take precedence
	for sequential values.

	Records that are not passed in are queried by the code.  These records
	have no precedence.  Their relative order will be preserved, but they fill
	in around the passed-in records as needed.

	Any records with a null sequence value are put at the end of the sequence
	in the order they are encountered.

	For example, assume records A, B, C, D, and E, with an original sequence of:

	A = 1, B = 2, C = 3, D = 4, E = 5

	If we attempt to modify B and D both to have a sequence value of 3, the
	re-sequenced records will be:

	A = 1, C = 2, B = 3, D = 4, E = 5

	Notes: A remains 1 because no passed-in record claims that value.  C becomes
	2 because no passed-in record claims a value less than or equal to 2, and it
	is the next queried record in the original sequence.  B becomes 3 because it
	is the first passed-in record to be encountered that claims that value.  D
	becomes 4 because it is the next passed-in record that claims a value less than
	or equal to 4.  E remains 5 because there are no more passed-in records and
	it is the next queried record in the original sequence.

	In this example, only records B and C have been modified with a new sequence
	value, so the list returned by the sequence method will contain only two records.

@author	 Glyn Anderson (LiquidHub.GHA)

@version	2015-03-18	LiquidHub.GHA
	Created.

@see		CWSequenceTest

	(c)2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWSequence
{
	/*******************************************************
			sequence methods (Trigger context)

	Use one of these sequence methods when the list of records
	to be sequenced is the records in a trigger.
	*******************************************************/

	public static List<sObject> sequence( CWTrigger theTrigger, String sequenceFieldName )
	{
		return sequence( theTrigger, sequenceFieldName, (String) null, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( CWTrigger theTrigger, String sequenceFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		return sequence( theTrigger, sequenceFieldName, (String) null, predicate, predicateFields );
	}

	public static List<sObject> sequence( CWTrigger theTrigger, String sequenceFieldName, String partitionFieldName )
	{
		return sequence( theTrigger, sequenceFieldName, partitionFieldName, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( CWTrigger theTrigger, String sequenceFieldName, String partitionFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		if ( String.isBlank( sequenceFieldName ) ) return new List<sObject>();
		CWPartition		partitionOfRecordsWithNewSequence	=
			!String.isBlank( partitionFieldName )
		?	new CWPartition( partitionFieldName )
		:	new CWPartition( (CWKeyFunction) null );

		for ( sObject record : theTrigger.list_Records )
		{
			if	(	!theTrigger.isDelete
				&&	!theTrigger.hasChanged( record, sequenceFieldName )
				) continue;
			Object	key		= partitionOfRecordsWithNewSequence.getKey( record );
			partitionOfRecordsWithNewSequence.putKey( key );
			if ( !theTrigger.isDelete )
			{
				Double	sequence	= (Double) record.get( sequenceFieldName );
				if ( sequence != null && sequence <= 0 )
				{
					record = record.clone( true, true, true, true );
					record.put( sequenceFieldName, (Double) null );
				}
				partitionOfRecordsWithNewSequence.get( key ).add( record );
			}
		}
		if ( partitionOfRecordsWithNewSequence.isEmpty() ) return new List<sObject>();

		return sequence( partitionOfRecordsWithNewSequence, theTrigger.sObjectType, sequenceFieldName, partitionFieldName, predicate, predicateFields );
	}

	/*******************************************************
			sequence methods (generic context)

	Use one of these sequence methods with an arbitrary list of records.
	*******************************************************/

	public static List<sObject> sequence( sObject recordWithNewSequence, String sequenceFieldName )
	{
		return sequence( recordWithNewSequence, sequenceFieldName, (String) null, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( sObject recordWithNewSequence, String sequenceFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		return sequence( recordWithNewSequence, sequenceFieldName, (String) null, predicate, predicateFields );
	}

	public static List<sObject> sequence( sObject recordWithNewSequence, String sequenceFieldName, String partitionFieldName )
	{
		return sequence( new List<sObject>{ recordWithNewSequence }, sequenceFieldName, partitionFieldName, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( sObject recordWithNewSequence, String sequenceFieldName, String partitionFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		return sequence( new List<sObject>{ recordWithNewSequence }, sequenceFieldName, partitionFieldName, predicate, predicateFields );
	}

	public static List<sObject> sequence( List<sObject> recordsWithNewSequence, String sequenceFieldName )
	{
		return sequence( recordsWithNewSequence, sequenceFieldName, (String) null, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( List<sObject> recordsWithNewSequence, String sequenceFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		return sequence( recordsWithNewSequence, sequenceFieldName, (String) null, predicate, predicateFields );
	}

	public static List<sObject> sequence( List<sObject> recordsWithNewSequence, String sequenceFieldName, String partitionFieldName )
	{
		return sequence( recordsWithNewSequence, sequenceFieldName, partitionFieldName, (CWPredicate) null, (List<String>) null );
	}

	public static List<sObject> sequence( List<sObject> recordsWithNewSequence, String sequenceFieldName, String partitionFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		if ( recordsWithNewSequence == null || recordsWithNewSequence.isEmpty() || String.isBlank( sequenceFieldName ) ) return new List<sObject>();

		CWPartition		partitionOfRecordsWithNewSequence	=
			!String.isBlank( partitionFieldName )
		?	new CWPartition( recordsWithNewSequence, partitionFieldName )
		:	new CWPartition( recordsWithNewSequence, (CWKeyFunction) null );

		return sequence( partitionOfRecordsWithNewSequence, recordsWithNewSequence.getSObjectType(), sequenceFieldName, partitionFieldName, predicate, predicateFields );
	}

	/*******************************************************
			sequence method (private implementation)

	This private method is called by the other sequence methods
	to do the actual sequencing work.
	*******************************************************/

	private static List<sObject> sequence( CWPartition partitionOfRecordsWithNewSequence, Schema.sObjectType sObjectType, String sequenceFieldName, String partitionFieldName, CWPredicate predicate, List<String> predicateFields )
	{
		CWSorter	sorter	= new CWSorter( sObjectType );
		sorter.sortAscendingNullsLast( sequenceFieldName );
		sorter.sort( partitionOfRecordsWithNewSequence );

		CWQuery query = CWQuery.newQuery( sObjectType );
		query.add( new List<String>{ 'Id', sequenceFieldName } );
		if ( predicateFields != null ) query.add( predicateFields );
		query.orderByAscendingNullsLast( sequenceFieldName );
		if ( !String.isBlank( partitionFieldName ) )
		{
			query.add( partitionFieldName );
			query.newWhereClause().isIn( partitionFieldName, new List<Object>( partitionOfRecordsWithNewSequence.keySet() ) );
		}

		CWPartition		partitionOfAllRecords	=
			!String.isBlank( partitionFieldName )
		?	new CWPartition( query.query(), partitionFieldName )
		:	new CWPartition( query.query(), (CWKeyFunction) null );

		List<sObject>	recordsToUpdate		= new List<sObject>();

		for ( Object key : partitionOfRecordsWithNewSequence.keySet() )
		{
			List<sObject>	recordsWithNewSequence			= partitionOfRecordsWithNewSequence.get( key );
			Map<Id,sObject>	mapOfRecordsWithNewSequence		= new Map<Id,sObject>( recordsWithNewSequence );

			List<sObject>	allRecords						= partitionOfAllRecords.get( key );
			Map<Id,sObject>	mapOfAllRecords					= new Map<Id,sObject>( allRecords );

			Double	sequence	= 1;

			while ( !allRecords.isEmpty() )
			{
				sObject		record	= allRecords.get( 0 );

				if ( mapOfRecordsWithNewSequence.containsKey( (Id) record.get( 'Id' ) ) )
				{
					allRecords.remove( 0 );
					continue;
				}

				if ( !CWPredicate.test( predicate, record ) )
				{
					allRecords.remove( 0 );
					if ( (Double) record.get( sequenceFieldName ) != null )
					{
						record.put( sequenceFieldName, null );
						recordsToUpdate.add( record );
					}
					continue;
				}

				if ( recordsWithNewSequence.isEmpty() )
				{
					allRecords.remove( 0 );
					if ( (Double) record.get( sequenceFieldName ) != sequence )
					{
						record.put( sequenceFieldName, sequence );
						recordsToUpdate.add( record );
					}
					sequence++;
					continue;
				}

				sObject		recordWithNewSequence	= mapOfAllRecords.get( (Id) recordsWithNewSequence.get( 0 ).get( 'Id' ) );
				Double		newSequence				= (Double) recordsWithNewSequence.get( 0 ).get( sequenceFieldName );

				if ( !CWPredicate.test( predicate, recordWithNewSequence ) )
				{
					recordsWithNewSequence.remove( 0 );
					if ( newSequence != null )
					{
						recordWithNewSequence.put( sequenceFieldName, null );
						recordsToUpdate.add( recordWithNewSequence );
					}
					continue;
				}

				if ( newSequence == null || newSequence > sequence )
				{
					allRecords.remove( 0 );
					if ( (Double) record.get( sequenceFieldName ) != sequence )
					{
						record.put( sequenceFieldName, sequence );
						recordsToUpdate.add( record );
					}
					sequence++;
					continue;
				}

				recordsWithNewSequence.remove( 0 );
				if ( newSequence != sequence )
				{
					recordWithNewSequence.put( sequenceFieldName, sequence );
					recordsToUpdate.add( recordWithNewSequence );
				}
				sequence++;
			}

			while ( !recordsWithNewSequence.isEmpty() )
			{
				sObject		recordWithNewSequence	= mapOfAllRecords.get( (Id) recordsWithNewSequence.get( 0 ).get( 'Id' ) );
				Double		newSequence				= (Double) recordsWithNewSequence.get( 0 ).get( sequenceFieldName );

				if ( !CWPredicate.test( predicate, recordWithNewSequence ) )
				{
					recordsWithNewSequence.remove( 0 );
					if ( newSequence != null )
					{
						recordWithNewSequence.put( sequenceFieldName, null );
						recordsToUpdate.add( recordWithNewSequence );
					}
					continue;
				}

				recordsWithNewSequence.remove( 0 );
				if ( newSequence != sequence )
				{
					recordWithNewSequence.put( sequenceFieldName, sequence );
					recordsToUpdate.add( recordWithNewSequence );
				}
				sequence++;
			}
		}

		return recordsToUpdate;
	}
}