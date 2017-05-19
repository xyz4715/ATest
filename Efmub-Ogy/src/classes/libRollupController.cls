/*******************************************************//**

@class		CWRollupController

@brief		CW Core Rollup Page Controller

	This class is the controller for CWRollup.page

@author		Michael Wing	(LiquidHub.EMW)

@version	2014-??-??	LiquidHub.EMW
	Created.

@todo		Consolodate this into CWRollupsController
@todo		Utilize CWSchema class

@see		

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWRollupController
{
	public String		title		{ get; set; }
	public String		mode		{ get; set; }
	public CWRollup__c rollup		{ get; set; }

	public CWRollupController()
	{
		String nameParam = ApexPages.currentPage().getParameters().get( 'name' );
		if ( String.isBlank( nameparam ) )
		{
			mode	= 'new';
			title	= 'New Rollup';
			rollup	= new CWRollup__c();
		}
		else
		{
			rollup	= CWRollup__c.getall().get( nameParam );
			if ( rollup == null)
			{
				mode	= 'new';
				title	= 'New Rollup';
				rollup	= new CWRollup__c();
			}
			else
			{
				title	= 'Editing' + rollup.Name;
				mode	= 'edit';
			}
		}
	}

	public List<SelectOption> getObjectNames()
	{
		List<String> objectNames = sortedObjectNames();
		return optionsFromStrings( objectNames );
	}

	public List<SelectOption> getChildFieldNames()
	{
		List<String> fieldNames = sortedFieldNamesFromObjectName( rollup.Child_Object__c, false );
		return optionsFromStrings( fieldNames );
	}

	public List<SelectOption> getChildParentFieldNames()
	{
		List<String> fieldNames = sortedFieldNamesFromObjectName( rollup.Child_Object__c, true );
		return optionsFromStrings( fieldNames );
	}

	public List<SelectOption> getParentFieldNames()
	{
		List<String> fieldNames = sortedFieldNamesFromObjectName( rollup.Parent_Object__c, false );
		return optionsFromStrings( fieldNames );
	}

	public List<SelectOption> getParentChildFieldNames()
	{
		List<String> fieldNames = sortedChildRelationshipNamesFromObjectName( rollup.Parent_Object__c );
		return optionsFromStrings( fieldNames );
	}

	public List<String> sortedObjectNames()
	{
		List<String> objectNames = new List<String>();

		for ( Schema.SObjectType f : Schema.getGlobalDescribe().values() )
		{
			objectNames.add( f.getDescribe().getName() );
		}

		objectNames.sort();
		return objectNames;
	}

	public List<SelectOption> getFunctionNames()
	{
		return
			optionsFromStrings
			(	new List<String>
				{	'Min',
					'Max',
					'Average',
					'Count',
					'Sum',
					'First',
					'Last',
					'Initialize'
				}
			);
	}

	public List<String> sortedFieldNamesFromObjectName( String objectName, Boolean lookupsOnly )
	{
		List<String> fieldNames = new List<String>();

		if ( String.isNotBlank( objectName ) )
		{
			SObjectType sType = Schema.getGlobalDescribe().get( objectName );
			if ( sType != null )
			{
				Map<String,Schema.SObjectField> mfields = sType.getDescribe().fields.getMap();
				for ( Schema.SObjectField field : mfields.values() )
				{
					if ( !lookupsOnly || field.getDescribe().getType() == Schema.DisplayType.Reference )
					{
						fieldNames.add( field.getDescribe().getName() );
					}
				}
			}
		}

		fieldNames.sort();
		return fieldNames;
	}

	public List<String> sortedChildRelationshipNamesFromObjectName( String objectName )
	{
		List<String> fieldNames = new List<String>();

		if ( String.isNotBlank( objectName ) )
		{
			SObjectType sType = Schema.getGlobalDescribe().get( objectName );
			if ( sType != null )
			{
				List<Schema.ChildRelationship> relationships = sType.getDescribe().getChildRelationships();
				for ( Schema.ChildRelationship relationship : relationships )
				{
					if ( String.isNotBlank( relationship.getRelationshipName() ) )
					{
						fieldNames.add( relationship.getRelationshipName() );
					}
				}
			}
		}

		fieldNames.sort();
		return fieldNames;
	}

	public List<SelectOption> optionsFromStrings( List<String> strings )
	{
		List<SelectOption> options = new List<SelectOption>();
		options.add( new SelectOption('', '-- select --') );
		for ( String str : strings )
		{
			options.add( new SelectOption( str, str ) );
		}
		return options;
	}

	public PageReference clickUpdate()
	{
		return null;
	}

	public PageReference clickSave()
	{
		try
		{
			SObjectType childObjectType = Schema.getGlobalDescribe().get( rollup.Child_Object__c );
			if ( childObjectType == null )
			{
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'invalid parent object ' + rollup.Child_Object__c ) );
				return null;
			}

			Map<String,Schema.SObjectField> childObjectFields = childObjectType.getDescribe().fields.getMap();
			if ( childObjectFields == null )
			{
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'invalid parent object ' + rollup.Child_Object__c ) );
				return null;
			}

			Schema.SObjectField childParentField = childObjectFields.get( rollup.Child_Parent_Field__c );
			if ( childParentField == null )
			{
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'invalid from child to parent field ' + rollup.Child_Parent_Field__c ) );
				return null;
			}

			rollup.Parent_Child_Field__c = childParentField.getDescribe().getRelationshipName();
			upsert rollup;
		}
		catch ( Exception e )
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, String.valueOf( e ) ) );
			return null;
		}

		PageReference reference = new PageReference( '/apex/CWRollupsPage' );
		reference.setRedirect( true );
		return reference;
	}

	public PageReference clickCancel()
	{
		PageReference reference = new PageReference( '/apex/CWRollupsPage' );
		reference.setRedirect( true );
		return reference;
	}
}