/*******************************************************//**

@class		CWObjectBrowserController

@brief		Object Browser Controller

	This is the controller for the Object Browser page, which displays
	all the objects in an org, with their 3-character prefixes and
	links to their list view pages.  (Subject to the running user's
	permissions.)

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-10-31	LiquidHub.GHA
	Created.
@version	2014-11-02	LiquidHub.GHA
	Added object detail mode.
@version	2014-11-11	LiquidHub.GHA
	Added link to object from reference field.
	Added additional categories of objects.
@version	2015-03-30	LiquidHub.GHA
	Added Formula, Default, External ID, and CWRollup functionality.

@see		CWObjectBrowserControllerTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public with sharing class CWObjectBrowserController
{
	public static	String		pageUrl		{ get { return ApexPages.currentPage().getUrl().substringBefore( '?' ); } }
	public			String		orgName
	{
		get
		{
			return
				orgInfo.Name + ' ('
			+	orgInfo.Id + ') - '
			+	orgInfo.InstanceName + ' ('
			+	(orgInfo.IsSandbox ? 'Sandbox) - ' : 'Production) - ')
			+	orgInfo.OrganizationType;
		}
	}

	private			Organization	orgInfo
	{
		get
		{
			if ( orgInfo == null )
			{
				for ( Organization org :
					[	SELECT	Id, InstanceName, IsSandbox, Name, OrganizationType
						FROM	Organization
						LIMIT	1
					]
					)
				{
					orgInfo = org;
				}
			}
			return orgInfo;
		}
		private set;
	}

	/*******************************************************
				obj parameter properties
	*******************************************************/

	public	String		objectName
	{
		get
		{
			if ( objectName == null )
			{
				objectName = ApexPages.currentPage().getParameters().get( 'obj' );
			}
			return objectName;
		}
		private set;
	}

	public	Boolean		showAllObjects	{ get { return String.isBlank( objectName ); } }
	public	Boolean		showFields		{ get { return !showAllObjects; } }

	/*******************************************************
					cwRollups property
	*******************************************************/

	private static	Map<String,Map<String,sObject>>	cwRollups
	{
		get
		{
			Boolean		cwRollupExists	= Schema.getGlobalDescribe().containsKey( 'CWRollup__c' );

			if ( cwRollups == null && (cwRollupExists || Test.isRunningTest()) )
			{
				cwRollups = new Map<String,Map<String,sObject>>();
				for ( sObject record :
						cwRollupExists	?	Database.query( 'SELECT Id, Name, Parent_Object__c, Parent_Field__c FROM CWRollup__c' )
										:	new List<sObject>{ new Account() }
					)
				{
					String	parentObject	= cwRollupExists ? (String) record.get( 'Parent_Object__c' ) : 'Test';
					String	parentField		= cwRollupExists ? (String) record.get( 'Parent_Field__c' ) : 'Test';

					if ( !cwRollups.containsKey( parentObject ) )
					{
						cwRollups.put( parentObject, new Map<String,sObject>() );
					}
					cwRollups.get( parentObject ).put( parentField, record );
				}
			}
			return cwRollups;
		}
		private set;
	}

	/*******************************************************
					FieldInfo class
	*******************************************************/

	public class FieldInfo implements Comparable
	{
		private	String							sObjectName;
		private	Schema.DescribeFieldResult		result;

		public	String		name			{ get { return result.getName(); } }
		public	String		label			{ get { return result.getLabel(); } }

		public	Boolean		hasHelpText		{ get { return String.isNotBlank( helpText ); } }
		public	String		helpText		{ get { return result.getInlineHelpText(); } }

		public	Boolean		isReference		{ get { return result.getType() == Schema.DisplayType.Reference && !result.isNamePointing(); } }
		public	String		referenceTo		{ get { return isReference ? result.getReferenceTo()[0].getDescribe().getName() : null; } }
		public	String		detailUrl		{ get { return isReference ? pageUrl + '?obj=' + result.getReferenceTo()[0].getDescribe().getName() : null; } }

		public	Boolean		isFormula		{ get { return result.isCalculated(); } }
		public	String		formula			{ get { return result.getCalculatedFormula(); } }

		public	Boolean		hasDefaultValue	{ get { return String.isNotBlank( defaultValue ); } }
		public	String		defaultValue	{ get { return result.getDefaultValue() != null ? String.valueOf( result.getDefaultValue() ) : result.getDefaultValueFormula(); } }

		public	Boolean		isExternalID	{ get { return result.isExternalID(); } }

		public	Boolean		isPicklist
		{
			get
			{
				List<Schema.PicklistEntry> values = result.getPicklistValues();
				return values != null && !values.isEmpty();
			}
		}

		public	String		picklistValues
		{
			get
			{
				List<String>	picklistLabels	= new List<String>();
				for ( Schema.PicklistEntry picklistEntry : result.getPicklistValues() )
				{
					picklistLabels.add( picklistEntry.getLabel() );
				}
				return String.join( picklistLabels, '\n' );
			}
		}

		public	Boolean		isDependent		{ get { return result.isDependentPicklist(); } }
		public	String		controller		{ get { return isDependent ? String.valueOf( result.getController() ) : null; } }
		public	Boolean		isRestricted	{ get { return result.isRestrictedPicklist(); } }

		private	sObject		cwRollup
		{
			get
			{
				if ( cwRollup == null && cwRollups != null )
				{
					Boolean		isRunningTest	= Test.isRunningTest();
					Map<String,sObject>	parentFields	= cwRollups.get( !isRunningTest ? sObjectName : 'Test' );
					if ( parentFields != null )
					{
						cwRollup	= parentFields.get( !isRunningTest ? name : 'Test' );
					}
				}
				return cwRollup;
			}
			private set;
		}

		public	Boolean		isCWRollup		{ get { return cwRollup != null; } }
		public	String		cwRollupId		{ get { return isCWRollup ? String.valueOf( cwRollup.get( 'Id' ) ) : ''; } }
		public	String		cwRollupName	{ get { return isCWRollup ? String.valueOf( cwRollup.get( 'Name' ) ) : ''; } }

		public	String		fieldType
		{
			get
			{
				if ( fieldType == null )
				{
					Schema.DisplayType	displayType		= result.getType();
					fieldType	= map_FieldType_TypeName.get( displayType );

					if ( result.isAutoNumber() )
					{
						fieldType = 'AutoNumber';
					}
					if ( fieldType == 'String' )
					{
						fieldType += ' (' + result.getLength() + ')';
					}
					if ( fieldType == 'Decimal' )
					{
						fieldType += ' (' + (result.getPrecision() - result.getScale()) + '.' + result.getScale() + ')';
					}
					if ( fieldType == 'Id' )
					{
						List<Schema.sObjectType> references = result.getReferenceTo();
						fieldType =
							displayType == Schema.DisplayType.Id		?	'Id'
						:	references == null || references.isEmpty()	?	'Id (-Unknown-)'
						:	result.isNamePointing()						?	'Id (-Polymorphic-)'
						:													'Id (' + references[0].getDescribe().getName() + ')';
					}
				}
				return fieldType;
			}
			private set;
		}

		public	Boolean		isRequired		{ get { return !result.isNillable(); } }
		public	Boolean		isUnique		{ get { return result.isUnique(); } }

		public FieldInfo( String sObjectName, Schema.DescribeFieldResult theResult )
		{
			this.sObjectName	= sObjectName;
			this.result			= theResult;
		}

		public Integer compareTo( Object other )
		{
			return name.compareTo( ((FieldInfo) other).name );
		}
	}

	/*******************************************************
					FieldInfoList class
	*******************************************************/

	public class FieldInfoList
	{
		public	String				name				{ get; set; }
		public	Boolean				collapse			{ get; set; }
		public	String				elementId			{ get { return name.deleteWhitespace(); } }

		public	List<FieldInfo>		fieldInfos
		{
			get { if ( fieldInfos == null ) { fieldInfos = new List<FieldInfo>(); } return fieldInfos; }
			private set;
		}
		public	Boolean		hasFieldInfos	{ get { return !fieldInfos.isEmpty(); } }

		public FieldInfoList( String theName, Boolean defaultCollapsed )
		{
			name		= theName;
			collapse	= defaultCollapsed;
		}

		private void add( FieldInfo info )
		{
			fieldInfos.add( info );
		}

		private void sort()
		{
			fieldInfos.sort();
		}
	}

	/*******************************************************
					FieldSetMemberInfo class
	*******************************************************/

	public class FieldSetMemberInfo implements Comparable
	{
		private	Schema.FieldSetMember	member;

		public	String		name		{ get { return member != null ? member.getFieldPath() : null; } }
		public	String		label		{ get { return member != null ? member.getLabel() : null; } }

		public FieldSetMemberInfo( Schema.FieldSetMember theMember )
		{
			member	= theMember;
		}

		public Integer compareTo( Object other )
		{
			return name != null ? name.compareTo( ((FieldSetMemberInfo) other).name ) : 0;
		}
	}

	/*******************************************************
					FieldSetInfo class
	*******************************************************/

	public class FieldSetInfo implements Comparable
	{
		private	Schema.FieldSet		fieldSet;

		public	String		name			{ get { return fieldSet != null ? fieldSet.getName() : null; } }
		public	Boolean		collapse		{ get; set; }
		public	String		elementId		{ get { return fieldSet != null ? name.deleteWhitespace() : null; } }
		public	String		label			{ get { return fieldSet != null ? fieldSet.getLabel() : null; } }
		public	String		description		{ get { return fieldSet != null ? fieldSet.getDescription() : null; } }

		public	List<FieldSetMemberInfo>	members
		{
			get
			{
				if ( members == null )
				{
					members = new List<FieldSetMemberInfo>();
					for ( Schema.FieldSetMember member : fieldSet != null ? fieldSet.getFields() : new List<Schema.FieldSetMember>() )
					{
						members.add( new FieldSetMemberInfo( member ) );
					}
					members.sort();
				}
				return members;
			}
			private set;
		}
		public	Boolean		hasMembers		{ get { return members != null && !members.isEmpty(); } }

		public FieldSetInfo( Schema.FieldSet theFieldSet, Boolean defaultCollapsed )
		{
			fieldSet	= theFieldSet;
			collapse	= defaultCollapsed;
		}

		public Integer compareTo( Object other )
		{
			return name != null ? name.compareTo( ((FieldSetInfo) other).name ) : 0;
		}
	}

	/*******************************************************
					RecordTypeInfo class
	*******************************************************/

	public class RecordTypeInfo implements Comparable
	{
		private	Schema.RecordTypeInfo		recordType;

		public	String		name			{ get { return rtId != null ? map_RecordTypes.get( rtId ).DeveloperName : null; } }
		public	String		label			{ get { return recordType != null ? recordType.getName() : null; } }
		public	String		description		{ get { return rtId != null ? map_RecordTypes.get( rtId ).Description : null; } }
		public	Id			rtId			{ get { return recordType != null ? recordType.getRecordTypeId() : null; } }

		public	Boolean		isDefault		{ get { return recordType != null && recordType.isDefaultRecordTypeMapping(); } }

		public RecordTypeInfo( Schema.RecordTypeInfo theRecordType )
		{
			recordType	= theRecordType;
		}

		public Integer compareTo( Object other )
		{
			return name != null ? name.compareTo( ((RecordTypeInfo) other).name ) : 0;
		}
	}

	private static	Map<Id,RecordType>	map_RecordTypes
	{
		get
		{
			if ( map_RecordTypes == null )
			{
				map_RecordTypes = new Map<Id,RecordType>( [SELECT Id, Description, DeveloperName FROM RecordType ] );
			}
			return map_RecordTypes;
		}
		private set;
	}

	/*******************************************************
					ChildRelationshipInfo class
	*******************************************************/

	public class ChildRelationshipInfo implements Comparable
	{
		private	Schema.ChildRelationship	childRelationship;

		public	String		sObjectName		{ get { return childRelationship.getChildSObject().getDescribe().getName(); } }
		public	String		detailUrl		{ get { return pageUrl + '?obj=' + sObjectName; } }
		public	String		fieldName		{ get { return childRelationship.getField().getDescribe().getName(); } }
		public	String		name			{ get { return childRelationship.getRelationshipName(); } }

		public	Boolean		isCascadeDelete		{ get { return childRelationship.isCascadeDelete(); } }
		public	Boolean		isRestrictedDelete		{ get { return childRelationship.isRestrictedDelete(); } }

		public ChildRelationshipInfo( Schema.ChildRelationship theChildRelationship )
		{
			childRelationship	= theChildRelationship;
		}

		public Integer compareTo( Object other )
		{
			return sObjectName != null ? sObjectName.compareTo( ((ChildRelationshipInfo) other).sObjectName ) : 0;
		}
	}

	/*******************************************************
				ChildRelationshipInfoList class
	*******************************************************/

	public class ChildRelationshipInfoList
	{
		public	String				name				{ get; set; }
		public	Boolean				collapse			{ get; set; }
		public	String				elementId			{ get { return name.deleteWhitespace(); } }

		public	List<ChildRelationshipInfo>		childRelationshipInfos
		{
			get { if ( childRelationshipInfos == null ) { childRelationshipInfos = new List<ChildRelationshipInfo>(); } return childRelationshipInfos; }
			private set;
		}
		public	Boolean		hasChildRelationshipInfos	{ get { return !childRelationshipInfos.isEmpty(); } }

		public ChildRelationshipInfoList( String theName, Boolean defaultCollapsed )
		{
			name		= theName;
			collapse	= defaultCollapsed;
		}

		private void add( ChildRelationshipInfo info )
		{
			childRelationshipInfos.add( info );
		}

		private void sort()
		{
			childRelationshipInfos.sort();
		}
	}

	/*******************************************************
					ObjectInfo class
	*******************************************************/

	public class ObjectInfo implements Comparable
	{
		private	Schema.DescribeSObjectResult	result;

		public	String		name		{ get { return result != null ? result.getName() : name; } private set; }
		public	String		detailUrl	{ get { return result != null ? pageUrl + '?obj=' + name : '#'; } }
		public	String		prefix		{ get { return result != null ? result.getKeyPrefix() : ''; } }
		public	String		label		{ get { return result != null ? result.getLabel() : name.substringBefore( '__' ).replace( '_', ' ' ); } }
		public	String		plural		{ get { return result != null ? result.getLabelPlural() : ''; } }

		public	Integer		numRecords	{ get { return Database.countQuery( 'SELECT COUNT() FROM ' + name ); } }

		public	String		listViewUrl
		{
			get
			{
				return
					String.isBlank( prefix )	?	null
				:	result.isCustomSetting()	?	'/setup/ui/listCustomSettingsData.apexp?id=' + prefix
				:									'/' + prefix;
			}
		}
		public	Boolean		hasListView	{ get { return listViewUrl != null; } }
		public	String		listViewLabel { get { return result.isCustomSetting() ? 'Manage' : 'List View'; } }

		public	List<FieldInfoList>		fieldInfoLists
		{
			get
			{
				if ( fieldInfoLists == null )
				{
					FieldInfoList	standardFields		= new FieldInfoList( 'Standard Fields', true );
					FieldInfoList	customFields		= new FieldInfoList( 'Custom Fields', false );

					fieldInfoLists		= new List<FieldInfoList>{ standardFields, customFields };

					for ( Schema.SObjectField fieldToken : result.fields.getMap().values() )
					{
						Schema.DescribeFieldResult	result		= fieldToken.getDescribe();
						if ( !result.isAccessible() ) continue;

						(	result.getName().contains( '__' )	?	customFields
						:											standardFields
						).add( new FieldInfo( name, result ) );
					}
					standardFields.collapse = customFields.hasFieldInfos;

					standardFields.sort();
					customFields.sort();
				}
				return fieldInfoLists;
			}
			private set;
		}
		public	Boolean		hasFields	{ get { return !fieldInfoLists.isEmpty(); } }

		public	List<FieldSetInfo>		fieldSetInfos
		{
			get
			{
				if ( fieldSetInfos == null )
				{
					Boolean	isRunningTest	= Test.isRunningTest();

					fieldSetInfos = new List<FieldSetInfo>();
					for ( Schema.FieldSet fieldSet : result.fieldSets.getMap().values() )
					{
						fieldSetInfos.add( new FieldSetInfo( fieldSet, true ) );
					}
					fieldSetInfos.sort();
				}
				return fieldSetInfos;
			}
			private set;
		}
		public	Boolean		hasFieldSets		{ get { return !fieldSetInfos.isEmpty(); } }

		public	List<RecordTypeInfo>	recordTypeInfos
		{
			get
			{
				if ( recordTypeInfos == null )
				{
					Boolean	isRunningTest	= Test.isRunningTest();

					recordTypeInfos = new List<RecordTypeInfo>();
					for ( Schema.RecordTypeInfo recordType : result.getRecordTypeInfos() )
					{
						if ( ( !recordType.isAvailable() || !map_RecordTypes.containsKey( recordType.getRecordTypeId() )) && !isRunningTest ) continue;

						if ( !isRunningTest ) recordTypeInfos.add( new RecordTypeInfo( recordType ) );
					}
					recordTypeInfos.sort();
				}
				return recordTypeInfos;
			}
			private set;
		}
		public	Boolean		hasRecordTypes	{ get { return !recordTypeInfos.isEmpty(); } }

		public	List<ChildRelationshipInfoList>	childRelationshipInfoLists
		{
			get
			{
				if ( childRelationshipInfoLists == null )
				{
					ChildRelationshipInfoList	standardObjects		= new ChildRelationshipInfoList( 'Standard Objects', true );
					ChildRelationshipInfoList	customObjects		= new ChildRelationshipInfoList( 'Custom Objects', true );

					childRelationshipInfoLists		= new List<ChildRelationshipInfoList>{ standardObjects, customObjects };

					for ( Schema.ChildRelationship childRelationship : result.getChildRelationships() )
					{
						(	childRelationship.getChildSObject().getDescribe().getName().contains( '__' )	?	customObjects
						:																						standardObjects
						).add( new ChildRelationshipInfo( childRelationship ) );
					}

					standardObjects.sort();
					customObjects.sort();
				}
				return childRelationshipInfoLists;
			}
			private set;
		}
		public	Boolean		hasChildRelationships	{ get { return !childRelationshipInfoLists.isEmpty(); } }

		public ObjectInfo( Schema.DescribeSObjectResult theResult )
		{
			result		= theResult;
		}

		public ObjectInfo( Schema.SObjectType theType )
		{
			result		= null;
			name		= String.valueOf( theType );
		}

		public Integer compareTo( Object other )
		{
			return name.compareTo( ((ObjectInfo) other).name );
		}
	}

	/*******************************************************
					ObjectInfoList class
	*******************************************************/

	public class ObjectInfoList
	{
		public	String				name				{ get; set; }
		public	Boolean				collapse			{ get; set; }
		public	String				elementId			{ get { return name.deleteWhitespace(); } }
		public	String				listViewHeader		{ get { return name != 'Custom Settings' ? 'List View' : 'Manage'; } }

		public	List<ObjectInfo>	objectInfos
		{
			get { if ( objectInfos == null ) { objectInfos = new List<ObjectInfo>(); } return objectInfos; }
			private set;
		}
		public	Boolean		hasObjectInfos		{ get { return !objectInfos.isEmpty(); } }

		public ObjectInfoList( String theName, Boolean defaultCollapsed )
		{
			name		= theName;
			collapse	= defaultCollapsed;
		}

		private void add( ObjectInfo info )
		{
			objectInfos.add( info );
		}

		private void sort()
		{
			objectInfos.sort();
		}
	}

	/*******************************************************
				detailObject property
	*******************************************************/

	public	ObjectInfo		detailObject
	{
		get
		{
			if ( detailObject == null && !showAllObjects )
			{
				Schema.sObjectType	sObjectType		= Schema.getGlobalDescribe().get( objectName );
				if ( sObjectType == null ) return null;

				Schema.DescribeSObjectResult	result		= sObjectType.getDescribe();
				detailObject = result != null && result.isAccessible() ? new ObjectInfo( result ) : null;
			}
			return detailObject;
		}
		private set;
	}

	/*******************************************************
				objectInfoLists property
	*******************************************************/

	public	List<ObjectInfoList>	objectInfoLists
	{
		get
		{
			if ( objectInfoLists == null )
			{
				ObjectInfoList	standardObjects		= new ObjectInfoList( 'Standard Objects',	true );
				ObjectInfoList	managedObjects		= new ObjectInfoList( 'Managed Objects',	true );
				ObjectInfoList	customObjects		= new ObjectInfoList( 'Custom Objects',		false );
				ObjectInfoList	customSettings		= new ObjectInfoList( 'Custom Settings',	true );
				ObjectInfoList	historyObjects		= new ObjectInfoList( 'History Objects',	true );
				ObjectInfoList	feedObjects			= new ObjectInfoList( 'Feed Objects',		true );
				ObjectInfoList	shareObjects		= new ObjectInfoList( 'Share Objects',		true );
				ObjectInfoList	tagObjects			= new ObjectInfoList( 'Tag Objects',		true );
				ObjectInfoList	knowledgeObjects	= new ObjectInfoList( 'Knowledge Objects',	true );
				ObjectInfoList	historicalObjects	= new ObjectInfoList( 'Historical Objects',	true );

				objectInfoLists		= new List<ObjectInfoList>
				{	customObjects,
					customSettings,
					standardObjects,
					managedObjects,
					historyObjects,
					feedObjects,
					shareObjects,
					tagObjects,
					knowledgeObjects,
					historicalObjects
				};

				Boolean	isRunningTest	= Test.isRunningTest();

				Map<String,Schema.SObjectType>	globalDescribe	= Schema.getGlobalDescribe().clone();
				for ( String sObjectName : globalDescribe.keySet() )
				{
					if ( sObjectName.endsWith( '__kav' ) )
					{
						knowledgeObjects.add( new ObjectInfo( globalDescribe.get( sObjectName ) ) );
						globalDescribe.remove( sObjectName );
					}
				}

				for ( Schema.DescribeSObjectResult result : Schema.describeSObjects( new List<String>( globalDescribe.keySet() ) ) )
				{
					if ( !result.isAccessible() ) continue;

					(	result.getName().substringBeforeLast( '__' ).contains( '__' )	?	managedObjects
					:	result.isCustomSetting()										?	customSettings
					:	result.getName().endsWith( 'History' )							?	historyObjects
					:	result.getName().endsWith( 'Feed' )								?	feedObjects
					:	result.getName().endsWith( 'Share' )							?	shareObjects
					:	result.getName().endsWith( 'Tag' )								?	tagObjects
					:	result.getName().endsWith( '__ka' )								?	knowledgeObjects
					:	result.getName().endsWith( '__DataCategorySelection' )			?	knowledgeObjects
					:	result.getName().endsWith( '__ViewStat' )						?	knowledgeObjects
					:	result.getName().endsWith( '__VoteStat' )						?	knowledgeObjects
					:	result.getName().endsWith( '_hd' )								?	historicalObjects
					:	result.isCustom()												?	customObjects
					:																		standardObjects
					).add( new ObjectInfo( result ) );
				}
				standardObjects.collapse = customObjects.hasObjectInfos;

				for ( ObjectInfoList infoList : objectInfoLists )
				{
					infoList.sort();
				}
			}
			return objectInfoLists;
		}
		private set;
	}

	/*******************************************************
				map_FieldType_TypeName
	*******************************************************/

	private static Map<Schema.DisplayType,String>	map_FieldType_TypeName = new Map<Schema.DisplayType,String>
	{
		Schema.DisplayType.AnyType			=>	'Object',
		Schema.DisplayType.Base64			=>	'Blob',
		Schema.DisplayType.Boolean			=>	'Boolean',
		Schema.DisplayType.ComboBox			=>	'String',
		Schema.DisplayType.Currency			=>	'Decimal',
		Schema.DisplayType.Date				=>	'Date',
		Schema.DisplayType.DateTime			=>	'DateTime',
		Schema.DisplayType.Double			=>	'Decimal',
		Schema.DisplayType.Email			=>	'String',
		Schema.DisplayType.EncryptedString	=>	'String',
		Schema.DisplayType.Id				=>	'Id',
		Schema.DisplayType.Location			=>	'Object',
		Schema.DisplayType.MultiPicklist	=>	'String',
		Schema.DisplayType.Percent			=>	'Decimal',
		Schema.DisplayType.Phone			=>	'String',
		Schema.DisplayType.Picklist			=>	'String',
		Schema.DisplayType.Reference		=>	'Id',
		Schema.DisplayType.String			=>	'String',
		Schema.DisplayType.TextArea			=>	'String',
		Schema.DisplayType.Time				=>	'Time',
		Schema.DisplayType.URL				=>	'String'
	};
}