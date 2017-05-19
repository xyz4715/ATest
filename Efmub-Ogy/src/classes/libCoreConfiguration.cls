/*******************************************************//**

@class		CWCoreConfiguration

@brief		CW Core Configuration Class

	This class manages the CW Core Configuration custom setting
	if it exists.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-04-04	LiquidHub.GHA
	Created.
@version	2014-08-04	LiquidHub.GHA
	Changed to work with a heirarchical custom setting.
@version	2014-10-13	LiquidHub.GHA
	Renamed class from CWFrameworkConfiguration.
	Now uses CWCoreConfiguration__c custom setting.
	Removed 'getDefaultErrorHandler' method.
	Renamed 'getConfigurationField' to 'get'.
	Added use of CWException if requested field is not found.
@version	2015-10-16	LiquidHub.GHA
	Added 'get' method with fallback parameter.

@see		CWCoreConfigurationTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWCoreConfiguration
{
	/*******************************************************
						properties
	*******************************************************/

	private static Boolean getInstance
	{
		get
		{
			getInstance = getInstance == null;
			return getInstance;
		}
		private set;
	}

	private static CWCoreConfiguration__c theConfiguration
	{
		get
		{
			if	(	theConfiguration == null
				&&	getInstance
				)
			{
				theConfiguration =
					!Test.isRunningTest()	?	CWCoreConfiguration__c.getInstance()
											:	new CWCoreConfiguration__c
												(	Default_ErrorHandler__c		= 'CWException.ThrowError',
													Disable_Rollups__c			= false,
													Disable_Triggers__c			= false,
													Allow_Deployment__c			= false,
													Google_API_Key__c			= (String) null
												);
			}
			return theConfiguration;
		}
		private set;
	}

	/*******************************************************
						get method

	This public method returns the value of the requested
	configuration parameter, if it exists.
	*******************************************************/

	public static Object get( String fieldName )
	{
		return
			(	CWSchema.isField( CWCoreConfiguration__c.getSObjectType(), fieldName )
			&&	theConfiguration != null
			)
		?	theConfiguration.get( fieldName )
		:	CWException.errorNull( 'CWCoreConfiguration.get: Unable to return a value for field: ' + fieldName );
	}

	/*******************************************************
						get method

	This public method returns the value of the requested
	configuration parameter, or the fallback value if it
	does not exist.
	*******************************************************/

	public static Object get( String fieldName, Object fallback )
	{
		Object	value	= null;

		if	(	CWSchema.isField( CWCoreConfiguration__c.getSObjectType(), fieldName )
			&&	theConfiguration != null
			)
		{
			value	= theConfiguration.get( fieldName );
		}

		return value != null ? value : fallback;
	}
}