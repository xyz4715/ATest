/*******************************************************//**

@class		CWStringTest

@brief		CW Core String Test Class

	Description goes here.

@author		Janeen Anderson (LiquidHub.JDA)
@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-08-29	LiquidHub.JDA
	Created.
@version	2015-10-16	LiquidHub.GHA
	Added a few more calls into CWString to get increase
	coverage from 98% to 99% (only one line not covered)

@see		CWString

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWStringTest
{
	private static list<String> fieldNameList = new list<String>
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
	static Set<String>	myNameSet		= new Set<String>( fieldNameList );
	static CWIterable	myIterStrings	= new CWIterable( (List<Object>) fieldNameList );

	static testMethod void testCaseStringMethods()
	{
		CWTest		myCWTest		= new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		myCWTest.assert( 'Test CWString ToTitleCase', 'NumberOfDigits', CWString.ToTitleCase('numberOfDigits') );
		CWString.ToTitleCase( CWString.ToTitleCase( fieldNameList ) );
		CWString.toList( CWString.ToTitleCase( fieldNameList ) );
		CWString.ToTitleCase( myNameSet );

		myCWTest.assert( 'Test CWString uncapitalize', 'numberofdigits', CWString.uncapitalize('NumberOfDigits') );
		CWString.uncapitalize( CWString.uncapitalize( fieldNameList ) );
		CWString.toList( CWString.uncapitalize( fieldNameList ) );
		CWString.uncapitalize( myNameSet );

		CWString.swapCase( fieldNameList[0] );
		CWString.swapCase( CWString.swapCase( fieldNameList ) );
		CWString.toList( CWString.swapCase( fieldNameList ) );
		CWString.swapCase( myNameSet );

		CWString.ToUpperCase( fieldNameList[0] );
		CWString.ToUpperCase( CWString.ToUpperCase( fieldNameList ) );
		CWString.toList( CWString.ToUpperCase( fieldNameList ) );
		CWString.ToUpperCase( myNameSet );

		CWString.toLowerCase( fieldNameList[0] );
		CWString.toLowerCase( CWString.toLowerCase( fieldNameList ) );
		CWString.toList( CWString.toLowerCase( fieldNameList ) );
		CWString.toLowerCase( myNameSet );

		CWString.capitalize( fieldNameList[0] );
		CWString.capitalize( CWString.capitalize( fieldNameList ) );
		CWString.toList( CWString.capitalize( fieldNameList ) );
		CWString.capitalize( myNameSet );

		myCWTest.stopTest();
		myCWTest.report();
	}

	static testMethod void testExtractStringMethods()
	{
		CWTest		myCWTest		= new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		CWString.substringBetween( fieldNameList[0], '_', '__c' );
		CWString.substringBetween( fieldNameList[0], '_' );
		CWString.substringBetween( CWString.substringBetween( fieldNameList, '_', '__c'  ), '_', '__c'  );
		CWString.substringBetween( CWString.substringBetween( fieldNameList, '_' ), '_' );
		CWString.toList( CWString.substringBetween( fieldNameList, '_' ) );
		CWString.substringBetween( fieldNameList, '_' );
		CWString.substringBetween( myNameSet, '_', '__c'  );
		CWString.substringBetween( myNameSet, '_' );

		CWString.substringBeforeLast( fieldNameList[0], '_' );
		CWString.substringBeforeLast( CWString.substringBeforeLast( fieldNameList, '_' ), '_' );
		CWString.toList( CWString.substringBeforeLast( fieldNameList, '_' ) );
		CWString.substringBeforeLast( myNameSet, '_' );

		CWString.substringBefore( fieldNameList[0], '_' );
		CWString.substringBefore( CWString.substringBefore( fieldNameList, '_' ), '_' );
		CWString.toList( CWString.substringBefore( fieldNameList, '_' ) );
		CWString.substringBefore( myNameSet, '_' );

		CWString.substringAfterLast( fieldNameList[0], '_' );
		CWString.substringAfterLast( CWString.substringAfterLast( fieldNameList, '_' ), '_' );
		CWString.toList( CWString.substringAfterLast( fieldNameList, '_' ) );
		CWString.substringAfterLast( myNameSet, '_' );

		CWString.substringAfter( fieldNameList[0], '_' );
		CWString.substringAfter( CWString.substringAfter( fieldNameList, '_' ), '_' );
		CWString.toList( CWString.substringAfter( fieldNameList, '_' ) );
		CWString.substringAfter( myNameSet, '_' );

		CWString.substring( fieldNameList[0], 1, 3 );
		CWString.substring( fieldNameList[0], 3 );
		CWString.substring( CWString.substring( fieldNameList, 1, 10  ), 1, 3  );
		CWString.substring( CWString.substring( fieldNameList, 1 ), 3 );
		CWString.toList( CWString.substring( fieldNameList, 1 ) );
		CWString.substring( fieldNameList, 3 );
		CWString.substring( myNameSet, 1, 3 );
		CWString.substring( myNameSet, 1 );

		CWString.right( fieldNameList[0], 3 );
		CWString.right( CWString.right( fieldNameList, 10 ), 3 );
		CWString.toList( CWString.right( fieldNameList, 10 ) );
		CWString.right( myNameSet, 3 );

		CWString.left( fieldNameList[0], 3 );
		CWString.left( CWString.left( fieldNameList, 3 ), 10 );
		CWString.toList( CWString.left( fieldNameList, 3 ) );
		CWString.left( myNameSet, 3 );

		CWString.mid( fieldNameList[0], 3, 3 );
		CWString.mid( CWString.mid( fieldNameList, 3, 3 ), 1, 1 );
		CWString.toList( CWString.mid( fieldNameList, 3, 3 ) );
		CWString.mid( myNameSet, 3, 3 );

		myCWTest.report();
		myCWTest.stopTest();
	}

	static testMethod void testModStringMethods()
	{
		CWTest myCWTest = new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		myCWTest.assert( 'Test CWString Reverse', (Object)CWString.reverse(fieldNameList[0]), 'c__0_8_rebmuN' );
		CWString.reverse( myIterStrings );
		CWString.reverse( fieldNameList );
		CWString.toList(CWString.reverse( fieldNameList ));
		CWString.reverse( CWString.reverse( fieldNameList ) );
		CWString.reverse( myNameSet );

		myCWTest.assert( 'Test CWString Replace First', CWString.replaceFirst('Number_8_0ABC', 'ABC', '__c'), fieldNameList[0] );
		CWString.replaceFirst( CWString.replaceFirst( fieldNameList, 'ABC', '__c' ), 'ABC', '__c' );
		CWString.toList( CWString.replaceFirst( fieldNameList, 'ABC', '__c' ) );
		CWString.replaceFirst( myNameSet, 'ABC', '__c' );

		Map<String,String> myReplacements = new Map<String,String>{ 'Color' => 'Number', 'ABC' => '__c' };
		myCWTest.assert( 'Test CWString replaceMap', CWString.replaceMap('Color_8_0ABC', myReplacements), fieldNameList[0] );
		CWString.replaceMap( CWString.replaceMap( fieldNameList, myReplacements ), myReplacements );
		CWString.toList( CWString.replaceMap( fieldNameList, myReplacements ) );
		CWString.replaceMap( myNameSet, myReplacements );

		myCWTest.assert( 'Test CWString Replace First', CWString.replaceAll('Number_8_0ABC', 'ABC', '__c'), fieldNameList[0] );
		CWString.replaceAll( CWString.replaceAll( fieldNameList, 'ABC', '__c' ), 'ABC', '__c' );
		CWString.toList( CWString.replaceAll( fieldNameList, 'ABC', '__c' ) );
		CWString.replaceAll( myNameSet, 'ABC', '__c' );

		myCWTest.assert( 'Test CWString Replace First', CWString.replace('Number_8_0ABC', 'ABC', '__c'), fieldNameList[0] );
		CWString.replace( CWString.replace( fieldNameList, 'ABC', '__c' ), 'ABC', '__c' );
		CWString.toList( CWString.replace( fieldNameList, 'ABC', '__c' ) );
		CWString.replace( myNameSet, 'ABC', '__c' );

		CWString.removeStartIgnoreCase( fieldNameList[0], 'Nu' );
		CWString.removeStartIgnoreCase( CWString.removeStartIgnoreCase( fieldNameList, 'Nu' ), 'Nu' );
		CWString.toList( CWString.removeStartIgnoreCase( fieldNameList, 'Nu' ) );
		CWString.removeStartIgnoreCase( myNameSet, 'Nu' );

		CWString.removeStart( fieldNameList[0], 'Nu' );
		CWString.removeStart( CWString.removeStart( fieldNameList, 'Nu' ), 'Nu' );
		CWString.toList( CWString.removeStart( fieldNameList, 'Nu' ) );
		CWString.removeStart( myNameSet, 'Nu' );

		CWString.removeEndIgnoreCase( fieldNameList[0], '__c' );
		CWString.removeEndIgnoreCase( CWString.removeEndIgnoreCase( fieldNameList, '__c' ), '__c' );
		CWString.toList( CWString.removeEndIgnoreCase( fieldNameList, '__c' ) );
		CWString.removeEndIgnoreCase( myNameSet, '__c' );

		CWString.removeEnd( fieldNameList[0], '__c' );
		CWString.removeEnd( CWString.removeEnd( fieldNameList, '__c' ), '__c' );
		CWString.toList( CWString.removeEnd( fieldNameList, '__c' ) );
		CWString.removeEnd( myNameSet, '__c' );

		CWString.remove( fieldNameList[0], '__c' );
		CWString.remove( CWString.remove( fieldNameList, '__c' ), '__c' );
		CWString.toList( CWString.remove( fieldNameList, '__c' ) );
		CWString.remove( myNameSet, '__c' );

		CWString.parenthesize( fieldNameList[0] );
		CWString.parenthesize( myIterStrings );
		CWString.parenthesize( fieldNameList );
		CWString.toList( CWString.parenthesize( fieldNameList ) );
		CWString.parenthesize( myNameSet );

		CWString.quote( fieldNameList[0] );
		CWString.quote( myIterStrings );
		CWString.quote( fieldNameList );
		CWString.toList( CWString.quote( fieldNameList ) );
		CWString.quote( myNameSet );

		myCWTest.stopTest();
		myCWTest.report();
	}

	static testMethod void testFormatStringMethods()
	{
		CWTest myCWTest = new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		CWString.repeat( fieldNameList[0], 2 );
		CWString.repeat( fieldNameList[0], 2, '^' );
		CWString.repeat( CWString.capitalize( fieldNameList ), 2 );
		CWString.repeat( CWString.capitalize( fieldNameList ), 2, '^' );
		CWString.repeat( fieldNameList, 2 );
		CWString.toList( CWString.repeat( fieldNameList, 2 ) );
		CWString.repeat( myIterStrings, 2 );
		CWString.repeat( myNameSet, 2 );
		CWString.repeat( fieldNameList, 2, '^' );
		CWString.repeat( myNameSet, 2, '^' );

		CWString.center( fieldNameList[0], '.', 50 );
		CWString.center( fieldNameList[0], 50 );
		CWString.center( CWString.capitalize( fieldNameList ), '....', 50 );
		CWString.center( CWString.capitalize( fieldNameList ), 50 );
		CWString.center( fieldNameList, '....', 50 );
		CWString.center( fieldNameList, 50 );
		CWString.toList( CWString.center( fieldNameList, 50 ) );
		CWString.center( myIterStrings, '....', 50 );
		CWString.center( myIterStrings, 50 );
		CWString.center( myNameSet, '....', 50 );
		CWString.center( myNameSet, 50 );

		CWString.rightpad( fieldNameList[0], '.', 50 );
		CWString.rightpad( fieldNameList[0], 50 );
		CWString.rightpad( CWString.capitalize( fieldNameList ), '....', 50 );
		CWString.rightpad( CWString.capitalize( fieldNameList ), 50 );
		CWString.rightpad( fieldNameList, '....', 50 );
		CWString.rightpad( fieldNameList, 50 );
		CWString.toList( CWString.rightpad( fieldNameList, 50 ) );
		CWString.rightpad( myIterStrings, '....', 50 );
		CWString.rightpad( myIterStrings, 50 );
		CWString.rightpad( myNameSet, '....', 50 );
		CWString.rightpad( myNameSet, 50 );

		CWString.leftpad( fieldNameList[0], '.', 50 );
		CWString.leftpad( fieldNameList[0], 50 );
		CWString.leftpad( CWString.capitalize( fieldNameList ), '....', 50 );
		CWString.leftpad( CWString.capitalize( fieldNameList ), 50 );
		CWString.leftpad( fieldNameList, '....', 50 );
		CWString.leftpad( fieldNameList, 50 );
		CWString.toList( CWString.leftpad( fieldNameList, 50 ) );
		CWString.leftpad( myIterStrings, '....', 50 );
		CWString.leftpad( myIterStrings, 50 );
		CWString.leftpad( myNameSet, '....', 50 );
		CWString.leftpad( myNameSet, 50 );

		CWString.addPrefix( fieldNameList[0], 'prefix' );
		CWString.addPrefix( myIterStrings, 'prefix' );
		CWString.addPrefix( fieldNameList, 'prefix' );
		CWString.toList( CWString.addPrefix( fieldNameList, 'prefix' ) );
		CWString.addPrefix( myNameSet, 'prefix' );
		CWString.addPrefix( fieldNameList[0] );
		CWString.addPrefix( myIterStrings );
		CWString.addPrefix( fieldNameList );
		CWString.addPrefix( myNameSet );

		CWString.addSuffix( fieldNameList[0], 'postfix' );
		CWString.addSuffix( myIterStrings, 'postfix' );
		CWString.addSuffix( fieldNameList, 'postfix' );
		CWString.toList( CWString.addSuffix( fieldNameList, 'postfix' ) );
		CWString.addSuffix( myNameSet, 'postfix' );
		CWString.addSuffix( fieldNameList[0] );
		CWString.addSuffix( myIterStrings );
		CWString.addSuffix( fieldNameList );
		CWString.addSuffix( myNameSet );

		CWString.addCircumfix( fieldNameList[0], 'cirfix' );
		CWString.addCircumfix( myIterStrings, 'cirfix' );
		CWString.addCircumfix( fieldNameList, 'cirfix' );
		CWString.toList( CWString.addCircumfix( fieldNameList, 'cirfix' ) );
		CWString.addCircumfix( myNameSet, 'cirfix' );
		CWString.addCircumfix( fieldNameList[0] );
		CWString.addCircumfix( myIterStrings );
		CWString.addCircumfix( fieldNameList );
		CWString.addCircumfix( myNameSet );
		CWString.addCircumfix( myIterStrings, 'Prefix', 'Postfix' );
		CWString.addCircumfix( fieldNameList, 'Prefix', 'Postfix' );
		CWString.addCircumfix( myNameSet, 'Prefix', 'Postfix' );

		myCWTest.stopTest();
		myCWTest.report();
	}

	static testMethod void testCleanupStringMethods()
	{
		CWTest myCWTest = new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		myCWTest.assert( 'Test CWString deleteWhitespace', 'Number_8_0__c', CWString.deleteWhitespace('Nu m ber _8_0__c') );
		CWString.deleteWhitespace( CWString.deleteWhitespace( fieldNameList ) );
		CWString.toList( CWString.deleteWhitespace( fieldNameList ) );
		CWString.deleteWhitespace( myNameSet );

		CWString.NormalizeSpace( fieldNameList[0] );
		CWString.NormalizeSpace( CWString.NormalizeSpace( fieldNameList ) );
		CWString.toList( CWString.NormalizeSpace( fieldNameList ) );
		CWString.NormalizeSpace( myNameSet );

		myCWTest.assert( 'Test CWString trim', 'Number_8_0__c', CWString.trim('  Number_8_0__c  ') );
		CWString.trim( CWString.trim( fieldNameList ) );
		CWString.toList( CWString.trim( fieldNameList ) );
		CWString.trim( myNameSet );

		myCWTest.assert( 'Test CWString Scrub', CWString.scrub('Number%8%0%%c'), 'Number\\%8\\%0\\%\\%c' );
		myCWTest.assert( 'Test CWString Scrub', CWString.scrub(fieldNameList[0]), 'Number\\_8\\_0\\_\\_c' );
		CWString.scrub( CWString.scrub( fieldNameList ) );
		CWString.toList( CWString.scrub( fieldNameList ) );
		CWString.scrub( myNameSet );

		myCWTest.assert( 'Test CWString Strip Html tags', fieldNameList[0], CWString.stripHtmltags('<html>Number_8_0__c</html>') );
		myCWTest.assert( 'Test CWString Scrub', CWString.stripHtmltags('Number_8_0__c'), fieldNameList[0] );
		CWString.stripHtmltags( CWString.stripHtmltags( fieldNameList ) );
		CWString.toList( CWString.stripHtmltags( fieldNameList ) );
		CWString.stripHtmltags( myNameSet );

		myCWTest.assert( 'Test CWString Unescape XML', CWString.unescapeXml('Number_8_0__c'), fieldNameList[0] );
		CWString.unescapeXml( CWString.unescapeXml( fieldNameList ) );
		CWString.toList( CWString.unescapeXml( fieldNameList ) );
		CWString.unescapeXml( myNameSet );

		CWString.unescapeHtml4( fieldNameList[0] );
		CWString.unescapeHtml4( CWString.unescapeHtml4( fieldNameList ) );
		CWString.toList( CWString.unescapeHtml4( fieldNameList ) );
		CWString.unescapeHtml4( myNameSet );

		CWString.unescapeHtml3( fieldNameList[0] );
		CWString.unescapeHtml3( CWString.unescapeHtml3( fieldNameList ) );
		CWString.toList( CWString.unescapeHtml3( fieldNameList ) );
		CWString.unescapeHtml3( myNameSet );

		CWString.unescapeEcmaScript( fieldNameList[0] );
		CWString.unescapeEcmaScript( CWString.unescapeEcmaScript( fieldNameList ) );
		CWString.toList( CWString.unescapeEcmaScript( fieldNameList ) );
		CWString.unescapeEcmaScript( myNameSet );

		CWString.unescapeCsv( fieldNameList[0] );
		CWString.unescapeCsv( CWString.unescapeCsv( fieldNameList ) );
		CWString.toList( CWString.unescapeCsv( fieldNameList ) );
		CWString.unescapeCsv( myNameSet );

		CWString.escapeXML( fieldNameList[0] );
		CWString.escapeXML( CWString.escapeXML( fieldNameList ) );
		CWString.toList( CWString.escapeXML( fieldNameList ) );
		CWString.escapeXML( myNameSet );		

		CWString.escapeHtml4( fieldNameList[0] );
		CWString.escapeHtml4( CWString.escapeHtml4( fieldNameList ) );
		CWString.toList( CWString.escapeHtml4( fieldNameList ) );
		CWString.escapeHtml4( myNameSet );

		CWString.escapeHtml3( fieldNameList[0] );
		CWString.escapeHtml3( CWString.escapeHtml3( fieldNameList ) );
		CWString.toList( CWString.escapeHtml3( fieldNameList ) );
		CWString.escapeHtml3( myNameSet );

		CWString.escapeEcmaScript( fieldNameList[0] );
		CWString.escapeEcmaScript( CWString.escapeEcmaScript( fieldNameList ) );
		CWString.toList( CWString.escapeEcmaScript( fieldNameList ) );
		CWString.escapeEcmaScript( myNameSet );

		CWString.escapeCsv( fieldNameList[0] );
		CWString.escapeCsv( CWString.escapeCsv( fieldNameList ) );
		CWString.toList( CWString.escapeCsv( fieldNameList ) );
		CWString.escapeCsv( myNameSet );

		CWString.escapeSingleQuotes( fieldNameList[0] );
		CWString.escapeSingleQuotes( CWString.escapeSingleQuotes( fieldNameList ) );
		CWString.toList( CWString.escapeSingleQuotes( fieldNameList ) );
		CWString.escapeSingleQuotes( myNameSet );

		myCWTest.stopTest();
		myCWTest.report();
	}

	static testMethod void testNotSoStringMethods()
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
		CWIterable		my_Iterable		= new CWIterable( (List<Object>) list_Records );

		CWTest myCWTest = new CWTest( 'testStringMethods' );

		myCWTest.startTest();
		CWString.random();
		CWString.toSet(myIterStrings);
		CWString.valueOf( (Object)list_Records[0] );
		CWString.toList(CWString.valueOf( my_Iterable ));
		CWString.valueOf( list_Records );
		CWString.valueOf( set_Objects );

		CWString.fileSize( 5500 );
		CWString.fileSize( 5500L ); 
		CWString.fileSize( 5500.0 );
		Double myDouble = 5.5;
		CWString.fileSize( myDouble );

		CWString.getCommonSuffix( myIterStrings );
		CWString.getCommonSuffix( fieldNameList );
		CWString.getCommonSuffix( myNameSet );

		CWString.getCommonPrefix( myIterStrings );
		CWString.getCommonPrefix( fieldNameList );
		CWString.getCommonPrefix( myNameSet );

		myCWTest.stopTest();
		myCWTest.report();
	}

	static testMethod void testSplitJoinStringMethods()
	{
		CWTest myCWTest = new CWTest( 'testStringMethods' );
		myCWTest.startTest();

		CWString.splitByCharacterTypeCamelCase( fieldNameList[0] );
		CWString.splitByCharacterTypeCamelCase( CWString.splitByCharacterTypeCamelCase( fieldNameList ) );
		CWString.toList( CWString.splitByCharacterTypeCamelCase( fieldNameList ) );
		CWString.splitByCharacterTypeCamelCase( myNameSet );

		CWString.splitByCharacterType( fieldNameList[0] );
		CWString.splitByCharacterType( CWString.splitByCharacterType( fieldNameList ) );
		CWString.toList( CWString.splitByCharacterType( fieldNameList ) );
		CWString.splitByCharacterType( myNameSet );

		CWString.split( fieldNameList[0] );
		CWString.split( fieldNameList[0], 1 );
		CWString.split( fieldNameList[0], '_' );
		CWString.split( CWString.capitalize( fieldNameList ), '_', 5 );
		CWString.split( CWString.capitalize( fieldNameList ), '_' );
		CWString.split( CWString.capitalize( fieldNameList ) );
		CWString.split( fieldNameList, '_', 5 );
		CWString.split( fieldNameList, '_' );
		CWString.split( fieldNameList );
		CWString.toList( CWString.split( fieldNameList ) );
		CWString.split( myNameSet, '_', 5 );
		CWString.split( myNameSet, '_' );
		CWString.split( myNameSet, 5 );
		CWString.split( myNameSet );
		CWString.split( fieldNameList, 5 );
		CWIterable anIterable = CWString.split( myIterStrings, 5 );
		Iterator<Object>	anIterator	= anIterable.Iterator();
		String	aString;
		do
		{
			aString	= (String) anIterator.next();
		}
		while ( aString != null );

		CWString.semicolonJoin( myIterStrings );
		CWString.semicolonJoin( fieldNameList );
		CWString.semicolonJoin( myNameSet );

		CWString.commaJoin( myIterStrings );
		CWString.commaJoin( fieldNameList );
		CWString.commaJoin( myNameSet );

		CWString.join( myIterStrings, '^' );
		CWString.join( fieldNameList, '^' );
		CWString.join( myNameSet, '^' );
		CWString.join( myIterStrings );
		CWString.join( fieldNameList );
		CWString.join( myNameSet );

		myCWTest.stopTest();
		myCWTest.report();
	}
}