/*******************************************************//**

@class		CWObjectBrowserControllerTest

@brief		CW Core Object Browser Controller Test Class

	Test class for CWObjectBrowserController.

@author		Janeen Anderson	(LiquidHub.JDA)
@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-08-29		LiquidHub.JDA
	Created.
@version	2015-03-31		LiquidHub.GHA
	Updated tests to match new functionality.
@version	2015-10-07		LiquidHub.GHA
	Removed dependency on CWTest to allow packaging.

@todo	test hasHelpText property
@todo	test helpText property
@todo	test isFormula property
@todo	test formula property
@todo	test hasDefaultValue property
@todo	test defaultValue property
@todo	test isExternalId property
@todo	test isPicklist property
@todo	test picklistValues property
@todo	test isDependent property
@todo	test controller property
@todo	test isRestricted property

@todo	test cwRollups property
@todo	test cwRollup property
@todo	test isCWRollup property
@todo	test cwRollupId property
@todo	test cwRollupName property

@todo	test object with AutoNumber field (Case?)
@todo	test object with Polymorphic reference (Task?)
-----
@todo	test FieldSetMemberInfo class
@todo	test FieldSetInfo class
@todo	test RecordTypeInfo class

@todo	test ObjectInfo.numRecords property
@todo	test ObjectInfo.listViewLabel property

@todo	test object with field set(s)
@todo	test object with record type(s)

@todo	test ObjectInfo constructor using sObjectType

@todo	test with Knowledge Article Version(s)



@see		CWObjectBrowserController

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public without sharing class CWObjectBrowserControllerTest
{
	static public testMethod void testCWObjectBrowserController()
	{
		Test.startTest();

		Test.setCurrentPage( Page.CWObjectBrowser );

		CWObjectBrowserController aCWobc = new CWObjectBrowserController();

		String	pageUrl			= CWObjectBrowserController.pageUrl;

		String theorgName = aCWobc.orgName;

		System.assert( aCWobc.showAllObjects );

		for ( CWObjectBrowserController.ObjectInfoList objectInfoList : aCWobc.objectInfoLists )
		{
			String	elementId	= objectInfoList.elementId;
			if ( !objectInfoList.hasObjectInfos ) continue;
			String	name		= objectInfoList.name;
			for ( CWObjectBrowserController.ObjectInfo objectInfo : objectInfoList.objectInfos )
			{
				String	detailUrl		= objectInfo.detailUrl;
				String	infoName		= objectInfo.name;
				String	prefix			= objectInfo.prefix;
				String	label			= objectInfo.label;
				String	listViewHeader	= objectInfoList.listViewHeader;
				if ( objectInfo.hasListView )
				{
					String	listViewUrl		= objectInfo.listViewUrl;
					String	listViewLabel	= objectInfo.listViewLabel;
					String	plural			= objectInfo.plural;
				}
				if ( infoName == 'Account' )
				{
					Integer	numRecords	= objectInfo.numRecords;
				}
			}
			Boolean collapse = objectInfoList.collapse;
		}

		CWObjectBrowserController.ObjectInfo	newObjectInfo	= new CWObjectBrowserController.ObjectInfo( Account.getSObjectType() );

		for ( String sObjectName : new List<String>{ 'Account', 'Contact', 'Case', 'Task' } )
		{
			ApexPages.currentPage().getParameters().put( 'obj', sObjectName );

			aCWobc = new CWObjectBrowserController();

			System.assert( aCWobc.showFields );

			String	objectName		= aCWobc.detailObject.name;
			if ( aCWobc.detailObject.hasFields )
			{
				for ( CWObjectBrowserController.FieldInfoList fieldInfoList : aCWobc.detailObject.fieldInfoLists )
				{
					String	elementId	= fieldInfoList.elementId;
					if ( !fieldInfoList.hasFieldInfos ) continue;
					String	name		= fieldInfoList.name;
					for ( CWObjectBrowserController.FieldInfo fieldInfo : fieldInfoList.fieldInfos )
					{
						String	infoName		= fieldInfo.name;
						String	label			= fieldInfo.label;
						Boolean	hasHelpText		= fieldInfo.hasHelpText;
						String	helpText		= fieldInfo.helpText;
						Boolean	isFormula		= fieldInfo.isFormula;
						String	formula			= fieldInfo.formula;

						if ( fieldInfo.hasDefaultValue )
						{
							String	defaultValue	= fieldInfo.defaultValue;
						}

						Boolean		isExternalID	= fieldInfo.isExternalID;

						if ( fieldInfo.isPicklist )
						{
							String	picklistValues	= fieldInfo.picklistValues;
							Boolean	isDependent		= fieldInfo.isDependent;
							String	controller		= fieldInfo.controller;
							Boolean	isRestricted	= fieldInfo.isRestricted;
						}

						String	fieldType		= fieldInfo.fieldType;

						if ( fieldInfo.isReference )
						{
							String	detailUrl		= fieldInfo.detailUrl;
							String	referenceTo		= fieldInfo.referenceTo;
						}

						Boolean	isCWRollup		= fieldInfo.isCWRollup;
						String	cwRollupId		= fieldInfo.cwRollupId;
						String	cwRollupName	= fieldInfo.cwRollupName;

						Boolean	isRequired		= fieldInfo.isRequired;
						Boolean	isUnique		= fieldInfo.isUnique;
					}
					Boolean	collapse	= fieldInfoList.collapse;
				}
			}

			if ( aCWobc.detailObject.hasFieldSets )
			{
				for ( CWObjectBrowserController.FieldSetInfo fieldSetInfo : aCWobc.detailObject.fieldSetInfos )
				{
					String	name		= fieldSetInfo.name;
					Boolean	collapse	= fieldSetInfo.collapse;
					String	elementId	= fieldSetInfo.elementId;
					String	setLabel	= fieldSetInfo.label;
					String	description	= fieldSetInfo.description;
					if ( !fieldSetInfo.hasMembers ) continue;
					for ( CWObjectBrowserController.FieldSetMemberInfo member : fieldSetInfo.members )
					{
						String	infoName	= member.name;
						String	label		= member.label;
					}
				}
			}
			else
			{
				CWObjectBrowserController.FieldSetInfo	fieldSetInfo	= new CWObjectBrowserController.FieldSetInfo( null, true );

				String	name		= fieldSetInfo.name;
				Boolean	collapse	= fieldSetInfo.collapse;
				String	elementId	= fieldSetInfo.elementId;
				String	setLabel	= fieldSetInfo.label;
				String	description	= fieldSetInfo.description;
				Boolean	hasMembers	= fieldSetInfo.hasMembers;

				List<CWObjectBrowserController.FieldSetMemberInfo>	members		= fieldSetInfo.members;

				fieldSetInfo.compareTo( fieldSetInfo );

				CWObjectBrowserController.FieldSetMemberInfo member		= new CWObjectBrowserController.FieldSetMemberInfo( null );

				String	memberName	= member.name;
				String	memberLabel	= member.label;

				member.compareTo( member );
			}

			if ( aCWobc.detailObject.hasRecordTypes )
			{
				for ( CWObjectBrowserController.RecordTypeInfo recordType : aCWobc.detailObject.recordTypeInfos )
				{
					String	name		= recordType.name;
					String	label		= recordType.label;
					String	description	= recordType.description;
					String	rtid		= recordType.rtId;
					Boolean	isDefault	= recordType.isDefault;
				}
			}
			else
			{
				CWObjectBrowserController.RecordTypeInfo recordType		= new CWObjectBrowserController.RecordTypeInfo( null );

				String	name		= recordType.name;
				String	label		= recordType.label;
				String	description	= recordType.description;
				String	rtid		= recordType.rtId;
				Boolean	isDefault	= recordType.isDefault;

				recordType.compareTo( recordType );
			}

			if ( aCWobc.detailObject.hasChildRelationships )
			{
				for ( CWObjectBrowserController.ChildRelationshipInfoList childRelationshipInfoList : aCWobc.detailObject.childRelationshipInfoLists )
				{
					String	elementId	= childRelationshipInfoList.elementId;
					if ( !childRelationshipInfoList.hasChildRelationshipInfos ) continue;
					for ( CWObjectBrowserController.ChildRelationshipInfo childRelationship : childRelationshipInfoList.childRelationshipInfos )
					{
						String	detailUrl			= childRelationship.detailUrl;
						String	fieldName			= childRelationship.fieldName;
						String	name				= childRelationship.name;
						Boolean	isCascadeDelete		= childRelationship.isCascadeDelete;
						Boolean	isRestrictedDelete	= childRelationship.isRestrictedDelete;
					}
					Boolean	collapse	= childRelationshipInfoList.collapse;
				}
			}
		}

		Test.stopTest();
	}
}