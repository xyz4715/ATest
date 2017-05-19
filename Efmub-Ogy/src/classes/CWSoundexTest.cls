/*******************************************************//**

@class		CWSoundexTest

@brief		CW Soundex Encoding Test Class

	Unit tests for CWSoundex class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-10-16	LiquidHub.GHA
	Created.

@see		CWSoundex

	(c)2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWSoundexTest
{	
	private static List<String>	inputStrings	= new List<String>{ 'Soundex',	'mellow',	'indivisibility',	null	};
	private static List<String>	outputStrings4	= new List<String>{ 'S532',		'M400',		'I531',				'0000'	};
	private static List<String>	outputStrings5	= new List<String>{ 'S5320',	'M4000',	'I5312',			'00000'	};

	private static List<CWTestObject__c>	testObjects		= new List<CWTestObject__c>();

	private static void initializeCWSoundexTest()
	{
		for ( Integer index = 0; index < inputStrings.size(); index++ )
		{
			testObjects.add( new CWTestObject__c( Text_40__c = inputStrings[ index ] ) );
		}
	}

	static testMethod void testCWSoundexEncodeStrings()
	{
		initializeCWSoundexTest();

		CWTest	testResults		= new CWTest( 'testCWSoundexEncodeStrings' );
		String	testingMethod	= 'CWSoundex.enocde';

		testResults.startTest();

		List<String>	outputStrings	= CWSoundex.encode( inputStrings, 4 );

		for ( Integer index = 0; index < inputStrings.size(); index++ )
		{
			testResults.assert
			(	testingMethod + ' - outputLength == 4',
				outputStrings4[ index ],
				outputStrings[ index ],
				testingMethod + ' failed to encode \'' + (inputStrings[ index ] != null ? inputStrings[ index ] : 'null') + '\' correctly\n'
			);
		}

		outputStrings	= CWSoundex.encode( inputStrings, 5 );

		for ( Integer index = 0; index < inputStrings.size(); index++ )
		{
			testResults.assert
			(	testingMethod + ' - outputLength == 5',
				outputStrings5[ index ],
				outputStrings[ index ],
				testingMethod + ' failed to encode \'' + (inputStrings[ index ] != null ? inputStrings[ index ] : 'null') + '\' correctly\n'
			);
		}

		outputStrings	= CWSoundex.encode( inputStrings, null );

		for ( Integer index = 0; index < inputStrings.size(); index++ )
		{
			testResults.assert
			(	testingMethod + ' - outputLength == null',
				outputStrings4[ index ],
				outputStrings[ index ],
				testingMethod + ' failed to encode \'' + (inputStrings[ index ] != null ? inputStrings[ index ] : 'null') + '\' correctly\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	static testMethod void testCWSoundexEncodeFields()
	{
		initializeCWSoundexTest();

		CWTest	testResults		= new CWTest( 'testCWSoundexEncodeRecords' );
		String	testingMethod	= 'CWSoundex.enocde';

		testResults.startTest();

		for ( Integer index = 0; index < testObjects.size(); index++ )
		{
			CWSoundex.encodeField( testObjects[ index ], 'Text_40__c', 'Soundex__c' );

			testResults.assert
			(	testingMethod + ' - fields',
				outputStrings5[ index ],
				testObjects[ index ].Soundex__c,
				testingMethod + ' failed to encode \'' + (inputStrings[ index ] != null ? inputStrings[ index ] : 'null') + '\' correctly\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}

	static testMethod void testCWSoundexEncodeRecords()
	{
		initializeCWSoundexTest();

		CWTrigger	theTrigger	= new CWTrigger( 'before insert', testObjects );

		CWTest	testResults		= new CWTest( 'testCWSoundexEncodeRecords' );
		String	testingMethod	= 'CWSoundex.enocde';

		testResults.startTest();

		CWSoundex.encode( theTrigger, new Map<String,String>{ 'Text_40__c' => 'Soundex__c' } );

		for ( Integer index = 0; index < testObjects.size(); index++ )
		{
			testResults.assert
			(	testingMethod + ' - trigger',
				inputStrings[ index ] != null ? outputStrings5[ index ] : null,
				testObjects[ index ].Soundex__c,
				testingMethod + ' failed to encode \'' + (inputStrings[ index ] != null ? inputStrings[ index ] : 'null') + '\' correctly\n'
			);
		}

		testResults.stopTest();
		testResults.report();
	}
}