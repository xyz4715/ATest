/*******************************************************//**

@class		CWQueryTest

@brief		CW Core Query Class Test Methods

	The CWQueryTest class contains the test methods for the
	CWQuery class.

	Entry points: ('x' indicates 100% coverage)

	public virtual class FilterClause
	{
x		public FilterClause add( String element )
x		public FilterClause add( List<String> list_Elements )

x		public FilterClause multiLike( String fieldName, String likes )
x		public FilterClause multiLike( String fieldName, List<String> list_Likes )

x		public override String toString()
	}

	public class WhereClause extends FilterClause
	{
x		public WhereClause newANDWhereClause( String element )
x		public WhereClause newANDWhereClause()
x		public WhereClause newORWhereClause( String element )
x		public WhereClause newORWhereClause()
x		public WhereClause newWhereClause( String element )
x		public WhereClause newWhereClause()

x		public WhereClause isIn( String fieldName, List<Object> list_Values )
x		public WhereClause isNotIn( String fieldName, List<Object> list_Values )
x		public WhereClause includesAny( String fieldName, List<Object> list_Values )
x		public WhereClause includesAll( String fieldName, List<Object> list_Values )
x		public WhereClause excludesAny( String fieldName, List<Object> list_Values )
x		public WhereClause excludesAll( String fieldName, List<Object> list_Values )

x		public WhereClause typeEqualTo( String fieldName, String sObjectName )
x		public WhereClause typeNotEqualTo( String fieldName, String sObjectName )
x		public WhereClause typeIn( String fieldName, List<String> list_sObjectNames )
x		public WhereClause typeNotIn( String fieldName, List<String> list_sObjectNames )
x		public WhereClause typeLike( String fieldName, String likeString )
	}

x	public WhereClause newANDWhereClause( String element )
x	public WhereClause newANDWhereClause()
x	public WhereClause newORWhereClause( String element )
x	public WhereClause newORWhereClause()
x	public WhereClause newWhereClause( String element )
x	public WhereClause newWhereClause()

	public class HavingClause extends FilterClause
	{
x		public HavingClause newANDHavingClause( String element )
x		public HavingClause newANDHavingClause()
x		public HavingClause newORHavingClause( String element )
x		public HavingClause newORHavingClause()
x		public HavingClause newHavingClause( String element )
x		public HavingClause newHavingClause()
	}

x	public HavingClause newANDHavingClause( String element )
x	public HavingClause newANDHavingClause()
x	public HavingClause newORHavingClause( String element )
x	public HavingClause newORHavingClause()
x	public HavingClause newHavingClause( String element )
x	public HavingClause newHavingClause()

x	public static CWQuery newQuery( String sObjectName )
x	public static CWQuery newQuery( Schema.sObjectType sObjectType )
x	public static CWQuery newQuery( Schema.DescribeSObjectResult sObjectResult )
x	public static CWQuery newQuery( sObject anSObject )
x	public static CWQuery newQuery( Id sObjectId )

x	public static CWQuery newAggregateQuery( String sObjectName )
x	public static CWQuery newAggregateQuery( Schema.sObjectType sObjectType )
x	public static CWQuery newAggregateQuery( Schema.DescribeSObjectResult sObjectResult )
x	public static CWQuery newAggregateQuery( sObject anSObject )
x	public static CWQuery newAggregateQuery( Id sObjectId )

x	public CWQuery newSubquery( String childRelationship )

x	public CWQuery add( String element )
x	public CWQuery add( List<String> list_Elements )
x	public CWQuery add( String lookupFieldName, List<String> list_Elements )
x	public CWQuery add( String lookupFieldName, String element )

x	public CWQuery addAllFields()
x	public CWQuery addFieldSet( String fieldSetName )

x	public CWQuery average( String fieldName, String alias )
x	public CWQuery average( String fieldName )

x	public CWQuery count( String fieldName, String alias )
x	public CWQuery count( String fieldName )
x	public CWQuery count()

x	public CWQuery countDistinct( String fieldName, String alias )
x	public CWQuery countDistinct( String fieldName )

x	public CWQuery min( String fieldName, String alias )
x	public CWQuery min( String fieldName )

x	public CWQuery max( String fieldName, String alias )
x	public CWQuery max( String fieldName )

x	public CWQuery sum( String fieldName, String alias )
x	public CWQuery sum( String fieldName )

x	public CWQuery groupBy( String element )

x	public CWQuery orderBy( String element )
x	public CWQuery orderByAscending( String element )
x	public CWQuery orderByAscendingNullsFirst( String element )
x	public CWQuery orderByAscendingNullsLast( String element )
x	public CWQuery orderByDescending( String element )
x	public CWQuery orderByDescendingNullsFirst( String element )
x	public CWQuery orderByDescendingNullsLast( String element )

x	public CWQuery setLimit( Integer limitCount )
x	public CWQuery setOffset( Integer offsetCount )

x	public CWQuery forView()
x	public CWQuery forReference()
x	public CWQuery forUpdate()

x	public override String toString()

x	public static Integer queriesRemaining()
x	public static Boolean isQueryPossible()

x	public List<sObject> query()
x	public List<AggregateResult> aggregateQuery()
x	public Database.QueryLocator getQueryLocator()

x	public String getSObjectName()
x	public WhereClause getWhereClause()
x	public CWQuery setWhereClause( WhereClause newWhereClause )

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-03-08	LiquidHub.GHA
	Created.
@version	2014-08-28	LiquidHub.GHA
	Coverage increased to 100%.
@version	2014-09-24	LiquidHub.GHA
	Additional tests for new forms of 'newQuery' and 'newAggregateQuery'.
@version	2014-09-30	LiquidHub.GHA
	Additional tests for new forms of 'newQuery' and 'newAggregateQuery'. (again)
@version	2014-12-18	LiquidHub.GHA
	Additional tests for access methods and 'getQueryLocator'.
@version	2015-07-20	LiquidHub.GHA
	Converted tests for new Monad pattern of CWQuery and related classes.
	Added various negative tests to acheive 100% coverage again.

@see		CWQuery

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWQueryTest
{
	/*******************************************************
						constants
	*******************************************************/

	private static final String							testSObjectName		= 'CWTestObject__c';
	private static final Schema.sObjectType				testSObjectType		= CWTestObject__c.getSObjectType();
	private static final Schema.DescribeSObjectResult	testSObjectResult	= CWSchema.getDescribeSObjectResult( testSObjectType );
	private static final sObject						testSObject			= new CWTestObject__c();

	private static final String testSObjectName_Bad			= 'NotAnSObject';

	private static final String testChildRelationship		= 'Children__r';
	private static final String testChildRelationship_Bad	= 'NotAChildRelationship';

	private static final String testLookupFieldName			= 'Lookup__c';
	private static final String testParentRelationshipName	= 'Lookup__r';
	private static final String testLookupFieldName_Bad		= 'NotALookupField';

	private static final String testFieldName_01			= 'Checkbox__c';
	private static final String testFieldName_02			= 'Currency__c';
	private static final String testFieldName_03			= 'Date__c';
	private static final String testFieldName_04			= 'DateTime__c';
	private static final String testFieldName_05			= 'Email__c';
	private static final String testFieldName_06			= 'Geolocation__c';
	private static final String testFieldName_07			= 'Lookup__c';
	private static final String testFieldName_08			= 'Multi_Select__c';
	private static final String testFieldName_09			= 'Number_12_6__c';
	private static final String testFieldName_10			= 'Number_18_0__c';
	private static final String testFieldName_11			= 'Number_8_0__c';
	private static final String testFieldName_12			= 'Percent__c';
	private static final String testFieldName_13			= 'Phone__c';
	private static final String testFieldName_14			= 'Picklist__c';
	private static final String testFieldName_15			= 'Text_40__c';
	private static final String testFieldName_16			= 'Text_Area__c';
	private static final String testFieldName_17			= 'Text_Encrypted__c';
	private static final String testFieldName_18			= 'Text_Long__c';
	private static final String testFieldName_19			= 'Text_Rich__c';
	private static final String testFieldName_20			= 'URL__c';
	private static final String testFieldName_Bad			= 'NotAField';

	private static final String testFieldSetName			= 'CWTestFieldSet';
	private static final String testFieldSetName_Bad		= 'NotAFieldSet';

	private static final String testAggregateFieldName		= testFieldName_02;
	private static final String testAggregateFieldAlias		= 'Aggregate';
	private static final String testGroupByFieldName		= testFieldName_14;
	private static final String testOrderByFieldName		= testFieldName_04;
	private static final String testOrderByFieldName2		= testFieldName_12;

	private static final String testWhereClauseElement		= testFieldName_11 + ' >= 100';
	private static final String testIsInField				= testFieldName_14;
	private static final String testIncludesField			= testFieldName_08;
	private static final String testMultiLikeField			= testFieldName_15;

	private static final String defaultQueryString			= 'SELECT Id FROM ' + testSObjectName;
	private static final String defaultAggregateQueryString	= 'SELECT COUNT(Id) FROM ' + testSObjectName;
	private static final String defaultSubqueryString		= 'SELECT (SELECT Id FROM ' + testChildRelationship + ') FROM ' + testSObjectName;

	private static final Integer testLimitValue				= 100;
	private static final Integer testOffsetValue			= 500;

	/*******************************************************
				testCWQueryFactoryMethods
	*******************************************************/

	private static testMethod void testCWQueryFactoryMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryFactoryMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public static CWQuery newQuery( String sObjectName )	*/
		testingMethod = 'CWQuery.newQuery';
		{
			//	newQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectName.\n' + testResults.getErrorString()
			);
		}
		{
			//	newQuery negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'NotAnSObject' );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with invalid sObjectName.\n' + testResults.getErrorString()
			);
		}
		{
			//	newQuery null test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( (String) null );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with null sObjectName.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newQuery( Schema.sObjectType sObjectType )	*/
		testingMethod = 'CWQuery.newQuery';
		{
			//	newQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectType );
			testResults.assert
			(	testingMethod + ' - Type',
				testQuery != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectType.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newQuery( Schema.DescribeSObjectResult sObjectResult )	*/
		testingMethod = 'CWQuery.newQuery';
		{
			//	newQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectResult );
			testResults.assert
			(	testingMethod + ' - Result',
				testQuery != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectResult.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newQuery( sObject anSObject )	*/
		testingMethod = 'CWQuery.newQuery';
		{
			//	newQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObject );
			testResults.assert
			(	testingMethod + ' - sObject',
				testQuery != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObject.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newQuery( Id sObjectId )	*/
		testingMethod = 'CWQuery.newQuery';
		{
			//	newQuery positive test
			testResults.clearErrors();
			sObject theObject = (sObject) new CWTestObject__c();
			insert theObject;
			CWQuery testQuery = CWQuery.newQuery( theObject.Id );
			testResults.assert
			(	testingMethod + ' - Id',
				testQuery != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid Id.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newAggregateQuery( String sObjectName )	*/
		testingMethod = 'CWQuery.newAggregateQuery';
		{
			//	newAggregateQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectName.\n' + testResults.getErrorString()
			);
		}
		{
			//	newAggregateQuery negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( 'NotAnSObject' );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with invalid sObjectName.\n' + testResults.getErrorString()
			);
		}
		{
			//	newAggregateQuery null test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( (String) null );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with null sObjectName.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newAggregateQuery( Schema.sObjectType sObjectType )	*/
		testingMethod = 'CWQuery.newAggregateQuery';
		{
			//	newAggregateQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectType );
			testResults.assert
			(	testingMethod + ' - Type',
				testQuery != null
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectType.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newAggregateQuery( Schema.DescribeSObjectResult sObjectResult )	*/
		testingMethod = 'CWQuery.newAggregateQuery';
		{
			//	newAggregateQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectResult );
			testResults.assert
			(	testingMethod + ' - Result',
				testQuery != null
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObjectResult.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newAggregateQuery( sObject anSObject )	*/
		testingMethod = 'CWQuery.newAggregateQuery';
		{
			//	newAggregateQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObject );
			testResults.assert
			(	testingMethod + ' - sObject',
				testQuery != null
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid sObject.\n' + testResults.getErrorString()
			);
		}

		/*	public static CWQuery newAggregateQuery( Id sObjectId )	*/
		testingMethod = 'CWQuery.newAggregateQuery';
		{
			//	newAggregateQuery positive test
			testResults.clearErrors();
			sObject theObject = (sObject) new CWTestObject__c();
			insert theObject;
			CWQuery testQuery = CWQuery.newAggregateQuery( theObject.Id );
			testResults.assert
			(	testingMethod + ' - Id',
				testQuery != null
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid Id.\n' + testResults.getErrorString()
			);
		}

		//	report if any errors have occurred
		testResults.report();

		/*	public CWQuery newSubquery( String childRelationship )	*/
		testingMethod = 'CWQuery.newSubquery';
		{
			//	newSubquery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Positive',
				testSubquery != null
			&&	testQuery.toString().equals( defaultSubqueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' returned null with valid child relationship.\n' + testResults.getErrorString()
			);
		}
		{
			//	newSubquery negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( 'NotAChildRelationship' );
			testResults.assert
			(	testingMethod + ' - Negative',
				testSubquery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with invalid child relationship.\n' + testResults.getErrorString()
			);
		}
		{
			//	newSubquery null test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( (String) null );
			testResults.assert
			(	testingMethod + ' - Null',
				testSubquery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null with null child relationship.\n' + testResults.getErrorString()
			);
		}
		{
			//	newSubquery aggregate query test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Aggregate',
				testSubquery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null on aggregate query.\n' + testResults.getErrorString()
			);
		}
		{
			//	newSubquery subquery test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery aSubquery = testQuery.newSubquery( testChildRelationship );
			CWQuery testSubquery = aSubquery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Subquery',
				testSubquery == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned non-null on subquery.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAddMethods
	*******************************************************/

	private static testMethod void testCWQueryAddMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryAddMethods' );
		String testingMethod = 'CWQuery.add';

		testResults.startTest();

		/*	public CWQuery add( String element )	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.add( testFieldName_01 ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testFieldName_01 + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add a valid element.\n' + testResults.getErrorString()
			);
		}
		{	//	NOTE: Currently, add does not validate field names.
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.add( testFieldName_Bad ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testFieldName_Bad + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' added an invalid element.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery != null
			&&	testQuery.add( (String) null ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added a null element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery add( List<String> list_Elements )	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.add( new List<String>{ testFieldName_01, testFieldName_02 } ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testFieldName_01 + ',' + testFieldName_02 + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add a valid element from a list.\n' + testResults.getErrorString()
			);
		}
		{	//	NOTE: Currently, add does not validate field names.
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.add( new List<String>{ testFieldName_01, testFieldName_Bad } ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testFieldName_01 + ',' + testFieldName_Bad + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' added an invalid element from a list.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery != null
			&&	testQuery.add( (List<String>) null ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null list of elements.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery add( String lookupFieldName, List<String> list_Elements )	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, new List<String>{ testFieldName_01, testFieldName_02 } ) == testQuery
			&&	testQuery.toString().equals
				(	'SELECT '
				+		testParentRelationshipName + '.' + testFieldName_01 + ','
				+		testParentRelationshipName + '.' + testFieldName_02
				+	' FROM ' + testSObjectName
				)
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add a valid parent element from a list.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, new List<String>{ testFieldName_01, testFieldName_Bad } ) == testQuery
			&&	testQuery.toString().equals
				(	'SELECT '
				+		testParentRelationshipName + '.' + testFieldName_01
				+	' FROM ' + testSObjectName
				)
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added an invalid parent element from a list.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, (List<String>) null ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null list of parent elements.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery add( String lookupFieldName, String element )	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, testFieldName_01 ) == testQuery
			&&	testQuery.toString().equals
				(	'SELECT '
				+		testParentRelationshipName + '.' + testFieldName_01
				+	' FROM ' + testSObjectName
				)
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add a valid parent element.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, testFieldName_Bad ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added an invalid parent element.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Null',
				testQuery != null
			&&	testQuery.add( testLookupFieldName, (String) null ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null parent element.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.add( testLookupFieldName_Bad, testFieldName_01 ) == testQuery
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added an invalid parent relationship.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAddAllFieldsMethod
	*******************************************************/

	public static testMethod void testCWQueryAddAllFieldsMethod()
	{
		CWTest testResults = new CWTest( 'testCWQueryAddAllFieldsMethod' );
		String testingMethod = 'CWQuery.addAllFields';

		String testAllFields = CWString.join( CWSchema.getSObjectFields( testSObjectName ).keySet(), ',' );

		testResults.startTest();

		/*	public CWQuery addAllFields()	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Query',
				testQuery != null
			&&	testQuery.addAllFields() == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testAllFields + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add all fields to query.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Aggregate',
				testQuery != null
			&&	testQuery.addAllFields() == testQuery
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' should not have added all fields to aggregate query.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Subquery',
				testSubquery != null
			&&	testSubquery.addAllFields() == testSubquery
			&&	testQuery.toString().equals( 'SELECT (SELECT ' + testAllFields + ' FROM ' + testChildRelationship + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add all fields to subquery.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAddFieldSetMethod
	*******************************************************/

	public static testMethod void testCWQueryAddFieldSetMethod()
	{
		CWTest testResults = new CWTest( 'testCWQueryAddFieldSetMethod' );
		String testingMethod = 'CWQuery.addFieldSet';

		String testFieldSet = CWString.join( CWSchema.getFieldSetMembers( testSObjectName, testFieldSetName ).keySet(), ',' );

		testResults.startTest();

		/*	public CWQuery addFieldSet( String fieldSetName )	*/
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Query Positive',
				testQuery != null
			&&	testQuery.addFieldSet( testFieldSetName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testFieldSet + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add field set to query.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Query Negative',
				testQuery != null
			&&	testQuery.addFieldSet( testFieldSetName_Bad ) == testQuery
			&&	testQuery.toString().equals( defaultQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added bad field set to query.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Aggregate',
				testQuery != null
			&&	testQuery.addFieldSet( testFieldSetName ) == testQuery
			&&	testQuery.toString().equals( defaultAggregateQueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added field set to aggregate query.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Subquery Positive',
				testSubquery != null
			&&	testSubquery.addFieldSet( testFieldSetName ) == testSubquery
			&&	testQuery.toString().equals( 'SELECT (SELECT ' + testFieldSet + ' FROM ' + testChildRelationship + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed to add field set to subquery.\n' + testResults.getErrorString()
			);
		}
		{
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery testSubquery = testQuery.newSubquery( testChildRelationship );
			testResults.assert
			(	testingMethod + ' - Subquery Negative',
				testSubquery != null
			&&	testSubquery.addFieldSet( testFieldSetName_Bad ) == testSubquery
			&&	testQuery.toString().equals( defaultSubqueryString )
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' added bad field set to subquery.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAggregateMethods
	*******************************************************/

	private static testMethod void testCWQueryAggregateMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryAggregateMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public CWQuery average( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.average';
		{
			//	average positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.average( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT AVG(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery average( String fieldName )	*/
		testingMethod = 'CWQuery.average';
		{
			//	average positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.average( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT AVG(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery count( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.count';
		{
			//	count positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.count( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}
		{
			//	count positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Asterisk and Alias',
				testQuery != null
			&&	testQuery.count( '*', testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT(Id) ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with asterisk and valid alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery count( String fieldName )	*/
		testingMethod = 'CWQuery.count';
		{
			//	count positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.count( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}
		{
			//	count positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Asterisk',
				testQuery != null
			&&	testQuery.count( '*' ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT(Id) FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with asterisk.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery count()	*/
		testingMethod = 'CWQuery.count';
		{
			//	count positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive no Arguments',
				testQuery != null
			&&	testQuery.count() == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT() FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with no arguments.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery countDistinct( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.countDistinct';
		{
			//	countDistinct positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.countDistinct( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT_DISTINCT(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery countDistinct( String fieldName )	*/
		testingMethod = 'CWQuery.countDistinct';
		{
			//	countDistinct positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.countDistinct( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT COUNT_DISTINCT(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery min( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.min';
		{
			//	min positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.min( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT MIN(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery min( String fieldName )	*/
		testingMethod = 'CWQuery.min';
		{
			//	min positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.min( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT MIN(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery max( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.max';
		{
			//	max positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.max( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT MAX(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery max( String fieldName )	*/
		testingMethod = 'CWQuery.max';
		{
			//	max positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.max( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT MAX(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery sum( String fieldName, String alias )	*/
		testingMethod = 'CWQuery.sum';
		{
			//	sum positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Alias',
				testQuery != null
			&&	testQuery.sum( testAggregateFieldName, testAggregateFieldAlias ) == testQuery
			&&	testQuery.toString().equals( 'SELECT SUM(' + testAggregateFieldName + ') ' + testAggregateFieldAlias + ' FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName and alias.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery sum( String fieldName )	*/
		testingMethod = 'CWQuery.sum';
		{
			//	sum positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Alias',
				testQuery != null
			&&	testQuery.sum( testAggregateFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT SUM(' + testAggregateFieldName + ') FROM ' + testSObjectName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid fieldName.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery groupBy( String element )	*/
		testingMethod = 'CWQuery.groupBy';
		{
			//	groupBy positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.groupBy( testGroupByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryOrderByMethods
	*******************************************************/

	private static testMethod void testCWQueryOrderByMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryOrderByMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public CWQuery orderBy( String element )	*/
		testingMethod = 'CWQuery.orderBy';
		{
			//	orderBy positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, One Element',
				testQuery != null
			&&	testQuery.orderBy( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}
		{
			//	orderBy positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, Two Elements',
				testQuery != null
			&&	testQuery.orderBy( testOrderByFieldName ) == testQuery
			&&	testQuery.orderBy( testOrderByFieldName2 ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ',' + testOrderByFieldName2 )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByAscending( String element )	*/
		testingMethod = 'CWQuery.orderByAscending';
		{
			//	orderByAscending positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, One Element',
				testQuery != null
			&&	testQuery.orderByAscending( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' ASC' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}
		{
			//	orderByAscending positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, Two Elements',
				testQuery != null
			&&	testQuery.orderByAscending( testOrderByFieldName ) == testQuery
			&&	testQuery.orderByAscending( testOrderByFieldName2 ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' ASC,' + testOrderByFieldName2 + ' ASC' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByAscendingNullsFirst( String element )	*/
		testingMethod = 'CWQuery.orderByAscendingNullsFirst';
		{
			//	orderByAscendingNullsFirst positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.orderByAscendingNullsFirst( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' ASC NULLS FIRST' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByAscendingNullsLast( String element )	*/
		testingMethod = 'CWQuery.orderByAscendingNullsLast';
		{
			//	orderByAscendingNullsLast positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.orderByAscendingNullsLast( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' ASC NULLS LAST' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByDescending( String element )	*/
		testingMethod = 'CWQuery.orderByDescending';
		{
			//	orderByDescending positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, One Element',
				testQuery != null
			&&	testQuery.orderByDescending( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' DESC' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}
		{
			//	orderByDescending positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive, Two Elements',
				testQuery != null
			&&	testQuery.orderByDescending( testOrderByFieldName ) == testQuery
			&&	testQuery.orderByDescending( testOrderByFieldName2 ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' DESC,' + testOrderByFieldName2 + ' DESC' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByDescendingNullsFirst( String element )	*/
		testingMethod = 'CWQuery.orderByDescendingNullsFirst';
		{
			//	orderByDescendingNullsFirst positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.orderByDescendingNullsFirst( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' DESC NULLS FIRST' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery orderByDescendingNullsLast( String element )	*/
		testingMethod = 'CWQuery.orderByDescendingNullsLast';
		{
			//	orderByDescendingNullsLast positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.orderByDescendingNullsLast( testOrderByFieldName ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' ORDER BY ' + testOrderByFieldName + ' DESC NULLS LAST' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryLimitOffsetMethods
	*******************************************************/

	private static testMethod void testCWQueryLimitOffsetMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryLimitOffsetMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public CWQuery setLimit( Integer limitCount )	*/
		testingMethod = 'CWQuery.setLimit';
		{
			//	setLimit positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.setLimit( testLimitValue ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' LIMIT ' + testLimitValue )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid limitCount.\n' + testResults.getErrorString()
			);
		}
		{
			//	setLimit negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.setLimit( -1 ) == testQuery
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' succeeded with an invalid limit.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery setOffset( Integer offsetCount )	*/
		testingMethod = 'CWQuery.setOffset';
		{
			//	setOffset positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.setOffset( testOffsetValue ) == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' OFFSET ' + testOffsetValue )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid offsetCount.\n' + testResults.getErrorString()
			);
		}
		{
			//	setOffset negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.setOffset( 100000 ) == testQuery
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' succeeded with an invalid offset.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryViewReferenceUpdateMethods
	*******************************************************/

	private static testMethod void testCWQueryViewReferenceUpdateMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryViewReferenceUpdateMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public CWQuery forView()	*/
		testingMethod = 'CWQuery.forView';
		{
			//	forView positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.forView() == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' FOR VIEW' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery forReference()	*/
		testingMethod = 'CWQuery.forReference';
		{
			//	forReference positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.forReference() == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' FOR REFERENCE' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public CWQuery forUpdate()	*/
		testingMethod = 'CWQuery.forUpdate';
		{
			//	forUpdate positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.forUpdate() == testQuery
			&&	testQuery.toString().equals( 'SELECT Id FROM ' + testSObjectName + ' FOR UPDATE' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryQueryMethod
	*******************************************************/

	private static testMethod void testCWQueryQueryMethod()
	{
		CWTest testResults = new CWTest( 'testCWQueryQueryMethod' );
		String testingMethod;

		testResults.startTest();

		/*	public List<sObject> query()	*/
		testingMethod = 'CWQuery.query';
		{
			//	query positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.query() != null
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	query negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testQuery.add( testFieldName_Bad );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.query() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed to fail.\n' + testResults.getErrorString()
			);
		}
		{
			//	query negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			while ( testQuery != null && CWQuery.isQueryPossible() ) testQuery.query();
			testResults.assert
			(	testingMethod + ' - Negative (Too Many)',
				testQuery != null
			&&	testQuery.query() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' returned impossible query.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAggregateQueryMethod
	*******************************************************/

	private static testMethod void testCWQueryAggregateQueryMethod()
	{
		CWTest testResults = new CWTest( 'testCWQueryAggregateQueryMethod' );
		String testingMethod;

		testResults.startTest();

		/*	public List<AggregateResult> aggregateQuery()	*/
		testingMethod = 'CWQuery.aggregateQuery';
		{
			//	aggregateQuery positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.aggregateQuery() != null
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	aggregateQuery negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testQuery.newHavingClause( testFieldName_Bad );
			testResults.assert
			(	testingMethod + ' - Negative',
				testQuery != null
			&&	testQuery.aggregateQuery() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed to fail.\n' + testResults.getErrorString()
			);
		}
		{
			//	aggregateQuery negative test - non-aggregate query
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Non-Aggregate Query',
				testQuery != null
			&&	testQuery.aggregateQuery() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed to fail.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryQueryLocatorMethod
	*******************************************************/

	private static testMethod void testCWQueryQueryLocatorMethod()
	{
		CWTest testResults = new CWTest( 'testCWQueryQueryLocatorMethod' );
		String testingMethod;

		testResults.startTest();

		/*	public Database.QueryLocator getQueryLocator()	*/
		testingMethod = 'CWQuery.getQueryLocator';
		{
			//	getQueryLocator positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.getQueryLocator() != null
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryAccessMethods
	*******************************************************/

	private static testMethod void testCWQueryAccessMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryAccessMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public String getSObjectName()	*/
		testingMethod = 'CWQuery.getSObjectName';
		{
			//	getSObjectName positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.getSObjectName() == testSObjectName
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause getWhereClause()		*/
		testingMethod = 'CWQuery.getWhereClause';
		{
			//	getWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause	theWhereClause;
			if ( testQuery != null ) theWhereClause = testQuery.newWhereClause();
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.getWhereClause() == theWhereClause
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause setWhereClause( WhereClause newWhereClause )		*/
		testingMethod = 'CWQuery.setWhereClause';
		{
			//	setWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause	theWhereClause;
			if ( testQuery != null ) theWhereClause = testQuery.newWhereClause();
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testQuery.getWhereClause() == theWhereClause
			&&	testQuery.setWhereClause( null ) == testQuery
			&&	testQuery.getWhereClause() == null
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryWhereClauseMethods
	*******************************************************/

	private static testMethod void testCWQueryWhereClauseMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryWhereClauseMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public WhereClause newANDWhereClause( String element )	*/
		testingMethod = 'CWQuery.newANDWhereClause';
		{
			//	newANDWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newANDWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newANDWhereClause()		*/
		testingMethod = 'CWQuery.newANDWhereClause';
		{
			//	newANDWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newANDWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newORWhereClause( String element )	*/
		testingMethod = 'CWQuery.newORWhereClause';
		{
			//	newORWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newORWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newORWhereClause()		*/
		testingMethod = 'CWQuery.newORWhereClause';
		{
			//	newORWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newORWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newWhereClause( String element )		*/
		testingMethod = 'CWQuery.newWhereClause';
		{
			//	newWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newWhereClause()		*/
		testingMethod = 'CWQuery.newWhereClause';
		{
			//	newWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	newWhereClause negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative - Multiple Clauses',
				testQuery != null
			&&	testQuery.newWhereClause() != null
			&&	testQuery.newWhereClause() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryHavingClauseMethods
	*******************************************************/

	private static testMethod void testCWQueryHavingClauseMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryHavingClauseMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public HavingClause newANDHavingClause( String element )	*/
		testingMethod = 'CWQuery.newANDHavingClause';
		{
			//	newANDHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newANDHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newANDHavingClause()		*/
		testingMethod = 'CWQuery.newANDHavingClause';
		{
			//	newANDHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newANDHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newORHavingClause( String element )	*/
		testingMethod = 'CWQuery.newORHavingClause';
		{
			//	newORHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newORHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newORHavingClause()		*/
		testingMethod = 'CWQuery.newORHavingClause';
		{
			//	newORHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newORHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newHavingClause( String element )		*/
		testingMethod = 'CWQuery.newHavingClause';
		{
			//	newHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testQuery.newHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING (' + testWhereClauseElement + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newHavingClause()		*/
		testingMethod = 'CWQuery.newHavingClause';
		{
			//	newHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testQuery.newHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	newHavingClause negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			testResults.assert
			(	testingMethod + ' - Negative - Multiple Clauses',
				testQuery != null
			&&	testQuery.newHavingClause() != null
			&&	testQuery.newHavingClause() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	newHavingClause negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative - No GroupBy',
				testQuery != null
			&&	testQuery.newHavingClause() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	newHavingClause negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			testResults.assert
			(	testingMethod + ' - Negative without Element',
				testQuery != null
			&&	testQuery.newHavingClause() == null
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQuerySetRelatedMethods
	*******************************************************/

	private static testMethod void testCWQuerySetRelatedMethods()
	{
		CWTest testResults = new CWTest( 'testCWQuerySetRelatedMethods' );
		String testingMethod;

		List<String> testSetValues = new List<String>{ 'Value1', 'Value2', 'Value3' };
		String testSetAnyString = CWString.parenthesize( CWString.commaJoin( CWString.quote( testSetValues ) ) );
		String testSetAllString = CWString.parenthesize( CWString.semicolonJoin( CWString.quote( testSetValues ) ) );

		testResults.startTest();

		/*	public Boolean isIn( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.isIn';
		{
			//	isIn positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.isIn( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' IN ' + testSetAnyString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean isNotIn( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.isNotIn';
		{
			//	isNotIn positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.isNotIn( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' NOT IN ' + testSetAnyString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean includesAny( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.includesAny';
		{
			//	includesAny positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.includesAny( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' INCLUDES ' + testSetAnyString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean includesAll( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.includesAll';
		{
			//	includesAll positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.includesAll( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' INCLUDES ' + testSetAllString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean excludesAny( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.excludesAny';
		{
			//	excludesAny positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.excludesAny( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' EXCLUDES ' + testSetAllString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean excludesAll( String fieldName, List<Object> list_Values )	*/
		testingMethod = 'CWQuery.excludesAll';
		{
			//	excludesAll positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.excludesAll( testIsInField, testSetValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (' + testIsInField + ' EXCLUDES ' + testSetAnyString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryTypeMethods
	*******************************************************/

	private static testMethod void testCWQueryTypeMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryTypeMethods' );
		String testingMethod;

		String testTypeQueryString = 'SELECT Id FROM Task WHERE (WhatId.Type ';
		List<String> testTypeSetValues = new List<String>{ 'Case', 'Opportunity', 'Account' };
		String testTypeSetString = CWString.parenthesize( CWString.commaJoin( CWString.quote( testTypeSetValues ) ) );

		testResults.startTest();

		/*	public Boolean typeEqualTo( String fieldName, String sObjectName )	*/
		testingMethod = 'CWQuery.WhereClause.typeEqualTo';
		{
			//	typeEqualTo positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeEqualTo( 'WhatId', 'Case' ) == testWhere
			&&	testQuery.toString().equals( testTypeQueryString + '= \'Case\')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	typeEqualTo negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Negative - No Field',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeEqualTo( (String) null, 'Case' ) == testWhere
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	typeEqualTo negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Negative - Bad Field',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeEqualTo( testFieldName_Bad, 'Case' ) == testWhere
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	typeEqualTo negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Negative - Field Not Polymorphic',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeEqualTo( 'Id', 'Case' ) == testWhere
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	typeEqualTo negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Negative - Bad sObjectName',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeEqualTo( 'WhatId', testSObjectName_Bad ) == testWhere
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean typeNotEqualTo( String fieldName, String sObjectName )	*/
		testingMethod = 'CWQuery.WhereClause.typeNotEqualTo';
		{
			//	typeNotEqualTo positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeNotEqualTo( 'WhatId', 'Case' ) == testWhere
			&&	testQuery.toString().equals( testTypeQueryString + '!= \'Case\')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean typeIn( String fieldName, List<String> list_sObjectNames )	*/
		testingMethod = 'CWQuery.WhereClause.typeIn';
		{
			//	typeIn positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeIn( 'WhatId', testTypeSetValues ) == testWhere
			&&	testQuery.toString().equals( testTypeQueryString + 'IN ' + testTypeSetString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}
		{
			//	typeIn negative test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Negative - No List',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeIn( 'WhatId', (List<String>) null ) == testWhere
			&&	testResults.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean typeNotIn( String fieldName, List<String> list_sObjectNames )	*/
		testingMethod = 'CWQuery.WhereClause.typeNotIn';
		{
			//	typeNotIn positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeNotIn( 'WhatId', testTypeSetValues ) == testWhere
			&&	testQuery.toString().equals( testTypeQueryString + 'NOT IN ' + testTypeSetString + ')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean typeLike( String fieldName, String likeString )	*/
		testingMethod = 'CWQuery.WhereClause.typeLike';
		{
			//	typeLike positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( 'Task' );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.typeLike( 'WhatId', '%__c' ) == testWhere
			&&	testQuery.toString().equals( testTypeQueryString + 'LIKE \'%__c\')' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryMultiLikeMethods
	*******************************************************/

	private static testMethod void testCWQueryMultiLikeMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryMultiLikeMethods' );
		String testingMethod;

		List<String> testMultiLikeValues = new List<String>{ 'Alpha', 'Beta' };
		String testMultiLikeString = CWString.join( testMultiLikeValues, ' ' );

		testResults.startTest();

		/*	public Boolean multiLike( String fieldName, String likes )	*/
		testingMethod = 'CWQuery.FilterClause.multiLike';
		{
			//	multiLike positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with String',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.multiLike( testMultiLikeField, testMultiLikeString ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE ((' + testMultiLikeField + ' LIKE \'%Alpha%\') AND (' + testMultiLikeField + ' LIKE \'%Beta%\'))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public Boolean multiLike( String fieldName, List<String> list_Likes )	*/
		testingMethod = 'CWQuery.FilterClause.multiLike';
		{
			//	multiLike positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with List',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.multiLike( testMultiLikeField, testMultiLikeValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE ((' + testMultiLikeField + ' LIKE \'%Alpha%\') AND (' + testMultiLikeField + ' LIKE \'%Beta%\'))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryFilterClauseAddMethods
	*******************************************************/

	private static testMethod void testCWQueryFilterClauseAddMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryFilterClauseAddMethods' );
		String testingMethod;

		List<String> testFilterClauseValues = new List<String>{ 'Alpha', 'Beta' };
		String testFilterClausueString = CWString.commaJoin( testFilterClauseValues );

		testResults.startTest();

		/*	public Boolean add( List<String> list_Elements )	*/
		testingMethod = 'CWQuery.FilterClause.add';
		{
			//	add positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newORWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with List',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.add( testFilterClauseValues ) == testWhere
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE (Alpha OR Beta)' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid list.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryNestedWhereClauseMethods
	*******************************************************/

	private static testMethod void testCWQueryNestedWhereClauseMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryNestedWhereClauseMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public WhereClause newANDWhereClause( String element )	*/
		testingMethod = 'CWQuery.WhereClause.newANDWhereClause';
		{
			//	newANDWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newANDWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newANDWhereClause()	*/
		testingMethod = 'CWQuery.WhereClause.newANDWhereClause';
		{
			//	newANDWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newANDWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newORWhereClause( String element )	*/
		testingMethod = 'CWQuery.WhereClause.newORWhereClause';
		{
			//	newORWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newORWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newORWhereClause()	*/
		testingMethod = 'CWQuery.WhereClause.newORWhereClause';
		{
			//	newORWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newORWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newWhereClause( String element )		*/
		testingMethod = 'CWQuery.WhereClause.newWhereClause';
		{
			//	newWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newWhereClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( defaultQueryString + ' WHERE ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid element.\n' + testResults.getErrorString()
			);
		}

		/*	public WhereClause newWhereClause()		*/
		testingMethod = 'CWQuery.WhereClause.newWhereClause';
		{
			//	newWhereClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newQuery( testSObjectName );
			CWQuery.WhereClause testWhere = testQuery != null ? testQuery.newWhereClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testWhere != null
			&&	testWhere.newWhereClause() != null
			&&	testQuery.toString().equals( defaultQueryString )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryNestedHavingClauseMethods
	*******************************************************/

	private static testMethod void testCWQueryNestedHavingClauseMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryNestedHavingClauseMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public HavingClause newANDHavingClause( String element )	*/
		testingMethod = 'CWQuery.HavingClause.newANDHavingClause';
		{
			//	newANDHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testHaving.newANDHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newANDHavingClause()	*/
		testingMethod = 'CWQuery.HavingClause.newANDHavingClause';
		{
			//	newANDHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testHaving.newANDHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newORHavingClause( String element )		*/
		testingMethod = 'CWQuery.HavingClause.newORHavingClause';
		{
			//	newORHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testHaving.newORHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newORHavingClause()		*/
		testingMethod = 'CWQuery.HavingClause.newORHavingClause';
		{
			//	newORHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testHaving.newORHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newHavingClause( String element )		*/
		testingMethod = 'CWQuery.HavingClause.newHavingClause';
		{
			//	newHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive with Element',
				testQuery != null
			&&	testHaving.newHavingClause( testWhereClauseElement ) != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName + ' HAVING ((' + testWhereClauseElement + '))' )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed with valid elmeent.\n' + testResults.getErrorString()
			);
		}

		/*	public HavingClause newHavingClause()		*/
		testingMethod = 'CWQuery.HavingClause.newHavingClause';
		{
			//	newHavingClause positive test
			testResults.clearErrors();
			CWQuery testQuery = CWQuery.newAggregateQuery( testSObjectName );
			testQuery.groupBy( testGroupByFieldName );
			CWQuery.HavingClause testHaving = testQuery != null ? testQuery.newHavingClause() : null;
			testResults.assert
			(	testingMethod + ' - Positive without Element',
				testQuery != null
			&&	testHaving.newHavingClause() != null
			&&	testQuery.toString().equals( 'SELECT ' + testGroupByFieldName + ' FROM ' + testSObjectName + ' GROUP BY ' + testGroupByFieldName )
			&&	!testResults.checkErrors(),
				testingMethod + ' failed.\n' + testResults.getErrorString()
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testCWQueryMiscellaneousMethods
	*******************************************************/

	private static testMethod void testCWQueryMiscellaneousMethods()
	{
		CWTest testResults = new CWTest( 'testCWQueryMiscellaneousMethods' );
		String testingMethod;

		testResults.startTest();

		testResults.assert
		(	'CWQuery.FilterClause.className',
			'CWQuery.FilterClause',
			(new CWQuery.FilterClause( CWQuery.newQuery( testSObjectName ) )).className(),
			'CWQuery.FilterClause.className failed.'
		);

		testResults.assert
		(	'CWQuery.FilterClause.error',
			!(new CWQuery.FilterClause( CWQuery.newQuery( testSObjectName ) )).error( 'error', 'message' )
		&&	testResults.lastErrorStartsWith( 'CWQuery.FilterClause.error' ),
			'CWQuery.FilterClause.error failed.'
		);

		testResults.stopTest();
		testResults.report();
	}
}