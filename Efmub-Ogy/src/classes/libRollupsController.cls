/*******************************************************//**

@class		CWRollupsController

@brief		CW Core Rollups Page Controller

	This class is the controller for CWRollups.page

@author		Michael Wing	(LiquidHub.EMW)

@version	2014-??-??	LiquidHub.EMW
	Created.

@see		

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWRollupsController
{
	public List<CWRollup__c> getRollups()
	{
		List<String> sortedNames = new List<String>();
		sortedNames.addAll( CWRollup__c.getall().keySet() );
		sortedNames.sort();

		List<CWRollup__c> sortedRollups = new List<CWRollup__c>();
		for ( String name : sortedNames )
		{
			sortedRollups.add( CWRollup__c.getAll().get( name ) );
		}
		return sortedRollups;
	}

	public PageReference clickNew()
	{
		PageReference reference = new PageReference( '/apex/CWRollupPage' );
		reference.setRedirect( true );
		return reference;
	}
}