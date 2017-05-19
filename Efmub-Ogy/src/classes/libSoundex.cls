/*******************************************************//**

@class		CWSoundex

@brief		CW Soundex Encoding Class

	Implements the Soundex algorithm for encoding strings.
	This can be used to create misspelling-tolerant searches.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2015-07-29	LiquidHub.GHA
	Created.
@version	2015-10-16	LiquidHub.GHA
	Added method headers.  Fixed a bug in the basic 'encode' method.

@see		CWSoundexTest

	(c)2015-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public with sharing class CWSoundex
{
	/*******************************************************
					soundexCodes map

	This map categorizes characters into six groupings plus
	groups for vowels and letters to ignore.
	*******************************************************/

	private static Map<String,String>	soundexCodes	= new Map<String,String>
	{
		'B' => '1', 'F' => '1', 'P' => '1', 'V' => '1',
		'C' => '2', 'G' => '2', 'J' => '2', 'K' => '2', 'Q' => '2', 'S' => '2', 'X' => '2', 'Z' => '2',
		'D' => '3', 'T' => '3',
		'L' => '4',
		'M' => '5', 'N' => '5',
		'R' => '6',
		'H' => 'I', 'W' => 'I',														//	'I' for Ignore
		'A' => 'V', 'E' => 'V', 'I' => 'V', 'O' => 'V', 'U' => 'V', 'Y' => 'V'		//	'V' for Vowel
	};

	/*******************************************************
					encode method

	Returns the Soundex encoding of the given string to the
	specified number of characters.
	*******************************************************/

	public static String encode( String inputString, Integer outputLength )
	{
		if ( outputLength == null || outputLength <= 0 ) outputLength = 4;

		String	padString		= '0'.repeat( outputLength );

		if ( String.isBlank( inputString ) ) return padString;

				inputString		= inputString.toUpperCase();
		String	outputString	= inputString.left( 1 );
		String	previousCode	= '';

		for ( String inputChar : inputString.right( inputString.length() - 1 ).split( '' ) )
		{
			String	currentCode		= soundexCodes.get( inputChar );
			if ( String.isBlank( currentCode ) || currentCode == 'V' ) { previousCode = ''; continue; }
			if ( currentCode == previousCode || currentCode == 'I' ) { continue; }

			outputString += currentCode;
			previousCode = currentCode;
			if ( outputString.length() >= outputLength ) break;
		}

		return (outputString + padString).left( outputLength );
	}

	/*******************************************************
					encode method

	Returns a list of encoded strings of the specified length
	derived from the given list of strings.
	*******************************************************/

	public static List<String> encode( List<String> inputStrings, Integer outputLength )
	{
		Set<String>	outputStrings	= new Set<String>();

		for ( String inputString : inputStrings )
		{
			outputStrings.add( encode( inputString, outputLength ) );
		}
		return new List<String>( outputStrings );
	}

	/*******************************************************
					encodeField method

	Reads a string field from the given record, encodes it,
	and writes the result to the specified field.  Returns
	the encoded string.
	*******************************************************/

	public static String encodeField( sObject record, String fieldName, String soundexField )
	{
		if ( !CWSchema.isField( record, fieldName ) || !CWSchema.isField( record, soundexField ) ) return null;

		Integer	soundexLength		= CWSchema.getFieldLength( record, soundexField );
		if ( soundexLength == null ) return null;

		String	soundexCode		= encode( (String) record.get( fieldName ), soundexLength );
		record.put( soundexField, soundexCode );
		return soundexCode;
	}

	/*******************************************************
					encode method

	Encodes one or more fields in each of the objects in the
	CWTrigger, writing the results to the corresponding
	fields, as specified by the 'encodings' map.  The 'encodings'
	map contains pairs of field names - the plaintext field
	is the key, the Soundex field is the value.

	This method will only take action when called from 'before'
	trigger events, other than 'before delete'.
	*******************************************************/

	public static void encode( CWTrigger theTrigger, Map<String,String> encodings )
	{
		if ( theTrigger.isDelete || theTrigger.isAfter ) return;

		for ( String fieldName : encodings.keySet() )
		{
			if ( !CWSchema.isField( theTrigger.sObjectType, fieldName ) ) continue;
			String	soundexField	= encodings.get( fieldName );
			Integer	soundexLength	= CWSchema.getFieldLength( theTrigger.sObjectType, soundexField );
			if ( soundexLength == null ) continue;

			for ( sObject record : theTrigger.newList )
			{
				if ( theTrigger.hasChanged( record, fieldName ) )
				{
					record.put( soundexField, encode( (String) record.get( fieldName ), soundexLength ) );
				}
			}
		}
	}
}