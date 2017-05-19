/*******************************************************//**

@class		CWTypeTest

@brief		Test Methods for CWType Class

	The CWTypeTest class contains the test methods for the
	CWType class.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-09-03	LiquidHub.GHA
	Created.

@see		CWType

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public class CWTypeTest
{
	/*******************************************************
				type checking methods
	*******************************************************/

	public static testMethod void testCWTypeTypeCheckingMethods()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeTypeCheckingMethods' );
		String	testingMethod;

		CWTestObject__c		testSObject	= new CWTestObject__c();
		insert	testSObject;

		Blob		testBlob		= Blob.valueOf( 'Blob' );
		Boolean		testBoolean		= true;
		Date		testDate		= Date.newInstance( 2014, 9, 3 );
		DateTime	testDateTime	= DateTime.newInstance( 2014, 9, 3, 21, 59, 0 );
		Decimal		testDecimal		= 3.141592654;
		Double		testDouble		= 2.718281828;
		Id			testId			= testSObject.Id;
		Integer		testInteger		= 42;
		Long		testLong		= 2147483648L;
		String		testString		= 'String';
		Time		testTime		= Time.newInstance( 22, 12, 0, 0 );

		testResult.startTest();

		testingMethod = 'CWType.isBlob';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.isBlob( testBlob )
		&&	!CWType.isBlob( testBoolean )
		&&	!CWType.isBlob( testDate )
		&&	!CWType.isBlob( testDateTime )
		&&	!CWType.isBlob( testDecimal )
		&&	!CWType.isBlob( testDouble )
		&&	!CWType.isBlob( testId )
		&&	!CWType.isBlob( testInteger )
		&&	!CWType.isBlob( testLong )
		&&	!CWType.isBlob( testSObject )
		&&	!CWType.isBlob( testString )
		&&	!CWType.isBlob( testTime )
		&&	!CWType.isBlob( (Blob) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isBoolean';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isBoolean( testBlob )
		&&	CWType.isBoolean( testBoolean )
		&&	!CWType.isBoolean( testDate )
		&&	!CWType.isBoolean( testDateTime )
		&&	!CWType.isBoolean( testDecimal )
		&&	!CWType.isBoolean( testDouble )
		&&	!CWType.isBoolean( testId )
		&&	!CWType.isBoolean( testInteger )
		&&	!CWType.isBoolean( testLong )
		&&	!CWType.isBoolean( testSObject )
		&&	!CWType.isBoolean( testString )
		&&	!CWType.isBoolean( testTime )
		&&	!CWType.isBoolean( (Boolean) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isDate';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isDate( testBlob )
		&&	!CWType.isDate( testBoolean )
		&&	CWType.isDate( testDate )
		&&	!CWType.isDate( testDateTime )
		&&	!CWType.isDate( testDecimal )
		&&	!CWType.isDate( testDouble )
		&&	!CWType.isDate( testId )
		&&	!CWType.isDate( testInteger )
		&&	!CWType.isDate( testLong )
		&&	!CWType.isDate( testSObject )
		&&	!CWType.isDate( testString )
		&&	!CWType.isDate( testTime )
		&&	!CWType.isDate( (Date) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isDateTime';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isDateTime( testBlob )
		&&	!CWType.isDateTime( testBoolean )
		&&	CWType.isDateTime( testDate )
		&&	CWType.isDateTime( testDateTime )
		&&	!CWType.isDateTime( testDecimal )
		&&	!CWType.isDateTime( testDouble )
		&&	!CWType.isDateTime( testId )
		&&	!CWType.isDateTime( testInteger )
		&&	!CWType.isDateTime( testLong )
		&&	!CWType.isDateTime( testSObject )
		&&	!CWType.isDateTime( testString )
		&&	!CWType.isDateTime( testTime )
		&&	!CWType.isDateTime( (DateTime) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isDecimal';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isDecimal( testBlob )
		&&	!CWType.isDecimal( testBoolean )
		&&	!CWType.isDecimal( testDate )
		&&	!CWType.isDecimal( testDateTime )
		&&	CWType.isDecimal( testDecimal )
		&&	CWType.isDecimal( testDouble )
		&&	!CWType.isDecimal( testId )
		&&	CWType.isDecimal( testInteger )
		&&	CWType.isDecimal( testLong )
		&&	!CWType.isDecimal( testSObject )
		&&	!CWType.isDecimal( testString )
		&&	!CWType.isDecimal( testTime )
		&&	!CWType.isDecimal( (Decimal) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isDouble';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isDouble( testBlob )
		&&	!CWType.isDouble( testBoolean )
		&&	!CWType.isDouble( testDate )
		&&	!CWType.isDouble( testDateTime )
		&&	CWType.isDouble( testDecimal )
		&&	CWType.isDouble( testDouble )
		&&	!CWType.isDouble( testId )
		&&	CWType.isDouble( testInteger )
		&&	CWType.isDouble( testLong )
		&&	!CWType.isDouble( testSObject )
		&&	!CWType.isDouble( testString )
		&&	!CWType.isDouble( testTime )
		&&	!CWType.isDouble( (Double) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isId';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isId( testBlob )
		&&	!CWType.isId( testBoolean )
		&&	!CWType.isId( testDate )
		&&	!CWType.isId( testDateTime )
		&&	!CWType.isId( testDecimal )
		&&	!CWType.isId( testDouble )
		&&	CWType.isId( testId )
		&&	!CWType.isId( testInteger )
		&&	!CWType.isId( testLong )
		&&	!CWType.isId( testSObject )
		&&	!CWType.isId( testString )
		&&	!CWType.isId( testTime )
		&&	!CWType.isId( (Id) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isInteger';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isInteger( testBlob )
		&&	!CWType.isInteger( testBoolean )
		&&	!CWType.isInteger( testDate )
		&&	!CWType.isInteger( testDateTime )
		&&	!CWType.isInteger( testDecimal )
		&&	!CWType.isInteger( testDouble )
		&&	!CWType.isInteger( testId )
		&&	CWType.isInteger( testInteger )
		&&	!CWType.isInteger( testLong )
		&&	!CWType.isInteger( testSObject )
		&&	!CWType.isInteger( testString )
		&&	!CWType.isInteger( testTime )
		&&	!CWType.isInteger( (Integer) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isLong';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isLong( testBlob )
		&&	!CWType.isLong( testBoolean )
		&&	!CWType.isLong( testDate )
		&&	!CWType.isLong( testDateTime )
		&&	!CWType.isLong( testDecimal )
		&&	!CWType.isLong( testDouble )
		&&	!CWType.isLong( testId )
		&&	CWType.isLong( testInteger )
		&&	CWType.isLong( testLong )
		&&	!CWType.isLong( testSObject )
		&&	!CWType.isLong( testString )
		&&	!CWType.isLong( testTime )
		&&	!CWType.isLong( (Long) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isObject';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.isObject( testBlob )
		&&	CWType.isObject( testBoolean )
		&&	CWType.isObject( testDate )
		&&	CWType.isObject( testDateTime )
		&&	CWType.isObject( testDecimal )
		&&	CWType.isObject( testDouble )
		&&	CWType.isObject( testId )
		&&	CWType.isObject( testInteger )
		&&	CWType.isObject( testLong )
		&&	CWType.isObject( testSObject )
		&&	CWType.isObject( testString )
		&&	CWType.isObject( testTime )
		&&	!CWType.isObject( (Object) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isSObject';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isSObject( testBlob )
		&&	!CWType.isSObject( testBoolean )
		&&	!CWType.isSObject( testDate )
		&&	!CWType.isSObject( testDateTime )
		&&	!CWType.isSObject( testDecimal )
		&&	!CWType.isSObject( testDouble )
		&&	!CWType.isSObject( testId )
		&&	!CWType.isSObject( testInteger )
		&&	!CWType.isSObject( testLong )
		&&	CWType.isSObject( testSObject )
		&&	!CWType.isSObject( testString )
		&&	!CWType.isSObject( testTime )
		&&	!CWType.isSObject( (sObject) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isString';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isString( testBlob )
		&&	!CWType.isString( testBoolean )
		&&	!CWType.isString( testDate )
		&&	!CWType.isString( testDateTime )
		&&	!CWType.isString( testDecimal )
		&&	!CWType.isString( testDouble )
		&&	CWType.isString( testId )
		&&	!CWType.isString( testInteger )
		&&	!CWType.isString( testLong )
		&&	!CWType.isString( testSObject )
		&&	CWType.isString( testString )
		&&	!CWType.isString( testTime )
		&&	!CWType.isString( (String) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isTime';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isTime( testBlob )
		&&	!CWType.isTime( testBoolean )
		&&	!CWType.isTime( testDate )
		&&	!CWType.isTime( testDateTime )
		&&	!CWType.isTime( testDecimal )
		&&	!CWType.isTime( testDouble )
		&&	!CWType.isTime( testId )
		&&	!CWType.isTime( testInteger )
		&&	!CWType.isTime( testLong )
		&&	!CWType.isTime( testSObject )
		&&	!CWType.isTime( testString )
		&&	CWType.isTime( testTime )
		&&	!CWType.isTime( (Time) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				type checking predicates
	*******************************************************/

	public static testMethod void testCWTypeTypeCheckingPredicates()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeTypeCheckingPredicates' );
		String	testingMethod;
		CWPredicate testPredicate;

		CWTestObject__c		testSObject	= new CWTestObject__c();
		insert	testSObject;

		Blob		testBlob		= Blob.valueOf( 'Blob' );
		Boolean		testBoolean		= true;
		Date		testDate		= Date.newInstance( 2014, 9, 3 );
		DateTime	testDateTime	= DateTime.newInstance( 2014, 9, 3, 21, 59, 0 );
		Decimal		testDecimal		= 3.141592654;
		Double		testDouble		= 2.718281828;
		Id			testId			= testSObject.Id;
		Integer		testInteger		= 42;
		Long		testLong		= 2147483648L;
		String		testString		= 'String';
		Time		testTime		= Time.newInstance( 22, 12, 0, 0 );

		testResult.startTest();

		testingMethod = 'CWType.IsBlob';
		testPredicate = new CWType.IsBlob();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Blob) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsBoolean';
		testPredicate = new CWType.IsBoolean();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Boolean) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsDate';
		testPredicate = new CWType.IsDate();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Date) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsDateTime';
		testPredicate = new CWType.IsDateTime();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	testPredicate.test( testDate )
		&&	testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (DateTime) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsDecimal';
		testPredicate = new CWType.IsDecimal();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	testPredicate.test( testDecimal )
		&&	testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	testPredicate.test( testInteger )
		&&	testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Decimal) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsDouble';
		testPredicate = new CWType.IsDouble();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	testPredicate.test( testDecimal )
		&&	testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	testPredicate.test( testInteger )
		&&	testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Double) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsId';
		testPredicate = new CWType.IsId();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Id) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsInteger';
		testPredicate = new CWType.IsInteger();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Integer) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsLong';
		testPredicate = new CWType.IsLong();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	testPredicate.test( testInteger )
		&&	testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (Long) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsObject';
		testPredicate = new CWType.IsObject();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			testPredicate.test( testBlob )
		&&	testPredicate.test( testBoolean )
		&&	testPredicate.test( testDate )
		&&	testPredicate.test( testDateTime )
		&&	testPredicate.test( testDecimal )
		&&	testPredicate.test( testDouble )
		&&	testPredicate.test( testId )
		&&	testPredicate.test( testInteger )
		&&	testPredicate.test( testLong )
		&&	testPredicate.test( testSObject )
		&&	testPredicate.test( testString )
		&&	testPredicate.test( testTime )
		&&	!testPredicate.test( (Object) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsSObject';
		testPredicate = new CWType.IsSObject();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (sObject) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsString';
		testPredicate = new CWType.IsString();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	testPredicate.test( testString )
		&&	!testPredicate.test( testTime )
		&&	!testPredicate.test( (String) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.IsTime';
		testPredicate = new CWType.IsTime();
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!testPredicate.test( testBlob )
		&&	!testPredicate.test( testBoolean )
		&&	!testPredicate.test( testDate )
		&&	!testPredicate.test( testDateTime )
		&&	!testPredicate.test( testDecimal )
		&&	!testPredicate.test( testDouble )
		&&	!testPredicate.test( testId )
		&&	!testPredicate.test( testInteger )
		&&	!testPredicate.test( testLong )
		&&	!testPredicate.test( testSObject )
		&&	!testPredicate.test( testString )
		&&	testPredicate.test( testTime )
		&&	!testPredicate.test( (Time) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				type classification methods
	*******************************************************/

	public static testMethod void testCWTypeTypeClassificationMethods()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeTypeClassificationMethods' );
		String	testingMethod;

		testResult.startTest();

		testingMethod = 'CWType.isPrimitive';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.isPrimitive( Blob.class )
		&&	CWType.isPrimitive( Boolean.class )
		&&	CWType.isPrimitive( Date.class )
		&&	CWType.isPrimitive( DateTime.class )
		&&	CWType.isPrimitive( Decimal.class )
		&&	CWType.isPrimitive( Double.class )
		&&	CWType.isPrimitive( Id.class )
		&&	CWType.isPrimitive( Integer.class )
		&&	CWType.isPrimitive( Long.class )
		&&	!CWType.isPrimitive( sObject.class )
		&&	CWType.isPrimitive( String.class )
		&&	CWType.isPrimitive( Time.class )
		&&	!CWType.isPrimitive( (Type) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isConstructable';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isConstructable( Blob.class )
		&&	!CWType.isConstructable( Boolean.class )
		&&	!CWType.isConstructable( Date.class )
		&&	!CWType.isConstructable( DateTime.class )
		&&	!CWType.isConstructable( Decimal.class )
		&&	!CWType.isConstructable( Double.class )
		&&	!CWType.isConstructable( Id.class )
		&&	!CWType.isConstructable( Integer.class )
		&&	!CWType.isConstructable( Long.class )
		&&	CWType.isConstructable( sObject.class )
		&&	!CWType.isConstructable( String.class )
		&&	!CWType.isConstructable( Time.class )
		&&	!CWType.isConstructable( (Type) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isNumeric';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isNumeric( Blob.class )
		&&	!CWType.isNumeric( Boolean.class )
		&&	!CWType.isNumeric( Date.class )
		&&	!CWType.isNumeric( DateTime.class )
		&&	CWType.isNumeric( Decimal.class )
		&&	CWType.isNumeric( Double.class )
		&&	!CWType.isNumeric( Id.class )
		&&	CWType.isNumeric( Integer.class )
		&&	CWType.isNumeric( Long.class )
		&&	!CWType.isNumeric( sObject.class )
		&&	!CWType.isNumeric( String.class )
		&&	!CWType.isNumeric( Time.class )
		&&	!CWType.isNumeric( (Type) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isOrdered';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			!CWType.isOrdered( Blob.class )
		&&	!CWType.isOrdered( Boolean.class )
		&&	CWType.isOrdered( Date.class )
		&&	CWType.isOrdered( DateTime.class )
		&&	CWType.isOrdered( Decimal.class )
		&&	CWType.isOrdered( Double.class )
		&&	!CWType.isOrdered( Id.class )
		&&	CWType.isOrdered( Integer.class )
		&&	CWType.isOrdered( Long.class )
		&&	!CWType.isOrdered( sObject.class )
		&&	!CWType.isOrdered( String.class )
		&&	CWType.isOrdered( Time.class )
		&&	!CWType.isOrdered( (Type) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				getPrimitiveType method
	*******************************************************/

	public static testMethod void testCWTypeGetPrimitiveTypeMethod()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeGetPrimitiveTypeMethod' );
		String	testingMethod;

		CWTestObject__c		testSObject	= new CWTestObject__c();
		insert	testSObject;

		Blob		testBlob		= Blob.valueOf( 'Blob' );
		Boolean		testBoolean		= true;
		Date		testDate		= Date.newInstance( 2014, 9, 3 );
		DateTime	testDateTime	= DateTime.newInstance( 2014, 9, 3, 21, 59, 0 );
		Decimal		testDecimal		= 3.141592654;
		Double		testDouble		= 2.718281828;
		Id			testId			= testSObject.Id;
		Integer		testInteger		= 42;
		Long		testLong		= 2147483648L;
		String		testString		= 'String';
		Time		testTime		= Time.newInstance( 22, 12, 0, 0 );

		testResult.startTest();

		testingMethod = 'CWType.getPrimitiveType';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getPrimitiveType( testBlob )		== Blob		.class
		&&	CWType.getPrimitiveType( testBoolean )	== Boolean	.class
		&&	CWType.getPrimitiveType( testDate )		== Date		.class
		&&	CWType.getPrimitiveType( testDateTime )	== DateTime	.class
		&&	CWType.getPrimitiveType( testDecimal )	== Double	.class	//	Decimal returns as Double
		&&	CWType.getPrimitiveType( testDouble )	== Double	.class
		&&	CWType.getPrimitiveType( testId )		== Id		.class
		&&	CWType.getPrimitiveType( testInteger )	== Integer	.class
		&&	CWType.getPrimitiveType( testLong )		== Long		.class
		&&	CWType.getPrimitiveType( testSObject )	== sObject	.class
		&&	CWType.getPrimitiveType( testString )	== String	.class
		&&	CWType.getPrimitiveType( testTime )		== Time		.class
		&&	CWType.getPrimitiveType( new CWType() )	== Object	.class
		&&	CWType.getPrimitiveType( (Object) null ) == null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.isPrimitive';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.isPrimitive( testBlob )
		&&	CWType.isPrimitive( testBoolean )
		&&	CWType.isPrimitive( testDate )
		&&	CWType.isPrimitive( testDateTime )
		&&	CWType.isPrimitive( testDecimal )
		&&	CWType.isPrimitive( testDouble )
		&&	CWType.isPrimitive( testId )
		&&	CWType.isPrimitive( testInteger )
		&&	CWType.isPrimitive( testLong )
		&&	!CWType.isPrimitive( testSObject )
		&&	CWType.isPrimitive( testString )
		&&	CWType.isPrimitive( testTime )
		&&	!CWType.isPrimitive( new CWType() )
		&&	!CWType.isPrimitive( (Object) null )
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				type translation methods
	*******************************************************/

	public static testMethod void testCWTypeTypeTranslationMethods()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeTypeTranslationMethods' );
		String	testingMethod;

		testResult.startTest();

		testingMethod = 'CWType.getDisplayTypes( Schema.SOAPType )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getDisplayTypes( Schema.SOAPType.AnyType )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Base64Binary )	!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Boolean )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Date )			!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.DateTime )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Double )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Id )			!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Integer )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.String )		!= null
		&&	CWType.getDisplayTypes( Schema.SOAPType.Time )			!= null
		&&	CWType.getDisplayTypes( (Schema.SOAPType) null )		== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.getDisplayTypes( Type )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getDisplayTypes( Blob	.class )	!= null
		&&	CWType.getDisplayTypes( Boolean	.class )	!= null
		&&	CWType.getDisplayTypes( Date	.class )	!= null
		&&	CWType.getDisplayTypes( DateTime.class )	!= null
		&&	CWType.getDisplayTypes( Decimal	.class )	!= null
		&&	CWType.getDisplayTypes( Double	.class )	!= null
		&&	CWType.getDisplayTypes( Id		.class )	!= null
		&&	CWType.getDisplayTypes( Integer	.class )	!= null
		&&	CWType.getDisplayTypes( Long	.class )	!= null
		&&	CWType.getDisplayTypes( Object	.class )	!= null
		&&	CWType.getDisplayTypes( String	.class )	!= null
		&&	CWType.getDisplayTypes( Time	.class )	!= null
		&&	CWType.getDisplayTypes( CWTestObject__c.class )	== null
		&&	CWType.getDisplayTypes( (Type) null )		== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.getSOAPType( Schema.DisplayType )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getSOAPType( Schema.DisplayType.AnyType )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Base64 )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Boolean )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.ComboBox )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Currency )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Date )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.DateTime )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Double )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Email )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.EncryptedString )	!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Id )					!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Location )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.MultiPicklist )		!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Percent )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Phone )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Picklist )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Reference )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.String )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.TextArea )			!= null
		&&	CWType.getSOAPType( Schema.DisplayType.Time )				!= null
		&&	CWType.getSOAPType( Schema.DisplayType.URL )				!= null
		&&	CWType.getSOAPType( (Schema.DisplayType) null )				== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.getSOAPTypes( Type )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getSOAPTypes( Blob	.class )	!= null
		&&	CWType.getSOAPTypes( Boolean.class )	!= null
		&&	CWType.getSOAPTypes( Date	.class )	!= null
		&&	CWType.getSOAPTypes( DateTime.class )	!= null
		&&	CWType.getSOAPTypes( Decimal.class )	!= null
		&&	CWType.getSOAPTypes( Double	.class )	!= null
		&&	CWType.getSOAPTypes( Id		.class )	!= null
		&&	CWType.getSOAPTypes( Integer.class )	!= null
		&&	CWType.getSOAPTypes( Long	.class )	!= null
		&&	CWType.getSOAPTypes( Object	.class )	!= null
		&&	CWType.getSOAPTypes( String	.class )	!= null
		&&	CWType.getSOAPTypes( Time	.class )	!= null
		&&	CWType.getSOAPTypes( CWTestObject__c.class )	== null
		&&	CWType.getSOAPTypes( (Type) null )		== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.getType( Schema.DisplayType )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getType( Schema.DisplayType.AnyType )			== Object	.class
		&&	CWType.getType( Schema.DisplayType.Base64 )				== Blob		.class
		&&	CWType.getType( Schema.DisplayType.Boolean )			== Boolean	.class
		&&	CWType.getType( Schema.DisplayType.ComboBox )			== String	.class
		&&	CWType.getType( Schema.DisplayType.Currency )			== Double	.class
		&&	CWType.getType( Schema.DisplayType.Date )				== Date		.class
		&&	CWType.getType( Schema.DisplayType.DateTime )			== DateTime	.class
		&&	CWType.getType( Schema.DisplayType.Double )				== Double	.class
		&&	CWType.getType( Schema.DisplayType.Email )				== String	.class
		&&	CWType.getType( Schema.DisplayType.EncryptedString )	== String	.class
		&&	CWType.getType( Schema.DisplayType.Id )					== Id		.class
		&&	CWType.getType( Schema.DisplayType.Location )			== Object	.class
		&&	CWType.getType( Schema.DisplayType.MultiPicklist )		== String	.class
		&&	CWType.getType( Schema.DisplayType.Percent )			== Double	.class
		&&	CWType.getType( Schema.DisplayType.Phone )				== String	.class
		&&	CWType.getType( Schema.DisplayType.Picklist )			== String	.class
		&&	CWType.getType( Schema.DisplayType.Reference )			== Id		.class
		&&	CWType.getType( Schema.DisplayType.String )				== String	.class
		&&	CWType.getType( Schema.DisplayType.TextArea )			== String	.class
		&&	CWType.getType( Schema.DisplayType.Time )				== Time		.class
		&&	CWType.getType( Schema.DisplayType.URL )				== String	.class
		&&	CWType.getType( (Schema.DisplayType) null )				== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.getType( Schema.SOAPType )';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.getType( Schema.SOAPType.AnyType )		== Object	.class
		&&	CWType.getType( Schema.SOAPType.Base64Binary )	== Blob		.class
		&&	CWType.getType( Schema.SOAPType.Boolean )		== Boolean	.class
		&&	CWType.getType( Schema.SOAPType.Date )			== Date		.class
		&&	CWType.getType( Schema.SOAPType.DateTime )		== DateTime	.class
		&&	CWType.getType( Schema.SOAPType.Double )		== Double	.class
		&&	CWType.getType( Schema.SOAPType.Id )			== Id		.class
		&&	CWType.getType( Schema.SOAPType.Integer )		== Integer	.class
		&&	CWType.getType( Schema.SOAPType.String )		== String	.class
		&&	CWType.getType( Schema.SOAPType.Time )			== Time		.class
		&&	CWType.getType( (Schema.SOAPType) null )		== null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				numeric conversion methods
	*******************************************************/

	public static testMethod void testCWTypeNumericConversionMethods()
	{
		CWTest	testResult		= new CWTest( 'testCWTypeNumericConversionMethods' );
		String	testingMethod;

		Decimal		testDecimal		= 3.141592654;
		Double		testDouble		= 2.718281828;
		Long		testLong		= 999L;
		Integer		testInteger		= 42;

		Decimal		testBigDecimal	= 9223372036854776833.0;		//	too big for Long or Integer
		Double		testBigDouble	= 9223372036854776833.0;		//	too big for Long or Integer
		Long		testBigLong		= 2147483648L;					//	too big for Integer

		testResult.startTest();

		testingMethod = 'CWType.toDecimal';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.toDecimal( testDecimal )		== testDecimal
		&&	CWType.toDecimal( testDouble )		== testDouble
		&&	CWType.toDecimal( testLong )		== testLong
		&&	CWType.toDecimal( testInteger )		== testInteger
		&&	CWType.toDecimal( new List<Decimal>{ testDecimal } )	!= null
		&&	CWType.toDecimal( new List<Double>{ testDouble } )		!= null
		&&	CWType.toDecimal( new List<Long>{ testLong } )			!= null
		&&	CWType.toDecimal( new List<Integer>{ testInteger } )	!= null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.toDouble';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.toDouble( testDecimal )		== testDecimal
		&&	CWType.toDouble( testDouble )		== testDouble
		&&	CWType.toDouble( testLong )			== testLong
		&&	CWType.toDouble( testInteger )		== testInteger
		&&	CWType.toDouble( new List<Decimal>{ testDecimal } )		!= null
		&&	CWType.toDouble( new List<Double>{ testDouble } )		!= null
		&&	CWType.toDouble( new List<Long>{ testLong } )			!= null
		&&	CWType.toDouble( new List<Integer>{ testInteger } )		!= null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.toLong';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.toLong( testDecimal )		== 3
		&&	CWType.toLong( testDouble )			== 2
		&&	CWType.toLong( testLong )			== testLong
		&&	CWType.toLong( testInteger )		== testInteger
		&&	CWType.toLong( new List<Decimal>{ testDecimal } )		!= null
		&&	CWType.toLong( new List<Double>{ testDouble } )			!= null
		&&	CWType.toLong( new List<Long>{ testLong } )				!= null
		&&	CWType.toLong( new List<Integer>{ testInteger } )		!= null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);
		testResult.clearErrors();
		testResult.assert
		(	testingMethod + ' Big Decimal',
			CWType.toLong( testBigDecimal )	== null
		&&	testResult.lastErrorStartsWith( testingMethod ),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);
		testResult.clearErrors();
		testResult.assert
		(	testingMethod + ' Big Double',
			CWType.toLong( testBigDouble )	== null
		&&	testResult.lastErrorStartsWith( testingMethod ),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testingMethod = 'CWType.toInteger';
		testResult.clearErrors();
		testResult.assert
		(	testingMethod,
			CWType.toInteger( testDecimal )		== 3
		&&	CWType.toInteger( testDouble )		== 2
		&&	CWType.toInteger( testLong )		== testLong
		&&	CWType.toInteger( testInteger )		== testInteger
		&&	CWType.toInteger( new List<Decimal>{ testDecimal } )	!= null
		&&	CWType.toInteger( new List<Double>{ testDouble } )		!= null
		&&	CWType.toInteger( new List<Long>{ testLong } )			!= null
		&&	CWType.toInteger( new List<Integer>{ testInteger } )	!= null
		&&	!testResult.checkErrors(),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);
		testResult.clearErrors();
		testResult.assert
		(	testingMethod + ' Big Decimal',
			CWType.toInteger( testBigDecimal )	== null
		&&	testResult.lastErrorStartsWith( testingMethod ),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);
		testResult.clearErrors();
		testResult.assert
		(	testingMethod + ' Big Double',
			CWType.toInteger( testBigDouble )	== null
		&&	testResult.lastErrorStartsWith( testingMethod ),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);
		testResult.clearErrors();
		testResult.assert
		(	testingMethod + ' Big Long',
			CWType.toInteger( testBigLong )		== null
		&&	testResult.lastErrorStartsWith( testingMethod ),
			testingMethod + ' failed.\n' + testResult.getErrorString()
		);

		testResult.stopTest();
		testResult.report();
	}
}