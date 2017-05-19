/*******************************************************//**

@class		CWCollectionTest

@brief		CW Core Collection Test Class

	Description goes here.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-02-03	LiquidHub.GHA
	Created.

@todo		Complete code coverage

@see		CWCollection

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWCollectionTest
{
	private static List<CWTestObject__c>	list_Records;
	private static List<BusinessHours>		list_BusinessHours;

	private static void initializeCWCollectionTest()
	{
		list_Records		= new List<CWTestObject__c>();
		list_BusinessHours	= new List<BusinessHours>();

		for ( Integer i = 0; i < 10; i++ )
		{
			list_Records.add
			(	new CWTestObject__c
				(	Number_8_0__c	= i,
					Checkbox__c		= i < 5,
					Date__c			= Date.today().addDays( i ),
					DateTime__c		= System.now().addDays( i ),
					Text_40__c		= 'Text ' + String.valueOf( i )
				)
			);
			list_BusinessHours.add( new BusinessHours( MondayStartTime = Time.newInstance( 12, 30, 0, 0 ) ) );
		}
		insert list_Records;
	}

	/*******************************************************
				testIsEmptyMethods method
	*******************************************************/

	static testMethod void testIsEmptyMethods()
	{
		CWTest	testResults		= new CWTest( 'testIsEmptyMethods' );
		String	testingMethod;

		testResults.startTest();

		testingMethod	= 'CWCollection.isEmpty';

		testResults.assert
		(	testingMethod + ' - Empty',
			CWCollection.isEmpty( new List<Integer>() ),
			testingMethod + ' thought empty list was not empty\n'
		);
		testResults.assert
		(	testingMethod + ' - Null',
			CWCollection.isEmpty( null ),
			testingMethod + ' thought null was not empty\n'
		);
		testResults.assert
		(	testingMethod + ' - Not Empty',
			!CWCollection.isEmpty( new List<Integer>{ 0 } ),
			testingMethod + ' thought non-empty list was empty\n'
		);

		testingMethod	= 'CWCollection.isNotEmpty';

		testResults.assert
		(	testingMethod + ' - Empty',
			!CWCollection.isNotEmpty( new List<Integer>() ),
			testingMethod + ' thought empty list was not empty\n'
		);
		testResults.assert
		(	testingMethod + ' - Null',
			!CWCollection.isNotEmpty( null ),
			testingMethod + ' thought null was not empty\n'
		);
		testResults.assert
		(	testingMethod + ' - Not Empty',
			CWCollection.isNotEmpty( new List<Integer>{ 0 } ),
			testingMethod + ' thought non-empty list was empty\n'
		);

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
				testListOfMethods method
	*******************************************************/

	//	This isn't really test code - this is Execute Anonymous code...
	static public testMethod void testListOfMethods()
	{
		CWTest	testResults		= new CWTest( 'testIsEmptyMethods' );
		String	testingMethod;

		testResults.startTest();

		testingMethod	= 'CWCollection.listOfObjects';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfObjects( list_Records, 'Number_8_0__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfBooleans';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfBooleans( list_Records, 'Checkbox__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfDates';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfDates( list_Records, 'Date__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfDateTimes';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfDateTimes( list_Records, 'DateTime__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfTimes';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfTimes( list_BusinessHours, 'MondayStartTime' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfDecimals';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfDecimals( list_Records, 'Number_8_0__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfDoubles';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfDoubles( list_Records, 'Number_8_0__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfIntegers';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfIntegers( list_Records, 'Number_8_0__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfLongs';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfLongs( list_Records, 'Number_8_0__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfStrings';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfStrings( list_Records, 'Text_40__c' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
		testingMethod	= 'CWCollection.listOfIDs';
		testResults.assert
		(	testingMethod,
			CWCollection.isNotEmpty( CWCollection.listOfIDs( list_Records, 'Id' ) ),
			testingMethod + ' returned a null or empty list\n'
		);
/*
		System.debug( CWCollection.setOfObjects( list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.setOfBooleans( list_Records, 'Checkbox__c' ) );
		System.debug( CWCollection.setOfDates( list_Records, 'Date__c' ) );
		System.debug( CWCollection.setOfDateTimes( list_Records, 'DateTime__c' ) );
		System.debug( CWCollection.setOfTimes( list_BusinessHours, 'MondayStartTime' ) );
		System.debug( CWCollection.setOfDecimals( list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.setOfDoubles( list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.setOfIntegers( list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.setOfLongs( list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.setOfStrings( list_Records, 'Text_40__c' ) );
		System.debug( CWCollection.setOfIDs( list_Records, 'Id' ) );

		Set<sObject>	set_sObjects	= new Set<sObject>( (List<sObject>) list_Records );
		Set<Object>		set_Objects		= new Set<Object>( (List<Object>) list_Records );
		Set<String>		fieldNameSet	= new Set<String>{ 'Number_18_0__c', 'Number_12_6__c', 'Number_8_0__c' };
		CWIterable		my_Iterable		= new CWIterable( (List<Object>) list_Records );
/*
		System.debug( CWCollection.mapRecords( list_Records, 'Text_40__c' ) );
		System.debug( CWCollection.mapRecords( CWCollection.mapRecords( list_Records, 'Text_40__c' ), 'Text_40__c' ) );
		System.debug( CWCollection.mapFields( (list<sObject>)null, 'Text_40__c', 'Text 0' ) );  // force exception for validateArguments
		System.debug( CWCollection.mapFields( list_Records, 'Number_8_0__c', '0' ) );
		System.debug( CWCollection.mapFields( CWCollection.mapRecords( list_Records, 'Number_8_0__c' ), 'Number_8_0__c', '0' ) );
/*
		System.debug( 'CWCollection list_Records is ' + (CWCollection.isEmpty( list_Records ) ? '' : 'not') + ' empty');
		System.debug( 'CWCollection list_Records is ' + (CWCollection.isNotEmpty( list_Records ) ? 'not' : '') + ' empty');

		System.debug( CWCollection.extractField( list_Records[0], 'Number_8_0__c' ) );
/*
		System.debug( CWCollection.extractParent( list_Records[0], 'Number_8_0__c' ) );
		System.debug( CWCollection.extractParent( my_Iterable, 'Parent' ) );
		System.debug( CWCollection.extractParent( (List<sObject>)list_Records, 'Parent' ) );
		System.debug( CWCollection.extractParent( new Set<sObject>((List<sObject>)list_Records), 'Parent' ) );
/*
		System.debug( CWCollection.extractField( my_Iterable, 'Number_8_0__c' ) );
		System.debug( CWCollection.extractField( (List<sObject>)list_Records, 'Number_8_0__c' ) );
		System.debug( CWCollection.extractField( new Set<sObject>((List<sObject>)list_Records), 'Number_8_0__c' ) );
/*
		System.debug( CWCollection.groupRecords( (List<sObject>)list_Records, 'Text_40__c' ) );
		System.debug( CWCollection.groupRecords( CWCollection.mapRecords( list_Records, 'Text_40__c' ), 'Text_40__c' ) );
		System.debug( CWCollection.groupFields( (List<sObject>)list_Records, 'Text_40__c', 'Val' ) );
		System.debug( CWCollection.groupFields( CWCollection.mapRecords( list_Records, 'Text_40__c' ), 'Text_40__c', 'Text 0' ) );

		System.debug( CWCollection.filterRecords( (List<sObject>)list_Records, 'Text_40__c', new Set<Object>((List<Object>)list_Records) ) );
		System.debug( CWCollection.filterRecords( CWCollection.mapRecords( list_Records, 'Text_40__c' ), 'Text_40__c', new Set<Object>((List<Object>)list_Records) ) );
		System.debug( CWCollection.filterRecords( (List<sObject>)list_Records, 'Text_40__c', (Object)list_Records[0]) );
		System.debug( CWCollection.filterRecords( CWCollection.mapRecords( list_Records, 'Text_40__c' ), 'Text_40__c', (Object)list_Records[0] ) );

		System.debug( CWCollection.countRecords( (List<sObject>)list_Records, 'Text_40__c', 'Val' ) );
		System.debug( CWCollection.countRecords( (List<sObject>)list_Records, 'Text_40__c', new Set<Object>((List<Object>)list_Records) ) );

		System.debug( CWCollection.sumOfIntegers((List<sObject>)list_Records, 'Number_8_0__c') );
		System.debug( CWCollection.sumOfIntegers((List<sObject>)list_Records, fieldNameSet) );
		System.debug( CWCollection.sumOfDoubles((List<sObject>)list_Records, 'Number_8_0__c') );
		System.debug( CWCollection.sumOfDoubles((List<sObject>)list_Records, fieldNameSet) );
		System.debug( CWCollection.sumOfDecimals((List<sObject>)list_Records, 'Number_8_0__c') );
		System.debug( CWCollection.sumOfDecimal((List<sObject>)list_Records, fieldNameSet) );
		System.debug( CWCollection.sumOfLongs((List<sObject>)list_Records, 'Number_8_0__c') );
		System.debug( CWCollection.sumOfLongs((List<sObject>)list_Records, fieldNameSet) );
//*/
	}
}