/*******************************************************//**

@class		CWAutoComplete

@brief		CW Core AutoComplete Functionality

	This implements auto-complete functionality for use with
	<apex:inputText> elements in Visualforce pages.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2013-??-??	LiquidHub.GHA
	Created.
@version	2014-11-21	LiquidHub.GHA
	Refactored to use namespace pattern with parameters object.
@version	2014-11-23	LiquidHub.GHA
	Enabled use of keyboard to select options.
@version	2014-11-24	LiquidHub.GHA
	Added support for style classes.

@see		DemoAutoComplete.page

	(c)2013-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

/***********************************************************
			CWAutoComplete module

parameters:
	size			Number		the number of options displayed in the select window (optional, default = 6)
	width			String		the width of the select window (optional)
	top				Number		the pixel offset for the top of the select window (optional, default = 0)
	left			Number		the pixel offset for the left of the select window (optional, default = 0)
	zIndex			Number		the zIndex for the select window (optional, default = 100)
	showAllOptions	Boolean		will show all options if the input has focus but no contents (optional, default = false)
	autoSelect		Boolean		if only one option remains, it is automatically selected (optional, default = false)
	multiMatch		Boolean		will split input on whitespace and match each part separately (optional, default = false)
	regExp			RegExp		regular expression used to filter options (optional)
	selectFunction	Function	function called when a selection is made (optional)
	selectClass		String		CSS class(es) with which to style the SELECT element
	optionClass		String		CSS class(es) with which to style the OPTION elements
***********************************************************/

function CWAutoComplete( moduleParameters )
{
	if ( !moduleParameters || typeof( moduleParameters ) != 'object' ) moduleParameters = {};

var	/* Object	*/	module				= {},
	/* Integer	*/	defaultSize			= 6,
	/* Integer	*/	defaultZIndex		= 100,

	/* Element	*/	input,				//	the input element to auto-complete
	/* Element	*/	selectSource,		//	the source select element
	/* Element	*/	select,				//	the dynamic select element
	/* Boolean	*/	hasFocus,			//	true if select or input has focus
	/* Boolean	*/	autoSelect,			//	true if only option should be automatically selected
	/* Boolean	*/	multiMatch,			//	true if input should be split and matched separately
	/* RegExp	*/	filterRegExp,		//	optional RegExp used to filter options before comparing
	/* Function	*/	selectFunction,		//	this is called when an option is selected
	/* String	*/	selectClass,		//	class(es) for SELECT elements
	/* String	*/	optionClass,		//	class(es) for OPTION elements

	/*******************************************************
						blur function

	Called when the INPUT or SELECT loses focus.  If, after a
	short delay, the INPUT/SELECT has still lost focus, copies
	the selected OPTION to the INPUT and destroys the SELECT.
	*******************************************************/

	blur = function()
	{
	var	/* Element	*/	blurInput			= input,
		/* Element	*/	blurSelect			= select,
		/* Function	*/	blurSelectFunction	= selectFunction;

		setTimeout
		(	function()
			{
				if ( hasFocus && blurInput === input ) return;
				if ( blurSelect.selectedIndex >= 0 )
				{
					blurInput.value		= blurSelect.options[ blurSelect.selectedIndex ].innerHTML;
					if ( blurSelectFunction ) blurSelectFunction( blurSelect.options[ blurSelect.selectedIndex ].value );
				}
			var	blurDiv					= blurSelect.parentNode;
				if ( blurDiv.parentNode ) blurDiv.parentNode.removeChild( blurDiv );
				if ( !hasFocus ) input = select = null;
			},
			50
		);
		hasFocus	= false;
	},

	/*******************************************************
					refreshOptions function

	Adds qualifying OPTIONs to the SELECT.
	*******************************************************/

	refreshOptions = function()
	{
	var	/* String	*/	escapedInput	= input.value.replace( /^\s+|\s+$/g, '' ).replace( /([.*+?^=!:${}()|[\]\/\\])/g, '\\$1' ),
		/* RegExp	*/	toMatch			= new RegExp( '^' + escapedInput + '| ' + escapedInput, 'i' ),
		/* Integer	*/	optionIndex,
		/* String	*/	optionValue;

		select.selectedIndex	= -1;
		while ( select.lastChild ) select.removeChild( select.lastChild );

		if ( !showAllOptions && escapedInput.length == 0 )
		{
			select.style.display	= 'none';
			return;
		}

		for ( optionIndex = 0; optionIndex < selectSource.options.length; optionIndex++ )
		{
		var	option					= selectSource.options[ optionIndex ];
			optionLabel				= option.innerHTML;
			if ( filterRegExp ) optionLabel = optionLabel.match( filterRegExp )[0];

			if ( multiMatch )
			{
			var	parts = escapedInput.split( /\s+/ ), i, matches = true;
				for ( i = 0; i < parts.length; i++ )
				{
				var	toMatch = new RegExp( '^' + parts[ i ] + '|\\s+' + parts[ i ], 'i' );
					if ( !toMatch.test( optionLabel ) ) { matches = false; break; }
				}
				if ( !matches ) continue;
			}
			else if ( !toMatch.test( optionLabel ) ) continue;

		var	newOption				= document.createElement( "OPTION" );
			newOption.innerHTML		= option.innerHTML;
			newOption.value			= option.value;
			newOption.selected		= false;
			newOption.className		= (optionClass + ' ' + (option.className || '')).replace( /^\s+|\s+$/g, '' );
			newOption.style.display	= 'block';
			select.appendChild( newOption );
		}

		if ( autoSelect && select.options.length == 1 ) input.value = select.options[0].innerHTML;
		select.style.display		= select.options.length > (autoSelect ? 1 : 0) ? 'inline' : 'none';
	},

	/*******************************************************
					inputKeyUp function

	Detects a key that could modify the input value and refreshes
	the options based on the new input value.
	*******************************************************/

	inputKeyUp = function( event )
	{
	var	keyCode		= (event || window.event).keyCode;
		if	(	keyCode ==  8							//	backspace
			||	keyCode == 32							//	space
			||	keyCode == 46							//	delete
			||	( 48 <= keyCode && keyCode <=  57)		//	0-9
			||	keyCode == 59							//	;: (FireFox only)
			||	keyCode == 61							//	=+ (FireFox only)
			||	( 65 <= keyCode && keyCode <=  90)		//	A-Z
			||	( 96 <= keyCode && keyCode <= 111)		//	numpad keys
			||	(186 <= keyCode && keyCode <= 192)		//	;: =+ ,< -_ .> /? `~
			||	(219 <= keyCode && keyCode <= 222)		//	[{ \| ]} '"
			)
		{
			refreshOptions();
		}
	},

	/*******************************************************
					inputKeyDown function

	Detects down-arrow and gives focus to the SELECT element.
	*******************************************************/

	inputKeyDown = function( event )
	{
		if ( (event || window.event).keyCode == 40 /* Down Arrow */ )
		{
			select.selectedIndex = 0;
			select.focus();
		}
	},

	/*******************************************************
					selectFocus function

	Retains focus when the SELECT gets focus.
	*******************************************************/

	selectFocus = function( event )
	{
		hasFocus	= select === (event || window.event).target;
	},

	/*******************************************************
					selectClick function

	Selects the OPTION that was clicked.
	*******************************************************/

	selectClick = function( event )
	{
		if ( select.selectedIndex >= 0 ) select.blur();
	},

	/*******************************************************
					selectKeyUp function

	When the SELECT has focus and ENTER is pressed, this copies
	the selected value to the INPUT and hides the SELECT.
	*******************************************************/

	selectKeyUp = function( event )
	{
		event					= (event || window.event);
		if ( event.keyCode == 13 /* ENTER */ && select.selectedIndex >= 0	)	select.blur();
		else if ( event.keyCode == 27 /* ESC key */							)	input.focus();
	},

	endOfVars;

	/*******************************************************
					module.focus function

	arguments:
		selectId			String		the ID of the select tag to use (required)
		focusParameters		Object		optional parameters
			(Any moduleParameters may be overridden by focusParameters)
	*******************************************************/

	module.focus = function( event, selectId, focusParameters )
	{
		event					= (event || window.event);
		hasFocus				= true;

		if ( input === event.target )
		{
			select.selectedIndex = -1;
			return;
		}

		if ( select )
		{
			if ( select.selectedIndex >= 0 )
			{
				input.value		= select.options[ select.selectedIndex ].innerHTML;
				if ( selectFunction ) selectFunction( select.options[ select.selectedIndex ].value );
			}
			select.parentNode.parentNode.removeChild( select.parentNode );
		}

		if ( !focusParameters || typeof( focusParameters ) !== 'object' ) focusParameters = {};

		filterRegExp			= focusParameters.regExp			|| moduleParameters.regExp;
		selectFunction			= focusParameters.selectFunction	|| moduleParameters.selectFunction;
		selectClass				= (moduleParameters.selectClass || '') + ' ' + (focusParameters.selectClass || '');
		optionClass				= (moduleParameters.optionClass || '') + ' ' + (focusParameters.optionClass || '');

		selectSource			= document.getElementById( selectId );

		input					= event.target;
		input.addEventListener( 'blur',		blur			);
		input.addEventListener( 'keyup',	inputKeyUp		);
		input.addEventListener( 'keydown',	inputKeyDown	);

	var	parent					= input.parentNode,
		div						= document.createElement( "DIV" ),
		width					= focusParameters.width || moduleParameters.width;

		parent.appendChild( div );
		select					= document.createElement( "SELECT" );
		div.appendChild( select );

		parent.style.position	= 'relative';
//		parent.style.display	= 'block';		//	necessary in FireFox if parent is a TD, harmless otherwise

		div.style.position		= 'absolute';
		div.style.top			= (input.offsetHeight - 0 + 4 + (focusParameters.top || moduleParameters.top || 0)) + 'px';
		div.style.left			= (focusParameters.left || moduleParameters.left || 0) + 'px';
		div.style.zIndex		= focusParameters.zIndex || moduleParameters.zIndex || defaultZIndex;
		div.style.display		= 'block';

		select.size				= focusParameters.size || moduleParameters.size || defaultSize;
		select.className		= (selectClass + ' ' + (selectSource.className || '')).replace( /^\s+|\s+$/g, '' );
		select.addEventListener( 'focus',	selectFocus		);
		select.addEventListener( 'blur',	blur			);
		select.addEventListener( 'keyup',	selectKeyUp		);
		select.addEventListener( 'click',	selectClick		);

		if ( width ) div.style.width = select.style.width = width;

		showAllOptions			=
			typeof( focusParameters.showAllOptions  ) === 'boolean'	?	focusParameters.showAllOptions
		:	typeof( moduleParameters.showAllOptions ) === 'boolean'	?	moduleParameters.showAllOptions
		:																false;

		autoSelect				=
			typeof( focusParameters.autoSelect  ) === 'boolean'		?	focusParameters.autoSelect
		:	typeof( moduleParameters.autoSelect ) === 'boolean'		?	moduleParameters.autoSelect
		:																false;

		multiMatch				=
			typeof( focusParameters.multiMatch  ) === 'boolean'		?	focusParameters.multiMatch
		:	typeof( moduleParameters.multiMatch ) === 'boolean'		?	moduleParameters.multiMatch
		:																false;

		refreshOptions();
	};

	return module;
};
