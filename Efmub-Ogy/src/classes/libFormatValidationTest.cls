/*******************************************************//**

@class		CWFormatValidationTest

@brief		CW Format Validation Test Class

	Unit Tests for the CWFormatValidation class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-10-16	LiquidHub.GHA
	Created.

@see		CWFormatValidation

	(c)2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWFormatValidationTest
{
	private static String	testSObjectName		= 'CWTestObject__c';
	private static String	testFieldName		= 'Text_40__c';
	private static String	testExpression		= '^\\w+$';

	private static String	validString			= 'This_is_valid_123';
	private static String	invalidString		= 'This isn\'t valid 123!';

	private static String	falseNegative		= ' produced a false negative\n';
	private static String	falsePositive		= ' produced a false positive\n';

	private static sObject	testObjectValid;
	private static sObject	testObjectInvalid;
	private static sObject	testObjectNull;

	private static void initializeCWFormatValidationTest()
	{
		insert new CWFormatValidation__c
		(	Name					= 'Test Format Validation',
			Object_Name__c			= testSObjectName,
			Field_Name__c			= testFieldName,
			Regular_Expression__c	= testExpression,
			Error_Message__c		= 'This field is not formatted correctly.'
		);

		testObjectValid		= (sObject) Type.forName( testSObjectName ).newInstance();
		testObjectValid.put( testFieldName, validString );
		testObjectInvalid	= (sObject) Type.forName( testSObjectName ).newInstance();
		testObjectInvalid.put( testFieldName, invalidString );
		testObjectNull		= (sObject) Type.forName( testSObjectName ).newInstance();
		testObjectNull.put( testFieldName, null );
		insert new List<sObject>{ testObjectValid, testObjectInvalid, testObjectNull };
	}

	static testMethod void testIsValidMethods()
	{
		CWTest	testResults		= new CWTest( 'testIsValidMethods' );
		String	testingMethod	= 'CWFormatValidation.isValid';

		initializeCWFormatValidationTest();

		testResults.startTest();

		testResults.assert
		(	testingMethod + ' - sObjectName (Positive)',
			CWFormatValidation.isValid( testSObjectName, testFieldName, validString ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - sObjectName (Negative)',
			!CWFormatValidation.isValid( testSObjectName, testFieldName, invalidString ),
			testingMethod + falsePositive
		);

		testResults.assert
		(	testingMethod + ' - sObjectType',
			CWFormatValidation.isValid( CWSchema.getSObjectType( testSObjectName ), testFieldName, validString ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - DescribeSObjectResult',
			CWFormatValidation.isValid( CWSchema.getDescribeSObjectResult( testSObjectName ), testFieldName, validString ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - Object Instance',
			CWFormatValidation.isValid( testObjectValid, testFieldName, validString ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - Object Id',
			CWFormatValidation.isValid( testObjectValid.Id, testFieldName, validString ),
			testingMethod + falseNegative
		);

		testResults.assert
		(	testingMethod + ' - Record (Positive)',
			CWFormatValidation.isValid( testObjectValid, testFieldName ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - Record (Negative)',
			!CWFormatValidation.isValid( testObjectInvalid, testFieldName ),
			testingMethod + falsePositive
		);

		testResults.assert
		(	testingMethod + ' - No Format',
			CWFormatValidation.isValid( 'Account', 'Name', invalidString ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - Bad Field',
			!CWFormatValidation.isValid( testSObjectName, 'NotAField', invalidString ),
			testingMethod + falsePositive
		);
		testResults.assert
		(	testingMethod + ' - Nillable Field',
			CWFormatValidation.isValid( testSObjectName, testFieldName, null ),
			testingMethod + falseNegative
		);
		testResults.assert
		(	testingMethod + ' - Non-Nillable Field',
			!CWFormatValidation.isValid( testSObjectName, 'Id', null ),
			testingMethod + falsePositive
		);

		testResults.stopTest();
		testResults.report();
	}
	
	static testMethod void testValidateMethod()
	{
		CWTest	testResults		= new CWTest( 'testValidateMethod' );
		String	testingMethod	= 'CWFormatValidation.validate';

		initializeCWFormatValidationTest();

		List<sObject>	testObjects		= (List<sObject>) Type.forName( 'List<' + testSObjectName + '>' ).newInstance();
		testObjects.add( testObjectValid );
		testObjects.add( testObjectInvalid );

		CWTrigger	insertTrigger	= new CWTrigger( 'before insert', testObjects  );

		sObject		validClone		= testObjectValid.clone( true, true, true, true );
		validClone.put( testFieldName, null );

		List<sObject>	newObjects		= (List<sObject>) Type.forName( 'List<' + testSObjectName + '>' ).newInstance();
		newObjects.add( validClone );
		List<sObject>	oldObjects		= (List<sObject>) Type.forName( 'List<' + testSObjectName + '>' ).newInstance();
		oldObjects.add( testObjectValid );

		CWTrigger	updateTrigger	= new CWTrigger( 'before update', newObjects, oldObjects );

		testResults.startTest();

		CWFormatValidation.validate( insertTrigger );
		CWFormatValidation.validate( updateTrigger );

		testResults.stopTest();
		testResults.report();
	}
}