/*******************************************************//**

@class		CWAccessible

@brief		Accessibility Interface

	Implement this interface to allow members of your class to
	be accessed via a "get()" method.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2015-12-29	LiquidHub.GHA
	Created.

	(c)2015-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public interface CWAccessible
{
	/*******************************************************
						get method

	Returns the value of the named field for this object.
	*******************************************************/

	Object get( String fieldName );

	/*******************************************************
					getFieldType method

	Returns the type of the named field for this class.
	*******************************************************/

	Type getFieldType( String fieldName );
}