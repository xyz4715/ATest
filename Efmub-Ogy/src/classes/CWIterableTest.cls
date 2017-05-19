/*******************************************************//**

@class		CWIterableTest

@brief		CW Core Iterable Test Class

	Description goes here.

@author		Janeen Anderson (LiquidHub.JDA)

@version	2014-08-29	LiquidHub.JDA
	Created.

@see		CWIterable

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public without sharing class CWIterableTest
{
	static public testMethod void testCaseStringMethods()
	{
		List<CWTestObject__c> list_Records = new List<CWTestObject__c>();
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
		}
		insert list_Records;

		Set<sObject>	set_sObjects	= new Set<sObject>( (List<sObject>) list_Records );
		Set<Object>		set_Objects		= new Set<Object>( (List<Object>) list_Records );
		Set<String>		fieldNameSet	= new Set<String>{ 'Number_18_0__c', 'Number_12_6__c', 'Number_8_0__c' };

		list<String>	fieldNameList	= new list<String>
		{	'Number_8_0__c',
			'Checkbox__c',
			'Currency__c',
			'Date__c',
			'DateTime__c',
			'Email__c',
			'Number_8_0__c',
			'Number_18_0__c',
			'Number_12_6__c',
			'Geolocation__c',
			'Text_40__c',
			'Text_Area__c',
			'Text_Long__c',
			'Text_Rich__c',
			'Text_Encrypted__c',
			'Percent__c',
			'Phone__c',
			'Picklist__c'
		};
		Set<String>		myNameSet		= new Set<String>( fieldNameList );

		CWTest			myCWTest		= new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		CWIterable		myIterStrings	= new CWIterable( (List<Object>) fieldNameList );
		CWIterable		my_Iterable		= new CWIterable( (List<Object>) list_Records );

		CWIterable		coverConstructors1	= new CWIterable( (Iterable<Object>) list_Records, (List<CWFunction>) null );

		// Cover toList member functions
		coverConstructors1.toList();
		myIterStrings.toList( String.class );	// or Type.forName( 'String' )
		coverConstructors1.toList( 50 );
		CWIterable.toList( my_Iterable );
		CWIterable.toList( myIterStrings, String.class, 50 ); 
		CWIterable.toList( myIterStrings, String.class );
		CWIterable.toList_String( myIterStrings, 50 ); 
		CWIterable.toList_String( myIterStrings );
		CWIterable.toList( my_Iterable, 50 );
		CWIterable.toList( my_Iterable, 50 );

		// Cover toList_Blob member functions
		coverConstructors1.toList_Blob();
		coverConstructors1.toList_Blob( 50 );
		CWIterable.toList_Blob( my_Iterable, 50 );
		CWIterable.toList_Blob( my_Iterable );

		// Cover toList_Boolean member functions
		coverConstructors1.toList_Boolean();
		coverConstructors1.toList_Boolean( 50 );
		CWIterable		myIterBools		= new CWIterable( (List<Object>) new List<Boolean>{ true, false } );
		CWIterable.toList_Boolean( myIterBools, 50 );
		CWIterable.toList_Boolean( myIterBools );

		// Cover toList_ Date and DateTime member functions
		CWIterable		myIterdates		= new CWIterable( (List<Object>) new List<Date>{ Date.Today(), Date.Today().addDays( 20 ) } );
		myIterdates.toList_Date();
		myIterdates.toList_Date( 50 );
		CWIterable.toList_Date( myIterdates, 50 );
		CWIterable.toList_Date( myIterdates );
		CWIterable		myIterDateTimes	= new CWIterable( (List<Object>) new List<DateTime>{ DateTime.Now(), DateTime.Now().addHours( 20 ) } );
		myIterDateTimes.toList_DateTime();
		myIterDateTimes.toList_DateTime( 50 );
		CWIterable.toList_DateTime( myIterDateTimes, 50 );
		CWIterable.toList_DateTime( myIterDateTimes );
		CWIterable		myIterTimes		= new CWIterable( (List<Object>) new List<Time>{ DateTime.Now().time(), DateTime.Now().addHours( 20 ).time() } );
		myIterTimes.toList_Time();
		myIterTimes.toList_Time( 50 );
		CWIterable.toList_Time( myIterTimes, 50 );
		CWIterable.toList_Time( myIterTimes );

		// Cover toList_ Number member functions
		Double D1 = 1.0, D2 = 2.0;
		CWIterable		myIterDoubles	= new CWIterable( (List<Object>) new List<Double>{ D1, D2 } );
		myIterDoubles.toList_Double();
		myIterDoubles.toList_Double( 50 );
		CWIterable.toList_Double( myIterDoubles, 50 );
		CWIterable.toList_Double( myIterDoubles );
		myIterDoubles.toList_Decimal();
		myIterDoubles.toList_Decimal( 50 );
		CWIterable.toList_Decimal( myIterDoubles, 50 );
		CWIterable.toList_Decimal( myIterDoubles );
		myIterDoubles.toList_Integer();
		myIterDoubles.toList_Integer( 50 );
		CWIterable.toList_Integer( myIterDoubles, 50 );
		CWIterable.toList_Integer( myIterDoubles );
		myIterDoubles.toList_Long();
		myIterDoubles.toList_Long( 50 );
		CWIterable.toList_Long( myIterDoubles, 50 );
		CWIterable.toList_Long( myIterDoubles );

		// Cover objects
		my_Iterable.toList_Object();
		my_Iterable.toList_Object( 50 );
		CWIterable.toList_Object( my_Iterable, 50 );
		CWIterable.toList_Object( my_Iterable );
		my_Iterable.toList_SObject();
		my_Iterable.toList_SObject( 50 );
		CWIterable.toList_SObject( my_Iterable, 50 );
		CWIterable.toList_SObject( my_Iterable );

		myCWTest.report();
		myCWTest.stopTest();
	}
}