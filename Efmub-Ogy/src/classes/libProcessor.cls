/*******************************************************//**

@class		CWProcessor

@brief		CW Core Processor Class

	A CWProcessor is a special kind of CWFunction that does
	not modify the incoming object, but which produces a useful
	side effect.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-02-22	LiquidHub.GHA
	Created.

@see		CWProcessorTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public abstract class CWProcessor extends CWFunction
{
	/*******************************************************
					transform method

	This version of transform processes the input Object
	without modifying it.
	*******************************************************/

	public override Object transform( Object theObject )
	{
		process( theObject );
		return theObject;
	}

	/*******************************************************
					process method

	This method must be overridden to extend CWProcessor.
	*******************************************************/

	public abstract void process( Object theObject );

	/*******************************************************
			getResultKey and getResultValue methods

	These methods may be overridden to extend CWProcessor.
	*******************************************************/

	public virtual String	getResultKey()		{ return null; }
	public virtual Object	getResultValue()	{ return null; }

	/*******************************************************
					process methods (static)

	These methods apply a list of CWProcessors to an iterable
	collection of Objects.  They return results in a CWObject
	instance, which may optionally be passed as an argument.
	*******************************************************/

	private static CWObject process( Iterable<Object> anIterable, List<CWProcessor> list_Processors, CWObject result )
	{
		(new CWIterable( anIterable, list_Processors )).toList();

		if ( result == null ) result = new CWObject();
		for ( CWProcessor processor : list_Processors )
		{
			String	resultKey	= processor.getResultKey();
			Object	resultValue	= processor.getResultValue();
			if ( resultKey != null ) result.put( resultKey, resultValue );
		}
		return result;
	}

	public static CWObject process( CWIterable anIterable, List<CWProcessor> list_Processors, CWObject result )
	{
		return process( (Iterable<Object>) anIterable, list_Processors, result );
	}

	public static CWObject process( List<Object> anIterable, List<CWProcessor> list_Processors, CWObject result )
	{
		return process( (Iterable<Object>) anIterable, list_Processors, result );
	}

	public static CWObject process( CWIterable anIterable, List<CWProcessor> list_Processors )
	{
		return process( (Iterable<Object>) anIterable, list_Processors, (CWObject) null );
	}

	public static CWObject process( List<Object> anIterable, List<CWProcessor> list_Processors )
	{
		return process( (Iterable<Object>) anIterable, list_Processors, (CWObject) null );
	}

	/*******************************************************
					process methods (static)

	These methods are as above, but they take a single
	CWProcessor instance.
	*******************************************************/

	private static CWObject process( Iterable<Object> anIterable, CWProcessor aProcessor, CWObject result )
	{
		return process( (Iterable<Object>) anIterable, new List<CWProcessor>{ aProcessor }, result );
	}

	public static CWObject process( CWIterable anIterable, CWProcessor aProcessor, CWObject result )
	{
		return process( (Iterable<Object>) anIterable, aProcessor, result );
	}

	public static CWObject process( List<Object> anIterable, CWProcessor aProcessor, CWObject result )
	{
		return process( (Iterable<Object>) anIterable, aProcessor, result );
	}

	public static CWObject process( CWIterable anIterable, CWProcessor aProcessor )
	{
		return process( (Iterable<Object>) anIterable, aProcessor, (CWObject) null );
	}

	public static CWObject process( List<Object> anIterable, CWProcessor aProcessor )
	{
		return process( (Iterable<Object>) anIterable, aProcessor, (CWObject) null );
	}
}