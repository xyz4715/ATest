/*******************************************************//**

@class		CWString

@brief		CW Core String Class

Augmentation
	addPrefix
	addSuffix
	addCircumfix
	quote
	parenthesize
	leftPad
	rightPad
	center
	repeat

Join / Split
	join
	commaJoin
	semicolonJoin
	split
	splitByCharacterType
	splitByCharacterTypeCamelCase

Substring Extraction
	left
	mid
	right
	substring
	substringAfter
	substringAfterLast
	substringBefore
	substringBeforeLast
	substringBetween
	getCommonPrefix
	getCommonSuffix

Case Manipulation
	capitalize
	toLowerCase
	toUpperCase
	swapCase
	uncapitalize
	toTitleCase

Whitespace Removal
	trim
	normalizeSpace
	deleteWhitespace

Substring Removal
	remove
	removeEnd
	removeEndIgnoreCase
	removeStart
	removeStartIgnoreCase

Substitution (Replace)
	replace
	replaceAll
	replaceMap
	replaceFirst

Escape / Unescape
	escapeSingleQuotes
	escapeCsv
	escapeEcmaScript
	escapeHtml3
	escapeHtml4
	escapeXml
	unescapeCsv
	unescapeEcmaScript
	unescapeHtml3
	unescapeHtml4
	unescapeXml
	stripHtmltags

Conversion / Creation
	reverse
	random
	valueOf
	fileSize

@author		Glyn Anderson (LiquidHub.GHA)

@version	2013-11-27	LiquidHub.GHA
	Completed first version.
@version	2013-12-25	LiquidHub.GHA
	Second version.  Includes a more complete set of methods
	patterned after existing String class methods.
@version	2014-02-26	LiquidHub.GHA
	Incorporated CWIterable in all list-handling methods.
@version	2014-03-03	LiquidHub.GHA
	Incorporated CWType.IsString predicate.
@version	2014-03-05	LiquidHub.GHA
	Added 'quote' and 'parenthesize' methods.
@version	2014-03-06	LiquidHub.GHA
	Fixed 'valueOf' to take collections of Objects.
@version	2014-04-24	LiquidHub.GHA
	Added method, 'replaceMap'.
@version	2014-09-17	LiquidHub.GHA
	Removed all use of CWPredicates to improve performance.
	In particular, CWType.IsString().

@todo		Decide whether to incorporate CWException for null results.
@todo		substringBetweenOuter
@todo		substringBetweenInner

@see		CWStringTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWString
{
	/***********************************************************
					IsNotBlank predicate

	Used to ensure that all Objects processed are non-blank Strings.
	***********************************************************/
/*
	public class IsNotBlank extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return
				(	theObject != null
				&&	theObject instanceof String
				&&	String.isNotBlank( (String) theObject )
				);
		}
	}
//*/
	/***********************************************************
					toList method

	Converts the CWIterable returned by a CWString method to a
	List of Strings.
	***********************************************************/

	public static List<String> toList( CWIterable theIterable )
	{
		return theIterable != null ? theIterable.toList_String() : null;
	}

	/***********************************************************
					toSet method

	Converts the CWIterable returned by a CWString method to a
	Set of Strings.
	***********************************************************/

	public static Set<String> toSet( CWIterable theIterable )
	{
		return theIterable != null ? new Set<String>( theIterable.toList_String() ) : null;
	}

	/***********************************************************
					getCommonPrefix method
	***********************************************************/

	public static String getCommonPrefix( CWIterable inputStrings )
	{
		return getCommonPrefix( toList( inputStrings ) );
	}

	public static String getCommonPrefix( List<String> inputStrings )
	{
		return inputStrings != null ? String.getCommonPrefix( inputStrings ) : null;
	}

	public static String getCommonPrefix( Set<String> inputStrings )
	{
		return getCommonPrefix( new List<String>( inputStrings ) );
	}

	/***********************************************************
					getCommonSuffix method
	***********************************************************/

	public static String getCommonSuffix( CWIterable inputStrings )
	{
		return getCommonSuffix( toList( inputStrings ) );
	}

	public static String getCommonSuffix( List<String> inputStrings )
	{
		return inputStrings != null ? reverse( getCommonPrefix( reverse( inputStrings ) ) ) : null;
	}

	public static String getCommonSuffix( Set<String> inputStrings )
	{
		return getCommonSuffix( new List<String>( inputStrings ) );
	}

	/***********************************************************
					addPrefix method
	***********************************************************/

	private static final String defaultPrefix = ' ';

	public static String addPrefix( String inputString, String prefix )
	{
		return inputString != null ? (prefix != null ? prefix : defaultPrefix) + inputString : null;
	}

	public static String addPrefix( String inputString )
	{
		return addPrefix( inputString, (String) null );
	}

	private class AddPrefix extends CWFunction
	{
		String	thePrefix;

		public AddPrefix( String prefix )
		{
			thePrefix	= prefix;
		}

		public override Object transform( Object theObject )
		{
			return addPrefix( (String) theObject, thePrefix );
		}
	}

	private static CWIterable addPrefix( Iterable<String> inputStrings, String prefix )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new AddPrefix( prefix ) );
	}

	public static CWIterable addPrefix( CWIterable inputStrings, String prefix )
	{
		return addPrefix( (Iterable<String>) inputStrings, prefix );
	}

	public static CWIterable addPrefix( CWIterable inputStrings )
	{
		return addPrefix( (Iterable<String>) inputStrings, (String) null );
	}

	public static CWIterable addPrefix( List<String> inputStrings, String prefix )
	{
		return addPrefix( (Iterable<String>) inputStrings, prefix );
	}

	public static CWIterable addPrefix( List<String> inputStrings )
	{
		return addPrefix( (Iterable<String>) inputStrings, (String) null );
	}

	public static CWIterable addPrefix( Set<String> inputStrings, String prefix )
	{
		return addPrefix( (Iterable<String>) inputStrings, prefix );
	}

	public static CWIterable addPrefix( Set<String> inputStrings )
	{
		return addPrefix( (Iterable<String>) inputStrings, (String) null );
	}

	/***********************************************************
					addSuffix method
	***********************************************************/

	private static final String defaultSuffix = ' ';

	public static String addSuffix( String inputString, String suffix )
	{
		return inputString != null ? inputString + (suffix != null ? suffix : defaultSuffix) : null;
	}

	public static String addSuffix( String inputString )
	{
		return addSuffix( inputString, (String) null );
	}

	private class AddSuffix extends CWFunction
	{
		String	theSuffix;

		public AddSuffix( String suffix )
		{
			theSuffix	= suffix;
		}

		public override Object transform( Object theObject )
		{
			return addSuffix( (String) theObject, theSuffix );
		}
	}

	private static CWIterable addSuffix( Iterable<String> inputStrings, String suffix )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new AddSuffix( suffix ) );
	}

	public static CWIterable addSuffix( CWIterable inputStrings, String suffix )
	{
		return addSuffix( (Iterable<String>) inputStrings, suffix );
	}

	public static CWIterable addSuffix( CWIterable inputStrings )
	{
		return addSuffix( (Iterable<String>) inputStrings, (String) null );
	}

	public static CWIterable addSuffix( List<String> inputStrings, String suffix )
	{
		return addSuffix( (Iterable<String>) inputStrings, suffix );
	}

	public static CWIterable addSuffix( List<String> inputStrings )
	{
		return addSuffix( (Iterable<String>) inputStrings, (String) null );
	}

	public static CWIterable addSuffix( Set<String> inputStrings, String suffix )
	{
		return addSuffix( (Iterable<String>) inputStrings, suffix );
	}

	public static CWIterable addSuffix( Set<String> inputStrings )
	{
		return addSuffix( (Iterable<String>) inputStrings, (String) null );
	}

	/***********************************************************
					addCircumfix method
	***********************************************************/

	public static String addCircumfix( String inputString, String prefix, String suffix )
	{
		return addSuffix( addPrefix( inputString, prefix ), suffix );
	}

	public static String addCircumfix( String inputString, String padString )
	{
		return addCircumfix( inputString, padString, padString );
	}

	public static String addCircumfix( String inputString )
	{
		return addCircumfix( inputString, (String) null, (String) null );
	}

	private class AddCircumfix extends CWFunction
	{
		String	thePrefix;
		String	theSuffix;

		public AddCircumfix( String prefix, String suffix )
		{
			thePrefix	= prefix;
			theSuffix	= suffix;
		}

		public override Object transform( Object theObject )
		{
			return addCircumfix( (String) theObject, thePrefix, theSuffix );
		}
	}

	private static CWIterable addCircumfix( Iterable<String> inputStrings, String prefix, String suffix )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new AddCircumfix( prefix, suffix ) );
	}

	public static CWIterable addCircumfix( CWIterable inputStrings, String prefix, String suffix )
	{
		return addCircumfix( (Iterable<String>) inputStrings, prefix, suffix );
	}

	public static CWIterable addCircumfix( CWIterable inputStrings, String padString )
	{
		return addCircumfix( (Iterable<String>) inputStrings, padString, padString );
	}

	public static CWIterable addCircumfix( CWIterable inputStrings )
	{
		return addCircumfix( (Iterable<String>) inputStrings, (String) null, (String) null );
	}

	public static CWIterable addCircumfix( List<String> inputStrings, String prefix, String suffix )
	{
		return addCircumfix( (Iterable<String>) inputStrings, prefix, suffix );
	}

	public static CWIterable addCircumfix( List<String> inputStrings, String padString )
	{
		return addCircumfix( (Iterable<String>) inputStrings, padString, padString );
	}

	public static CWIterable addCircumfix( List<String> inputStrings )
	{
		return addCircumfix( (Iterable<String>) inputStrings, (String) null, (String) null );
	}

	public static CWIterable addCircumfix( Set<String> inputStrings, String prefix, String suffix )
	{
		return addCircumfix( (Iterable<String>) inputStrings, prefix, suffix );
	}

	public static CWIterable addCircumfix( Set<String> inputStrings, String padString )
	{
		return addCircumfix( (Iterable<String>) inputStrings, padString, padString );
	}

	public static CWIterable addCircumfix( Set<String> inputStrings )
	{
		return addCircumfix( (Iterable<String>) inputStrings, (String) null, (String) null );
	}

	/***********************************************************
					quote method
	***********************************************************/

	public static String quote( String inputString )
	{
		return addCircumfix( inputString, '\'' );
	}

	private class Quote extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return quote( (String) theObject );
		}
	}

	private static CWIterable quote( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Quote() );
	}

	public static CWIterable quote( CWIterable inputStrings )
	{
		return quote( (Iterable<String>) inputStrings );
	}

	public static CWIterable quote( List<String> inputStrings )
	{
		return quote( (Iterable<String>) inputStrings );
	}

	public static CWIterable quote( Set<String> inputStrings )
	{
		return quote( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					parenthesize method
	***********************************************************/

	public static String parenthesize( String inputString )
	{
		return addCircumfix( inputString, '(', ')' );
	}

	private class Parenthesize extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return parenthesize( (String) theObject );
		}
	}

	private static CWIterable parenthesize( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Parenthesize() );
	}

	public static CWIterable parenthesize( CWIterable inputStrings )
	{
		return parenthesize( (Iterable<String>) inputStrings );
	}

	public static CWIterable parenthesize( List<String> inputStrings )
	{
		return parenthesize( (Iterable<String>) inputStrings );
	}

	public static CWIterable parenthesize( Set<String> inputStrings )
	{
		return parenthesize( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					leftPad method
	***********************************************************/

	public static String leftPad( String inputString, String padString, Integer length )
	{
		return
			inputString == null					?	null
		:	length == null						?	inputString
		:	padString == null					?	inputString.leftPad( length )
		:	padString == ''						?	inputString
		:	length <= inputString.length()		?	inputString
		:											right( repeat( padString, length ) + inputString, length );
	}

	public static String leftPad( String inputString, Integer length )
	{
		return leftPad( inputString, (String) null, length );
	}

	private class LeftPad extends CWFunction
	{
		String	thePadString;
		Integer	theLength;

		public LeftPad( String padString, Integer length )
		{
			thePadString	= padString;
			theLength		= length;
		}

		public override Object transform( Object theObject )
		{
			return leftPad( (String) theObject, thePadString, theLength );
		}
	}

	private static CWIterable leftPad( Iterable<String> inputStrings, String padString, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new LeftPad( padString, length ) );
	}

	public static CWIterable leftPad( CWIterable inputStrings, String padString, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable leftPad( CWIterable inputStrings, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable leftPad( List<String> inputStrings, String padString, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable leftPad( List<String> inputStrings, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable leftPad( Set<String> inputStrings, String padString, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable leftPad( Set<String> inputStrings, Integer length )
	{
		return leftPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	/***********************************************************
					rightPad method
	***********************************************************/

	public static String rightPad( String inputString, String padString, Integer length )
	{
		return
			inputString == null					?	null
		:	length == null						?	inputString
		:	padString == null					?	inputString.rightPad( length )
		:	padString == ''						?	inputString
		:	length <= inputString.length()		?	inputString
		:											left( inputString + repeat( padString, length ), length );
	}

	public static String rightPad( String inputString, Integer length )
	{
		return rightPad( inputString, (String) null, length );
	}

	private class RightPad extends CWFunction
	{
		String	thePadString;
		Integer	theLength;

		public RightPad( String padString, Integer length )
		{
			thePadString	= padString;
			theLength		= length;
		}

		public override Object transform( Object theObject )
		{
			return rightPad( (String) theObject, thePadString, theLength );
		}
	}

	private static CWIterable rightPad( Iterable<String> inputStrings, String padString, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new RightPad( padString, length ) );
	}

	public static CWIterable rightPad( CWIterable inputStrings, String padString, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable rightPad( CWIterable inputStrings, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable rightPad( List<String> inputStrings, String padString, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable rightPad( List<String> inputStrings, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable rightPad( Set<String> inputStrings, String padString, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable rightPad( Set<String> inputStrings, Integer length )
	{
		return rightPad( (Iterable<String>) inputStrings, (String) null, length );
	}

	/***********************************************************
					center method
	***********************************************************/

	public static String center( String inputString, String padString, Integer length )
	{
		return
			inputString == null					?	null
		:	length == null						?	inputString
		:	padString == null					?	inputString.center( length )
		:	padString == ''						?	inputString
		:											inputString.center( length, padString );
	}

	public static String center( String inputString, Integer length )
	{
		return center( inputString, (String) null, length );
	}

	private class Center extends CWFunction
	{
		String	thePadString;
		Integer	theLength;

		public Center( String padString, Integer length )
		{
			thePadString	= padString;
			theLength		= length;
		}

		public override Object transform( Object theObject )
		{
			return center( (String) theObject, thePadString, theLength );
		}
	}

	private static CWIterable center( Iterable<String> inputStrings, String padString, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Center( padString, length ) );
	}

	public static CWIterable center( CWIterable inputStrings, String padString, Integer length )
	{
		return center( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable center( CWIterable inputStrings, Integer length )
	{
		return center( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable center( List<String> inputStrings, String padString, Integer length )
	{
		return center( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable center( List<String> inputStrings, Integer length )
	{
		return center( (Iterable<String>) inputStrings, (String) null, length );
	}

	public static CWIterable center( Set<String> inputStrings, String padString, Integer length )
	{
		return center( (Iterable<String>) inputStrings, padString, length );
	}

	public static CWIterable center( Set<String> inputStrings, Integer length )
	{
		return center( (Iterable<String>) inputStrings, (String) null, length );
	}

	/***********************************************************
					repeat method
	***********************************************************/

	public static String repeat( String inputString, Integer repeats, String separator )
	{
		return
			inputString == null		?	null
		:	repeats == null			?	inputString
		:	separator == null		?	inputString.repeat( repeats )
		:								inputString.repeat( separator, repeats );
	}

	public static String repeat( String inputString, Integer repeats )
	{
		return repeat( inputString, repeats, (String) null );
	}

	private class Repeat extends CWFunction
	{
		Integer	theRepeats;
		String	theSeparator;

		public Repeat( Integer repeats, String separator )
		{
			theRepeats		= repeats;
			theSeparator	= separator;
		}

		public override Object transform( Object theObject )
		{
			return repeat( (String) theObject, theRepeats, theSeparator );
		}
	}

	private static CWIterable repeat( Iterable<String> inputStrings, Integer repeats, String separator )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Repeat( repeats, separator ) );
	}

	public static CWIterable repeat( CWIterable inputStrings, Integer repeats, String separator )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, separator );
	}

	public static CWIterable repeat( CWIterable inputStrings, Integer repeats )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, (String) null );
	}

	public static CWIterable repeat( List<String> inputStrings, Integer repeats, String separator )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, separator );
	}

	public static CWIterable repeat( List<String> inputStrings, Integer repeats )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, (String) null );
	}

	public static CWIterable repeat( Set<String> inputStrings, Integer repeats, String separator )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, separator );
	}

	public static CWIterable repeat( Set<String> inputStrings, Integer repeats )
	{
		return repeat( (Iterable<String>) inputStrings, repeats, (String) null );
	}

	/***********************************************************
					join method
	***********************************************************/

	private static final String joinSeparator = '';

	public static String join( CWIterable inputStrings, String separator )
	{
		return join( toList( inputStrings ), separator );
	}

	public static String join( CWIterable inputStrings )
	{
		return join( toList( inputStrings ), (String) null );
	}

	public static String join( List<String> inputStrings, String separator )
	{
		return inputStrings != null ? String.join( inputStrings, separator != null ? separator : joinSeparator ) : null;
	}

	public static String join( List<String> inputStrings )
	{
		return join( inputStrings, (String) null );
	}

	public static String join( Set<String> inputStrings, String separator )
	{
		return join( new List<String>( inputStrings ), separator );
	}

	public static String join( Set<String> inputStrings )
	{
		return join( new List<String>( inputStrings ), (String) null );
	}

	/***********************************************************
					commaJoin method
	***********************************************************/

	public static String commaJoin( CWIterable inputStrings )
	{
		return commaJoin( toList( inputStrings ) );
	}

	public static String commaJoin( List<String> list_inputStrings )
	{
		return join( list_inputStrings, ',' );
	}

	public static String commaJoin( Set<String> set_inputStrings )
	{
		return commaJoin( new List<String>( set_inputStrings ) );
	}

	/***********************************************************
					semicolonJoin method
	***********************************************************/

	public static String semicolonJoin( CWIterable inputStrings )
	{
		return semicolonJoin( toList( inputStrings ) );
	}

	public static String semicolonJoin( List<String> list_inputStrings )
	{
		return join( list_inputStrings, ';' );
	}

	public static String semicolonJoin( Set<String> set_inputStrings )
	{
		return semicolonJoin( new List<String>( set_inputStrings ) );
	}

	/***********************************************************
				SplitIterable and SplitIterator classes

	These are special Iterable/Iterator classes used by the various
	split methods.
	***********************************************************/

	private class SplitIterable extends CWIterable
	{
		private CWFunction	theFunction;

		public SplitIterable( Iterable<Object> anIterable, CWFunction aFunction )
		{
			super( anIterable );
			theFunction	= aFunction;
		}

		public CWIterable transform( String inputString )
		{
			return (CWIterable) CWFunction.transform( theFunction, (Object) inputString );
		}

		public override Iterator<Object> Iterator()
		{
			return new SplitIterator( this, super.Iterator() );
		}
	}

	private class SplitIterator implements Iterator<Object>
	{
		private SplitIterable		theIterable;	//	the SplitIterable we iterate
		private Iterator<Object>	theIterator;	//	the Iterator of the base CWIterable
		private Iterator<Object>	the2ndIterator;	//	the Iterator of the secondary Iterable

		public SplitIterator( SplitIterable anIterable, Iterator<Object> anIterator )
		{
			theIterable		= anIterable;
			theIterator		= anIterator;
			the2ndIterator	= (new CWIterable( (Iterable<Object>) null )).Iterator();
		}

		public Boolean hasNext()
		{
			return the2ndIterator.hasNext() || theIterator.hasNext();
		}

		public Object next()
		{
			for (;;)
			{
				if ( the2ndIterator.hasNext() ) return the2ndIterator.next();
				if ( !theIterator.hasNext() ) break;
				the2ndIterator = (theIterable.transform( (String) theIterator.next() )).Iterator();
			}
			return null;
		}
	}

	/***********************************************************
					split method
	***********************************************************/

	private static final String whitespace = '\\s+';

	public static CWIterable split( String inputString, String regex, Integer maxSplits )
	{
		return new CWIterable
		(	(List<Object>)
			(	inputString == null		?	null
			:	maxSplits == null		?	inputString.split( regex != null ? regex : whitespace )
			:								inputString.split( regex != null ? regex : whitespace, maxSplits )
			)
//			, regex == null ? new IsNotBlank() : (CWPredicate) null
		);
	}

	public static CWIterable split( String inputString, String regex )
	{
		return split( inputString, regex, (Integer) null );
	}

	public static CWIterable split( String inputString, Integer maxSplits )
	{
		return split( inputString, (String) null, maxSplits );
	}

	public static CWIterable split( String inputString )
	{
		return split( inputString, (String) null, (Integer) null );
	}

	private class Split extends CWFunction
	{
		String		theRegex;
		Integer		theMaxSplits;

		public Split( String regex, Integer maxSplits )
		{
			theRegex		= regex;
			theMaxSplits	= maxSplits;
		}

		public override Object transform( Object theObject )
		{
			return split( (String) theObject, theRegex, theMaxSplits );
		}
	}

	private static CWIterable split( Iterable<String> inputStrings, String regex, Integer maxSplits )
	{
		return new SplitIterable( (Iterable<Object>) inputStrings, new Split( regex, maxSplits ) );
	}

	public static CWIterable split( CWIterable inputStrings, String regex, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, regex, maxSplits );
	}

	public static CWIterable split( CWIterable inputStrings, String regex )
	{
		return split( (Iterable<String>) inputStrings, regex, (Integer) null );
	}

	public static CWIterable split( CWIterable inputStrings, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, (String) null, maxSplits );
	}

	public static CWIterable split( CWIterable inputStrings )
	{
		return split( (Iterable<String>) inputStrings, (String) null, (Integer) null );
	}

	public static CWIterable split( List<String> inputStrings, String regex, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, regex, maxSplits );
	}

	public static CWIterable split( List<String> inputStrings, String regex )
	{
		return split( (Iterable<String>) inputStrings, regex, (Integer) null );
	}

	public static CWIterable split( List<String> inputStrings, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, (String) null, maxSplits );
	}

	public static CWIterable split( List<String> inputStrings )
	{
		return split( (Iterable<String>) inputStrings, (String) null, (Integer) null );
	}

	public static CWIterable split( Set<String> inputStrings, String regex, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, regex, maxSplits );
	}

	public static CWIterable split( Set<String> inputStrings, String regex )
	{
		return split( (Iterable<String>) inputStrings, regex, (Integer) null );
	}

	public static CWIterable split( Set<String> inputStrings, Integer maxSplits )
	{
		return split( (Iterable<String>) inputStrings, (String) null, maxSplits );
	}

	public static CWIterable split( Set<String> inputStrings )
	{
		return split( (Iterable<String>) inputStrings, (String) null, (Integer) null );
	}

	/***********************************************************
					splitByCharacterType method
	***********************************************************/

	public static CWIterable splitByCharacterType( String inputString )
	{
		return new CWIterable( (List<Object>) (inputString != null ? inputString.splitByCharacterType() : null) );
	}

	private class SplitByCharacterType extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return splitByCharacterType( (String) theObject );
		}
	}

	private static CWIterable splitByCharacterType( Iterable<String> inputStrings )
	{
		return new SplitIterable( (Iterable<Object>) inputStrings, new SplitByCharacterType() );
	}

	public static CWIterable splitByCharacterType( CWIterable inputStrings )
	{
		return splitByCharacterType( (Iterable<String>) inputStrings );
	}

	public static CWIterable splitByCharacterType( List<String> inputStrings )
	{
		return splitByCharacterType( (Iterable<String>) inputStrings );
	}

	public static CWIterable splitByCharacterType( Set<String> inputStrings )
	{
		return splitByCharacterType( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					splitByCharacterTypeCamelCase method
	***********************************************************/

	public static CWIterable splitByCharacterTypeCamelCase( String inputString )
	{
		return new CWIterable( (List<Object>) (inputString != null ? inputString.splitByCharacterTypeCamelCase() : null) );
	}

	private class SplitByCharacterTypeCamelCase extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return splitByCharacterTypeCamelCase( (String) theObject );
		}
	}

	private static CWIterable splitByCharacterTypeCamelCase( Iterable<String> inputStrings )
	{
		return new SplitIterable( (Iterable<Object>) inputStrings, new SplitByCharacterTypeCamelCase() );
	}

	public static CWIterable splitByCharacterTypeCamelCase( CWIterable inputStrings )
	{
		return splitByCharacterTypeCamelCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable splitByCharacterTypeCamelCase( List<String> inputStrings )
	{
		return splitByCharacterTypeCamelCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable splitByCharacterTypeCamelCase( Set<String> inputStrings )
	{
		return splitByCharacterTypeCamelCase( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					left method
	***********************************************************/

	public static String left( String inputString, Integer length )
	{
		return
			inputString == null		?	null
		:	length == null			?	inputString
		:	length <= 0				?	''
		:								inputString.left( length );
	}

	private class Left extends CWFunction
	{
		Integer	theLength;

		public Left( Integer length )
		{
			theLength = length;
		}

		public override Object transform( Object theObject )
		{
			return left( (String) theObject, theLength );
		}
	}

	private static CWIterable left( Iterable<String> inputStrings, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Left( length ) );
	}

	public static CWIterable left( CWIterable inputStrings, Integer length )
	{
		return left( (Iterable<String>) inputStrings, length );
	}

	public static CWIterable left( List<String> inputStrings, Integer length )
	{
		return left( (Iterable<String>) inputStrings, length );
	}

	public static CWIterable left( Set<String> inputStrings, Integer length )
	{
		return left( (Iterable<String>) inputStrings, length );
	}

	/***********************************************************
					mid method
	***********************************************************/

	public static String mid( String inputString, Integer startIndex, Integer length )
	{
		return
			inputString == null						?	null
		:	startIndex == null || length == null	?	inputString
		:	length <= 0								?	''
		:												inputString.mid( startIndex, length );
	}

	private class Mid extends CWFunction
	{
		Integer	theStartIndex;
		Integer	theLength;

		public Mid( Integer startIndex, Integer length )
		{
			theStartIndex	= startIndex;
			theLength		= length;
		}

		public override Object transform( Object theObject )
		{
			return mid( (String) theObject, theStartIndex, theLength );
		}
	}

	private static CWIterable mid( Iterable<String> inputStrings, Integer startIndex, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Mid( startIndex, length ) );
	}

	public static CWIterable mid( CWIterable inputStrings, Integer startIndex, Integer length )
	{
		return mid( (Iterable<String>) inputStrings, startIndex, length );
	}

	public static CWIterable mid( List<String> inputStrings, Integer startIndex, Integer length )
	{
		return mid( (Iterable<String>) inputStrings, startIndex, length );
	}

	public static CWIterable mid( Set<String> inputStrings, Integer startIndex, Integer length )
	{
		return mid( (Iterable<String>) inputStrings, startIndex, length );
	}

	/***********************************************************
					right method
	***********************************************************/

	public static String right( String inputString, Integer length )
	{
		return
			inputString == null		?	null
		:	length == null			?	inputString
		:	length <= 0				?	''
		:								inputString.right( length );
	}

	private class Right extends CWFunction
	{
		Integer	theLength;

		public Right( Integer length )
		{
			theLength = length;
		}

		public override Object transform( Object theObject )
		{
			return right( (String) theObject, theLength );
		}
	}

	private static CWIterable right( Iterable<String> inputStrings, Integer length )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Right( length ) );
	}

	public static CWIterable right( CWIterable inputStrings, Integer length )
	{
		return right( (Iterable<String>) inputStrings, length );
	}

	public static CWIterable right( List<String> inputStrings, Integer length )
	{
		return right( (Iterable<String>) inputStrings, length );
	}

	public static CWIterable right( Set<String> inputStrings, Integer length )
	{
		return right( (Iterable<String>) inputStrings, length );
	}

	/***********************************************************
					substring method
	***********************************************************/

	public static String substring( String inputString, Integer startIndex, Integer endIndex )
	{
		return
			inputString == null		?	null
		:	startIndex == null		?	inputString
		:	endIndex == null		?	inputString.substring( startIndex )
		:	endIndex <= startIndex	?	''
		:								inputString.substring( startIndex, endIndex );
	}

	public static String substring( String inputString, Integer startIndex )
	{
		return substring( inputString, startIndex, (Integer) null );
	}

	private class Substring extends CWFunction
	{
		Integer	theStartIndex;
		Integer	theEndIndex;

		public Substring( Integer startIndex, Integer endIndex )
		{
			theStartIndex	= startIndex;
			theEndIndex		= endIndex;
		}

		public override Object transform( Object theObject )
		{
			return substring( (String) theObject, theStartIndex, theEndIndex );
		}
	}

	private static CWIterable substring( Iterable<String> inputStrings, Integer startIndex, Integer endIndex )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Substring( startIndex, endIndex ) );
	}

	public static CWIterable substring( CWIterable inputStrings, Integer startIndex, Integer endIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, endIndex );
	}

	public static CWIterable substring( CWIterable inputStrings, Integer startIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, (Integer) null );
	}

	public static CWIterable substring( List<String> inputStrings, Integer startIndex, Integer endIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, endIndex );
	}

	public static CWIterable substring( List<String> inputStrings, Integer startIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, (Integer) null );
	}

	public static CWIterable substring( Set<String> inputStrings, Integer startIndex, Integer endIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, endIndex );
	}

	public static CWIterable substring( Set<String> inputStrings, Integer startIndex )
	{
		return substring( (Iterable<String>) inputStrings, startIndex, (Integer) null );
	}

	/***********************************************************
					substringAfter method
	***********************************************************/

	public static String substringAfter( String inputString, String separator )
	{
		return
			inputString == null		?	null
		:	separator == null		?	inputString
		:								inputString.substringAfter( separator );
	}

	private class SubstringAfter extends CWFunction
	{
		String	theSeparator;

		public SubstringAfter( String separator )
		{
			theSeparator	= separator;
		}

		public override Object transform( Object theObject )
		{
			return substringAfter( (String) theObject, theSeparator );
		}
	}

	private static CWIterable substringAfter( Iterable<String> inputStrings, String separator )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SubstringAfter( separator ) );
	}

	public static CWIterable substringAfter( CWIterable inputStrings, String separator )
	{
		return substringAfter( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringAfter( List<String> inputStrings, String separator )
	{
		return substringAfter( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringAfter( Set<String> inputStrings, String separator )
	{
		return substringAfter( (Iterable<String>) inputStrings, separator );
	}

	/***********************************************************
					substringAfterLast method
	***********************************************************/

	public static String substringAfterLast( String inputString, String separator )
	{
		return
			inputString == null		?	null
		:	separator == null		?	inputString
		:								inputString.substringAfterLast( separator );
	}

	private class SubstringAfterLast extends CWFunction
	{
		String	theSeparator;

		public SubstringAfterLast( String separator )
		{
			theSeparator	= separator;
		}

		public override Object transform( Object theObject )
		{
			return substringAfterLast( (String) theObject, theSeparator );
		}
	}

	private static CWIterable substringAfterLast( Iterable<String> inputStrings, String separator )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SubstringAfterLast( separator ) );
	}

	public static CWIterable substringAfterLast( CWIterable inputStrings, String separator )
	{
		return substringAfterLast( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringAfterLast( List<String> inputStrings, String separator )
	{
		return substringAfterLast( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringAfterLast( Set<String> inputStrings, String separator )
	{
		return substringAfterLast( (Iterable<String>) inputStrings, separator );
	}

	/***********************************************************
					substringBefore method
	***********************************************************/

	public static String substringBefore( String inputString, String separator )
	{
		return
			inputString == null		?	null
		:	separator == null		?	inputString
		:								inputString.substringBefore( separator );
	}

	private class SubstringBefore extends CWFunction
	{
		String	theSeparator;

		public SubstringBefore( String separator )
		{
			theSeparator	= separator;
		}

		public override Object transform( Object theObject )
		{
			return substringBefore( (String) theObject, theSeparator );
		}
	}

	private static CWIterable substringBefore( Iterable<String> inputStrings, String separator )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SubstringBefore( separator ) );
	}

	public static CWIterable substringBefore( CWIterable inputStrings, String separator )
	{
		return substringBefore( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringBefore( List<String> inputStrings, String separator )
	{
		return substringBefore( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringBefore( Set<String> inputStrings, String separator )
	{
		return substringBefore( (Iterable<String>) inputStrings, separator );
	}

	/***********************************************************
					substringBeforeLast method
	***********************************************************/

	public static String substringBeforeLast( String inputString, String separator )
	{
		return
			inputString == null		?	null
		:	separator == null		?	inputString
		:								inputString.substringBeforeLast( separator );
	}

	private class SubstringBeforeLast extends CWFunction
	{
		String	theSeparator;

		public SubstringBeforeLast( String separator )
		{
			theSeparator	= separator;
		}

		public override Object transform( Object theObject )
		{
			return substringBeforeLast( (String) theObject, theSeparator );
		}
	}

	private static CWIterable substringBeforeLast( Iterable<String> inputStrings, String separator )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SubstringBeforeLast( separator ) );
	}

	public static CWIterable substringBeforeLast( CWIterable inputStrings, String separator )
	{
		return substringBeforeLast( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringBeforeLast( List<String> inputStrings, String separator )
	{
		return substringBeforeLast( (Iterable<String>) inputStrings, separator );
	}

	public static CWIterable substringBeforeLast( Set<String> inputStrings, String separator )
	{
		return substringBeforeLast( (Iterable<String>) inputStrings, separator );
	}

	/***********************************************************
					substringBetween method
	***********************************************************/

	public static String substringBetween( String inputString, String open, String close )
	{
		return
			inputString == null					?	null
		:	open == null || close == null		?	inputString
		:											inputString.substringBetween( open, close );
	}

	public static String substringBetween( String inputString, String separator )
	{
		return
			inputString == null		?	null
		:	separator == null		?	inputString
		:								inputString.substringBetween( separator );
	}

	private class SubstringBetween extends CWFunction
	{
		String	theOpen;
		String	theClose;

		public SubstringBetween( String open, String close )
		{
			theOpen		= open;
			theClose	= close;
		}

		public override Object transform( Object theObject )
		{
			return
				theClose != null	?	substringBetween( (String) theObject, theOpen, theClose )
			:							substringBetween( (String) theObject, theOpen );
		}
	}

	private static CWIterable substringBetween( Iterable<String> inputStrings, String open, String close )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SubstringBetween( open, close ) );
	}

	public static CWIterable substringBetween( CWIterable inputStrings, String open, String close )
	{
		return substringBetween( (Iterable<String>) inputStrings, open, close );
	}

	public static CWIterable substringBetween( CWIterable inputStrings, String separator )
	{
		return substringBetween( (Iterable<String>) inputStrings, separator, (String) null );
	}

	public static CWIterable substringBetween( List<String> inputStrings, String open, String close )
	{
		return substringBetween( (Iterable<String>) inputStrings, open, close );
	}

	public static CWIterable substringBetween( List<String> inputStrings, String separator )
	{
		return substringBetween( (Iterable<String>) inputStrings, separator, (String) null );
	}

	public static CWIterable substringBetween( Set<String> inputStrings, String open, String close )
	{
		return substringBetween( (Iterable<String>) inputStrings, open, close );
	}

	public static CWIterable substringBetween( Set<String> inputStrings, String separator )
	{
		return substringBetween( (Iterable<String>) inputStrings, separator, (String) null );
	}

	/***********************************************************
					capitalize method
	***********************************************************/

	public static String capitalize( String inputString )
	{
		return inputString != null ? inputString.capitalize() : null;
	}

	private class Capitalize extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return capitalize( (String) theObject );
		}
	}

	private static CWIterable capitalize( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Capitalize() );
	}

	public static CWIterable capitalize( CWIterable inputStrings )
	{
		return capitalize( (Iterable<String>) inputStrings );
	}

	public static CWIterable capitalize( List<String> inputStrings )
	{
		return capitalize( (Iterable<String>) inputStrings );
	}

	public static CWIterable capitalize( Set<String> inputStrings )
	{
		return capitalize( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					toLowerCase method
	***********************************************************/

	public static String toLowerCase( String inputString )
	{
		return inputString != null ? inputString.toLowerCase() : null;
	}

	private class ToLowerCase extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return toLowerCase( (String) theObject );
		}
	}

	private static CWIterable toLowerCase( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ToLowerCase() );
	}

	public static CWIterable toLowerCase( CWIterable inputStrings )
	{
		return toLowerCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toLowerCase( List<String> inputStrings )
	{
		return toLowerCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toLowerCase( Set<String> inputStrings )
	{
		return toLowerCase( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					toUpperCase method
	***********************************************************/

	public static String toUpperCase( String inputString )
	{
		return inputString != null ? inputString.toUpperCase() : null;
	}

	private class ToUpperCase extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return toUpperCase( (String) theObject );
		}
	}

	private static CWIterable toUpperCase( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ToUpperCase() );
	}

	public static CWIterable toUpperCase( CWIterable inputStrings )
	{
		return toUpperCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toUpperCase( List<String> inputStrings )
	{
		return toUpperCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toUpperCase( Set<String> inputStrings )
	{
		return toUpperCase( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					swapCase method
	***********************************************************/

	public static String swapCase( String inputString )
	{
		return inputString != null ? inputString.swapCase() : null;
	}

	private class SwapCase extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return swapCase( (String) theObject );
		}
	}

	private static CWIterable swapCase( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new SwapCase() );
	}

	public static CWIterable swapCase( CWIterable inputStrings )
	{
		return swapCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable swapCase( List<String> inputStrings )
	{
		return swapCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable swapCase( Set<String> inputStrings )
	{
		return swapCase( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					uncapitalize method
	***********************************************************/

	public static String uncapitalize( String inputString )
	{
		return inputString != null ? inputString.uncapitalize() : null;
	}

	private class Uncapitalize extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return uncapitalize( (String) theObject );
		}
	}

	private static CWIterable uncapitalize( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Uncapitalize() );
	}

	public static CWIterable uncapitalize( CWIterable inputStrings )
	{
		return uncapitalize( (Iterable<String>) inputStrings );
	}

	public static CWIterable uncapitalize( List<String> inputStrings )
	{
		return uncapitalize( (Iterable<String>) inputStrings );
	}

	public static CWIterable uncapitalize( Set<String> inputStrings )
	{
		return uncapitalize( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					toTitleCase method
	***********************************************************/

	public static String toTitleCase( String inputString )
	{
		return inputString != null ? join( capitalize( toLowerCase( splitByCharacterTypeCamelCase( inputString ) ) ) ) : null;
	}

	private class ToTitleCase extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return toTitleCase( (String) theObject );
		}
	}

	private static CWIterable toTitleCase( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ToTitleCase() );
	}

	public static CWIterable toTitleCase( CWIterable inputStrings )
	{
		return toTitleCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toTitleCase( List<String> inputStrings )
	{
		return toTitleCase( (Iterable<String>) inputStrings );
	}

	public static CWIterable toTitleCase( Set<String> inputStrings )
	{
		return toTitleCase( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					trim method
	***********************************************************/

	public static String trim( String inputString )
	{
		return inputString != null ? inputString.trim() : null;
	}

	private class Trim extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return trim( (String) theObject );
		}
	}

	private static CWIterable trim( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Trim() );
	}

	public static CWIterable trim( CWIterable inputStrings )
	{
		return trim( (Iterable<String>) inputStrings );
	}

	public static CWIterable trim( List<String> inputStrings )
	{
		return trim( (Iterable<String>) inputStrings );
	}

	public static CWIterable trim( Set<String> inputStrings )
	{
		return trim( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					normalizeSpace method
	***********************************************************/

	public static String normalizeSpace( String inputString )
	{
		return inputString != null ? inputString.normalizeSpace() : null;
	}

	private class NormalizeSpace extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return normalizeSpace( (String) theObject );
		}
	}

	private static CWIterable normalizeSpace( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new NormalizeSpace() );
	}

	public static CWIterable normalizeSpace( CWIterable inputStrings )
	{
		return normalizeSpace( (Iterable<String>) inputStrings );
	}

	public static CWIterable normalizeSpace( List<String> inputStrings )
	{
		return normalizeSpace( (Iterable<String>) inputStrings );
	}

	public static CWIterable normalizeSpace( Set<String> inputStrings )
	{
		return normalizeSpace( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					deleteWhitespace method
	***********************************************************/

	public static String deleteWhitespace( String inputString )
	{
		return inputString != null ? inputString.deleteWhitespace() : null;
	}

	private class DeleteWhitespace extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return deleteWhitespace( (String) theObject );
		}
	}

	private static CWIterable deleteWhitespace( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new DeleteWhitespace() );
	}

	public static CWIterable deleteWhitespace( CWIterable inputStrings )
	{
		return deleteWhitespace( (Iterable<String>) inputStrings );
	}

	public static CWIterable deleteWhitespace( List<String> inputStrings )
	{
		return deleteWhitespace( (Iterable<String>) inputStrings );
	}

	public static CWIterable deleteWhitespace( Set<String> inputStrings )
	{
		return deleteWhitespace( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					remove method
	***********************************************************/

	public static String remove( String inputString, String removeString )
	{
		return
			inputString == null		?	null
		:	removeString == null	?	inputString
		:								inputString.remove( removeString );
	}

	private class Remove extends CWFunction
	{
		String	theRemoveString;

		public Remove( String removeString )
		{
			theRemoveString	= removeString;
		}

		public override Object transform( Object theObject )
		{
			return remove( (String) theObject, theRemoveString );
		}
	}

	private static CWIterable remove( Iterable<String> inputStrings, String removeString )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Remove( removeString ) );
	}

	public static CWIterable remove( CWIterable inputStrings, String removeString )
	{
		return remove( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable remove( List<String> inputStrings, String removeString )
	{
		return remove( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable remove( Set<String> inputStrings, String removeString )
	{
		return remove( (Iterable<String>) inputStrings, removeString );
	}

	/***********************************************************
					removeEnd method
	***********************************************************/

	public static String removeEnd( String inputString, String removeString )
	{
		return
			inputString == null		?	null
		:	removeString == null	?	inputString
		:								inputString.removeEnd( removeString );
	}

	private class RemoveEnd extends CWFunction
	{
		String	theRemoveString;

		public RemoveEnd( String removeString )
		{
			theRemoveString	= removeString;
		}

		public override Object transform( Object theObject )
		{
			return removeEnd( (String) theObject, theRemoveString );
		}
	}

	private static CWIterable removeEnd( Iterable<String> inputStrings, String removeString )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new RemoveEnd( removeString ) );
	}

	public static CWIterable removeEnd( CWIterable inputStrings, String removeString )
	{
		return removeEnd( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeEnd( List<String> inputStrings, String removeString )
	{
		return removeEnd( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeEnd( Set<String> inputStrings, String removeString )
	{
		return removeEnd( (Iterable<String>) inputStrings, removeString );
	}

	/***********************************************************
					removeEndIgnoreCase method
	***********************************************************/

	public static String removeEndIgnoreCase( String inputString, String removeString )
	{
		return
			inputString == null		?	null
		:	removeString == null	?	inputString
		:								inputString.removeEndIgnoreCase( removeString );
	}

	private class RemoveEndIgnoreCase extends CWFunction
	{
		String	theRemoveString;

		public RemoveEndIgnoreCase( String removeString )
		{
			theRemoveString	= removeString;
		}

		public override Object transform( Object theObject )
		{
			return removeEndIgnoreCase( (String) theObject, theRemoveString );
		}
	}

	private static CWIterable removeEndIgnoreCase( Iterable<String> inputStrings, String removeString )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new RemoveEndIgnoreCase( removeString ) );
	}

	public static CWIterable removeEndIgnoreCase( CWIterable inputStrings, String removeString )
	{
		return removeEndIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeEndIgnoreCase( List<String> inputStrings, String removeString )
	{
		return removeEndIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeEndIgnoreCase( Set<String> inputStrings, String removeString )
	{
		return removeEndIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	/***********************************************************
					removeStart method
	***********************************************************/

	public static String removeStart( String inputString, String removeString )
	{
		return
			inputString == null		?	null
		:	removeString == null	?	inputString
		:								inputString.removeStart( removeString );
	}

	private class RemoveStart extends CWFunction
	{
		String	theRemoveString;

		public RemoveStart( String removeString )
		{
			theRemoveString	= removeString;
		}

		public override Object transform( Object theObject )
		{
			return removeStart( (String) theObject, theRemoveString );
		}
	}

	private static CWIterable removeStart( Iterable<String> inputStrings, String removeString )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new RemoveStart( removeString ) );
	}

	public static CWIterable removeStart( CWIterable inputStrings, String removeString )
	{
		return removeStart( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeStart( List<String> inputStrings, String removeString )
	{
		return removeStart( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeStart( Set<String> inputStrings, String removeString )
	{
		return removeStart( (Iterable<String>) inputStrings, removeString );
	}

	/***********************************************************
					removeStartIgnoreCase method
	***********************************************************/

	public static String removeStartIgnoreCase( String inputString, String removeString )
	{
		return
			inputString == null		?	null
		:	removeString == null	?	inputString
		:								inputString.removeStartIgnoreCase( removeString );
	}

	private class RemoveStartIgnoreCase extends CWFunction
	{
		String	theRemoveString;

		public RemoveStartIgnoreCase( String removeString )
		{
			theRemoveString	= removeString;
		}

		public override Object transform( Object theObject )
		{
			return removeStartIgnoreCase( (String) theObject, theRemoveString );
		}
	}

	private static CWIterable removeStartIgnoreCase( Iterable<String> inputStrings, String removeString )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new RemoveStartIgnoreCase( removeString ) );
	}

	public static CWIterable removeStartIgnoreCase( CWIterable inputStrings, String removeString )
	{
		return removeStartIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeStartIgnoreCase( List<String> inputStrings, String removeString )
	{
		return removeStartIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	public static CWIterable removeStartIgnoreCase( Set<String> inputStrings, String removeString )
	{
		return removeStartIgnoreCase( (Iterable<String>) inputStrings, removeString );
	}

	/***********************************************************
					replace method
	***********************************************************/

	public static String replace( String inputString, String target, String replacement )
	{
		return
			inputString == null						?	null
		:	target == null || replacement == null	?	inputString
		:												inputString.replace( target, replacement );
	}

	private class Replace extends CWFunction
	{
		String	theTarget;
		String	theReplacement;

		public Replace( String target, String replacement )
		{
			theTarget		= target;
			theReplacement	= replacement;
		}

		public override Object transform( Object theObject )
		{
			return replace( (String) theObject, theTarget, theReplacement );
		}
	}

	private static CWIterable replace( Iterable<String> inputStrings, String target, String replacement )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Replace( target, replacement ) );
	}

	public static CWIterable replace( CWIterable inputStrings, String target, String replacement )
	{
		return replace( (Iterable<String>) inputStrings, target, replacement );
	}

	public static CWIterable replace( List<String> inputStrings, String target, String replacement )
	{
		return replace( (Iterable<String>) inputStrings, target, replacement );
	}

	public static CWIterable replace( Set<String> inputStrings, String target, String replacement )
	{
		return replace( (Iterable<String>) inputStrings, target, replacement );
	}

	/***********************************************************
					replaceAll method
	***********************************************************/

	public static String replaceAll( String inputString, String regex, String replacement )
	{
		return
			inputString == null						?	null
		:	regex == null || replacement == null	?	inputString
		:												inputString.replaceAll( regex, replacement );
	}

	private class ReplaceAll extends CWFunction
	{
		String	theRegex;
		String	theReplacement;

		public ReplaceAll( String regex, String replacement )
		{
			theRegex		= regex;
			theReplacement	= replacement;
		}

		public override Object transform( Object theObject )
		{
			return replaceAll( (String) theObject, theRegex, theReplacement );
		}
	}

	private static CWIterable replaceAll( Iterable<String> inputStrings, String regex, String replacement )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ReplaceAll( regex, replacement ) );
	}

	public static CWIterable replaceAll( CWIterable inputStrings, String regex, String replacement )
	{
		return replaceAll( (Iterable<String>) inputStrings, regex, replacement );
	}

	public static CWIterable replaceAll( List<String> inputStrings, String regex, String replacement )
	{
		return replaceAll( (Iterable<String>) inputStrings, regex, replacement );
	}

	public static CWIterable replaceAll( Set<String> inputStrings, String regex, String replacement )
	{
		return replaceAll( (Iterable<String>) inputStrings, regex, replacement );
	}

	/***********************************************************
					replaceMap method
	***********************************************************/

	public static String replaceMap( String inputString, Map<String,String> replacements )
	{
		if ( inputString == null ) return null;
		if ( replacements == null ) return inputString;

		for ( String regex : replacements.keySet() )
		{
			inputString = inputString.replaceAll( regex, replacements.get( regex ) );
		}

		return inputString;
	}

	private class ReplaceMap extends CWFunction
	{
		Map<String,String> theReplacements;

		public ReplaceMap( Map<String,String> replacements )
		{
			theReplacements	= replacements;
		}

		public override Object transform( Object theObject )
		{
			return replaceMap( (String) theObject, theReplacements );
		}
	}

	private static CWIterable replaceMap( Iterable<String> inputStrings, Map<String,String> replacements )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ReplaceMap( replacements ) );
	}

	public static CWIterable replaceMap( CWIterable inputStrings, Map<String,String> replacements )
	{
		return replaceMap( (Iterable<String>) inputStrings, replacements );
	}

	public static CWIterable replaceMap( List<String> inputStrings, Map<String,String> replacements )
	{
		return replaceMap( (Iterable<String>) inputStrings, replacements );
	}

	public static CWIterable replaceMap( Set<String> inputStrings, Map<String,String> replacements )
	{
		return replaceMap( (Iterable<String>) inputStrings, replacements );
	}

	/***********************************************************
					replaceFirst method
	***********************************************************/

	public static String replaceFirst( String inputString, String regex, String replacement )
	{
		return
			inputString == null						?	null
		:	regex == null || replacement == null	?	inputString
		:												inputString.replaceFirst( regex, replacement );
	}

	private class ReplaceFirst extends CWFunction
	{
		String	theRegex;
		String	theReplacement;

		public ReplaceFirst( String regex, String replacement )
		{
			theRegex		= regex;
			theReplacement	= replacement;
		}

		public override Object transform( Object theObject )
		{
			return replaceFirst( (String) theObject, theRegex, theReplacement );
		}
	}

	private static CWIterable replaceFirst( Iterable<String> inputStrings, String regex, String replacement )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new ReplaceFirst( regex, replacement ) );
	}

	public static CWIterable replaceFirst( CWIterable inputStrings, String regex, String replacement )
	{
		return replaceFirst( (Iterable<String>) inputStrings, regex, replacement );
	}

	public static CWIterable replaceFirst( List<String> inputStrings, String regex, String replacement )
	{
		return replaceFirst( (Iterable<String>) inputStrings, regex, replacement );
	}

	public static CWIterable replaceFirst( Set<String> inputStrings, String regex, String replacement )
	{
		return replaceFirst( (Iterable<String>) inputStrings, regex, replacement );
	}

	/***********************************************************
					escapeSingleQuotes method
	***********************************************************/

	public static String escapeSingleQuotes( String inputString )
	{
		return inputString != null ? String.escapeSingleQuotes( inputString ) : null;
	}

	private class EscapeSingleQuotes extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeSingleQuotes( (String) theObject );
		}
	}

	private static CWIterable escapeSingleQuotes( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeSingleQuotes() );
	}

	public static CWIterable escapeSingleQuotes( CWIterable inputStrings )
	{
		return escapeSingleQuotes( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeSingleQuotes( List<String> inputStrings )
	{
		return escapeSingleQuotes( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeSingleQuotes( Set<String> inputStrings )
	{
		return escapeSingleQuotes( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					escapeCsv method
	***********************************************************/

	public static String escapeCsv( String inputString )
	{
		return inputString != null ? inputString.escapeCsv() : null;
	}

	private class EscapeCsv extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeCsv( (String) theObject );
		}
	}

	private static CWIterable escapeCsv( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeCsv() );
	}

	public static CWIterable escapeCsv( CWIterable inputStrings )
	{
		return escapeCsv( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeCsv( List<String> inputStrings )
	{
		return escapeCsv( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeCsv( Set<String> inputStrings )
	{
		return escapeCsv( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					escapeEcmaScript method
	***********************************************************/

	public static String escapeEcmaScript( String inputString )
	{
		return inputString != null ? inputString.escapeEcmaScript() : null;
	}

	private class EscapeEcmaScript extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeEcmaScript( (String) theObject );
		}
	}

	private static CWIterable escapeEcmaScript( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeEcmaScript() );
	}

	public static CWIterable escapeEcmaScript( CWIterable inputStrings )
	{
		return escapeEcmaScript( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeEcmaScript( List<String> inputStrings )
	{
		return escapeEcmaScript( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeEcmaScript( Set<String> inputStrings )
	{
		return escapeEcmaScript( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					escapeHtml3 method
	***********************************************************/

	public static String escapeHtml3( String inputString )
	{
		return inputString != null ? inputString.escapeHtml3() : null;
	}

	private class EscapeHtml3 extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeHtml3( (String) theObject );
		}
	}

	private static CWIterable escapeHtml3( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeHtml3() );
	}

	public static CWIterable escapeHtml3( CWIterable inputStrings )
	{
		return escapeHtml3( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeHtml3( List<String> inputStrings )
	{
		return escapeHtml3( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeHtml3( Set<String> inputStrings )
	{
		return escapeHtml3( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					escapeHtml4 method
	***********************************************************/

	public static String escapeHtml4( String inputString )
	{
		return inputString != null ? inputString.escapeHtml4() : null;
	}

	private class EscapeHtml4 extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeHtml4( (String) theObject );
		}
	}

	private static CWIterable escapeHtml4( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeHtml4() );
	}

	public static CWIterable escapeHtml4( CWIterable inputStrings )
	{
		return escapeHtml4( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeHtml4( List<String> inputStrings )
	{
		return escapeHtml4( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeHtml4( Set<String> inputStrings )
	{
		return escapeHtml4( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					escapeXml method
	***********************************************************/

	public static String escapeXml( String inputString )
	{
		return inputString != null ? inputString.escapeXml() : null;
	}

	private class EscapeXml extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return escapeXml( (String) theObject );
		}
	}

	private static CWIterable escapeXml( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new EscapeXml() );
	}

	public static CWIterable escapeXml( CWIterable inputStrings )
	{
		return escapeXml( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeXml( List<String> inputStrings )
	{
		return escapeXml( (Iterable<String>) inputStrings );
	}

	public static CWIterable escapeXml( Set<String> inputStrings )
	{
		return escapeXml( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					unescapeCsv method
	***********************************************************/

	public static String unescapeCsv( String inputString )
	{
		return inputString != null ? inputString.unescapeCsv() : null;
	}

	private class UnescapeCsv extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return unescapeCsv( (String) theObject );
		}
	}

	private static CWIterable unescapeCsv( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new UnescapeCsv() );
	}

	public static CWIterable unescapeCsv( CWIterable inputStrings )
	{
		return unescapeCsv( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeCsv( List<String> inputStrings )
	{
		return unescapeCsv( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeCsv( Set<String> inputStrings )
	{
		return unescapeCsv( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					unescapeEcmaScript method
	***********************************************************/

	public static String unescapeEcmaScript( String inputString )
	{
		return inputString != null ? inputString.unescapeEcmaScript() : null;
	}

	private class UnescapeEcmaScript extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return unescapeEcmaScript( (String) theObject );
		}
	}

	private static CWIterable unescapeEcmaScript( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new UnescapeEcmaScript() );
	}

	public static CWIterable unescapeEcmaScript( CWIterable inputStrings )
	{
		return unescapeEcmaScript( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeEcmaScript( List<String> inputStrings )
	{
		return unescapeEcmaScript( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeEcmaScript( Set<String> inputStrings )
	{
		return unescapeEcmaScript( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					unescapeHtml3 method
	***********************************************************/

	public static String unescapeHtml3( String inputString )
	{
		return inputString != null ? inputString.unescapeHtml3() : null;
	}

	private class UnescapeHtml3 extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return unescapeHtml3( (String) theObject );
		}
	}

	private static CWIterable unescapeHtml3( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new UnescapeHtml3() );
	}

	public static CWIterable unescapeHtml3( CWIterable inputStrings )
	{
		return unescapeHtml3( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeHtml3( List<String> inputStrings )
	{
		return unescapeHtml3( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeHtml3( Set<String> inputStrings )
	{
		return unescapeHtml3( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					unescapeHtml4 method
	***********************************************************/

	public static String unescapeHtml4( String inputString )
	{
		return inputString != null ? inputString.unescapeHtml4() : null;
	}

	private class UnescapeHtml4 extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return unescapeHtml4( (String) theObject );
		}
	}

	private static CWIterable unescapeHtml4( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new UnescapeHtml4() );
	}

	public static CWIterable unescapeHtml4( CWIterable inputStrings )
	{
		return unescapeHtml4( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeHtml4( List<String> inputStrings )
	{
		return unescapeHtml4( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeHtml4( Set<String> inputStrings )
	{
		return unescapeHtml4( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					unescapeXml method
	***********************************************************/

	public static String unescapeXml( String inputString )
	{
		return inputString != null ? inputString.unescapeXml() : null;
	}

	private class UnescapeXml extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return unescapeXml( (String) theObject );
		}
	}

	private static CWIterable unescapeXml( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new UnescapeXml() );
	}

	public static CWIterable unescapeXml( CWIterable inputStrings )
	{
		return unescapeXml( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeXml( List<String> inputStrings )
	{
		return unescapeXml( (Iterable<String>) inputStrings );
	}

	public static CWIterable unescapeXml( Set<String> inputStrings )
	{
		return unescapeXml( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					stripHtmltags method
	***********************************************************/

	public static String stripHtmltags( String inputString )
	{
		return inputString != null ? inputString.stripHtmltags() : null;
	}

	private class StripHtmltags extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return stripHtmltags( (String) theObject );
		}
	}

	private static CWIterable stripHtmltags( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new StripHtmltags() );
	}

	public static CWIterable stripHtmltags( CWIterable inputStrings )
	{
		return stripHtmltags( (Iterable<String>) inputStrings );
	}

	public static CWIterable stripHtmltags( List<String> inputStrings )
	{
		return stripHtmltags( (Iterable<String>) inputStrings );
	}

	public static CWIterable stripHtmltags( Set<String> inputStrings )
	{
		return stripHtmltags( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					scrub method
	***********************************************************/

	public static String scrub( String inputString )
	{
		return String.escapeSingleQuotes( inputString ).replaceAll( '%', '\\\\%' ).replaceAll( '_', '\\\\_' );
	}

	private class Scrub extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return scrub( (String) theObject );
		}
	}

	private static CWIterable scrub( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Scrub() );
	}

	public static CWIterable scrub( CWIterable inputStrings )
	{
		return scrub( (Iterable<String>) inputStrings );
	}

	public static CWIterable scrub( List<String> inputStrings )
	{
		return scrub( (Iterable<String>) inputStrings );
	}

	public static CWIterable scrub( Set<String> inputStrings )
	{
		return scrub( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					reverse method
	***********************************************************/

	public static String reverse( String inputString )
	{
		return inputString != null ? inputString.reverse() : null;
	}

	private class Reverse extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return reverse( (String) theObject );
		}
	}

	private static CWIterable reverse( Iterable<String> inputStrings )
	{
		return new CWIterable( (Iterable<Object>) inputStrings, new Reverse() );
	}

	public static CWIterable reverse( CWIterable inputStrings )
	{
		return reverse( (Iterable<String>) inputStrings );
	}

	public static CWIterable reverse( List<String> inputStrings )
	{
		return reverse( (Iterable<String>) inputStrings );
	}

	public static CWIterable reverse( Set<String> inputStrings )
	{
		return reverse( (Iterable<String>) inputStrings );
	}

	/***********************************************************
					valueOf method
	***********************************************************/

	public static String valueOf( Object inputObject )
	{
		return inputObject != null ? String.valueOf( inputObject ) : null;
	}

	private class ValueOf extends CWFunction
	{
		public override Object transform( Object theObject )
		{
			return valueOf( theObject );
		}
	}

	private static CWIterable valueOf( Iterable<Object> inputObjects )
	{
		return new CWIterable( (Iterable<Object>) inputObjects, new ValueOf() );
	}

	public static CWIterable valueOf( CWIterable inputObjects )
	{
		return valueOf( (Iterable<Object>) inputObjects );
	}

	public static CWIterable valueOf( List<Object> inputObjects )
	{
		return valueOf( (Iterable<Object>) inputObjects );
	}

	public static CWIterable valueOf( Set<Object> inputObjects )
	{
		return valueOf( (Iterable<Object>) inputObjects );
	}

	/***********************************************************
					fileSize method
	***********************************************************/

	private static List<String> sizeSuffixes
	{
		get
		{
			if ( sizeSuffixes == null )
			{
				sizeSuffixes = new List<String>{ ' Bytes', ' KB', ' MB', ' GB', ' TB', ' PB' };
			}
			return sizeSuffixes;
		}
	}

	public static String fileSize( Decimal fileBytes )
	{
		fileBytes = fileBytes.round( System.RoundingMode.DOWN );

		Integer	precision	= 0;
		Decimal	multipleOfK	= 1;
		Decimal	nextK		= 1024;
		String	suffix;

		for ( String aSuffix : sizeSuffixes )
		{
			suffix = aSuffix;

			if ( fileBytes < nextK ) break;

			precision	= 2;
			multipleOfK	= nextK;
			nextK		*= 1024;
		}

		return String.valueOf( fileBytes.divide( multipleOfK, precision, System.RoundingMode.HALF_UP ) ) + suffix;
	}

	public static String fileSize( Double fileBytes )
	{
		return fileSize( Decimal.valueOf( fileBytes ) );
	}

	public static String fileSize( Long fileBytes )
	{
		return fileSize( Decimal.valueOf( fileBytes ) );
	}

	public static String fileSize( Integer fileBytes )
	{
		return fileSize( Decimal.valueOf( fileBytes ) );
	}

	/***********************************************************
					random method
	***********************************************************/

	public static String random()
	{
		return String.valueOf( Math.random() ).substringAfter( '.' );
	}
}