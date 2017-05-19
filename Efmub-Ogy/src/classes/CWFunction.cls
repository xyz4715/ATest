/*******************************************************//**

@class		CWFunction

@brief		CW Core Function Class

	A function takes an argument and returns that argument transformed.
	This abstract class provides an interface method, 'transform'.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-02-22	LiquidHub.GHA
	Created.

@see		CWFunctionTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public abstract class CWFunction
{
	/*******************************************************
					transform method

	This abstract method must be overridden by derived classes.
	It implements the transformation function.
	*******************************************************/

	public abstract Object transform( Object theObject );

	/*******************************************************
					transform method

	This static version of 'transform' applies the given
	function to the given object and returns the result.
	If there is no function, the object is returned unmodified.
	*******************************************************/

	public static Object transform( CWFunction theFunction, Object theObject )
	{
		return theFunction != null ? theFunction.transform( theObject ) : theObject;
	}

	/*******************************************************
					transform method

	This static version of 'transform' applies the given
	functions to the given object and returns the result.
	If there are no functions, the object is returned unmodified.
	*******************************************************/

	public static Object transform( List<CWFunction> list_Functions, Object theObject )
	{
		if ( list_Functions != null )
		{
			for ( CWFunction theFunction : list_Functions )
			{
				theObject = transform( theFunction, theObject );
			}
		}
		return theObject;
	}
}