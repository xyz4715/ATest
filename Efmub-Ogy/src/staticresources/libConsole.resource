/*******************************************************//**

@class		CWConsole

@brief		CW Core Console Utilities



@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-08-24	LiquidHub.GHA
	Created.

@see		

	(c)2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

/***********************************************************
				CWConsole module

parameters:
	subTabIcon		String		the initial icon of this subtab (optional)
	subTabTitle		String		the initial title of this subtab (optional)
	returnURL		URL			the URL of the page to return to in this subtab (optional)
***********************************************************/

function CWConsole( moduleParameters )
{
	if ( !moduleParameters || typeof( moduleParameters ) != 'object' ) moduleParameters = {};

var	/* Object	*/	module				= {},
	/* String	*/	primaryTabId		= null,
	/* String	*/	subTabId			= null,
	/* Array	*/	paramStrings		= location.search.substr( 1 ).split( "&" ),
	/* Object	*/	pageParameters		= {},

	/* Integer	*/	index,
	/* Array	*/	keyValuePair,

	/*******************************************************
					onload function

	This will be called when the page loads.  It gets the Ids
	of the enclosing tab and subtab, and sets the subtab title.
	*******************************************************/

	onload = function()
	{
		if ( !sforce || !sforce.console ) return;

		if ( sforce.console.isInConsole() )
		{
			//	get the id's of both the primary tab and this subtab
			sforce.console.getEnclosingPrimaryTabId( function( result ) { primaryTabId = result.id; } );
			sforce.console.getEnclosingTabId( function( result ) { subTabId = result.id; } );

			//	set the icon of this subtab
			if ( typeof( moduleParameters.subTabIcon ) === 'string' )
			{
//alert( 'Setting Tab Icon to: ' + moduleParameters.subTabIcon );
				sforce.console.setTabIcon( moduleParameters.subTabIcon );
			}

			//	set the title of this subtab
			if ( typeof( moduleParameters.subTabTitle ) === 'string' )
			{
				sforce.console.setTabTitle( moduleParameters.subTabTitle );
			}
		}
		else
		{
			//	set the title of this browser tab
			if ( typeof( moduleParameters.subTabTitle ) === 'string' )
			{
				document.title = moduleParameters.subTabTitle;
			}
		}
	},

	/*******************************************************
					addParameter function
	*******************************************************/

	addParameter = function( url, param, value )
	{
		return url + (url.indexOf( '?' ) > -1 ? '&' : '?') + param + '=' + value;
	},

	endOfVars;

	/*******************************************************
				module.isInConsole function
	*******************************************************/

	module.isInConsole = function()
	{
		return sforce.console.isInConsole();
	};

	/*******************************************************
				module.redirectThisSubTab function

	arguments:
		redirectURL			String		the URL to redirect this subTab (required)
		subTabTitle			String		the new title for this subTab (optional)
	*******************************************************/

	module.redirectThisSubTab = function( redirectURL, subTabTitle )
	{
		if ( !redirectURL ) return;

	var	returnURL	= pageParameters[ 'retURL' ];

		//	if we're going someplace new, make sure it knows about the return URL, if any
		if ( returnURL ) redirectURL = addParameter( redirectURL, 'retURL', returnURL );

		//	otherwise reopen this subtab
		if ( sforce.console.isInConsole() )
		{
			redirectURL = addParameter( redirectURL, 'isdtp', 'vw' );
			sforce.console.openSubtab
			(	/*	Enclosing Primary Tab Id	*/	primaryTabId,
				/*	URL for new Subtab			*/	redirectURL,
				/*	Active (true = take focus)	*/	true,
				/*	Label for new Subtab		*/	subTabTitle || null,
				/*	Id of Subtab to override	*/	subTabId,
				/*	Callback function			*/	function( result ) { if ( !result.success ) alert( (subTabTitle || 'The') + ' subtab cannot be opened.\n' + redirectURL ); },
				/*	Name for new Subtab			*/	null
			);
		}
		else
		{
			window.location = redirectURL;
		}
	};

	/*******************************************************
				module.openNewSubTab function

	arguments:
		newSubTabURL		String		the URL to open in a new subTab (required)
		subTabTitle			String		the title for the new subTab (optional)
		subTabName			String		the name of the subTab (optional)
	*******************************************************/

	module.openNewSubTab = function( newSubTabURL, subTabTitle, subTabName )
	{
		sforce.console.getEnclosingPrimaryTabId( function( result ) {
			primaryTabId = result.id;
			if ( sforce.console.isInConsole() && typeof( subTabName ) === 'string' )
			{
				sforce.console.focusSubtabByNameAndPrimaryTabId( subTabName, primaryTabId, function( result ) {
					if ( !result.success ) internalOpenNewSubTab( newSubTabURL, subTabTitle, subTabName );
				} );
			}
			else
			{
				internalOpenNewSubTab( newSubTabURL, subTabTitle, subTabName );
			}
		} );
	}

	internalOpenNewSubTab = function( newSubTabURL, subTabTitle, subTabName )
	{
		if ( !newSubTabURL ) return;

	var	returnURL	= pageParameters[ 'retURL' ];

		//	if we're going someplace new, make sure it knows about the return URL, if any
		if ( returnURL ) newSubTabURL = addParameter( newSubTabURL, 'retURL', returnURL );

		//	otherwise open a new subtab
		if ( sforce.console.isInConsole() )
		{
			newSubTabURL = addParameter( newSubTabURL, 'isdtp', 'vw' );

			sforce.console.openSubtab
			(	/*	Enclosing Primary Tab Id	*/	primaryTabId,
				/*	URL for new Subtab			*/	newSubTabURL,
				/*	Active (true = take focus)	*/	true,
				/*	Label for new Subtab		*/	subTabTitle || null,
				/*	Id of Subtab to override	*/	null,
				/*	Callback function			*/	function( result ) { if ( !result.success ) alert( (subTabTitle || 'The') + ' subtab cannot be opened.\n' + newSubTabURL ); },
				/*	Name for new Subtab			*/	subTabName || null
			);
		}
		else
		{
			window.open( newSubTabURL );
		}
	};

	/*******************************************************
				module.closeThisSubtab function
	*******************************************************/

	module.closeThisSubtab = function()
	{
		if ( sforce.console.isInConsole() )
		{
			sforce.console.refreshPrimaryTabById
			(	primaryTabId,
				false,
				function() { if ( subTabId ) sforce.console.closeTab( subTabId ); }
			);
		}
		else
		{
			window.close();
		}
	};

	/*******************************************************
				module.openNewPrimaryTab function

	arguments:
		newPrimaryTabURL	String		the URL to open in a new primary tab (required)
		primaryTabTitle		String		the title for the new primary tab (optional)
		primaryTabName		String		the name of the primary tab (optional)
	*******************************************************/

	module.openNewPrimaryTab = function( newPrimaryTabURL, primaryTabTitle, primaryTabName )
	{
		if ( sforce.console.isInConsole() && typeof( primaryTabName ) === 'string' )
		{
			sforce.console.focusPrimaryTabByName( primaryTabName, function( result ) {
				if ( !result.success ) internalOpenNewPrimaryTab( newPrimaryTabURL, primaryTabTitle, primaryTabName );
			} );
		}
		else
		{
			internalOpenNewPrimaryTab( newPrimaryTabURL, primaryTabTitle, primaryTabName );
		}
	}

	internalOpenNewPrimaryTab = function( newPrimaryTabURL, primaryTabTitle, primaryTabName )
	{
		if ( !newPrimaryTabURL ) return;

	var	returnURL	= pageParameters[ 'retURL' ];

		//	if we're going someplace new, make sure it knows about the return URL, if any
		if ( returnURL ) newPrimaryTabURL = addParameter( newPrimaryTabURL, 'retURL', returnURL );

		//	otherwise open a new primary tab
		if ( sforce.console.isInConsole() )
		{
			newPrimaryTabURL = addParameter( newPrimaryTabURL, 'isdtp', 'vw' );

			sforce.console.openPrimaryTab
			(	/*	Id of primary tab to override	*/	null,
				/*	URL for new primary tab			*/	newPrimaryTabURL,
				/*	Active (true = take focus)		*/	true,
				/*	Label for new primary tab		*/	primaryTabTitle || null,
				/*	Callback function				*/	function( result ) { if ( !result.success ) alert( (primaryTabTitle || 'The') + ' primary tab cannot be opened.\n' + newPrimaryTabURL ); },
				/*	Name for new primary tab		*/	primaryTabName || null
			);
		}
		else
		{
			window.open( newPrimaryTabURL );
		}
	};

	/*******************************************************
				module.closeThisPrimaryTab function
	*******************************************************/

	module.closeThisPrimaryTab = function()
	{
		if ( sforce.console.isInConsole() )
		{
			sforce.console.getEnclosingPrimaryTabId( function( result ) {
				if ( result.id ) sforce.console.closeTab( result.id );
			} );
		}
		else
		{
			window.close();
		}
	};

	/*******************************************************
				module.setTabUnsavedChanges function
	*******************************************************/

	module.setTabUnsavedChanges = function()
	{
		if ( sforce.console.isInConsole() )
		{
			sforce.console.setTabUnsavedChanges( true, function( result ){} );
		}
	};

	/*******************************************************
				module.clearTabUnsavedChanges function
	*******************************************************/

	module.clearTabUnsavedChanges = function()
	{
		if ( sforce.console.isInConsole() )
		{
			sforce.console.setTabUnsavedChanges( false, function( result ){} );
		}
	};

	/*******************************************************
				module.jumpToAnchor function

	arguments:
		target			String		the anchor name (required)
	*******************************************************/

	module.jumpToAnchor = function( target )
	{
		window.location.hash = target;
	};

	/*******************************************************
				module.onLoad function

	arguments:
		onLoadFunction		Function		the function to call on load (required)
	*******************************************************/

	module.onLoad = function( onLoadFunction )
	{
		if ( typeof( onLoadFunction ) === 'function' )
		{
			if ( window.addEventListener )
			{
				window.addEventListener( 'load', onLoadFunction, false );	//	W3C
			}
			else
			{
				window.attachEvent( 'onload', onLoadFunction );				//	IE
			}
		}
	};

	/*******************************************************
					module initialization
	*******************************************************/

	for ( index = 0; index < paramStrings.length; index++ )
	{
		keyValuePair = paramStrings[ index ].split( "=" );
		pageParameters[ keyValuePair[ 0 ] ] = decodeURIComponent( keyValuePair[ 1 ] );
	}

	module.onLoad( onload );

	return module;
};
