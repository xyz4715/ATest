/*******************************************************//**

@class		CWQuery

@brief		CW Core Query Class

	The CWQuery class is used to build and execute arbitrary
	queries.  Almost all SOQL features are supported, including
	child relationship queries (subqueries), and aggregate queries.

	Supported SOQL features:
	*	SELECT		including parent relationships, child relationships,
					and aggregate functions
	*	FROM		using sObject name for queries and aggregate queries,
					and child relationship name for subqueries
	*	WHERE		can join multiple conditions with AND or OR, an can
					nest clauses to create arbitrarily complex clauses
	*	GROUP BY	currently supports only one field name, which is also
					added to the SELECT clause
	*	HAVING		can join multiple conditions with AND or OR, an can
					nest clauses to create arbitrarily complex clauses
	*	ORDER BY	supports multiple field names, each with its own order
					(ascending/descending) and nulls first/last
	*	LIMIT		any number greater than zero, up to 10000
	*	OFFSET		any number greater than zero, up to 2000
	*	FOR VIEW		\
	*	FOR REFERENCE	 :	only in a primary query
	*	FOR UPDATE		/

	Aggregate functions supported:
	*	AVG
	*	COUNT			including COUNT(*), which becomes COUNT(Id)
	*	COUNT_DISTINCT
	*	MIN
	*	MAX
	*	SUM

	Unsupported SOQL features:
	*	TYPEOF
	*	WITH
	*	GROUP BY ROLLUP
	*	GROUP BY CUBE
	*	GROUPING
	*	UPDATE VIEWSTAT

@author		Glyn Anderson (LiquidHub.GHA)

@version	2013-11-06	LiquidHub.GHA
	Created.
@version	2014-02-04	LiquidHub.GHA
	Revamped CWQuery to be non-static.  Created WhereClause inner class.
@version	2014-02-05	LiquidHub.GHA
	Added CWException error handling.  Added aggregate functions.
	WhereClause class became FilterClause, which both WhereClause and
	HavingClause extend.  Created 'aggregateQuery' method.
@version	2014-02-06	LiquidHub.GHA
	Added class header documentation. Added error handling to FilterClause
	class.  Added support for GROUP BY field list.
@version	2014-02-07	LiquidHub.GHA
	Added support for IN, NOT IN, INCLUDES (includesAny, includesAll),
	EXCLUDES (excludesAny, excludesAll) in WhereClause.
@version	2014-02-08	LiquidHub.GHA
	Added support for polymorphic relationship filter,
	e.g. What.Type IN ('Account', 'Opportunity')
	Reworked factory methods so that CWQuery, WhereClause and HavingClause
	are all allocated by the instance that will contain them.
	Consolidated validation logic into validation methods.
@version	2014-02-08	LiquidHub.GHA
	Continued validation work.
@version	2014-03-05	LiquidHub.GHA
	Implemented 'queriesRemaining' and 'isQueryPossible' methods. 'query' and
	'aggregateQuery' now test the governor limit and issue a CWException error
	if no more queries are possible.
@version	2014-03-07	LiquidHub.GHA
	Completed validation work.
@version	2014-09-24	LiquidHub.GHA
	Added additional forms of 'newQuery' and 'newAggregateQuery' to
	support all ways to specify an sObject type.
@version	2014-10-10	LiquidHub.GHA
	Added access methods: getSObjectName, getWhereClause and setWhereClause
@version	2014-12-18	LiquidHub.GHA
	Added 'getQueryLocator' method.
@version	2015-07-14	LiquidHub.GHA
	Converted everything to the Monad design pattern.
@version	2015-12-28	LiquidHub.GHA
	Expanded FilterClause factory methods to take a list of elements.
@version	2016-02-22	LiquidHub.GHA
	FilterClauses now evaluate to true/null/false.  True/false FilterClauses are suppressed.
	A query whose FilterClause is false is considered 'empty' and will return an empty list.
	Element uniqueness test is now case insensitive.  'isIn' and 'isNotIn' can now be called
	without a field name and 'Id' is assumed.
@version	2016-02-24	LiquidHub.GHA
	Initial support for semi-join and anti-join.

@todo	Add support for TYPEOF / WHEN / ELSE / END
@todo	Add support for GROUP BY ROLLUP
@todo	Add support for GROUP BY CUBE
@todo	Add support for GROUPING
@todo	Add support for time constants
@todo	Add support for DISTANCE and GEOLOCATION, and lat/long fields

@see		CWQueryTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWQuery
{
	/*******************************************************
					className method
	*******************************************************/

	private String className()
	{
		return 'CWQuery';
	}

	/*******************************************************
				Operator enumeration

	This enum is used to determine whether the elements of a
	FilterClause are joined with 'AND' or 'OR'.
	*******************************************************/

	private enum Operator
	{
		AND_Operator,
		OR_Operator
	}

	private static final Operator defaultOperator	= Operator.AND_Operator;

	/*******************************************************
				FilterClause class

	The FilterClause class is used to create the WHERE and
	HAVING clauses of a query.  FilterClause instances can
	contain other FilterClause instances.  The elements of
	an instance are joined by one of two operators: 'AND'
	or 'OR'.
	*******************************************************/

	public virtual class FilterClause
	{
		/***************************************************
						className method
		***************************************************/

		@testVisible
		private virtual String className()
		{
			return theQuery.className() + '.FilterClause';
		}

		/***************************************************
				FilterClause instance variables
		***************************************************/

		private CWQuery			theQuery;
		private Operator		theOperator;
		private List<Object>	list_FilterElements;

		private Boolean			evaluation;				//	this is set as a side-effect of the toString() method

		/***************************************************
					FilterClause constructor

		The FilterClause constructor takes an optional Operator
		(which defaults to 'AND') and an optional element
		(which becomes the fist element in the FilterClause).
		***************************************************/

		private FilterClause( CWQuery query, Operator op, List<Object> elements )
		{
			theQuery			= query;
			theOperator			= op != null ? op : defaultOperator;
			list_FilterElements	= new List<Object>();
			if ( elements != null ) list_FilterElements.addAll( elements );
		}

		private FilterClause( CWQuery query, Operator op, String element )
		{
			this( query, op, String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		@testVisible
		private FilterClause( CWQuery query )
		{
			this( query, (Operator) null, (String) null );
		}

		/***************************************************
					argument validation methods
		***************************************************/

		@testVisible
		private Boolean error( String method, String errorMessage )
		{
			return CWException.error( className() + '.' + method + ': ' + errorMessage );
		}

		private Boolean validateNotNull( String method, Object theObject, String errorMessage )
		{
			return
				theObject != null
			||	error( method, errorMessage );
		}

		private Boolean validateNotBlank( String method, String theString, String errorMessage )
		{
			return
				String.isNotBlank( theString )
			||	error( method, errorMessage );
		}

		private Boolean validateList( String method, List<Object> theList, String whatsInTheList )
		{
			return validateNotNull( method, theList, 'Invalid list of ' + whatsInTheList + '.' );
		}

		private Boolean validateElement( String method, String element )
		{
			return validateNotBlank( method, element, 'Invalid ' + className() + ' element (' + element + ').' );
		}

		private Boolean validateField( String method, String sObjectName, String fieldName )
		{
			return
				validateNotBlank( method, fieldName, 'Invalid field specification.' )
			&&	(	fieldName.contains( '.' )
				||	CWSchema.isField( sObjectName, fieldName )
				||	error( method, 'Invalid field specification (' + sObjectName + '.' + fieldName + ').' )
				);
		}

		private Boolean validateField( String method, String fieldName )
		{
			return	validateField( method, theQuery.theSObjectName, fieldName );
		}

		private Boolean validatePolymorphism( String method, String fieldName )
		{
			return
				validateField( method, fieldName )
			&&	(	CWSchema.getDescribeFieldResult( theQuery.theSObjectName, fieldName ).isNamePointing()
				||	error( method, 'Field is not polymorphic (' + fieldName + ').' )
				);
		}

		private Boolean validateSObjectName( String method, String sObjectName )
		{
			return
				CWSchema.isSObject( sObjectName )
			||	error( method, 'Invalid sObject name (' + sObjectName + ').' );
		}

		private Boolean validateANDFilterClause( String method, String errorMessage )
		{
			return
				theOperator	== Operator.AND_Operator
			||	error( method, errorMessage );
		}

		/***************************************************
					addFilterElement methods
		***************************************************/

		private Boolean addFilterElement( String method, Object element )
		{
			list_FilterElements.add( element );
			return true;
		}

		private Boolean addFilterElement( String method, List<String> list_Elements )
		{
			Boolean	success = true;
			for ( String element : list_Elements )
			{
				if ( element == null ) continue;

				success =
					validateElement( method, element )
				&&	addFilterElement( method, element )
				&&	success;
			}
			return success;
		}

		/***************************************************
						add methods

		Add methods can be used to add a single element or
		subordinate FilterClause, or lists of either of these.
		***************************************************/

		public FilterClause add( String element )
		{
			String	method = 'add';
			Boolean	success =
				validateElement( method, element )
			&&	addFilterElement( method, element );
			return this;
		}

		public FilterClause add( List<String> list_Elements )
		{
			String	method = 'add';
			Boolean	success =
				validateList( method, list_Elements, className() + ' elements' )
			&&	addFilterElement( method, list_Elements );
			return this;
		}

		/***************************************************
						multiLike methods
		***************************************************/

		public FilterClause multiLike( String fieldName, List<String> list_Likes )
		{
			Boolean	falseValue	= false;
			String	method = 'multiLike';
			Boolean	success =
			(	validateField( method, fieldName )
			&&	validateList( method, list_Likes, 'Likes' )
			&&	(	!CWCollection.isEmpty( list_Likes )
				?	addFilterElement
					(	method,
						CWString.toList( CWString.addCircumfix( CWString.split( CWString.scrub( list_Likes ) ), '(' + fieldName + ' LIKE \'%', '%\')' ) )
					)
				:	addFilterElement( method, false )
				)
			);
			return this;
		}

		public FilterClause multiLike( String fieldName, String likes )
		{
			return multiLike( fieldName, new List<String>{ likes } );
		}

		/***************************************************
						toString method

		This method returns the String representation of the
		FilterClause, suitable for use in a query string.
		***************************************************/

		public override String toString()
		{
			Boolean	identity	= (theOperator == Operator.AND_Operator);
			Boolean	zero		= !identity;

			Boolean	evaluation	= identity;

			List<String> list_Elements = new List<String>();
			{
				Set<String> set_UniqueElements = new Set<String>();

				for ( Object element : list_FilterElements )
				{
					if ( element == null ) continue;

					if ( element instanceOf Boolean )
					{
						if ( (Boolean) element == zero ) evaluation = zero;
						continue;
					}

					String	filterElement = String.valueOf( element );
					String	uniqueElement = filterElement.toLowerCase();

					if	(	String.isNotBlank( filterElement )
						&&	!set_UniqueElements.contains( uniqueElement )
						)
					{
						list_Elements.add( filterElement );
						set_UniqueElements.add( uniqueElement );
					}

					Boolean	elementEvaluation	= element instanceOf FilterClause ? ((FilterClause) element).evaluation : null;

					evaluation	=
						evaluation == zero || elementEvaluation == zero	?	zero
					:	evaluation == identity							?	elementEvaluation
					:														null;
				}
			}
			this.evaluation	= evaluation;

			String	filterString = CWString.join( list_Elements, theOperator == Operator.AND_Operator ? ' AND ' : ' OR ' );

			return String.isNotBlank( filterString ) && evaluation == null ? CWString.parenthesize( filterString ) : '';
		}
	}

	/*******************************************************
					WhereClause class
	*******************************************************/

	public class WhereClause extends FilterClause
	{
		/***************************************************
						className method
		***************************************************/

		private override String className()
		{
			return theQuery.className() + '.WhereClause';
		}

		/***************************************************
					WhereClause constructor
		***************************************************/

		private WhereClause( CWQuery query, Operator op, List<Object> elements )
		{
			super( query, op, elements );
		}

		/***************************************************
						factory methods
		***************************************************/

		private WhereClause createWhereClause( Operator op, List<Object> elements )
		{
			WhereClause theWhereClause = new WhereClause( theQuery, op, elements );
			list_FilterElements.add( theWhereClause );
			return theWhereClause;
		}

		public WhereClause newANDWhereClause( List<Object> elements )
		{
			return createWhereClause( Operator.AND_Operator, elements );
		}

		public WhereClause newANDWhereClause( String element )
		{
			return newANDWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public WhereClause newANDWhereClause()
		{
			return newANDWhereClause( (List<Object>) null );
		}

		public WhereClause newORWhereClause( List<Object> elements )
		{
			return createWhereClause( Operator.OR_Operator, elements );
		}

		public WhereClause newORWhereClause( String element )
		{
			return newORWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public WhereClause newORWhereClause()
		{
			return newORWhereClause( (List<Object>) null );
		}

		public WhereClause newWhereClause( List<Object> elements )
		{
			return createWhereClause( (Operator) null, elements );
		}

		public WhereClause newWhereClause( String element )
		{
			return newWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public WhereClause newWhereClause()
		{
			return newWhereClause( (List<Object>) null );
		}

		/***************************************************
					addSet related methods

		isIn			field value is IN the set
		isNotIn			field value is NOT IN the set
		includesAny		field INCLUDES any set element
		includesAll		field INCLUDES all set elements
		excludesAny		field EXCLUDES any set element
		excludesAll		field EXCLUDES all set elements
		***************************************************/

		private Boolean addSet( String method, String fieldName, List<Object> list_Values, String comparator, String separator, Boolean whatEmptyMeans )
		{
			return
			(	validateField( method, fieldName )
			&&	validateList( method, list_Values, 'values' )
			&&	(	CWCollection.isNotEmpty( list_Values )
				?	addFilterElement
					(	method,
						(	fieldName +	comparator
						+	CWString.parenthesize( CWString.join( CWString.quote( CWString.valueOf( list_Values ) ), separator ) )
						)
					)
				:	addFilterElement( method, whatEmptyMeans )
				)
			);
		}

		public WhereClause isIn( String fieldName, List<Object> list_Values )
		{
			addSet( 'isIn', fieldName, list_Values, ' IN ', ',', false );
			return this;
		}

		public WhereClause isIn( List<Object> list_Values )
		{
			addSet( 'isIn', 'Id', list_Values, ' IN ', ',', false );
			return this;
		}

		public WhereClause isNotIn( String fieldName, List<Object> list_Values )
		{
			addSet( 'isNotIn', fieldName, list_Values, ' NOT IN ', ',', true );
			return this;
		}

		public WhereClause isNotIn( List<Object> list_Values )
		{
			addSet( 'isNotIn', 'Id', list_Values, ' NOT IN ', ',', true );
			return this;
		}

		public WhereClause includesAny( String fieldName, List<Object> list_Values )
		{
			addSet( 'includesAny', fieldName, list_Values, ' INCLUDES ', ',', false );
			return this;
		}

		public WhereClause includesAll( String fieldName, List<Object> list_Values )
		{
			addSet( 'includesAll', fieldName, list_Values, ' INCLUDES ', ';', false );
			return this;
		}

		public WhereClause excludesAny( String fieldName, List<Object> list_Values )
		{
			addSet( 'excludesAny', fieldName, list_Values, ' EXCLUDES ', ';', true );
			return this;
		}

		public WhereClause excludesAll( String fieldName, List<Object> list_Values )
		{
			addSet( 'excludesAll', fieldName, list_Values, ' EXCLUDES ', ',', true );
			return this;
		}

		/***************************************************
			addJoin methods for semi-joins and anti-joins

		isIn			field value is IN the semi-join
		isNotIn			field value is NOT IN the anti-join
		***************************************************/

		private Boolean addJoin( String method, String fieldName, CWQuery joinQuery, String comparator, String separator, Boolean whatEmptyMeans )
		{
			String	joinString;
			Boolean	joinIsEmpty		= true;

			if ( joinQuery != null )
			{
				joinString	= joinQuery.toString();
				joinIsEmpty	= joinQuery.isEmpty;
			}

			return
			(	(	joinQuery.isJoin
				||	error( method, 'Only join queries may be used in a WhereClause.' )
				)
			&&	(	!theQuery.isJoin
				||	error( method, 'Join queries may not be used in the WhereClause of another join query.' )
				)
			&&	(	joinQuery.theSObjectName != theQuery.theSObjectName
				||	error( method, 'Joins may not query the same object as the parent query.' )
				)
			&&	(	theQuery.joinCount++ <= MAX_JOINS
				||	error( method, 'A query may not have more than ' + String.valueOf( --theQuery.joinCount ) + 'joins.' )
				)
			&&	validateField( method, fieldName )
			&&	(	joinQuery.joinType == CWSchema.getFieldSOAPType( theQuery.theSObjectName, fieldName )
				||	error( method, 'The \'' + fieldName + '\' field is not type-compatible with the join query.' )
				)
			&&	validateANDFilterClause( method, 'Joins can only be used in an AND WhereClause.' )
			&&	(	!joinIsEmpty
				?	addFilterElement( method, fieldName + comparator + '(' + joinString + ')' )
				:	addFilterElement( method, whatEmptyMeans )
				)
			);
		}

		public WhereClause isIn( String fieldName, CWQuery semiJoin )
		{
			addJoin( 'isIn', fieldName, semiJoin, ' IN ', ',', false );
			return this;
		}

		public WhereClause isIn( CWQuery semiJoin )
		{
			addJoin( 'isIn', 'Id', semiJoin, ' IN ', ',', false );
			return this;
		}

		public WhereClause isNotIn( String fieldName, CWQuery antiJoin )
		{
			addJoin( 'isNotIn', fieldName, antiJoin, ' NOT IN ', ',', true );
			return this;
		}

		public WhereClause isNotIn( CWQuery antiJoin )
		{
			addJoin( 'isNotIn', 'Id', antiJoin, ' NOT IN ', ',', true );
			return this;
		}

		/***************************************************
					type equality comparisons

		Including 'typeEqualTo' and 'typeNotEqualTo'.
		***************************************************/

		private Boolean typeEqualityTest( String method, String fieldName, String sObjectName, String comparator )
		{
			return
				validatePolymorphism( method, fieldName )
			&&	validateSObjectName( method, sObjectName )
			&&	addFilterElement( method, fieldName + '.Type ' + comparator + ' \'' + sObjectName + '\'' );
		}

		public WhereClause typeEqualTo( String fieldName, String sObjectName )
		{
			typeEqualityTest( 'typeEqualTo', fieldName, sObjectName, '=' );
			return this;
		}

		public WhereClause typeNotEqualTo( String fieldName, String sObjectName )
		{
			typeEqualityTest( 'typeNotEqualTo', fieldName, sObjectName, '!=' );
			return this;
		}

		/***************************************************
					type membership comparisons

		Including 'typeIn' and 'typeNotIn'.
		***************************************************/

		private Boolean typeMembershipTest( String method, String fieldName, List<String> list_sObjectNames, String comparator, Boolean whatEmptyMeans )
		{
			return
			(	validatePolymorphism( method, fieldName )
			&&	validateList( method, list_sObjectNames, 'sObject names' )
			&&	(	CWCollection.isNotEmpty( list_sObjectNames )
				?	addFilterElement
					(	method,
						(	fieldName + '.Type ' +	comparator
						+	CWString.parenthesize( CWString.commaJoin( CWString.quote( new CWIterable( (Iterable<Object>) list_sObjectNames, new ValidateSObjectName( this, method ) ) ) ) )
						)
					)
				:	addFilterElement( method, whatEmptyMeans )
				)
			);
		}

		public WhereClause typeIn( String fieldName, List<String> list_sObjectNames )
		{
			typeMembershipTest( 'typeIn', fieldName, list_sObjectNames, 'IN ', false );
			return this;
		}

		public WhereClause typeNotIn( String fieldName, List<String> list_sObjectNames )
		{
			typeMembershipTest( 'typeNotIn', fieldName, list_sObjectNames, 'NOT IN ', true );
			return this;
		}

		/***************************************************
					type LIKE comparison
		***************************************************/

		public WhereClause typeLike( String fieldName, String likeString )
		{
			String	method = 'typeLike';
			Boolean	success =
				validatePolymorphism( method, fieldName )
			&&	validateNotBlank( method, likeString, 'Invalid LIKE string.' )
			&&	addFilterElement( method, fieldName + '.Type LIKE \'' + likeString + '\'' );
			return this;
		}
	}

	/*******************************************************
				WhereClause factory methods
	*******************************************************/

	private WhereClause createWhereClause( String method, Operator op, List<Object> elements )
	{
		if ( theWhereClause != null )
		{
			error( method, 'Cannot create the WhereClause more than once.' );
			return null;
		}

		theWhereClause = new WhereClause( this, op, elements );
		return theWhereClause;
	}

	public WhereClause newANDWhereClause( List<Object> elements )
	{
		return createWhereClause( 'newANDWhereClause', Operator.AND_Operator, elements );
	}

	public WhereClause newANDWhereClause( String element )
	{
		return newANDWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public WhereClause newANDWhereClause()
	{
		return newANDWhereClause( (List<Object>) null );
	}

	public WhereClause newORWhereClause( List<Object> elements )
	{
		return createWhereClause( 'newORWhereClause', Operator.OR_Operator, elements );
	}

	public WhereClause newORWhereClause( String element )
	{
		return newORWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public WhereClause newORWhereClause()
	{
		return newORWhereClause( (List<Object>) null );
	}

	public WhereClause newWhereClause( List<Object> elements )
	{
		return createWhereClause( 'newWhereClause', (Operator) null, elements );
	}

	public WhereClause newWhereClause( String element )
	{
		return newWhereClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public WhereClause newWhereClause()
	{
		return newWhereClause( (List<Object>) null );
	}

	/*******************************************************
					HavingClause class
	*******************************************************/

	public class HavingClause extends FilterClause
	{
		/***************************************************
						className method
		***************************************************/

		private override String className()
		{
			return theQuery.className() + '.HavingClause';
		}

		/***************************************************
					HavingClause constructors
		***************************************************/

		private HavingClause( CWQuery query, Operator op, List<Object> elements )
		{
			super( query, op, elements );
		}

		/***************************************************
						factory methods
		***************************************************/

		private HavingClause createHavingClause( Operator op, List<Object> elements )
		{
			HavingClause theHavingClause = new HavingClause( theQuery, op, elements );
			list_FilterElements.add( theHavingClause );
			return theHavingClause;
		}

		public HavingClause newANDHavingClause( List<Object> elements )
		{
			return createHavingClause( Operator.AND_Operator, elements );
		}

		public HavingClause newANDHavingClause( String element )
		{
			return newANDHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public HavingClause newANDHavingClause()
		{
			return newANDHavingClause( (List<Object>) null );
		}

		public HavingClause newORHavingClause( List<Object> elements )
		{
			return createHavingClause( Operator.OR_Operator, elements );
		}

		public HavingClause newORHavingClause( String element )
		{
			return newORHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public HavingClause newORHavingClause()
		{
			return newORHavingClause( (List<Object>) null );
		}

		public HavingClause newHavingClause( List<Object> elements )
		{
			return createHavingClause( (Operator) null, elements );
		}

		public HavingClause newHavingClause( String element )
		{
			return newHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
		}

		public HavingClause newHavingClause()
		{
			return newHavingClause( (List<Object>) null );
		}
	}

	/*******************************************************
				HavingClause factory methods
	*******************************************************/

	private HavingClause createHavingClause( String method, Operator op, List<Object> elements )
	{
		if	(	validateAggregate( method, 'Cannot use HAVING in a non-aggregate query.' )
			&&	(	!list_GroupByElements.isEmpty()
				||	error( method, 'Cannot use HAVING without GROUP BY.' )
				)
			&&	(	theHavingClause == null
				||	error( method, 'Cannot create the HavingClause more than once.' )
				)
			)
		{
			theHavingClause = new HavingClause( this, op, elements );
			return theHavingClause;
		}
		return null;
	}

	public HavingClause newANDHavingClause( List<Object> elements )
	{
		return createHavingClause( 'newANDHavingClause', Operator.AND_Operator, elements );
	}

	public HavingClause newANDHavingClause( String element )
	{
		return newANDHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public HavingClause newANDHavingClause()
	{
		return newANDHavingClause( (List<Object>) null );
	}

	public HavingClause newORHavingClause( List<Object> elements )
	{
		return createHavingClause( 'newORHavingClause', Operator.OR_Operator, elements );
	}

	public HavingClause newORHavingClause( String element )
	{
		return newORHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public HavingClause newORHavingClause()
	{
		return newORHavingClause( (List<Object>) null );
	}

	public HavingClause newHavingClause( List<Object> elements )
	{
		return createHavingClause( 'newHavingClause', (Operator) null, elements );
	}

	public HavingClause newHavingClause( String element )
	{
		return newHavingClause( String.isNotBlank( element ) ? new List<Object>{ element } : (List<Object>) null );
	}

	public HavingClause newHavingClause()
	{
		return newHavingClause( (List<Object>) null );
	}

	/*******************************************************
				CWQuery instance variables
	*******************************************************/

	private Boolean			isAggregate;
	private Boolean			isJoin;
	private Schema.SOAPType	joinType;
	private Integer			joinCount;

	private String			theSObjectName;
	private String			theChildRelationship;
	private List<Object>	list_SelectElements;

	private WhereClause		theWhereClause;

	private String			theGroupBy;
	private List<String>	list_GroupByElements;
	private HavingClause	theHavingClause;

	private List<String>	list_OrderByElements;
	private Integer			theLimit;
	private Integer			theOffset;

	private Boolean			forView;
	private Boolean			forReference;
	private Boolean			forUpdate;

	private Boolean			isEmpty;				//	this is set as a side-effect of the toString() method

	private static Integer	MAX_JOINS	= 2;

	/*******************************************************
					access methods
	*******************************************************/

	public String getSObjectName()
	{
		return theSObjectName;
	}

	public WhereClause getWhereClause()
	{
		return theWhereClause;
	}

	public CWQuery setWhereClause( WhereClause newWhereClause )
	{
		theWhereClause = newWhereClause;
		return this;
	}

	/*******************************************************
					CWQuery constructor
	*******************************************************/

	private CWQuery( String sObjectName, String childRelationship, Boolean aggregate, Boolean joinjoin )
	{
		isAggregate				= aggregate;
		isJoin					= joinjoin;
		joinType				= null;
		joinCount				= 0;
		theSObjectName			= sObjectName;
		theChildRelationship	= childRelationship;
		list_SelectElements		= new List<Object>();
		list_GroupByElements	= new List<String>();
		list_OrderByElements	= new List<String>();
		forView					= false;
		forReference			= false;
		forUpdate				= false;
	}

	private static final Boolean	IS_AGGREGATE	= true;
	private static final Boolean	IS_JOIN			= true;

	/***************************************************
				argument validation methods
	***************************************************/

	private Boolean error( String method, String errorMessage )
	{
		return CWException.error( className() + '.' + method + ': ' + errorMessage );
	}

	private Boolean validateNotNull( String method, Object theObject, String errorMessage )
	{
		return
			theObject != null
		||	error( method, errorMessage );
	}

	private Boolean validateNotBlank( String method, String theString, String errorMessage )
	{
		return
			String.isNotBlank( theString )
		||	error( method, errorMessage );
	}

	private Boolean validateNotAggregate( String method, String errorMessage )
	{
		return
			!isAggregate
		||	error( method, errorMessage );
	}

	private Boolean validateAggregate( String method, String errorMessage )
	{
		return
			isAggregate
		||	error( method, errorMessage );
	}

	private Boolean validateNotJoin( String method, String errorMessage )
	{
		return
			!isJoin
		||	error( method, errorMessage );
	}

	private Boolean validateNotSubquery( String method, String errorMessage )
	{
		return
			theChildRelationship == null
		||	error( method, errorMessage );
	}

	private Boolean validateList( String method, List<Object> theList, String whatsInTheList )
	{
		return validateNotNull( method, theList, 'Invalid list of ' + whatsInTheList + '.' );
	}

	private Boolean validateField( String method, String sObjectName, String fieldName )
	{
		return
			validateNotBlank( method, fieldName, 'Invalid field specification.' )
		&&	(	fieldName.contains( '.' )
			||	CWSchema.isField( sObjectName, fieldName )
			||	error( method, 'Invalid field specification (' + sObjectName + '.' + fieldName + ').' )
			);
	}

	private Boolean validateField( String method, String fieldName )
	{
		return	validateField( method, theSObjectName, fieldName );
	}

	private Boolean validateFieldSet( String method, String fieldSetName )
	{
		return
			CWSchema.isFieldSet( theSObjectName, fieldSetName )
		||	error( method, 'Invalid field set specification (' + fieldSetName + ').' );
	}
/*
	private Boolean validatePolymorphism( String method, String fieldName )
	{
		return
			validateField( method, fieldName )
		&&	(	CWSchema.getDescribeFieldResult( theSObjectName, fieldName ).isNamePointing()
			||	error( method, 'Field is not polymorphic (' + fieldName + ').' )
			);
	}
//*/
	private Boolean validateSObjectName( String method, String sObjectName )
	{
		return
			validateNotBlank( method, sObjectName, 'Invalid sObject name.' )
			&&	(	CWSchema.isSObject( sObjectName )
				||	error( method, 'Invalid sObject name (' + sObjectName + ').' )
				);
	}

	private class ValidateSObjectName extends CWPredicate
	{
		private FilterClause	theFilterClause;
		private String			theMethod;

		public ValidateSObjectName( FilterClause filterClause, String method )
		{
			theFilterClause	= filterClause;
			theMethod		= method;
		}

		public override Boolean test( Object theObject )
		{
			return theFilterClause.validateSObjectName( theMethod, (String) theObject );
		}
	}

	private Boolean validateChildRelationship( String method, String childRelationship )
	{
		return
			validateNotBlank( method, childRelationship, 'Invalid child relationship.' )
		&&	(	CWSchema.isChildRelationship( theSObjectName, childRelationship )
			||	error( method, 'Invalid child relationship (' + childRelationship + ').' )
			);
	}

	private Boolean validateParentRelationship( String method, String lookupFieldName )
	{
		return
			validateNotBlank( method, lookupFieldName, 'Invalid parent relationship.' )
		&&	(	CWSchema.isParentRelationship( theSObjectName, lookupFieldName )
			||	error( method, 'Invalid parent relationship (' + lookupFieldName + ').' )
			);
	}

	private Boolean validateGreaterThanZero( String method, String thing, Integer value )
	{
		return
			value == null
		||	value > 0
		||	error( method, thing + ' must be greater than zero (' + String.valueOf( value ) + ').' );
	}

	private Boolean validateNotGreaterThan( String method, String thing, Integer value, Integer max )
	{
		return
			value == null
		||	value <= max
		||	error( method, thing + ' cannot be greater than ' + String.valueOf( max ) + ' (' + String.valueOf( value ) + ').' );
	}

	/*******************************************************
					newQuery methods
	*******************************************************/

	public static CWQuery newQuery( String sObjectName )
	{
		CWQuery theQuery = new CWQuery( sObjectName, (String) null, !IS_AGGREGATE, !IS_JOIN );
		return theQuery.validateSObjectName( 'newQuery', sObjectName ) ? theQuery : null;
	}

	public static CWQuery newQuery( Schema.sObjectType sObjectType )
	{
		return newQuery( CWSchema.getSObjectName( sObjectType ) );
	}

	public static CWQuery newQuery( Schema.DescribeSObjectResult sObjectResult )
	{
		return newQuery( CWSchema.getSObjectName( sObjectResult ) );
	}

	public static CWQuery newQuery( sObject anSObject )
	{
		return newQuery( CWSchema.getSObjectName( anSObject ) );
	}

	public static CWQuery newQuery( Id sObjectId )
	{
		return newQuery( CWSchema.getSObjectName( sObjectId ) );
	}

	/*******************************************************
					newAggregateQuery methods
	*******************************************************/

	public static CWQuery newAggregateQuery( String sObjectName )
	{
		CWQuery theQuery = new CWQuery( sObjectName, (String) null, IS_AGGREGATE, !IS_JOIN );
		return theQuery.validateSObjectName( 'newAggregateQuery', sObjectName ) ? theQuery : null;
	}

	public static CWQuery newAggregateQuery( Schema.sObjectType sObjectType )
	{
		return newAggregateQuery( CWSchema.getSObjectName( sObjectType ) );
	}

	public static CWQuery newAggregateQuery( Schema.DescribeSObjectResult sObjectResult )
	{
		return newAggregateQuery( CWSchema.getSObjectName( sObjectResult ) );
	}

	public static CWQuery newAggregateQuery( sObject anSObject )
	{
		return newAggregateQuery( CWSchema.getSObjectName( anSObject ) );
	}

	public static CWQuery newAggregateQuery( Id sObjectId )
	{
		return newAggregateQuery( CWSchema.getSObjectName( sObjectId ) );
	}

	/*******************************************************
					newJoinQuery methods
	*******************************************************/

	public static CWQuery newJoinQuery( String sObjectName, String fieldName )
	{
		String	method	= 'newJoinQuery';
		CWQuery theQuery = new CWQuery( sObjectName, (String) null, !IS_AGGREGATE, IS_JOIN );
		if	(	theQuery.validateSObjectName( method, sObjectName )
			&&	theQuery.validateField( method, fieldName )
			)
		{
			theQuery.joinType	= CWSchema.getFieldSOAPType( sObjectName, fieldName );
			theQuery.addSelectElement( method, fieldName );
			return theQuery;
		}
		return null;
	}

	public static CWQuery newJoinQuery( Schema.sObjectType sObjectType, String fieldName )
	{
		return newJoinQuery( CWSchema.getSObjectName( sObjectType ), fieldName );
	}

	public static CWQuery newJoinQuery( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	{
		return newJoinQuery( CWSchema.getSObjectName( sObjectResult ), fieldName );
	}

	public static CWQuery newJoinQuery( sObject anSObject, String fieldName )
	{
		return newJoinQuery( CWSchema.getSObjectName( anSObject ), fieldName );
	}

	public static CWQuery newJoinQuery( Id sObjectId, String fieldName )
	{
		return newJoinQuery( CWSchema.getSObjectName( sObjectId ), fieldName );
	}

	/*******************************************************
					newSubquery method
	*******************************************************/

	private CWQuery createSubquery( String method, String childRelationship )
	{
		CWQuery theQuery = new CWQuery( CWSchema.getChildSObjectName( theSObjectName, childRelationship ), childRelationship, !IS_AGGREGATE, !IS_JOIN );
		addSelectElement( method, theQuery );
		return theQuery;
	}

	public CWQuery newSubquery( String childRelationship )
	{
		String	method = 'newSubquery';
		return
			(	validateNotAggregate( method, 'Cannot add a subquery to an aggregate query.' )
			&&	validateNotJoin( method, 'Cannot add a subquery to a join query.' )
			&&	validateNotSubquery( method, 'Cannot add a subquery to a subquery.' )
			&&	validateChildRelationship( method, childRelationship )
			)
		?	createSubquery( method, childRelationship )
		:	null;
	}

	/*******************************************************
					add methods
	*******************************************************/

	private String addAggregateErrorMessage()
	{
		return 'Cannot add SELECT element to an aggregate query - use \'' + className() + '.groupBy\'.';
	}

	private String addJoinErrorMessage()
	{
		return 'Cannot add SELECT element to a join query.';
	}

	private Boolean addSelectElement( String method, Object element )
	{
		list_SelectElements.add( element );
		return true;
	}

	public CWQuery add( String element )
	{
		String	method = 'add';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	validateNotBlank( method, element, 'Invalid SELECT element.' )
		&&	addSelectElement( method, (Object) element );
		return this;
	}

	private Boolean addSelectElement( String method, List<String> list_Elements )
	{
		Boolean success = true;
		for ( String element : list_Elements )
		{
			if ( element == null ) continue;

			success =
				validateNotBlank( method, element, 'Invalid SELECT element.' )
			&&	addSelectElement( method, (Object) element )
			&&	success;
		}
		return success;
	}

	public CWQuery add( List<String> list_Elements )
	{
		String	method = 'add';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	validateList( method, list_Elements, 'SELECT elements' )
		&&	addSelectElement( method, list_Elements );
		return this;
	}

	private Boolean addSelectElement( String method, String lookupFieldName, List<String> list_Elements )
	{
		String	parentRelationship	= CWSchema.getParentRelationshipName( theSObjectName, lookupFieldName );
		String	parentSObjectName	= CWSchema.getParentSObjectName( theSObjectName, lookupFieldName );

		Boolean success = true;
		for ( String element : list_Elements )
		{
			if ( element == null ) continue;

			success =
				validateField( method, parentSObjectName, element )
			&&	addSelectElement( method, parentRelationship + '.' + element )
			&&	success;
		}
		return success;
	}

	public CWQuery add( String lookupFieldName, List<String> list_Elements )
	{
		String	method = 'add';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	validateParentRelationship( method, lookupFieldName )
		&&	validateList( method, list_Elements, 'parent field names' )
		&&	addSelectElement( method, (Object) lookupFieldName )
		&&	addSelectElement( method, lookupFieldName, list_Elements );
		return this;
	}

	public CWQuery add( String lookupFieldName, String element )
	{
		String	method = 'add';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	validateParentRelationship( method, lookupFieldName )
		&&	validateNotBlank( method, element, 'Invalid parent element.' )
		&&	addSelectElement( method, (Object) lookupFieldName )
		&&	addSelectElement( method, lookupFieldName, new List<String>{ element } );
		return this;
	}

	/*******************************************************
					addAllFields method
	*******************************************************/

	public CWQuery addAllFields()
	{
		String	method = 'addAllFields';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	addSelectElement( method, new List<String>( CWSchema.getSObjectFields( theSObjectName ).keySet() ) );
		return this;
	}

	/*******************************************************
					addFieldSet method
	*******************************************************/

	public CWQuery addFieldSet( String fieldSetName )
	{
		String	method = 'addFieldSet';
		Boolean	success =
			validateNotAggregate( method, addAggregateErrorMessage() )
		&&	validateNotJoin( method, addJoinErrorMessage() )
		&&	validateFieldSet( method, fieldSetName )
		&&	addSelectElement( method, new List<String>( CWSchema.getFieldSetMembers( theSObjectName, fieldSetName ).keySet() ) );
		return this;
	}

	/*******************************************************
					average method
	*******************************************************/

	private String nonAggregateErrorMessage( String what )
	{
		return 'Cannot use ' + what + ' in a non-aggregate query.';
	}

	private Boolean aggregateFunction( String method, String function, String fieldName, String alias )
	{
		return
			validateAggregate( method, nonAggregateErrorMessage( function ) )
		&&	validateField( method, fieldName )
		&&	addSelectElement( method, function + '(' + fieldName + ')' + (String.isBlank( alias ) ? '' : ' ' + alias) );
	}

	public CWQuery average( String fieldName, String alias )
	{
		aggregateFunction( 'average', 'AVG', fieldName, alias );
		return this;
	}

	public CWQuery average( String fieldName )
	{
		return average( fieldName, (String) null );
	}

	/*******************************************************
				count methods
	*******************************************************/

	public CWQuery count( String fieldName, String alias )
	{
		if ( fieldName == '*' ) fieldName = 'Id';

		aggregateFunction( 'count', 'COUNT', fieldName, alias );
		return this;
	}

	public CWQuery count( String fieldName )
	{
		return count( fieldName, (String) null );
	}

	public CWQuery count()
	{
		String	method = 'count';
		Boolean	success =
			validateAggregate( method, nonAggregateErrorMessage( 'aggregate function' ) )
		&&	addSelectElement( method, 'COUNT()' );
		return this;
	}

	/*******************************************************
				countDistinct methods
	*******************************************************/

	public CWQuery countDistinct( String fieldName, String alias )
	{
		aggregateFunction( 'countDistinct', 'COUNT_DISTINCT', fieldName, alias );
		return this;
	}

	public CWQuery countDistinct( String fieldName )
	{
		return countDistinct( fieldName, (String) null );
	}

	/*******************************************************
				min method
	*******************************************************/

	public CWQuery min( String fieldName, String alias )
	{
		aggregateFunction( 'min', 'MIN', fieldName, alias );
		return this;
	}

	public CWQuery min( String fieldName )
	{
		return min( fieldName, (String) null );
	}

	/*******************************************************
				max method
	*******************************************************/

	public CWQuery max( String fieldName, String alias )
	{
		aggregateFunction( 'max', 'MAX', fieldName, alias );
		return this;
	}

	public CWQuery max( String fieldName )
	{
		return max( fieldName, (String) null );
	}

	/*******************************************************
				sum method
	*******************************************************/

	public CWQuery sum( String fieldName, String alias )
	{
		aggregateFunction( 'sum', 'SUM', fieldName, alias );
		return this;
	}

	public CWQuery sum( String fieldName )
	{
		return sum( fieldName, (String) null );
	}

	/*******************************************************
				groupBy method
	*******************************************************/

	private Boolean addGroupByElement( String method, String element )
	{
		list_GroupByElements.add( element );
		addSelectElement( method, element );
		return true;
	}

	public CWQuery groupBy( String element )
	{
		String	method = 'groupBy';
		Boolean	success =
			validateAggregate( method, 'Cannot use GROUP BY in a non-aggregate query.' )
		&&	validateField( method, element )
		&&	addGroupByElement( method, element );
		return this;
	}

	/*******************************************************
				orderBy methods
	*******************************************************/

	private Boolean addOrderByElement( String element, String ascDesc, String nullsOrder )
	{
		List<String>	list_OrderByStrings	= new List<String>();

		list_OrderByStrings.add( element );
		if ( String.isNotBlank( ascDesc )		) list_OrderByStrings.add( ascDesc );
		if ( String.isNotBlank( nullsOrder )	) list_OrderByStrings.add( nullsOrder );

		list_OrderByElements.add( CWString.join( list_OrderByStrings ) );
		return true;
	}

	private CWQuery orderBy( String element, String ascDesc, String nullsOrder )
	{
		String	method = 'orderBy';
		Boolean	success =
			validateNotAggregate( method, 'Cannot use ORDER BY in an aggregate query.' )
		&&	validateNotJoin( method, 'Cannot use ORDER BY in a join query.' )
		&&	validateField( method, element )
		&&	addOrderByElement( element, ascDesc, nullsOrder );
		return this;
	}

	public CWQuery orderBy( String element )
	{
		return orderBy( element, (String) null, (String) null );
	}

	public CWQuery orderByAscending( String element )
	{
		return orderBy( element, ' ASC', (String) null );
	}

	public CWQuery orderByAscendingNullsFirst( String element )
	{
		return orderBy( element, ' ASC', ' NULLS FIRST' );
	}

	public CWQuery orderByAscendingNullsLast( String element )
	{
		return orderBy( element, ' ASC', ' NULLS LAST' );
	}

	public CWQuery orderByDescending( String element )
	{
		return orderBy( element, ' DESC', (String) null );
	}

	public CWQuery orderByDescendingNullsFirst( String element )
	{
		return orderBy( element, ' DESC', ' NULLS FIRST' );
	}

	public CWQuery orderByDescendingNullsLast( String element )
	{
		return orderBy( element, ' DESC', ' NULLS LAST' );
	}

	/*******************************************************
				setLimit method
	*******************************************************/

	private Boolean setLimitCount( Integer limitCount )
	{
		theLimit = limitCount;
		return true;
	}

	public CWQuery setLimit( Integer limitCount )
	{
		String	method = 'setLimit';
		//	NOTE: It's OK for limitCount to be null.  It will reset the limit.
		Boolean	success =
			validateGreaterThanZero( method, 'Limit', limitCount )
		&&	validateNotGreaterThan( method, 'Limit', limitCount, 10000 )
		&&	setLimitCount( limitCount );
		return this;
	}

	/*******************************************************
				setOffset method
	*******************************************************/

	private Boolean setOffsetCount( Integer offsetCount )
	{
		theOffset = offsetCount;
		return true;
	}

	public CWQuery setOffset( Integer offsetCount )
	{
		String	method = 'setOffset';
		//	NOTE: It's OK for offsetCount to be null.  It will reset the offset.
		if ( offsetCount == 0 ) offsetCount = null;
		Boolean	success =
			validateGreaterThanZero( method, 'Offset', offsetCount )
		&&	validateNotGreaterThan( method, 'Offset', offsetCount, 2000 )
		&&	setOffsetCount( offsetCount );
		return this;
	}

	/*******************************************************
				forView method
	*******************************************************/

	private Boolean setForView()
	{
		forView = true;
		return true;
	}

	public CWQuery forView()
	{
		String	method = 'forView';
		Boolean	success =
			validateNotAggregate( method, 'Cannot use FOR VIEW in an aggregate query.' )
		&&	validateNotJoin( method, 'Cannot use FOR VIEW in a join query.' )
		&&	validateNotSubquery( method, 'Cannot use FOR VIEW in a subquery.' )
		&&	setForView();
		return this;
	}

	/*******************************************************
				forReference method
	*******************************************************/

	private Boolean setForReference()
	{
		forReference = true;
		return true;
	}

	public CWQuery forReference()
	{
		String	method = 'forReference';
		Boolean	success =
			validateNotAggregate( method, 'Cannot use FOR REFERENCE in an aggregate query.' )
		&&	validateNotJoin( method, 'Cannot use FOR REFERENCE in a join query.' )
		&&	validateNotSubquery( method, 'Cannot use FOR REFERENCE in a subquery.' )
		&&	setForReference();
		return this;
	}

	/*******************************************************
				forUpdate method
	*******************************************************/

	private Boolean setForUpdate()
	{
		forUpdate = true;
		return true;
	}

	public CWQuery forUpdate()
	{
		String	method = 'forUpdate';
		Boolean	success =
			validateNotAggregate( method, 'Cannot use FOR UPDATE in an aggregate query.' )
		&&	validateNotJoin( method, 'Cannot use FOR UPDATE in a join query.' )
		&&	validateNotSubquery( method, 'Cannot use FOR UPDATE in a subquery.' )
		&&	setForUpdate();
		return this;
	}

	/*******************************************************
					toString method

	This method returns the String representation of the CWQuery
	instance, suitable for use as (or in) a query string.
	*******************************************************/

	public override String toString()
	{
		List<String> list_Elements = new List<String>();
		{
			Set<String> set_UniqueElements = new Set<String>();

			for ( Object element : list_SelectElements )
			{
				if ( element == null ) continue;

				String	selectElement = String.valueOf( element );
				String	uniqueElement = selectElement.toLowerCase();

				if	(	String.isNotBlank( selectElement )
					&&	!set_UniqueElements.contains( uniqueElement )
					)
				{
					list_Elements.add( selectElement );
					set_UniqueElements.add( uniqueElement );
				}
			}
		}

		List<String> list_QueryStrings = new List<String>();

		if ( theChildRelationship != null ) list_QueryStrings.add( '(' );

		list_QueryStrings.add( 'SELECT ' );
		list_QueryStrings.add
		(	!list_Elements.isEmpty()	?	CWString.commaJoin( list_Elements )
		:	isAggregate					?	'COUNT(Id)'
		:									'Id'
		);
		list_QueryStrings.add( ' FROM ' );
		list_QueryStrings.add( theChildRelationship != null ? theChildRelationship : theSObjectName );

		isEmpty		= false;

		if ( theWhereClause != null )
		{
			String	whereString = theWhereClause.toString();
			if ( String.isNotBlank( whereString ) )
			{
				list_QueryStrings.add( ' WHERE ' );
				list_QueryStrings.add( whereString );
			}

			isEmpty		= theWhereClause.evaluation == false;
		}

		if ( !list_GroupByElements.isEmpty() )
		{
			list_QueryStrings.add( ' GROUP BY ' );
			list_QueryStrings.add( CWString.commaJoin( list_GroupByElements ) );
		}

		if ( theHavingClause != null )
		{
			String	havingString = theHavingClause.toString();
			if ( String.isNotBlank( havingString ) )
			{
				list_QueryStrings.add( ' HAVING ' );
				list_QueryStrings.add( havingString );
			}

			isEmpty		= theHavingClause.evaluation == false;
		}

		if ( !list_OrderByElements.isEmpty() )
		{
			list_QueryStrings.add( ' ORDER BY ' );
			list_QueryStrings.add( CWString.commaJoin( list_OrderByElements ) );
		}

		if ( theLimit != null )
		{
			list_QueryStrings.add( ' LIMIT ' );
			list_QueryStrings.add( String.valueOf( theLimit ) );
		}

		if ( theOffset != null )
		{
			list_QueryStrings.add( ' OFFSET ' );
			list_QueryStrings.add( String.valueOf( theOffset ) );
		}

		if ( forView )		list_QueryStrings.add( ' FOR VIEW' );
		if ( forReference )	list_QueryStrings.add( ' FOR REFERENCE' );
		if ( forUpdate )	list_QueryStrings.add( ' FOR UPDATE' );

		if ( theChildRelationship != null ) list_QueryStrings.add( ')' );

		return CWString.join( list_QueryStrings );
	}

	/*******************************************************
				queriesRemaining method

	This method returns the number of queries remaining before
	hitting the Apex governor limit.
	*******************************************************/

	public static Integer queriesRemaining()
	{
		return Limits.getLimitQueries() - Limits.getQueries();
	}

	/*******************************************************
				isQueryPossible method

	This method returns true if more queries are possible,
	otherwise, it invokes a CWException error.
	*******************************************************/

	public static Boolean isQueryPossible()
	{
		return queriesRemaining() > 0;
	}

	private Boolean isQueryPossible( String method )
	{
		return
		(	isQueryPossible()
		||	error( method, 'No more queries are possible.' )
		);
	}

	/*******************************************************
					query method

	This method executes the query represented by the CWQuery
	instance, and returns the query results.  If the query is
	empty or not possible, this returns an empty list.  If the
	query throws an exception, this returns null.
	*******************************************************/

	private List<sObject> doQuery()
	{
		String	queryString	= toString();

		if ( isEmpty || !isQueryPossible( 'query' ) ) return (List<sObject>) Type.forName( 'List<' + theSObjectName + '>' ).newInstance();

		try						{	return (List<sObject>) Database.query( queryString );													}
		catch ( Exception e )	{	return (List<sObject>) CWException.errorNull( 'CWQuery.query: Error with query:\n' + queryString, e );	}
	}

	public List<sObject> query()
	{
		return
			isAggregate						?	(List<sObject>) CWException.errorNull( 'CWQuery.query: For an aggregate query, use \'CWQuery.aggregateQuery\'.' )
		:	theChildRelationship != null	?	(List<sObject>) CWException.errorNull( 'CWQuery.query: Subqueries cannot be queried directly.' )
		:										doQuery();
	}

	/*******************************************************
					aggregateQuery method

	This method executes the aggregate query represented by
	the CWQuery instance, and returns the query results.  If
	the query is empty or not possible, this returns an empty
	list.  If the query throws an exception, this returns null.
	*******************************************************/

	private List<AggregateResult> doAggregateQuery()
	{
		String	queryString	= toString();

		if ( isEmpty || !isQueryPossible( 'aggregateQuery' ) ) return new List<AggregateResult>();

		try						{	return (List<AggregateResult>) Database.query( queryString );															}
		catch ( Exception e )	{	return (List<AggregateResult>) CWException.errorNull( 'CWQuery.aggregateQuery: Error with query:\n' + queryString, e );	}
	}

	public List<AggregateResult> aggregateQuery()
	{
		return
			!isAggregate
		?	(List<AggregateResult>) CWException.errorNull( 'CWQuery.aggregateQuery: For a non-aggregate query, use \'CWQuery.query\'.' )
		:	doAggregateQuery();
	}

	/*******************************************************
					getQueryLocator method

	This method returns the QueryLocator represented by the
	CWQuery instance.
	*******************************************************/

	public Database.QueryLocator getQueryLocator()
	{
		return Database.getQueryLocator( String.valueOf( this ) );
	}
}