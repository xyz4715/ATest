/*******************************************************//**

@class		CWAutoFormat

@brief		CW Core AutoFormat Functionality

	This implements auto-format functionality for use with
	<apex:inputText> elements in Visualforce pages.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-01-08	LiquidHub.GHA
	Created.
@version	2015-01-12	LiquidHub.GHA
	Mostly complete version.
@version	2015-01-13	LiquidHub.GHA
	Complete version.  Added 'change' function parameter.

@see		DemoAutoFormat.page

	(c)2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

/***********************************************************
			CWAutoFormat module

parameters:
***********************************************************/

function CWAutoFormat( moduleParameters )
{
	if ( !moduleParameters || typeof( moduleParameters ) !== 'object' ) moduleParameters = {};

var	/* Object	*/	module	= {},
	/* Object	*/	codes,				//	map of codes - characters used in patterns
	/* Element	*/	input,				//	the input element to auto-format
	/* String	*/	pattern,			//	the pattern to format against
	/* String	*/	patternChars,		//	array of characters of the pattern
	/* String	*/	hint,				//	the hint string
	/* String	*/	userInput,			//	characters the user has actually entered
	/* Integer	*/	maxLength,			//	maximum number of characters allowed in userInput
	/* Function	*/	change,				//	function to call when the input value changes

	/*******************************************************
					inputKeyDown function

	Detects a key that could modify the input value and validates
	it against the pattern.  Also handles navigation within the
	text.
	*******************************************************/

	inputKeyDown = function( event )
	{
		event = event || window.event;
		if ( event.keyCode == 9 ) return true;
		event.preventDefault();

		if ( event.alkKey || event.ctrlKey ) return true;

	var	keyCode = event.keyCode,
		inputIndex, cursorPosition, newChar, code;

		if	(	keyCode == 35 || keyCode == 40	)		//	end, down arrow
		{
			setCursorPosition( getMaxCursorPosition() );
		}

		if	(	keyCode == 36 || keyCode == 38	)		//	home, up arrow
		{
			setCursorPosition( 0 );
		}

		cursorPosition = getCursorPosition();

		if	(	keyCode == 37	)		//	left arrow
		{
			setCursorPosition( cursorPosition > 0 ? cursorPosition - 1 : 0 );
		}

		if	(	keyCode == 39	)		//	right arrow
		{
			setCursorPosition( cursorPosition < getMaxCursorPosition() ? cursorPosition + 1 : getMaxCursorPosition() );
		}

		if	(	keyCode ==  8	)		//	backspace
		{
			if ( cursorPosition > 0 )
			{
				setCursorPosition( --cursorPosition );
				if ( codes[ patternChars[ cursorPosition ] ] )
				{
					inputIndex = getInputIndex( cursorPosition );
					userInput = userInput.substring( 0, inputIndex ) + userInput.substring( inputIndex + 1 );
					setCursorPosition( formatInput( inputIndex, true ) );
				}
			}
		}

		if	(	keyCode == 46	)		//	delete
		{
			if ( cursorPosition < patternChars.length )
			{
				setCursorPosition( cursorPosition + 1 );
				if ( codes[ patternChars[ cursorPosition ] ] )
				{
					inputIndex = getInputIndex( cursorPosition );
					userInput = userInput.substring( 0, inputIndex ) + userInput.substring( inputIndex + 1 );
					setCursorPosition( formatInput( inputIndex, true ) );
				}
			}
		}

		if	(	keyCode == 32							//	space
			||	( 48 <= keyCode && keyCode <=  57)		//	0-9
			||	keyCode == 59							//	;: (FireFox only)
			||	keyCode == 61							//	=+ (FireFox only)
			||	( 65 <= keyCode && keyCode <=  90)		//	A-Z
			||	( 96 <= keyCode && keyCode <= 111)		//	numpad keys 0-9
			||	(186 <= keyCode && keyCode <= 192)		//	;: =+ ,< -_ .> /? `~
			||	(219 <= keyCode && keyCode <= 222)		//	[{ \| ]} '"
			)
		{
			if ( userInput.length >= maxLength ) return false;
			while ( cursorPosition < patternChars.length )
			{
				code = codes[ patternChars[ cursorPosition ] ];
				if ( code ) break;
				cursorPosition++;
			}
			if ( cursorPosition >= patternChars.length ) return false;
			newChar = charFromKeyCode( keyCode, event.shiftKey );
			if ( !code.test( newChar ) ) return false;
			inputIndex = getInputIndex( cursorPosition );
			userInput = userInput.substring( 0, inputIndex ) + newChar + userInput.substring( inputIndex );
			setCursorPosition( formatInput( inputIndex + 1, true ) );
		}

		if ( change ) change( input );
		return true;
	},

	/*******************************************************
					getInputIndex function

	Returns the index into 'userInput' that corresponds to
	the given cursor position.
	*******************************************************/

	getInputIndex = function( position )
	{
	var	valueIndex, inputIndex = 0;

		for ( valueIndex = 0; valueIndex < position; valueIndex++ )
		{
			if ( codes[ patternChars[ valueIndex ] ] ) inputIndex++;
		}
		return Math.min( inputIndex, userInput.length );
	},

	/*******************************************************
					getMaxCursorPosition function

	Returns the maximum cursor position based on the input so far.
	*******************************************************/

	getMaxCursorPosition = function()
	{
	var	valueIndex, inputIndex = 0;

		for ( valueIndex = 0; inputIndex < userInput.length; valueIndex++ )
		{
			if ( codes[ patternChars[ valueIndex ] ] ) inputIndex++;
		}
		while ( valueIndex < patternChars.length && !codes[ patternChars[ valueIndex ] ] ) valueIndex++;
		return valueIndex;
	},

	/*******************************************************
					keyCode conversion strings

	These strings are used to map keyCodes to characters.
	*******************************************************/

	lower = '0123456789_;_=___abcdefghijklmnopqrstuvwxyz_____0123456789',
	upper = ')!@#$%^&*(_:_+___ABCDEFGHIJKLMNOPQRSTUVWXYZ_____0123456789',
	punctLower = ';=,-./`',
	punctUpper = ':+<_>?~',
	braceLower = "[\\]'",
	braceUpper = '{|}"',

	/*******************************************************
					charFromKeyCode function

	Returns the character that corresponds to the given keyCode
	with the given shift key state applied.
	*******************************************************/

	charFromKeyCode = function( keyCode, shift )
	{
		if	(	keyCode == 32
			)
		{
			return ' ';
		}
		if	(	( 48 <= keyCode && keyCode <=  57)		//	0-9
			||	keyCode == 59							//	;: (FireFox only)
			||	keyCode == 61							//	=+ (FireFox only)
			||	( 65 <= keyCode && keyCode <=  90)		//	A-Z
			||	( 96 <= keyCode && keyCode <= 111)		//	numpad keys 0-9
			)
		{
			return (shift ? upper : lower).substring( keyCode - 48, keyCode - 47 );
		}
		if	(	(186 <= keyCode && keyCode <= 192)		//	;: =+ ,< -_ .> /? `~
			)
		{
			return (shift ? punctUpper : punctLower).substring( keyCode - 186, keyCode - 185 );
		}
		if	(	(219 <= keyCode && keyCode <= 222)		//	[{ \| ]} '"
			)
		{
			return (shift ? braceUpper : braceLower).substring( keyCode - 186, keyCode - 185 );
		}
		return '';
	},

	/*******************************************************
					formatInput function

	Populates the value of the input by combining the 'userInput'
	with the pattern string and optionally appending the remainder
	of the hint string, if 'addHint' is true.
	*******************************************************/

	formatInput = function( cursorIndex, addHint )
	{
	var	inputChars = userInput.split( '' ),
		outputString = '',
		inputIndex, patternIndex, cursorPosition;

		inputIndex = 0;
		for ( patternIndex = 0; inputIndex < inputChars.length; patternIndex++ )
		{
			outputString += codes[ patternChars[ patternIndex ] ] ? inputChars[ inputIndex++ ] : patternChars[ patternIndex ];
			if ( cursorIndex == inputIndex )
			{
				cursorPosition = patternIndex + 1;
			}
		}
		while ( cursorPosition < patternChars.length && !codes[ patternChars[ cursorPosition ] ] ) cursorPosition++;
		input.value = outputString + (addHint ? hint.substring( outputString.length ) : '');
		return cursorPosition;
	},

	/*******************************************************
					getCursorPosition function

	Returns the cursor position within the input text.
	*******************************************************/

	getCursorPosition = function()
	{
		if ( typeof input.selectionStart == 'number' ) return input.selectionStart;
		return Math.abs( document.selection.createRange().moveStart( 'character', -input.value.length ) );
	},

	/*******************************************************
					setCursorPosition function

	Moves the cursor to a position within the input text.
	*******************************************************/

	setCursorPosition = function( cursorPosition )
	{
		if ( typeof input.selectionStart == 'number' )
		{
			input.setSelectionRange( cursorPosition, cursorPosition );
		}
		else
		{
		var	range = input.createTextRange();
			range.move( 'character', cursorPosition );
			range.select();
		}
	},

	/*******************************************************
					inputBlur function

	On blur, formats the user input into the input, without the
	hint string.
	*******************************************************/

	inputBlur = function( event )
	{
		formatInput( getInputIndex( getCursorPosition() ), false );
		if ( change ) change( input );
	},

	/*******************************************************
					inputClick function

	On click, ensures that the cursor is in a valid position.
	*******************************************************/

	inputClick = function( event )
	{
		setCursorPosition( formatInput( getInputIndex( getCursorPosition() ), true ) );
	},

	endOfVars;

	/*******************************************************
					module.focus function

	arguments:
		event				Object
		focusParameters		Object
	*******************************************************/

	module.focus = function( event, focusParameters )
	{
		event			= (event || window.event);
		hasFocus		= true;

		if ( !focusParameters || typeof( focusParameters ) !== 'object' ) focusParameters = {};

		input			= event.target;
		input.addEventListener( 'keydown', inputKeyDown, false );
		input.addEventListener( 'blur', inputBlur, false );
		input.addEventListener( 'click', inputClick, false );

		pattern			= typeof( focusParameters.pattern ) === 'string' ? focusParameters.pattern : '';
		hint			= typeof( focusParameters.hint ) === 'string' ? focusParameters.hint : '';
		if ( !hint ) hint = pattern;
		change	= typeof( focusParameters.change ) === 'function' ? focusParameters.change : null;

		patternChars	= pattern.split( '' );
		userInput		= '';
		maxLength		= 0;

	var	patternIndex;
		for ( patternIndex = 0; patternIndex < pattern.length; patternIndex++ )
		{
			if ( codes[ patternChars[ patternIndex ] ] ) maxLength++;
		}
		for ( patternIndex = 0; patternIndex < input.value.length; patternIndex++ )
		{
			if ( codes[ patternChars[ patternIndex ] ] ) userInput += input.value.substring( patternIndex, patternIndex + 1 );
		}
		setCursorPosition( formatInput( userInput.length, true ) );
		if ( change ) change( input );
	};

	/*******************************************************
					module initialization
	*******************************************************/

	codes = typeof( moduleParameters.codes ) === 'object' ? moduleParameters.codes : {};

	return module;
};
