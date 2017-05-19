/*******************************************************//**

@class		CWSorter

@brief		CW Core Sorter Class

	This class implements multi-field sorting of any sObject.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2013-11-10	LiquidHub.GHA
	Created.
@version	2014-08-07	LiquidHub.GHA
	Added 'isComparable' and 'compare' methods.
@version	2015-03-19	LiquidHub.GHA
	Added a version of 'sort' that takes a list of lists to be sorted,
	and another that takes a CWPartition and applies the sort to all of
	its lists.
@version	2015-12-29	LiquidHub.GHA
	Added the capability of sorting a list of CWAccessible objects.
	Refactored to the Monad pattern.

@see		CWSorterTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWSorter
{
	/*******************************************************
					ComparableWrapper class
	*******************************************************/

	private class ComparableWrapper implements Comparable
	{
		CWAccessible	theAccessible;
		sObject			theObject;
		CWSorter		theSorter;

		ComparableWrapper( sObject anObject, CWSorter aSorter )
		{
			theObject	= anObject;
			theSorter	= aSorter;
		}

		ComparableWrapper( CWAccessible	anAccessible, CWSorter aSorter )
		{
			theAccessible	= anAccessible;
			theSorter		= aSorter;
		}

		public Integer compareTo( Object other )
		{
			if ( theObject != null )
			{
				sObject	otherObject	= ((ComparableWrapper) other).theObject;

				for ( String fieldName : theSorter.fields() )
				{
					Integer comparison =
					(	theSorter.sortDirection( fieldName )
					*	CWCompare.compare
						(	theSorter.getType( fieldName ),
							theObject,
							otherObject,
							fieldName,
							theSorter.nullComparison( fieldName )
						)
					);

					if ( comparison != 0 ) return comparison;
				}
				return 0;
			}

			if ( theAccessible != null )
			{
				CWAccessible	otherAccessible	= ((ComparableWrapper) other).theAccessible;

				for ( String fieldName : theSorter.fields() )
				{
					Integer comparison =
					(	theSorter.sortDirection( fieldName )
					*	CWCompare.compare
						(	theSorter.getType( fieldName ),
							theAccessible,
							otherAccessible,
							fieldName,
							theSorter.nullComparison( fieldName )
						)
					);

					if ( comparison != 0 ) return comparison;
				}
				return 0;
			}

			return 0;
		}
	}

	/*******************************************************
					Sort Order values
	*******************************************************/

	private static final Integer	SORT_DESCENDING		= -1;
	private static final Integer	SORT_ASCENDING		=  1;

	/*******************************************************
				Member Variables and Access Methods
	*******************************************************/

	private Schema.sObjectType		sObjectType;
	private	CWAccessible			accessible;
	private List<String>			list_SortFields;
	private Map<String,Integer>		map_SortField_SortOrder;
	private Map<String,Integer>		map_SortField_NullComparison;
	private Map<String,Type>		map_SortField_Type;

	private List<String> fields()
	{
		return list_SortFields;
	}

	private Type getType( String fieldName )
	{
		return map_SortField_Type.get( fieldName );
	}

	private Integer sortDirection( String fieldName )
	{
		return map_SortField_SortOrder.get( fieldName );
	}

	private Integer nullComparison( String fieldName )
	{
		return map_SortField_NullComparison.get( fieldName );
	}

	/*******************************************************
						Constructor(s)
	*******************************************************/

	public CWSorter( String sObjectName )
	{
		this( CWSchema.getSObjectType( sObjectName ) );
	}

	public CWSorter( Schema.sObjectType soType )
	{
		sObjectType	= soType;
		initializeCollections();
	}

	public CWSorter( Schema.DescribeSObjectResult sObjectResult )
	{
		this( CWSchema.getSObjectType( sObjectResult ) );
	}

	public CWSorter( sObject anSObject )
	{
		this( CWSchema.getSObjectType( anSObject ) );
	}

	public CWSorter( Type objType )
	{
		this( (CWAccessible) (objType != null ? objType.newInstance() : null) );
	}

	public CWSorter( CWAccessible anAccessible )
	{
		accessible	= anAccessible;
		initializeCollections();
	}

	/*******************************************************
				initializeCollections method

	Used internally by constructors.
	*******************************************************/

	private void initializeCollections()
	{
		list_SortFields					= new List<String>();
		map_SortField_SortOrder			= new Map<String,Integer>();
		map_SortField_NullComparison	= new Map<String,Integer>();
		map_SortField_Type				= new Map<String,Type>();
	}

	/*******************************************************
						sortField method
	*******************************************************/

	private CWSorter sortField( String fieldName, Integer ascDesc, Integer nullComparison )
	{
		if	(	String.isBlank( fieldName )
			||	ascDesc			== null
			||	nullComparison	== null
			) return this;

		Type	fieldType	=
			sObjectType != null		?	CWSchema.getFieldType( sObjectType, fieldName )
		:	accessible  != null		?	accessible.getFieldType( fieldName )
		:								null;

		if ( !CWCompare.isComparable( fieldType ) ) return this;

		list_SortFields				.add( fieldName					);
		map_SortField_SortOrder		.put( fieldName, ascDesc		);
		map_SortField_NullComparison.put( fieldName, nullComparison	);
		map_SortField_Type			.put( fieldName, fieldType		);

		return this;
	}

	/*******************************************************
					sortAscending method
	*******************************************************/

	public CWSorter sortAscending( String fieldName )
	{
		return sortAscendingNullsFirst( fieldName );
	}

	public CWSorter sortAscendingNullsFirst( String fieldName )
	{
		return sortField( fieldName, SORT_ASCENDING, CWCompare.nullIsSmall() );
	}

	public CWSorter sortAscendingNullsLast( String fieldName )
	{
		return sortField( fieldName, SORT_ASCENDING, CWCompare.nullIsLarge() );
	}

	/*******************************************************
					sortDescending method
	*******************************************************/

	public CWSorter sortDescending( String fieldName )
	{
		return sortDescendingNullsLast( fieldName );
	}

	public CWSorter sortDescendingNullsFirst( String fieldName )
	{
		return sortField( fieldName, SORT_DESCENDING, CWCompare.nullIsLarge() );
	}

	public CWSorter sortDescendingNullsLast( String fieldName )
	{
		return sortField( fieldName, SORT_DESCENDING, CWCompare.nullIsSmall() );
	}

	/*******************************************************
						sort methods
	*******************************************************/

	public CWSorter sort( List<sObject> theList )
	{
		if ( theList != null && !list_SortFields.isEmpty() )
		{
			List<ComparableWrapper> list_ToSort = new List<ComparableWrapper>();

			for ( sObject anSObject : theList )
			{
				list_ToSort.add( new ComparableWrapper( anSObject, this ) );
			}

			try { list_ToSort.sort(); } catch( Exception e ) { return this; }

			theList.clear();

			for ( ComparableWrapper aWrapper : list_ToSort )
			{
				theList.add( aWrapper.theObject );
			}
		}
		return this;
	}

	public CWSorter sort( List<List<sObject>> theListOfLists )
	{
		if ( theListOfLists != null ) for ( List<sObject> theList : theListOfLists ) sort( theList );
		return this;
	}

	public CWSorter sort( CWPartition thePartition )
	{
		if ( thePartition != null ) sort( thePartition.values() );
		return this;
	}

	public CWSorter sort( List<CWAccessible> theList )
	{
		if ( theList != null && !list_SortFields.isEmpty() )
		{
			List<ComparableWrapper> list_ToSort = new List<ComparableWrapper>();

			for ( CWAccessible anAccessible : theList )
			{
				list_ToSort.add( new ComparableWrapper( anAccessible, this ) );
			}

			try { list_ToSort.sort(); } catch( Exception e ) { return this; }

			theList.clear();

			for ( ComparableWrapper aWrapper : list_ToSort )
			{
				theList.add( aWrapper.theAccessible );
			}
		}
		return this;
	}

	public CWSorter sort( List<List<CWAccessible>> theListOfLists )
	{
		if ( theListOfLists != null ) for ( List<CWAccessible> theList : theListOfLists ) sort( theList );
		return this;
	}
}