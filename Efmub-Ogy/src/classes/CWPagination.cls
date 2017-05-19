/*******************************************************//**

@class		CWPagination

@brief		CW Core Pagination Class

	This class implements pagination functionality.

@author		Glyn Anderson	(LiquidHub.GHA)
@author		Tim Smith		(LiquidHub.TRS)

@version	2014-10-10	LiquidHub.GHA
	Created.
@version	2014-11-07	LiquidHub.TRS
	Added goToRecordId method

@see		CWPaginationTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWPagination
{
	/*******************************************************
						constants
	*******************************************************/

	private static final Integer	defaultNumPerPage	= 10;

	/*******************************************************
						members
	*******************************************************/

	private CWQuery		query;
	private CWFunction	transformation;
	private Type		resultType;

	/*******************************************************
						properties
	*******************************************************/

	public Integer	numRecords
	{
		get
		{
			if ( numRecords == null )
			{
				CWQuery	countQuery	= CWQuery.newAggregateQuery( query.getSObjectName() );
				countQuery.setWhereClause( query.getWhereClause() );
				countQuery.count( 'Id', 'numRecords' );
				numRecords = (Integer) countQuery.aggregateQuery()[0].get( 'numRecords' );
			}
			return numRecords;
		}
		private set;
	}

	public Integer	pageOffset			{ get; set { if ( value >= 0 && value < numRecords ) pageOffset = value; } }
	public Integer	numPerPage			{ get { return numPerPage != null ? numPerPage : defaultNumPerPage; } set; }
	public Integer	currentPage			{ get { return (pageOffset + numPerPage - 1) / numPerPage + 1; } }
	public Integer	numPages			{ get { return (numRecords + numPerPage - 1) / numPerPage; } }
	public Integer	firstOnPage			{ get { return pageOffset + 1; } }
	public Integer	lastOnPage			{ get { return Math.min( pageOffset + numPerPage, numRecords ); } }
	public Boolean	hasPreviousPage		{ get { return firstOnPage > 1; } }
	public Boolean	hasNextPage			{ get { return lastOnPage < numRecords; } }

	/*******************************************************
				CWPagination constructors
	*******************************************************/

	public CWPagination( CWQuery theQuery, CWFunction theFunction, Type theType )
	{
		if ( theQuery == null ) return;

		query			= theQuery;
		transformation	= theFunction;
		resultType		= theType != null ? theType : Type.forName( query.getSObjectName() );

		resetPagination();
	}

	public CWPagination( CWQuery theQuery )
	{
		this( theQuery, (CWFunction) null, (Type) null );
	}

	/*******************************************************
				resetPagination method

	Use this method anytime the number of records changes
	due to insertion or deletion, or altered WHERE clause.
	*******************************************************/

	public void resetPagination()
	{
		numRecords = null;
		gotoFirstPage();
	}

	/*******************************************************
					navigation methods
	*******************************************************/

	public void	gotoFirstPage()
	{
		pageOffset = 0;
	}

	public void gotoPreviousPage()
	{
		if ( hasPreviousPage ) pageOffset = Math.max( pageOffset - numPerPage, 0 );
	}

	public void	gotoNextPage()
	{
		if ( hasNextPage ) pageOffset = lastOnPage;
	}

	public void gotoLastPage()
	{
		if ( hasNextPage ) pageOffset = (numPages - 1) * numPerPage;
	}

	public void gotoPage( Integer pageNumber )
	{
		if ( 1 <= pageNumber && pageNumber <= numPages ) pageOffset = (pageNumber - 1) * numPerPage;
	}

	public void gotoRecord( Integer recordNumber )
	{
		if ( 1 <= recordNumber && recordNumber <= numRecords ) pageOffset = recordNumber - 1;
	}
	
	public void gotoRecordId( String recordId )
	{
		List<SObject> queryResult 			= query.query();
		
		for ( Integer i = 0 ; i < queryResult.size() ; i ++ )
		{
			if ( queryResult[ i ].Id == recordId )
			{
				gotoRecord( i + 1 );
				break;
			}
		}
	}

	/*******************************************************
				pageRecords property

	Returns a list containing the current page's content.
	*******************************************************/

	public List<Object> pageRecords
	{
		get
		{
			query.setLimit( numPerPage );
			query.setOffset( pageOffset );
			return (new CWIterable( (Iterable<Object>) query.query(), transformation )).toList( resultType );
		}
	}

	/*******************************************************
				page number properties
	*******************************************************/

	public Integer	pageNumberWindow		{ get; set; }

	public List<Integer>	pageNumbers
	{
		get
		{
			Integer firstPage	= pageNumberWindow != null ? Math.max( currentPage - pageNumberWindow, 1 ) : 1;
			Integer lastPage	= pageNumberWindow != null ? Math.min( firstPage + 2*pageNumberWindow, numPages ) : numPages;

			if ( lastPage == numPages )
			{
				firstPage = pageNumberWindow != null ? Math.max( lastPage - 2*pageNumberWindow, 1 ) : 1;
			}

			pageNumbers = new List<Integer>();
			for ( Integer i = firstPage; i <= lastPage; i++ ) pageNumbers.add( i );
			return pageNumbers;
		}
		private set;
	}
}