/*******************************************************//**

@class		CWSortTest

@brief		ClosedWon Test Class for CWTime and related classes

	This class implements support for web callouts using HTTP.

@author		Janeen Anderson		(ClosedWon.JDA)

@version	2014-12-17	ClosedWon.JDA
	Created.

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest(seeAllData=true)
public class CWSorterTest
{
	private static testMethod void testCWSorter()
	{
		List<CWTestObject__c> myTestList1 = new List<CWTestObject__c>();
		List<CWTestObject__c> myTestList2 = new List<CWTestObject__c>();
		Boolean aBool = true;
		for ( Integer i = 0; i < 15; i++ )
		{
			aBool = !aBool;
			myTestList1.add
			(	new CWTestObject__c
				(	Checkbox__c		= aBool,
					Currency__c		= i * 101.01,
					Date__c			= Date.Today().addDays( i ),
					DateTime__c		= DateTime.newInstance( 2012 + i, 11, 5, 16, 0, 0 ),
					Email__c		= 'nobody' + i + '@gmail.com'
				)
			);
			myTestList2.add
			(	new CWTestObject__c
				(	Checkbox__c		= aBool,
					Currency__c		= i * 101.01,
					Date__c			= Date.Today().addDays( i ),
					DateTime__c		= DateTime.newInstance( 2012 + i, 11, 5, 16, 0, 0 ),
					Email__c		= 'nobody' + i + '@gmail.com'
				)
			);
		}
		insert  myTestList1;
		insert	myTestList2;

		CWPartition	myTestParition	= new CWPartition( myTestList2, 'Checkbox__c' );

		CWTest		testResults		= new CWTest( 'CWSortTest 1' );
		testResults.startTest();

		CWSorter	TestSorter1		= new CWSorter( 'CWTestObject__c' );
		CWSorter	TestSorter2		= new CWSorter( CWSchema.getDescribeSObjectResult( 'CWTestObject__c' ) );
		CWSorter	TestSorter3		= new CWSorter( myTestList1[0] );

		TestSorter3.sortAscending( 'Date__c' );
		TestSorter3.sortAscendingNullsFirst( 'Currency__c' );
		TestSorter3.sortAscendingNullsLast( 'Email__c' );
		testResults.assert( 'TestSorter 3 sort', TestSorter3.sort( (List<sObject>) myTestList1 ) );

		TestSorter2.sortDescending( 'Date__c' );
		TestSorter2.sortDescendingNullsFirst( 'Currency__c' );
		TestSorter2.sortDescendingNullsLast( 'Email__c' );
		testResults.assert( 'TestSorter 2 sort list', TestSorter2.sort( (List<sObject>) myTestList1 ) );
		testResults.assert( 'TestSorter 2 sort partition', TestSorter2.sort( myTestParition ) );

		testResults.stopTest();
		testResults.report();
	}
}