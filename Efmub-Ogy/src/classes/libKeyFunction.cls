/*******************************************************//**

@class		CWKeyFunction

@brief		CW Core Key Function Class

	This class is a special kind of CWFunction that takes an
	sObject and returns an Object.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-03-04	LiquidHub.GHA
	Created.

@see		CWKeyFunctionTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public abstract class CWKeyFunction extends CWFunction
{
	public override Object transform( Object theObject )
	{
		return CWType.isSObject( theObject ) ? getKey( (sObject) theObject ) : null;
	}

	public abstract Object getKey( sObject theRecord );
}