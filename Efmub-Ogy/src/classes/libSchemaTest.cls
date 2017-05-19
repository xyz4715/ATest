/*******************************************************//**

@class		CWSchemaTest

@brief		CW Core Schema Class Test Methods

	The CWSchemaTest class contains the test methods for the
	CWSchema class.

	Entry points:

	public static Map<String,Schema.sObjectType> getGlobalDescribe()
	public static Set<String> getAllSObjectNames()
	public static List<Schema.sObjectType> getAllSObjectTypes()

	public static Boolean isSObject( String sObjectName )
	public static Boolean isSObject( Schema.sObjectType sObjectType )
	public static Boolean isSObject( Schema.DescribeSObjectResult sObjectResult )
	public static Boolean isSObject( sObject anSObject )
	public static Boolean isSObject( Id sObjectId )

	public static String getSObjectName( String sObjectName )
	public static String getSObjectName( Schema.sObjectType sObjectType )
	public static String getSObjectName( Schema.DescribeSObjectResult sObjectResult )
	public static String getSObjectName( sObject anSObject )
	public static String getSObjectName( Id sObjectId )

	public static Schema.sObjectType getSObjectType( String sObjectName )
	public static Schema.sObjectType getSObjectType( Schema.sObjectType sObjectType )
	public static Schema.sObjectType getSObjectType( Schema.DescribeSObjectResult sObjectResult )
	public static Schema.sObjectType getSObjectType( sObject anSObject )
	public static Schema.sObjectType getSObjectType( Id sObjectId )

	public static Schema.DescribeSObjectResult getDescribeSObjectResult( String sObjectName )
	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.sObjectType sObjectType )
	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult )
	public static Schema.DescribeSObjectResult getDescribeSObjectResult( sObject anSObject )
	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Id sObjectId )

	public static String getSObjectLabel( String sObjectName )
	public static String getSObjectLabel( Schema.sObjectType sObjectType )
	public static String getSObjectLabel( Schema.DescribeSObjectResult sObjectResult )
	public static String getSObjectLabel( sObject anSObject )
	public static String getSObjectLabel( Id sObjectId )

	public static String getKeyPrefix( String sObjectName )
	public static String getKeyPrefix( Schema.sObjectType sObjectType )
	public static String getKeyPrefix( Schema.DescribeSObjectResult sObjectResult )
	public static String getKeyPrefix( sObject anSObject )
	public static String getKeyPrefix( Id sObjectId )

	public static Map<String,Schema.sObjectField> getSObjectFields( String sObjectName )
	public static Map<String,Schema.sObjectField> getSObjectFields( Schema.sObjectType sObjectType )
	public static Map<String,Schema.sObjectField> getSObjectFields( Schema.DescribeSObjectResult sObjectResult )
	public static Map<String,Schema.sObjectField> getSObjectFields( sObject anSObject )
	public static Map<String,Schema.sObjectField> getSObjectFields( Id sObjectId )

	public static Map<String,Schema.FieldSet> getFieldSets( String sObjectName )
	public static Map<String,Schema.FieldSet> getFieldSets( Schema.sObjectType sObjectType )
	public static Map<String,Schema.FieldSet> getFieldSets( Schema.DescribeSObjectResult sObjectResult )
	public static Map<String,Schema.FieldSet> getFieldSets( sObject anSObject )
	public static Map<String,Schema.FieldSet> getFieldSets( Id sObjectId )

	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( String sObjectName )
	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.sObjectType sObjectType )
	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.DescribeSObjectResult sObjectResult )
	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( sObject anSObject )
	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Id sObjectId )

	public static Map<String,Schema.ChildRelationship> getChildRelationships( String sObjectName )
	public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.sObjectType sObjectType )
	public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.DescribeSObjectResult sObjectResult )
	public static Map<String,Schema.ChildRelationship> getChildRelationships( sObject anSObject )
	public static Map<String,Schema.ChildRelationship> getChildRelationships( Id sObjectId )

	public static Boolean isField( String sObjectName, String fieldName )
	public static Boolean isField( Schema.sObjectType sObjectType, String fieldName )
	public static Boolean isField( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Boolean isField( sObject anSObject, String fieldName )
	public static Boolean isField( Id sObjectId, String fieldName )
	public static Boolean isField( Schema.sObjectField sObjectField )
	public static Boolean isField( Schema.DescribeFieldResult fieldResult )

	public static Schema.sObjectField getSObjectField( String sObjectName, String fieldName )
	public static Schema.sObjectField getSObjectField( Schema.sObjectType sObjectType, String fieldName )
	public static Schema.sObjectField getSObjectField( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Schema.sObjectField getSObjectField( sObject anSObject, String fieldName )
	public static Schema.sObjectField getSObjectField( Id sObjectId, String fieldName )
	public static Schema.sObjectField getSObjectField( Schema.sObjectField sObjectField )
	public static Schema.sObjectField getSObjectField( Schema.DescribeFieldResult fieldResult )

	public static Schema.DescribeFieldResult getDescribeFieldResult( String sObjectName, String fieldName )
	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectType sObjectType, String fieldName )
	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Schema.DescribeFieldResult getDescribeFieldResult( sObject anSObject, String fieldName )
	public static Schema.DescribeFieldResult getDescribeFieldResult( Id sObjectId, String fieldName )
	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectField sObjectField )
	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeFieldResult fieldResult )

	public static String getFieldName( String sObjectName, String fieldName )
	public static String getFieldName( Schema.sObjectType sObjectType, String fieldName )
	public static String getFieldName( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static String getFieldName( sObject anSObject, String fieldName )
	public static String getFieldName( Id sObjectId, String fieldName )
	public static String getFieldName( Schema.sObjectField sObjectField )
	public static String getFieldName( Schema.DescribeFieldResult fieldResult )

	public static String getFieldLabel( String sObjectName, String fieldName )
	public static String getFieldLabel( Schema.sObjectType sObjectType, String fieldName )
	public static String getFieldLabel( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static String getFieldLabel( sObject anSObject, String fieldName )
	public static String getFieldLabel( Id sObjectId, String fieldName )
	public static String getFieldLabel( Schema.sObjectField sObjectField )
	public static String getFieldLabel( Schema.DescribeFieldResult fieldResult )

	public static Schema.DisplayType getFieldDisplayType( String sObjectName, String fieldName )
	public static Schema.DisplayType getFieldDisplayType( Schema.sObjectType sObjectType, String fieldName )
	public static Schema.DisplayType getFieldDisplayType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Schema.DisplayType getFieldDisplayType( sObject anSObject, String fieldName )
	public static Schema.DisplayType getFieldDisplayType( Id sObjectId, String fieldName )
	public static Schema.DisplayType getFieldDisplayType( Schema.sObjectField sObjectField )
	public static Schema.DisplayType getFieldDisplayType( Schema.DescribeFieldResult fieldResult )

	public static Type getFieldType( String sObjectName, String fieldName )
	public static Type getFieldType( Schema.sObjectType sObjectType, String fieldName )
	public static Type getFieldType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Type getFieldType( sObject anSObject, String fieldName )
	public static Type getFieldType( Id sObjectId, String fieldName )
	public static Type getFieldType( Schema.sObjectField sObjectField )
	public static Type getFieldType( Schema.DescribeFieldResult fieldResult )

	public static Schema.SOAPType getFieldSOAPType( String sObjectName, String fieldName )
	public static Schema.SOAPType getFieldSOAPType( Schema.sObjectType sObjectType, String fieldName )
	public static Schema.SOAPType getFieldSOAPType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Schema.SOAPType getFieldSOAPType( sObject anSObject, String fieldName )
	public static Schema.SOAPType getFieldSOAPType( Id sObjectId, String fieldName )
	public static Schema.SOAPType getFieldSOAPType( Schema.sObjectField sObjectField )
	public static Schema.SOAPType getFieldSOAPType( Schema.DescribeFieldResult fieldResult )

	public static Integer getFieldLength( String sObjectName, String fieldName )
	public static Integer getFieldLength( Schema.sObjectType sObjectType, String fieldName )
	public static Integer getFieldLength( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Integer getFieldLength( sObject anSObject, String fieldName )
	public static Integer getFieldLength( Id sObjectId, String fieldName )
	public static Integer getFieldLength( Schema.sObjectField sObjectField )
	public static Integer getFieldLength( Schema.DescribeFieldResult fieldResult )

	public static Map<String,Schema.PicklistEntry> getPicklistEntries( String sObjectName, String fieldName )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectType sObjectType, String fieldName )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeSObjectResult sObjectResult, String fieldName )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( sObject anSObject, String fieldName )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Id sObjectId, String fieldName )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectField sObjectField )
	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeFieldResult fieldResult )

	public static Boolean isFieldSet( String sObjectName, String fieldSetName )
	public static Boolean isFieldSet( Schema.sObjectType sObjectType, String fieldSetName )
	public static Boolean isFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
	public static Boolean isFieldSet( sObject anSObject, String fieldSetName )
	public static Boolean isFieldSet( Id sObjectId, String fieldSetName )
	public static Boolean isFieldSet( Schema.FieldSet fieldSet )

	public static Schema.FieldSet getFieldSet( String sObjectName, String fieldSetName )
	public static Schema.FieldSet getFieldSet( Schema.sObjectType sObjectType, String fieldSetName )
	public static Schema.FieldSet getFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
	public static Schema.FieldSet getFieldSet( sObject anSObject, String fieldSetName )
	public static Schema.FieldSet getFieldSet( Id sObjectId, String fieldSetName )
	public static Schema.FieldSet getFieldSet( Schema.FieldSet fieldSet )

	public static String getFieldSetName( String sObjectName, String fieldSetName )
	public static String getFieldSetName( Schema.sObjectType sObjectType, String fieldSetName )
	public static String getFieldSetName( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
	public static String getFieldSetName( sObject anSObject, String fieldSetName )
	public static String getFieldSetName( Id sObjectId, String fieldSetName )
	public static String getFieldSetName( Schema.FieldSet fieldSet )

	public static String getFieldSetLabel( String sObjectName, String fieldSetName )
	public static String getFieldSetLabel( Schema.sObjectType sObjectType, String fieldSetName )
	public static String getFieldSetLabel( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
	public static String getFieldSetLabel( sObject anSObject, String fieldSetName )
	public static String getFieldSetLabel( Id sObjectId, String fieldSetName )
	public static String getFieldSetLabel( Schema.FieldSet fieldSet )

	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( String sObjectName, String fieldSetName )
	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.sObjectType sObjectType, String fieldSetName )
	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( sObject anSObject, String fieldSetName )
	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Id sObjectId, String fieldSetName )
	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.FieldSet fieldSet )

	public static Boolean isRecordType( String sObjectName, String recordTypeName )
	public static Boolean isRecordType( Schema.sObjectType sObjectType, String recordTypeName )
	public static Boolean isRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static Boolean isRecordType( sObject anSObject, String recordTypeName )
	public static Boolean isRecordType( Id sObjectId, String recordTypeName )
	public static Boolean isRecordType( RecordType recordType )
	public static Boolean isRecordType( Schema.RecordTypeInfo recordTypeInfo )
	public static Boolean isRecordType( Id recordTypeId )

	public static RecordType getRecordType( String sObjectName, String recordTypeName )
	public static RecordType getRecordType( Schema.sObjectType sObjectType, String recordTypeName )
	public static RecordType getRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static RecordType getRecordType( sObject anSObject, String recordTypeName )
	public static RecordType getRecordType( Id sObjectId, String recordTypeName )
	public static RecordType getRecordType( RecordType recordType )
	public static RecordType getRecordType( Schema.RecordTypeInfo recordTypeInfo )
	public static RecordType getRecordType( Id recordTypeId )

	public static Schema.RecordTypeInfo getRecordTypeInfo( String sObjectName, String recordTypeName )
	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.sObjectType sObjectType, String recordTypeName )
	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static Schema.RecordTypeInfo getRecordTypeInfo( sObject anSObject, String recordTypeName )
	public static Schema.RecordTypeInfo getRecordTypeInfo( Id sObjectId, String recordTypeName )
	public static Schema.RecordTypeInfo getRecordTypeInfo( RecordType recordType )
	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.RecordTypeInfo recordTypeInfo )
	public static Schema.RecordTypeInfo getRecordTypeInfo( Id recordTypeId )

	public static Id getRecordTypeId( String sObjectName, String recordTypeName )
	public static Id getRecordTypeId( Schema.sObjectType sObjectType, String recordTypeName )
	public static Id getRecordTypeId( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static Id getRecordTypeId( sObject anSObject, String recordTypeName )
	public static Id getRecordTypeId( Id sObjectId, String recordTypeName )
	public static Id getRecordTypeId( RecordType recordType )
	public static Id getRecordTypeId( Schema.RecordTypeInfo recordTypeInfo )
	public static Id getRecordTypeId( Id recordTypeId )

	public static String getRecordTypeName( String sObjectName, String recordTypeName )
	public static String getRecordTypeName( Schema.sObjectType sObjectType, String recordTypeName )
	public static String getRecordTypeName( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static String getRecordTypeName( sObject anSObject, String recordTypeName )
	public static String getRecordTypeName( Id sObjectId, String recordTypeName )
	public static String getRecordTypeName( RecordType recordType )
	public static String getRecordTypeName( Schema.RecordTypeInfo recordTypeInfo )
	public static String getRecordTypeName( Id recordTypeId )

	public static String getRecordTypeLabel( String sObjectName, String recordTypeName )
	public static String getRecordTypeLabel( Schema.sObjectType sObjectType, String recordTypeName )
	public static String getRecordTypeLabel( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static String getRecordTypeLabel( sObject anSObject, String recordTypeName )
	public static String getRecordTypeLabel( Id sObjectId, String recordTypeName )
	public static String getRecordTypeLabel( RecordType recordType )
	public static String getRecordTypeLabel( Schema.RecordTypeInfo recordTypeInfo )
	public static String getRecordTypeLabel( Id recordTypeId )

	public static Boolean isPersonType( String sObjectName, String recordTypeName )
	public static Boolean isPersonType( Schema.sObjectType sObjectType, String recordTypeName )
	public static Boolean isPersonType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
	public static Boolean isPersonType( sObject anSObject, String recordTypeName )
	public static Boolean isPersonType( Id sObjectId, String recordTypeName )
	public static Boolean isPersonType( RecordType recordType )
	public static Boolean isPersonType( Schema.RecordTypeInfo recordTypeInfo )
	public static Boolean isPersonType( Id recordTypeId )

	public static Boolean isChildRelationship( String sObjectName, String childRelationshipName )
	public static Boolean isChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Boolean isChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Boolean isChildRelationship( sObject anSObject, String childRelationshipName )
	public static Boolean isChildRelationship( Id sObjectId, String childRelationshipName )
	public static Boolean isChildRelationship( Schema.ChildRelationship childRelationship )

	public static Schema.ChildRelationship getChildRelationship( String sObjectName, String childRelationshipName )
	public static Schema.ChildRelationship getChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Schema.ChildRelationship getChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Schema.ChildRelationship getChildRelationship( sObject anSObject, String childRelationshipName )
	public static Schema.ChildRelationship getChildRelationship( Id sObjectId, String childRelationshipName )
	public static Schema.ChildRelationship getChildRelationship( Schema.ChildRelationship childRelationship )

	public static String getChildSObjectName( String sObjectName, String childRelationshipName )
	public static String getChildSObjectName( Schema.sObjectType sObjectType, String childRelationshipName )
	public static String getChildSObjectName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static String getChildSObjectName( sObject anSObject, String childRelationshipName )
	public static String getChildSObjectName( Id sObjectId, String childRelationshipName )
	public static String getChildSObjectName( Schema.ChildRelationship childRelationship )

	public static Schema.sObjectType getChildSObjectType( String sObjectName, String childRelationshipName )
	public static Schema.sObjectType getChildSObjectType( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Schema.sObjectType getChildSObjectType( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Schema.sObjectType getChildSObjectType( sObject anSObject, String childRelationshipName )
	public static Schema.sObjectType getChildSObjectType( Id sObjectId, String childRelationshipName )
	public static Schema.sObjectType getChildSObjectType( Schema.ChildRelationship childRelationship )

	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( String sObjectName, String childRelationshipName )
	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( sObject anSObject, String childRelationshipName )
	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Id sObjectId, String childRelationshipName )
	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.ChildRelationship childRelationship )

	public static String getChildFieldName( String sObjectName, String childRelationshipName )
	public static String getChildFieldName( Schema.sObjectType sObjectType, String childRelationshipName )
	public static String getChildFieldName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static String getChildFieldName( sObject anSObject, String childRelationshipName )
	public static String getChildFieldName( Id sObjectId, String childRelationshipName )
	public static String getChildFieldName( Schema.ChildRelationship childRelationship )

	public static Schema.sObjectField getChildSObjectField( String sObjectName, String childRelationshipName )
	public static Schema.sObjectField getChildSObjectField( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Schema.sObjectField getChildSObjectField( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Schema.sObjectField getChildSObjectField( sObject anSObject, String childRelationshipName )
	public static Schema.sObjectField getChildSObjectField( Id sObjectId, String childRelationshipName )
	public static Schema.sObjectField getChildSObjectField( Schema.ChildRelationship childRelationship )

	public static Schema.DescribeFieldResult getChildDescribeFieldResult( String sObjectName, String childRelationshipName )
	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.sObjectType sObjectType, String childRelationshipName )
	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static Schema.DescribeFieldResult getChildDescribeFieldResult( sObject anSObject, String childRelationshipName )
	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Id sObjectId, String childRelationshipName )
	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.ChildRelationship childRelationship )

	public static String getChildRelationshipName( String sObjectName, String childRelationshipName )
	public static String getChildRelationshipName( Schema.sObjectType sObjectType, String childRelationshipName )
	public static String getChildRelationshipName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
	public static String getChildRelationshipName( sObject anSObject, String childRelationshipName )
	public static String getChildRelationshipName( Id sObjectId, String childRelationshipName )
	public static String getChildRelationshipName( Schema.ChildRelationship childRelationship )

	public static Boolean isParentRelationship( String sObjectName, String lookupFieldName )
	public static Boolean isParentRelationship( Schema.sObjectType sObjectType, String lookupFieldName )
	public static Boolean isParentRelationship( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
	public static Boolean isParentRelationship( sObject anSObject, String lookupFieldName  )
	public static Boolean isParentRelationship( Id sObjectId, String lookupFieldName )

	public static String getParentRelationshipName( String sObjectName, String lookupFieldName )
	public static String getParentRelationshipName( Schema.sObjectType sObjectType, String lookupFieldName )
	public static String getParentRelationshipName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
	public static String getParentRelationshipName( sObject anSObject, String lookupFieldName  )
	public static String getParentRelationshipName( Id sObjectId, String lookupFieldName )

	public static String getParentSObjectName( String sObjectName, String lookupFieldName )
	public static String getParentSObjectName( Schema.sObjectType sObjectType, String lookupFieldName )
	public static String getParentSObjectName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
	public static String getParentSObjectName( sObject anSObject, String lookupFieldName )
	public static String getParentSObjectName( Id sObjectId, String lookupFieldName )

	public static Schema.sObjectType getParentSObjectType( String sObjectName, String lookupFieldName )
	public static Schema.sObjectType getParentSObjectType( Schema.sObjectType sObjectType, String lookupFieldName )
	public static Schema.sObjectType getParentSObjectType( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
	public static Schema.sObjectType getParentSObjectType( sObject anSObject, String lookupFieldName  )
	public static Schema.sObjectType getParentSObjectType( Id sObjectId, String lookupFieldName )

	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( String sObjectName, String lookupFieldName )
	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.sObjectType sObjectType, String lookupFieldName )
	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.sObjectType sObjectType, String lookupFieldName )
	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( sObject anSObject, String lookupFieldName  )
	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Id sObjectId, String lookupFieldName )

	public static Map<String,Schema.sObjectField> getParentSObjectFields( String sObjectName, String lookupFieldName )
	public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.sObjectType sObjectType, String lookupFieldName )
	public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
	public static Map<String,Schema.sObjectField> getSObjectFields( sObject anSObject, String lookupFieldName  )
	public static Map<String,Schema.sObjectField> getSObjectFields( Id sObjectId, String lookupFieldName )


@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-08-28	LiquidHub.GHA
	Created.
@version	2014-09-29	LiquidHub.GHA
	Added tests for new methods.

@see		CWSchema

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWSchemaTest
{
	/*******************************************************
						constants
	*******************************************************/

	private static final String		testSObjectName					= 'CWTestObject__c';
	private static final String		testSObjectLabel				= 'CWTestObject';
	private static final String		testSObjectName_Bad				= 'NotAnSObject';

	private static final String		testFieldName					= 'Lookup__c';
	private static final String		testFieldLabel					= 'Lookup';

	private static final Schema.DisplayType	testFieldDisplayType	= Schema.DisplayType.Reference;
	private static final Type				testFieldType			= Id.class;
	private static final Schema.SOAPType	testFieldSOAPType		= Schema.SOAPType.Id;

	private static final String		testFieldLengthName				= 'Text_40__c';
	private static final Integer	testFieldLengthLength			= 40;

	private static final String		testPicklistFieldName			= 'Picklist__c';
	private static final String		testNotPicklistFieldName		= 'Lookup__c';

	private static final String		testFieldSetName				= 'CWTestFieldSet';
	private static final String		testFieldSetNameNoNameSpace		= 'CWTestFieldSet';
	private static final String		testFieldSetLabel				= 'CWTestFieldSet';

	private static final String		testRecordTypeName				= 'CWTestRecordType';
	private static final String		testRecordTypeLabel				= 'CWTestRecordType';
	private static final String		testNotRecordTypeName			= 'NotARecordType';

	private static final String		testChildRelationshipName		= 'Children__r';
	private static final String		testNotChildRelationshipName	= 'NotAChildRelationship';
	private static final String		testChildFieldName				= 'Lookup__c';

	private static final String		testLookupFieldName				= 'Lookup__c';
	private static final String		testNotLookupFieldName			= 'NotALookupField';
	private static final String		testParentRelationshipName		= 'Lookup__r';

	/*******************************************************
				testCWSchemaGlobalDescribe
	*******************************************************/

	private static testMethod void testCWSchemaGlobalDescribe()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaGlobalDescribe' );
		String	testingMethod;

		testResult.startTest();

		/*	public static Map<String,Schema.sObjectType> getGlobalDescribe()	*/
		{
			testingMethod = 'CWSchema.getGlobalDescribe';
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			testResult.assert
			(	testingMethod,
				globalDescribe != null
			&&	!globalDescribe.isEmpty()
			&&	globalDescribe.get( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Set<String> getAllSObjectNames()	*/
		{
			testingMethod = 'CWSchema.getAllSObjectNames';
			testResult.clearErrors();
			Set<String> allSObjectNames = CWSchema.getAllSObjectNames();
			testResult.assert
			(	testingMethod,
				allSObjectNames != null
			&&	!allSObjectNames.isEmpty()
			&&	allSObjectNames.contains( testSObjectName.toLowercase() )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static List<Schema.sObjectType> getAllSObjectTypes()		*/
		{
			testingMethod = 'CWSchema.getAllSObjectTypes';
			testResult.clearErrors();
			List<Schema.sObjectType> allSObjectTypes = CWSchema.getAllSObjectTypes();
			testResult.assert
			(	testingMethod,
				allSObjectTypes != null
			&&	!allSObjectTypes.isEmpty()
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsSObject
	*******************************************************/

	private static testMethod void testCWSchemaIsSObject()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsSObject' );
		String	testingMethod = 'CWSchema.isSObject';

		testResult.startTest();

		/*	public static Boolean isSObject( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isSObject( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isSObject( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isSObject( sObjectType )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isSObject( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isSObject( sObjectResult )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isSObject( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isSObject( anSObject )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isSObject( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isSObject( anSObject.Id )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaSObjectName
	*******************************************************/

	private static testMethod void testCWSchemaSObjectName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaSObjectName' );
		String	testingMethod = 'CWSchema.getSObjectName';

		testResult.startTest();

		/*	public static String getSObjectName( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getSObjectName( testSObjectName ).equals( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getSObjectName( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static String getSObjectName( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getSObjectName( sObjectType ).equals( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectName( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getSObjectName( sObjectResult ).equals( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectName( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getSObjectName( anSObject ).equals( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectName( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getSObjectName( anSObject.Id ).equals( testSObjectName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaSObjectType
	*******************************************************/

	private static testMethod void testCWSchemaSObjectType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaSObjectType' );
		String	testingMethod = 'CWSchema.getSObjectType';

		testResult.startTest();

		/*	public static Schema.sObjectType getSObjectType( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getSObjectType( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getSObjectType( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Schema.sObjectType getSObjectType( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getSObjectType( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getSObjectType( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getSObjectType( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getSObjectType( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getSObjectType( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getSObjectType( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getSObjectType( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaDescribeSObjectResult
	*******************************************************/

	private static testMethod void testCWSchemaDescribeSObjectResult()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaDescribeSObjectResult' );
		String	testingMethod = 'CWSchema.getDescribeSObjectResult';

		testResult.startTest();

		/*	public static Schema.DescribeSObjectResult getDescribeSObjectResult( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getDescribeSObjectResult( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getDescribeSObjectResult( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getDescribeSObjectResult( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getDescribeSObjectResult( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getDescribeSObjectResult( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getDescribeSObjectResult( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getDescribeSObjectResult( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getDescribeSObjectResult( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectId Null',
				CWSchema.getDescribeSObjectResult( (Id) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectId.\n'
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaSObjectLabel
	*******************************************************/

	private static testMethod void testCWSchemaSObjectLabel()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaSObjectLabel' );
		String	testingMethod = 'CWSchema.getSObjectLabel';

		testResult.startTest();

		/*	public static String getSObjectLabel( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getSObjectLabel( testSObjectName ).equals( testSObjectLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getSObjectLabel( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static String getSObjectLabel( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getSObjectLabel( sObjectType ).equals( testSObjectLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectLabel( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getSObjectLabel( sObjectResult ).equals( testSObjectLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectLabel( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getSObjectLabel( anSObject ).equals( testSObjectLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getSObjectLabel( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getSObjectLabel( anSObject.Id ).equals( testSObjectLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaKeyPrefix
	*******************************************************/

	private static testMethod void testCWSchemaKeyPrefix()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaKeyPrefix' );
		String	testingMethod = 'CWSchema.getKeyPrefix';

		String	keyPrefixSObjectName	= 'Account';
		String	keyPrefix				= '001';

		testResult.startTest();

		/*	public static String getKeyPrefix( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getKeyPrefix( keyPrefixSObjectName ).equals( keyPrefix )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getKeyPrefix( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static String getKeyPrefix( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( keyPrefixSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getKeyPrefix( sObjectType ).equals( keyPrefix )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getKeyPrefix( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( keyPrefixSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getKeyPrefix( sObjectResult ).equals( keyPrefix )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getKeyPrefix( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( keyPrefixSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getKeyPrefix( anSObject ).equals( keyPrefix )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getKeyPrefix( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( keyPrefixSObjectName ).newInstance();
			anSObject.put( 'Name', 'Test Account' );
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getKeyPrefix( anSObject.Id ).equals( keyPrefix )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaSObjectFields
	*******************************************************/

	private static testMethod void testCWSchemaSObjectFields()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaSObjectFields' );
		String	testingMethod = 'CWSchema.getSObjectFields';

		testResult.startTest();

		/*	public static Map<String,Schema.sObjectField> getSObjectFields( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getSObjectFields( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getSObjectFields( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Map<String,Schema.sObjectField> getSObjectFields( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getSObjectFields( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getSObjectFields( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getSObjectFields( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getSObjectFields( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getSObjectFields( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getSObjectFields( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getSObjectFields( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSets
	*******************************************************/

	private static testMethod void testCWSchemaFieldSets()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSets' );
		String	testingMethod = 'CWSchema.getFieldSets';

		testResult.startTest();

		/*	public static Map<String,Schema.FieldSet> getFieldSets( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSets( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSets( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Map<String,Schema.FieldSet> getFieldSets( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSets( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSet> getFieldSets( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSets( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSet> getFieldSets( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSets( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSet> getFieldSets( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSets( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordTypeInfos
	*******************************************************/

	private static testMethod void testCWSchemaRecordTypeInfos()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordTypeInfos' );
		String	testingMethod = 'CWSchema.getRecordTypeInfos';

		testResult.startTest();

		/*	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getRecordTypeInfos( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getRecordTypeInfos( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getRecordTypeInfos( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getRecordTypeInfos( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getRecordTypeInfos( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getRecordTypeInfos( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildRelationships
	*******************************************************/

	private static testMethod void testCWSchemaChildRelationships()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildRelationships' );
		String	testingMethod = 'CWSchema.getChildRelationships';

		testResult.startTest();

		/*	public static Map<String,Schema.ChildRelationship> getChildRelationships( String sObjectName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildRelationships( testSObjectName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getChildRelationships( (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null sObjectName.\n'
			);
		}

		/*	public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.sObjectType sObjectType )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildRelationships( sObjectType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.DescribeSObjectResult sObjectResult )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.sObjectType> globalDescribe = CWSchema.getGlobalDescribe();
			Schema.sObjectType sObjectType = globalDescribe != null ? globalDescribe.get( testSObjectName ) : null;
			Schema.DescribeSObjectResult sObjectResult = sObjectType != null ? sObjectType.getDescribe() : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildRelationships( sObjectResult ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.ChildRelationship> getChildRelationships( sObject anSObject )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildRelationships( anSObject ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.ChildRelationship> getChildRelationships( Id sObjectId )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildRelationships( anSObject.Id ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsField
	*******************************************************/

	private static testMethod void testCWSchemaIsField()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsField' );
		String	testingMethod = 'CWSchema.isField';

		testResult.startTest();

		/*	public static Boolean isField( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isField( testSObjectName, testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isField( sObjectType, testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isField( sObjectResult, testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isField( anSObject, testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isField( anSObject.Id, testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.isField( sObjectField )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isField( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.isField( sObjectField.getDescribe() )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaSObjectField
	*******************************************************/

	private static testMethod void testCWSchemaSObjectField()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaSObjectField' );
		String	testingMethod = 'CWSchema.getSObjectField';

		testResult.startTest();

		/*	public static Schema.sObjectField getSObjectField( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getSObjectField( testSObjectName, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getSObjectField( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static Schema.sObjectField getSObjectField( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getSObjectField( sObjectType, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getSObjectField( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getSObjectField( sObjectResult, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getSObjectField( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getSObjectField( anSObject, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getSObjectField( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getSObjectField( anSObject.Id, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getSObjectField( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getSObjectField( sObjectField ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getSObjectField( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getSObjectField( sObjectField.getDescribe() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaDescribeFieldResult
	*******************************************************/

	private static testMethod void testCWSchemaDescribeFieldResult()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaDescribeFieldResult' );
		String	testingMethod = 'CWSchema.getDescribeFieldResult';

		testResult.startTest();

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getDescribeFieldResult( testSObjectName, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getDescribeFieldResult( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getDescribeFieldResult( sObjectType, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getDescribeFieldResult( sObjectResult, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getDescribeFieldResult( anSObject, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getDescribeFieldResult( anSObject.Id, testFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getDescribeFieldResult( sObjectField ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getDescribeFieldResult( sObjectField.getDescribe() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldName
	*******************************************************/

	private static testMethod void testCWSchemaFieldName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldName' );
		String	testingMethod = 'CWSchema.getFieldName';

		testResult.startTest();

		/*	public static String getFieldName( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldName( testSObjectName, testFieldName ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldName( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static String getFieldName( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldName( sObjectType, testFieldName ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldName( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldName( sObjectResult, testFieldName ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldName( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldName( anSObject, testFieldName ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldName( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldName( anSObject.Id, testFieldName ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldName( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldName( sObjectField ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldName( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldName( sObjectField.getDescribe() ).equals( testFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldLabel
	*******************************************************/

	private static testMethod void testCWSchemaFieldLabel()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldLabel' );
		String	testingMethod = 'CWSchema.getFieldLabel';

		testResult.startTest();

		/*	public static String getFieldLabel( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldLabel( testSObjectName, testFieldName ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldLabel( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static String getFieldLabel( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldLabel( sObjectType, testFieldName ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldLabel( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldLabel( sObjectResult, testFieldName ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldLabel( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldLabel( anSObject, testFieldName ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldLabel( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldLabel( anSObject.Id, testFieldName ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldLabel( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldLabel( sObjectField ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldLabel( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldLabel( sObjectField.getDescribe() ).equals( testFieldLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldDisplayType
	*******************************************************/

	private static testMethod void testCWSchemaFieldDisplayType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldDisplayType' );
		String	testingMethod = 'CWSchema.getFieldDisplayType';

		testResult.startTest();

		/*	public static Schema.DisplayType getFieldDisplayType( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldDisplayType( testSObjectName, testFieldName ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldDisplayType( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldDisplayType( sObjectType, testFieldName ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldDisplayType( sObjectResult, testFieldName ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldDisplayType( anSObject, testFieldName ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldDisplayType( anSObject.Id, testFieldName ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldDisplayType( sObjectField ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DisplayType getFieldDisplayType( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldDisplayType( sObjectField.getDescribe() ) == testFieldDisplayType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldType
	*******************************************************/

	private static testMethod void testCWSchemaFieldType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldType' );
		String	testingMethod = 'CWSchema.getFieldType';

		testResult.startTest();

		/*	public static Type getFieldType( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldType( testSObjectName, testFieldName ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldType( sObjectType, testFieldName ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldType( sObjectResult, testFieldName ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldType( anSObject, testFieldName ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldType( anSObject.Id, testFieldName ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldType( sObjectField ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Type getFieldType( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldType( sObjectField.getDescribe() ) == testFieldType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSOAPType
	*******************************************************/

	private static testMethod void testCWSchemaFieldSOAPType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSOAPType' );
		String	testingMethod = 'CWSchema.getFieldSOAPType';

		testResult.startTest();

		/*	public static Schema.SOAPType getFieldSOAPType( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSOAPType( testSObjectName, testFieldName ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSOAPType( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSOAPType( sObjectType, testFieldName ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSOAPType( sObjectResult, testFieldName ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSOAPType( anSObject, testFieldName ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSOAPType( anSObject.Id, testFieldName ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldSOAPType( sObjectField ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.SOAPType getFieldSOAPType( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldSOAPType( sObjectField.getDescribe() ) == testFieldSOAPType
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldLength
	*******************************************************/

	private static testMethod void testCWSchemaFieldLength()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldLength' );
		String	testingMethod = 'CWSchema.getFieldLength';

		testResult.startTest();

		/*	public static Integer getFieldLength( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldLength( testSObjectName, testFieldLengthName ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldLength( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldName.\n'
			);
		}

		/*	public static Integer getFieldLength( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldLength( sObjectType, testFieldLengthName ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Integer getFieldLength( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldLength( sObjectResult, testFieldLengthName ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Integer getFieldLength( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldLength( anSObject, testFieldLengthName ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Integer getFieldLength( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldLength( anSObject.Id, testFieldLengthName ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Integer getFieldLength( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldLengthName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getFieldLength( sObjectField ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Integer getFieldLength( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testFieldLengthName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getFieldLength( sObjectField.getDescribe() ) == testFieldLengthLength
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaPicklistEntries
	*******************************************************/

	private static testMethod void testCWSchemaPicklistEntries()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaPicklistEntries' );
		String	testingMethod = 'CWSchema.getPicklistEntries';

		testResult.startTest();

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( String sObjectName, String fieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getPicklistEntries( testSObjectName, testPicklistFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName (Negative)',
				CWSchema.getPicklistEntries( testSObjectName, testNotPicklistFieldName ) == null
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectType sObjectType, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getPicklistEntries( sObjectType, testPicklistFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeSObjectResult sObjectResult, String fieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getPicklistEntries( sObjectResult, testPicklistFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( sObject anSObject, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getPicklistEntries( anSObject, testPicklistFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getPicklistEntries( anSObject.Id, testPicklistFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectField sObjectField )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testPicklistFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectField',
				sObjectField != null
			&&	CWSchema.getPicklistEntries( sObjectField ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeFieldResult fieldResult )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.sObjectField sObjectField = sObjectType != null ? sObjectType.getDescribe().fields.getMap().get( testPicklistFieldName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldResult',
				sObjectField != null
			&&	CWSchema.getPicklistEntries( sObjectField.getDescribe() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsFieldSet
	*******************************************************/

	private static testMethod void testCWSchemaIsFieldSet()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsFieldSet' );
		String	testingMethod = 'CWSchema.isFieldSet';

		testResult.startTest();

		/*	public static Boolean isFieldSet( String sObjectName, String fieldSetName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isFieldSet( testSObjectName, testFieldSetName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isFieldSet( Schema.sObjectType sObjectType, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isFieldSet( sObjectType, testFieldSetName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isFieldSet( sObjectResult, testFieldSetName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isFieldSet( sObject anSObject, String fieldSetName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isFieldSet( anSObject, testFieldSetName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isFieldSet( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isFieldSet( anSObject.Id, testFieldSetName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isFieldSet( Schema.FieldSet fieldSet )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.FieldSet fieldSet = sObjectType != null ? sObjectType.getDescribe().fieldSets.getMap().get( testFieldSetName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldSet',
				fieldSet != null
			&&	CWSchema.isFieldSet( fieldSet )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSet
	*******************************************************/

	private static testMethod void testCWSchemaFieldSet()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSet' );
		String	testingMethod = 'CWSchema.getFieldSet';

		testResult.startTest();

		/*	public static Schema.FieldSet getFieldSet( String sObjectName, String fieldSetName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSet( testSObjectName, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSet( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldSetName.\n'
			);
		}

		/*	public static Schema.FieldSet getFieldSet( Schema.sObjectType sObjectType, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSet( sObjectType, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.FieldSet getFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSet( sObjectResult, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.FieldSet getFieldSet( sObject anSObject, String fieldSetName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSet( anSObject, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.FieldSet getFieldSet( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSet( anSObject.Id, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.FieldSet getFieldSet( Schema.FieldSet fieldSet )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.FieldSet fieldSet = sObjectType != null ? sObjectType.getDescribe().fieldSets.getMap().get( testFieldSetName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldSet',
				fieldSet != null
			&&	CWSchema.getFieldSet( fieldSet ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSetName
	*******************************************************/

	private static testMethod void testCWSchemaFieldSetName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSetName' );
		String	testingMethod = 'CWSchema.getFieldSetName';

		testResult.startTest();

		/*	public static String getFieldSetName( String sObjectName, String fieldSetName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSetName( testSObjectName, testFieldSetName ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSetName( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldSetName.\n'
			);
		}

		/*	public static String getFieldSetName( Schema.sObjectType sObjectType, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSetName( sObjectType, testFieldSetName ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetName( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSetName( sObjectResult, testFieldSetName ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetName( sObject anSObject, String fieldSetName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSetName( anSObject, testFieldSetName ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetName( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSetName( anSObject.Id, testFieldSetName ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetName( Schema.FieldSet fieldSet )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.FieldSet fieldSet = sObjectType != null ? sObjectType.getDescribe().fieldSets.getMap().get( testFieldSetName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldSet',
				fieldSet != null
			&&	CWSchema.getFieldSetName( fieldSet ).equals( testFieldSetNameNoNameSpace )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSetLabel
	*******************************************************/

	private static testMethod void testCWSchemaFieldSetLabel()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSetLabel' );
		String	testingMethod = 'CWSchema.getFieldSetLabel';

		testResult.startTest();

		/*	public static String getFieldSetLabel( String sObjectName, String fieldSetName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSetLabel( testSObjectName, testFieldSetName ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSetLabel( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldSetName.\n'
			);
		}

		/*	public static String getFieldSetLabel( Schema.sObjectType sObjectType, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSetLabel( sObjectType, testFieldSetName ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetLabel( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSetLabel( sObjectResult, testFieldSetName ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetLabel( sObject anSObject, String fieldSetName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSetLabel( anSObject, testFieldSetName ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetLabel( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSetLabel( anSObject.Id, testFieldSetName ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getFieldSetLabel( Schema.FieldSet fieldSet )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.FieldSet fieldSet = sObjectType != null ? sObjectType.getDescribe().fieldSets.getMap().get( testFieldSetName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldSet',
				fieldSet != null
			&&	CWSchema.getFieldSetLabel( fieldSet ).equals( testFieldSetLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaFieldSetMembers
	*******************************************************/

	private static testMethod void testCWSchemaFieldSetMembers()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaFieldSetMembers' );
		String	testingMethod = 'CWSchema.getFieldSetMembers';

		testResult.startTest();

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( String sObjectName, String fieldSetName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getFieldSetMembers( testSObjectName, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getFieldSetMembers( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null fieldSetName.\n'
			);
		}

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.sObjectType sObjectType, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getFieldSetMembers( sObjectType, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getFieldSetMembers( sObjectResult, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( sObject anSObject, String fieldSetName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getFieldSetMembers( anSObject, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Id sObjectId, String fieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getFieldSetMembers( anSObject.Id, testFieldSetName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.FieldSet fieldSet )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			Schema.FieldSet fieldSet = sObjectType != null ? sObjectType.getDescribe().fieldSets.getMap().get( testFieldSetName ) : null;
			testResult.assert
			(	testingMethod + ' - fieldSet',
				fieldSet != null
			&&	CWSchema.getFieldSetMembers( fieldSet ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsRecordType
	*******************************************************/

	private static testMethod void testCWSchemaIsRecordType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsRecordType' );
		String	testingMethod = 'CWSchema.isRecordType';

		testResult.startTest();

		/*	public static Boolean isRecordType( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isRecordType( testSObjectName, testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName (Negative)',
				!CWSchema.isRecordType( testSObjectName, testNotRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isRecordType( sObjectType, testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isRecordType( sObjectResult, testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isRecordType( anSObject, testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isRecordType( anSObject.Id, testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static Boolean isRecordType( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.isRecordType( recordType )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.isRecordType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isRecordType( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.isRecordType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordType
	*******************************************************/

	private static testMethod void testCWSchemaRecordType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordType' );
		String	testingMethod = 'CWSchema.getRecordType';

		testResult.startTest();

		/*	public static RecordType getRecordType( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getRecordType( testSObjectName, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getRecordType( sObjectType, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getRecordType( sObjectResult, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getRecordType( anSObject, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getRecordType( anSObject.Id, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static RecordType getRecordType( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.getRecordType( recordType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static RecordType getRecordType( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordTypeInfo
	*******************************************************/

	private static testMethod void testCWSchemaRecordTypeInfo()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordTypeInfo' );
		String	testingMethod = 'CWSchema.getRecordTypeInfo';

		testResult.startTest();

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getRecordTypeInfo( testSObjectName, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getRecordTypeInfo( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null recordTypeName.\n'
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getRecordTypeInfo( sObjectType, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getRecordTypeInfo( sObjectResult, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getRecordTypeInfo( anSObject, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getRecordTypeInfo( anSObject.Id, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.getRecordTypeInfo( recordType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeInfo( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.RecordTypeInfo getRecordTypeInfo( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeInfo( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordTypeId
	*******************************************************/

	private static testMethod void testCWSchemaRecordTypeId()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordTypeId' );
		String	testingMethod = 'CWSchema.getRecordTypeId';

		testResult.startTest();

		/*	public static Id getRecordTypeId( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getRecordTypeId( testSObjectName, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getRecordTypeId( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null recordTypeName.\n'
			);
		}

		/*	public static Id getRecordTypeId( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getRecordTypeId( sObjectType, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Id getRecordTypeId( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getRecordTypeId( sObjectResult, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Id getRecordTypeId( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getRecordTypeId( anSObject, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Id getRecordTypeId( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getRecordTypeId( anSObject.Id, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static Id getRecordTypeId( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.getRecordTypeId( recordType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Id getRecordTypeId( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeId( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo Null',
				CWSchema.getRecordTypeId( (Schema.RecordTypeInfo) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null recordTypeInfo.\n'
			);
		}

		/*	public static Id getRecordTypeId( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeId( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordTypeName
	*******************************************************/

	private static testMethod void testCWSchemaRecordTypeName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordTypeName' );
		String	testingMethod = 'CWSchema.getRecordTypeName';

		testResult.startTest();

		/*	public static String getRecordTypeName( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getRecordTypeName( testSObjectName, testRecordTypeName ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getRecordTypeName( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null recordTypeName.\n'
			);
		}

		/*	public static String getRecordTypeName( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getRecordTypeName( sObjectType, testRecordTypeName ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeName( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getRecordTypeName( sObjectResult, testRecordTypeName ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeName( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getRecordTypeName( anSObject, testRecordTypeName ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeName( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getRecordTypeName( anSObject.Id, testRecordTypeName ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static String getRecordTypeName( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.getRecordTypeName( recordType ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeName( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeName( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeName( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeName( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ).equals( testRecordTypeName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaRecordTypeLabel
	*******************************************************/

	private static testMethod void testCWSchemaRecordTypeLabel()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaRecordTypeLabel' );
		String	testingMethod = 'CWSchema.getRecordTypeLabel';

		testResult.startTest();

		/*	public static String getRecordTypeLabel( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			String	label	= CWSchema.getRecordTypeLabel( testSObjectName, testRecordTypeName );
			testResult.assert
			(	testingMethod + ' - sObjectName',
				label != null
			&&	label.equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getRecordTypeLabel( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null recordTypeName.\n'
			);
		}

		/*	public static String getRecordTypeLabel( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			String	label	= sObjectType != null ? CWSchema.getRecordTypeLabel( sObjectType, testRecordTypeName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectType',
				label != null
			&&	label.equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeLabel( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			String	label	= sObjectResult != null ? CWSchema.getRecordTypeLabel( sObjectResult, testRecordTypeName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				label != null
			&&	label.equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeLabel( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			String	label	= anSObject != null ? CWSchema.getRecordTypeLabel( anSObject, testRecordTypeName ) : null;
			testResult.assert
			(	testingMethod + ' - anSObject',
				label != null
			&&	label.equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeLabel( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			String	label	= anSObject.Id != null ? CWSchema.getRecordTypeLabel( anSObject.Id, testRecordTypeName ) : null;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				label != null
			&&	label.equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		for ( RecordType rType : [SELECT Id, sObjectType, Name, DeveloperName FROM RecordType WHERE sObjectType = :testSObjectName AND Name = :testRecordTypeName] )
		{
			recordType = rType;
		}

		/*	public static String getRecordTypeLabel( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.getRecordTypeLabel( recordType ).equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeLabel( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeLabel( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ).equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getRecordTypeLabel( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.getRecordTypeLabel( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ).equals( testRecordTypeLabel )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsPersonType
	*******************************************************/

	private static testMethod void testCWSchemaIsPersonType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsPersonType' );
		String	testingMethod = 'CWSchema.isPersonType';

		testResult.startTest();

		/*	public static Boolean isPersonType( String sObjectName, String recordTypeName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isPersonType( testSObjectName, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( Schema.sObjectType sObjectType, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isPersonType( sObjectType, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isPersonType( sObjectResult, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( sObject anSObject, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isPersonType( anSObject, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( Id sObjectId, String recordTypeName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isPersonType( anSObject.Id, testRecordTypeName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		RecordType recordType;
		CWQuery	recordTypeQuery = CWQuery.newQuery( 'RecordType' );
		recordTypeQuery.addAllFields();
		CWQuery.WhereClause whereClause = recordTypeQuery.newAndWhereClause( 'IsActive = true' );
		whereClause.add( 'sObjectType = \'' + testSObjectName + '\'' );
		whereClause.add( 'Name = \'' + testRecordTypeName + '\'' );
		for ( RecordType rType : (List<RecordType>) recordTypeQuery.query() )
		{
			recordType = rType;
		}

		/*	public static Boolean isPersonType( RecordType recordType )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordType',
				recordType != null
			&&	CWSchema.isPersonType( recordType ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( Schema.RecordTypeInfo recordTypeInfo )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.isPersonType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ) ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isPersonType( Id recordTypeId )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - recordTypeInfo',
				recordType != null
			&&	CWSchema.isPersonType( CWSchema.getRecordTypeInfos( testSObjectName ).get( recordType.Id ).getRecordTypeId() ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsChildRelationship
	*******************************************************/

	private static testMethod void testCWSchemaIsChildRelationship()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsChildRelationship' );
		String	testingMethod = 'CWSchema.isChildRelationship';

		testResult.startTest();

		/*	public static Boolean isChildRelationship( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isChildRelationship( testSObjectName, testChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName (Negative)',
				!CWSchema.isChildRelationship( testSObjectName, testNotChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isChildRelationship( sObjectType, testChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isChildRelationship( sObjectResult, testChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isChildRelationship( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isChildRelationship( anSObject, testChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isChildRelationship( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isChildRelationship( anSObject.Id, testChildRelationshipName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isChildRelationship( Schema.ChildRelationship childRelationship )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.isChildRelationship( childRelationship )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildRelationship
	*******************************************************/

	private static testMethod void testCWSchemaChildRelationship()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildRelationship' );
		String	testingMethod = 'CWSchema.getChildRelationship';

		testResult.startTest();

		/*	public static Schema.ChildRelationship getChildRelationship( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildRelationship( testSObjectName, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.ChildRelationship getChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildRelationship( sObjectType, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.ChildRelationship getChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildRelationship( sObjectResult, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.ChildRelationship getChildRelationship( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildRelationship( anSObject, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.ChildRelationship getChildRelationship( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildRelationship( anSObject.Id, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.ChildRelationship getChildRelationship( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildRelationship( childRelationship ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildSObjectName
	*******************************************************/

	private static testMethod void testCWSchemaChildSObjectName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildSObjectName' );
		String	testingMethod = 'CWSchema.getChildSObjectName';

		testResult.startTest();

		/*	public static String getChildSObjectName( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildSObjectName( testSObjectName, testChildRelationshipName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildSObjectName( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildSObjectName( sObjectType, testChildRelationshipName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildSObjectName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildSObjectName( sObjectResult, testChildRelationshipName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildSObjectName( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildSObjectName( anSObject, testChildRelationshipName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildSObjectName( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildSObjectName( anSObject.Id, testChildRelationshipName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildSObjectName( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildSObjectName( childRelationship ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildSObjectType
	*******************************************************/

	private static testMethod void testCWSchemaChildSObjectType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildSObjectType' );
		String	testingMethod = 'CWSchema.getChildSObjectType';

		testResult.startTest();

		/*	public static Schema.sObjectType getChildSObjectType( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildSObjectType( testSObjectName, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getChildSObjectType( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null childRelationshipName.\n'
			);
		}

		/*	public static Schema.sObjectType getChildSObjectType( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildSObjectType( sObjectType, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getChildSObjectType( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildSObjectType( sObjectResult, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getChildSObjectType( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildSObjectType( anSObject, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getChildSObjectType( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildSObjectType( anSObject.Id, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getChildSObjectType( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildSObjectType( childRelationship ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildDescribeSObjectResult
	*******************************************************/

	private static testMethod void testCWSchemaChildDescribeSObjectResult()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildDescribeSObjectResult' );
		String	testingMethod = 'CWSchema.getChildDescribeSObjectResult';

		testResult.startTest();

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildDescribeSObjectResult( testSObjectName, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildDescribeSObjectResult( sObjectType, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildDescribeSObjectResult( sObjectResult, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildDescribeSObjectResult( anSObject, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildDescribeSObjectResult( anSObject.Id, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildDescribeSObjectResult( childRelationship ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildFieldName
	*******************************************************/

	private static testMethod void testCWSchemaChildFieldName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildFieldName' );
		String	testingMethod = 'CWSchema.getChildFieldName';

		testResult.startTest();

		/*	public static String getChildFieldName( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildFieldName( testSObjectName, testChildRelationshipName ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildFieldName( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildFieldName( sObjectType, testChildRelationshipName ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildFieldName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildFieldName( sObjectResult, testChildRelationshipName ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildFieldName( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildFieldName( anSObject, testChildRelationshipName ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildFieldName( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildFieldName( anSObject.Id, testChildRelationshipName ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildFieldName( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildFieldName( childRelationship ) == testChildFieldName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildSObjectField
	*******************************************************/

	private static testMethod void testCWSchemaChildSObjectField()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildSObjectField' );
		String	testingMethod = 'CWSchema.getChildSObjectField';

		testResult.startTest();

		/*	public static Schema.sObjectField getChildSObjectField( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildSObjectField( testSObjectName, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getChildSObjectField( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null childRelationshipName.\n'
			);
		}

		/*	public static Schema.sObjectField getChildSObjectField( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildSObjectField( sObjectType, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getChildSObjectField( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildSObjectField( sObjectResult, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getChildSObjectField( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildSObjectField( anSObject, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getChildSObjectField( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildSObjectField( anSObject.Id, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectField getChildSObjectField( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildSObjectField( childRelationship ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildDescribeFieldResult
	*******************************************************/

	private static testMethod void testCWSchemaChildDescribeFieldResult()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildDescribeFieldResult' );
		String	testingMethod = 'CWSchema.getChildSObjectField';

		testResult.startTest();

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildDescribeFieldResult( testSObjectName, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildDescribeFieldResult( sObjectType, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildDescribeFieldResult( sObjectResult, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildDescribeFieldResult( anSObject, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildDescribeFieldResult( anSObject.Id, testChildRelationshipName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildDescribeFieldResult( childRelationship ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaChildRelationshipName
	*******************************************************/

	private static testMethod void testCWSchemaChildRelationshipName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaChildRelationshipName' );
		String	testingMethod = 'CWSchema.getChildRelationshipName';

		testResult.startTest();

		/*	public static String getChildRelationshipName( String sObjectName, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getChildRelationshipName( testSObjectName, testChildRelationshipName ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName Null',
				CWSchema.getChildRelationshipName( testSObjectName, (String) null ) == null
			&&	testResult.checkErrors()
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' accepted a null childRelationshipName.\n'
			);
		}

		/*	public static String getChildRelationshipName( Schema.sObjectType sObjectType, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getChildRelationshipName( sObjectType, testChildRelationshipName ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildRelationshipName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getChildRelationshipName( sObjectResult, testChildRelationshipName ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildRelationshipName( sObject anSObject, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getChildRelationshipName( anSObject, testChildRelationshipName ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildRelationshipName( Id sObjectId, String childRelationshipName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getChildRelationshipName( anSObject.Id, testChildRelationshipName ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getChildRelationshipName( Schema.ChildRelationship childRelationshipName )	*/
		{
			testResult.clearErrors();
			Map<String,Schema.ChildRelationship> map_childRelationships = CWSchema.getChildRelationships( CWSchema.getSObjectType( testSObjectName ) );
			Schema.ChildRelationship childRelationship = map_childRelationships != null ? map_childRelationships.get( testChildRelationshipName ) : null;
			testResult.assert
			(	testingMethod + ' - childRelationship',
				childRelationship != null
			&&	CWSchema.getChildRelationshipName( childRelationship ) == testChildRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaIsParentRelationship
	*******************************************************/

	private static testMethod void testCWSchemaIsParentRelationship()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaIsParentRelationship' );
		String	testingMethod = 'CWSchema.isParentRelationship';

		testResult.startTest();

		/*	public static Boolean isParentRelationship( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.isParentRelationship( testSObjectName, testLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName (Negative)',
				!CWSchema.isParentRelationship( testSObjectName, testNotLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isParentRelationship( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.isParentRelationship( sObjectType, testLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isParentRelationship( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.isParentRelationship( sObjectResult, testLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isParentRelationship( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.isParentRelationship( anSObject, testLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Boolean isParentRelationship( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.isParentRelationship( anSObject.Id, testLookupFieldName )
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaParentRelationshipName
	*******************************************************/

	private static testMethod void testCWSchemaParentRelationshipName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaParentRelationshipName' );
		String	testingMethod = 'CWSchema.getParentRelationshipName';

		testResult.startTest();

		/*	public static String getParentRelationshipName( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getParentRelationshipName( testSObjectName, testLookupFieldName ) == testParentRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentRelationshipName( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getParentRelationshipName( sObjectType, testLookupFieldName ) == testParentRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentRelationshipName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getParentRelationshipName( sObjectResult, testLookupFieldName ) == testParentRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentRelationshipName( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getParentRelationshipName( anSObject, testLookupFieldName ) == testParentRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentRelationshipName( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getParentRelationshipName( anSObject.Id, testLookupFieldName ) == testParentRelationshipName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaParentSObjectName
	*******************************************************/

	private static testMethod void testCWSchemaParentSObjectName()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaParentSObjectName' );
		String	testingMethod = 'CWSchema.getParentSObjectName';

		testResult.startTest();

		/*	public static String getParentSObjectName( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getParentSObjectName( testSObjectName, testLookupFieldName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentSObjectName( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getParentSObjectName( sObjectType, testLookupFieldName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentSObjectName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getParentSObjectName( sObjectResult, testLookupFieldName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentSObjectName( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getParentSObjectName( anSObject, testLookupFieldName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static String getParentSObjectName( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getParentSObjectName( anSObject.Id, testLookupFieldName ) == testSObjectName
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaParentSObjectType
	*******************************************************/

	private static testMethod void testCWSchemaParentSObjectType()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaParentSObjectType' );
		String	testingMethod = 'CWSchema.getParentSObjectType';

		testResult.startTest();

		/*	public static Schema.sObjectType getParentSObjectType( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getParentSObjectType( testSObjectName, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getParentSObjectType( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getParentSObjectType( sObjectType, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getParentSObjectType( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getParentSObjectType( sObjectResult, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult (Negative)',
				sObjectResult != null
			&&	CWSchema.getParentSObjectType( sObjectResult, testNotLookupFieldName ) == null
			&&	testResult.lastErrorStartsWith( testingMethod ),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getParentSObjectType( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getParentSObjectType( anSObject, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.sObjectType getParentSObjectType( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getParentSObjectType( anSObject.Id, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaParentDescribeSObjectResult
	*******************************************************/

	private static testMethod void testCWSchemaParentDescribeSObjectResult()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaParentDescribeSObjectResult' );
		String	testingMethod = 'CWSchema.getParentDescribeSObjectResult';

		testResult.startTest();

		/*	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getParentDescribeSObjectResult( testSObjectName, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getParentDescribeSObjectResult( sObjectType, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getParentDescribeSObjectResult( sObjectResult, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getParentDescribeSObjectResult( anSObject, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getParentDescribeSObjectResult( anSObject.Id, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}

	/*******************************************************
				testCWSchemaParentSObjectFields
	*******************************************************/

	private static testMethod void testCWSchemaParentSObjectFields()
	{
		CWTest	testResult		= new CWTest( 'testCWSchemaParentSObjectFields' );
		String	testingMethod = 'CWSchema.getParentSObjectFields';

		testResult.startTest();

		/*	public static Map<String,Schema.sObjectField> getParentSObjectFields( String sObjectName, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			testResult.assert
			(	testingMethod + ' - sObjectName',
				CWSchema.getParentSObjectFields( testSObjectName, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.sObjectType sObjectType, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.sObjectType sObjectType = CWSchema.getSObjectType( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectType',
				sObjectType != null
			&&	CWSchema.getParentSObjectFields( sObjectType, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			Schema.DescribeSObjectResult sObjectResult = CWSchema.getDescribeSObjectResult( testSObjectName );
			testResult.assert
			(	testingMethod + ' - sObjectResult',
				sObjectResult != null
			&&	CWSchema.getParentSObjectFields( sObjectResult, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getParentSObjectFields( sObject anSObject, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			testResult.assert
			(	testingMethod + ' - anSObject',
				anSObject != null
			&&	CWSchema.getParentSObjectFields( anSObject, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		/*	public static Map<String,Schema.sObjectField> getParentSObjectFields( Id sObjectId, String lookupFieldName )	*/
		{
			testResult.clearErrors();
			sObject anSObject = (sObject) Type.forName( testSObjectName ).newInstance();
			insert anSObject;
			testResult.assert
			(	testingMethod + ' - sObjectId',
				anSObject != null
			&&	anSObject.Id != null
			&&	CWSchema.getParentSObjectFields( anSObject.Id, testLookupFieldName ) != null
			&&	!testResult.checkErrors(),
				testingMethod + ' failed.\n' + testResult.getErrorString()
			);
		}

		testResult.stopTest();
		testResult.report();
	}
}