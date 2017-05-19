/*******************************************************//**

@class		CWCompareTest

@brief		Test Class for CW Core Compare Class

	Entry points tested:

	public static Integer	nullIsSmall()
	public static Integer	nullIsLarge()

	public static Boolean isComparable( Type theType )

	public static Integer compare( Type theType, Object objectA, Object objectB, Integer nullComparison )
	public static Integer compare( Type theType, Object objectA, Object objectB )
	public static Integer compareNullIsSmall( Type theType, Object objectA, Object objectB )
	public static Integer compareNullIsLarge( Type theType, Object objectA, Object objectB )

	public static Integer compare( Object objectA, Object objectB, Integer nullComparison )
	public static Integer compare( Object objectA, Object objectB )
	public static Integer compareNullIsSmall( Object objectA, Object objectB )
	public static Integer compareNullIsLarge( Object objectA, Object objectB )

	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName, Integer nullComparison )
	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName )
	public static Integer compareNullIsSmall( Type theType, sObject objectA, sObject objectB, String fieldName )
	public static Integer compareNullIsLarge( Type theType, sObject objectA, sObject objectB, String fieldName )

	public static Integer compare( sObject objectA, sObject objectB, String fieldName, Integer nullComparison )
	public static Integer compare( sObject objectA, sObject objectB, String fieldName )
	public static Integer compareNullIsSmall( sObject objectA, sObject objectB, String fieldName )
	public static Integer compareNullIsLarge( sObject objectA, sObject objectB, String fieldName )

	public static Integer compare( Type theType, CWObject objectA, CWObject objectB, String fieldName, Integer nullComparison )
	public static Integer compare( Type theType, CWObject objectA, CWObject objectB, String fieldName )
	public static Integer compareNullIsSmall( Type theType, CWObject objectA, CWObject objectB, String fieldName )
	public static Integer compareNullIsLarge( Type theType, CWObject objectA, CWObject objectB, String fieldName )

	public static Integer compare( CWObject objectA, CWObject objectB, String fieldName, Integer nullComparison )
	public static Integer compare( CWObject objectA, CWObject objectB, String fieldName )
	public static Integer compareNullIsSmall( CWObject objectA, CWObject objectB, String fieldName )
	public static Integer compareNullIsLarge( CWObject objectA, CWObject objectB, String fieldName )

	public static Boolean equals( Object objectA, Object objectB )
	public static Boolean equals( sObject objectA, sObject objectB, String fieldName )
	public static Boolean equals( CWObject objectA, CWObject objectB, String fieldName )

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-10-02	LiquidHub.GHA
	Created.

@see		CWCompare

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public class CWCompareTest
{
	public static testMethod void testCompareKnownTypes()
	{
		CWTest testResults = new CWTest( 'testCompareKnownTypes' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		testResults.startTest();

		/*	public static Integer compare( Type theType, Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( Id.class, (Object) objectA.Id, (Object) objectB.Id );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( Id.class, (Object) objectB.Id, (Object) objectA.Id );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( Id.class, (Object) objectA.Id, (Object) objectA.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( Id.class, (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( Id.class, (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( Type theType, Object objectA, Object objectB, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( Id.class, (Object) objectA.Id, (Object) null, CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( Id.class, (Object) null, (Object) objectB.Id, CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( Id.class, (Object) objectA.Id, (Object) null, CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( Id.class, (Object) null, (Object) objectB.Id, CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( Type theType, Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( Id.class, (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( Id.class, (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( Type theType, Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( Id.class, (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( Id.class, (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareUnknownTypes()
	{
		CWTest testResults = new CWTest( 'testCompareUnknownTypes' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		testResults.startTest();

		/*	public static Integer compare( Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( (Object) objectA.Id, (Object) objectB.Id );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( (Object) objectB.Id, (Object) objectA.Id );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( (Object) objectA.Id, (Object) objectA.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( Object objectA, Object objectB, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( (Object) objectA.Id, (Object) null, CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( (Object) null, (Object) objectB.Id, CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( (Object) objectA.Id, (Object) null, CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( (Object) null, (Object) objectB.Id, CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( (Object) objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( (Object) null, (Object) objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareKnownFields()
	{
		CWTest testResults = new CWTest( 'testCompareKnownFields' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		CWTestObject__c	objectC	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		testResults.startTest();

		/*	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( Id.class, (sObject) objectA, (sObject) objectB, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( Id.class, (sObject) objectB, (sObject) objectA, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( Id.class, (sObject) objectA, (sObject) objectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( Id.class, (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( Id.class, (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( Id.class, (sObject) objectA, (sObject) objectC, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( Id.class, (sObject) objectC, (sObject) objectB, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( Id.class, (sObject) objectA, (sObject) objectC, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( Id.class, (sObject) objectC, (sObject) objectB, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( Type theType, sObject objectA, sObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( Id.class, (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( Id.class, (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( Type theType, sObject objectA, sObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( Id.class, (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( Id.class, (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareUnknownFields()
	{
		CWTest testResults = new CWTest( 'testCompareUnknownFields' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		CWTestObject__c	objectC	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		testResults.startTest();

		/*	public static Integer compare( sObject objectA, sObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( (sObject) objectA, (sObject) objectB, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( (sObject) objectB, (sObject) objectA, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( (sObject) objectA, (sObject) objectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( Type theType, sObject objectA, sObject objectB, String fieldName, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( (sObject) objectA, (sObject) objectC, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( (sObject) objectC, (sObject) objectB, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( (sObject) objectA, (sObject) objectC, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( (sObject) objectC, (sObject) objectB, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( Type theType, sObject objectA, sObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( Type theType, sObject objectA, sObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( (sObject) objectA, (sObject) objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( (sObject) objectC, (sObject) objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareKnownValues()
	{
		CWTest testResults = new CWTest( 'testCompareKnownValues' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		CWObject	cwobjectA	= new CWObject();	cwobjectA.put( 'Id', objectA.Id );
		CWObject	cwobjectB	= new CWObject();	cwobjectB.put( 'Id', objectB.Id );
		CWObject	cwobjectC	= new CWObject();

		testResults.startTest();

		/*	public static Integer compare( Type theType, CWObject objectA, CWObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( Id.class, cwobjectA, cwobjectB, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( Id.class, cwobjectB, cwobjectA, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( Id.class, cwobjectA, cwobjectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( Id.class, cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( Id.class, cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( Type theType, CWObject objectA, CWObject objectB, String fieldName, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( Id.class, cwobjectA, cwobjectC, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( Id.class, cwobjectC,cwobjectB, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( Id.class, cwobjectA, cwobjectC, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( Id.class, cwobjectC, cwobjectB, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( Type theType, CWObject objectA, CWObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( Id.class, cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( Id.class, cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( Type theType, CWObject objectA, CWObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( Id.class, cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( Id.class, cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareUnknownValues()
	{
		CWTest testResults = new CWTest( 'testCompareUnknownValues' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		CWObject	cwobjectA	= new CWObject();	cwobjectA.put( 'Id', objectA.Id );
		CWObject	cwobjectB	= new CWObject();	cwobjectB.put( 'Id', objectB.Id );
		CWObject	cwobjectC	= new CWObject();

		testResults.startTest();

		/*	public static Integer compare( CWObject objectA, CWObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compare';
		{
			Integer comparison;
			comparison = CWCompare.compare( cwobjectA, cwobjectB, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				objectA.Id < objectB.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			comparison = CWCompare.compare( cwobjectB, cwobjectA, 'Id' );
			testResults.assert
			(	testingMethod + ' - IdB, IdA',
				objectB.Id < objectA.Id ? comparison < 0 : comparison > 0,
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				0,
				CWCompare.compare( cwobjectA, cwobjectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (default)',
				1,
				CWCompare.compare( cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (default)',
				-1,
				CWCompare.compare( cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compare( CWObject objectA, CWObject objectB, String fieldName, Integer nullComparison )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null (small)',
				1,
				CWCompare.compare( cwobjectA, cwobjectC, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (small)',
				-1,
				CWCompare.compare( cwobjectC,cwobjectB, 'Id', CWCompare.nullIsSmall() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null (large)',
				-1,
				CWCompare.compare( cwobjectA, cwobjectC, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB (large)',
				1,
				CWCompare.compare( cwobjectC, cwobjectB, 'Id', CWCompare.nullIsLarge() ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsSmall( CWObject objectA, CWObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				1,
				CWCompare.compareNullIsSmall( cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				-1,
				CWCompare.compareNullIsSmall( cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Integer compareNullIsLarge( CWObject objectA, CWObject objectB )	*/
		testingMethod = 'CWCompare.compareNullIsLarge';
		{
			testResults.assert
			(	testingMethod + ' - IdA, null',
				-1,
				CWCompare.compareNullIsLarge( cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, IdB',
				1,
				CWCompare.compareNullIsLarge( cwobjectC, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testCompareForEquality()
	{
		CWTest testResults = new CWTest( 'testCompareForEquality' );
		String testingMethod;

		CWTestObject__c	objectA	= new CWTestObject__c();
		CWTestObject__c	objectB	= new CWTestObject__c();
		CWTestObject__c	objectC	= new CWTestObject__c();
		insert new List<CWTestObject__c>{ objectA, objectB };

		CWObject	cwobjectA	= new CWObject();	cwobjectA.put( 'Id', objectA.Id );
		CWObject	cwobjectB	= new CWObject();	cwobjectB.put( 'Id', objectB.Id );
		CWObject	cwobjectC	= new CWObject();

		testResults.startTest();

		/*	public static Boolean equals( Object objectA, Object objectB )	*/
		testingMethod = 'CWCompare.equals';
		{
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				!CWCompare.equals( objectA.Id, objectB.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				CWCompare.equals( objectA.Id, objectA.Id ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null',
				!CWCompare.equals( objectA.Id, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, null',
				CWCompare.equals( (Object) null, (Object) null ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Boolean equals( sObject objectA, sObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compare';
		{
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				!CWCompare.equals( objectA, objectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				CWCompare.equals( objectA, objectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null',
				!CWCompare.equals( objectA, objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, null',
				CWCompare.equals( objectC, objectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		/*	public static Boolean equals( CWObject objectA, CWObject objectB, String fieldName )	*/
		testingMethod = 'CWCompare.compareNullIsSmall';
		{
			testResults.assert
			(	testingMethod + ' - IdA, IdB',
				!CWCompare.equals( cwobjectA, cwobjectB, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, IdA',
				CWCompare.equals( cwobjectA, cwobjectA, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - IdA, null',
				!CWCompare.equals( cwobjectA, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
			testResults.assert
			(	testingMethod + ' - null, null',
				CWCompare.equals( cwobjectC, cwobjectC, 'Id' ),
				testingMethod + ' incorrectly compared Id values.\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	public static testMethod void testMiscCompareMethods()
	{
		CWTest testResults = new CWTest( 'testMiscCompareMethods' );
		String testingMethod;

		testResults.startTest();

		/*	public static Boolean isComparable( Type theType )	*/
		testingMethod = 'CWCompare.isComparable';
		{
			testResults.assert
			(	testingMethod + ' - Integer',
				CWCompare.isComparable( Integer.class )
			);
			testResults.assert
			(	testingMethod + ' - Blob',
				!CWCompare.isComparable( Blob.class )
			);
		}

		CWCompare.compare( Boolean.class, true, false );

		testResults.stopTest();
		testResults.report();
	}
}