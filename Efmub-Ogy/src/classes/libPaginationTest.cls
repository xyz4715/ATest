/*******************************************************//**

@class		CWPaginationTest

@brief		Tests for CWPagination Class

	The CWPaginationTest class contains the test methods for the
	CWPagination class.

@author		Tim Smith (LiquidHub.TRS)

@version	2014-11-11	LiquidHub.TRS
	Created.

@todo		Fix usage of CWTest

@see		CWPagination

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWPaginationTest
{
	/*******************************************************
					Constants
	*******************************************************/

	private static List<String> fieldSet	= new List<String>{ 'Name' };
	private static Integer		numRecords	= 10;

	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwPaginationUnitTest()
	{
		////	Create Records for Test
		List<Account>	accounts	= new List<Account>();
		for ( Integer i = 0 ; i < numRecords ; i++ )
		{
			accounts.add( new Account( Name = 'Test ' + i ) );
		}
		insert accounts;

		////	Begin Test
		CWTest testResults		= new CWTest( 'CWPartitionTest' );
		String testingMethod;

		testResults.startTest();

		//	Create query
		CWQuery			theQuery	= CWQuery.newQuery( Account.getSObjectType() );
		//	Add fieldset to query
		theQuery.add( fieldSet );
		CWPagination	pages		= new CWPagination( theQuery );
		pages.numPerPage			= 1;

		List<Account>	accountPage	= ( List<Account> ) pages.pageRecords;

		////	gotoFirstPage method test
		testResults				= new CWTest( 'gotoFirstPage' );
		pages.gotoFirstPage();

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			!pages.hasPreviousPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoNextPage method test
		testResults				= new CWTest( 'gotoNextPage' );
		pages.gotoNextPage();

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			1,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoPreviousPage method test
		testResults				= new CWTest( 'gotoPreviousPage' );
		pages.gotoPreviousPage();

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			0,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoLastPage method test
		testResults				= new CWTest( 'gotoLastPage' );
		pages.gotoLastPage();

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			!pages.hasNextPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoPage method test
		testResults				= new CWTest( 'gotoPage' );
		pages.gotoPage( numRecords - 1 );

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			numRecords - 1,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoPage method test
		testResults				= new CWTest( 'gotoPage' );
		pages.gotoPage( numRecords - 1 );

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			numRecords - 1,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoRecord method test
		testResults				= new CWTest( 'gotoRecord' );
		pages.gotoRecord( numRecords );

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			numRecords - 1,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	gotoRecord method test
		testResults				= new CWTest( 'gotoRecord' );
		pages.gotoRecordId( accounts[0].Id );

		////	gotoFirstPage method test assertions
		testResults.assert
		(	testingMethod,
			0,
			pages.currentPage,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	getPageNumbers method test assertions
		testResults.assert
		(	testingMethod,
			numRecords,
			pages.pageNumbers.size(),
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);
	}
}