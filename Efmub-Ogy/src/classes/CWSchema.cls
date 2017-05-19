/*******************************************************//**

@class      CWSchema

@brief      CW Core Schema Class

    This class provides an orthogonal interface to the standard
    Schema namespace.  This class is split into sections.

    Section 1:  Private Static Data Structures
    ==========================================

    These local data structures are used to cache the results of
    operations that count against Apex limits, such as calls to
    getDescribe, fields, fieldSets, getChildRelationships, etc.
    (2014-09-24) As of Summer '14, there are no limits on describe
    calls.  This section still contains data structures to cache
    Maps that are build in Apex, to avoid redundant effort.

    Section 2:  sObject Methods
    ===========================

    These methods provide access to information about sObjects.
    An sObject can be specified in any one of five ways:

        String                          sObjectName
        Schema.sObjectType              sObjectType
        Schema.DescribeSObjectResult    sObjectResult
        sObject                         anSObject
        Id                              sObjectId

    All sObject Methods can be invoked with any of these five
    sObject specifications.  The methods include:

        getGlobalDescribe               -- takes no arguments
        getAllSObjectNames              -- takes no arguments
        getAllSObjectTypes              -- takes no arguments

        isSObject
        getSObjectName
        getSObjectType
        getDescribeSObjectResult
        getSObjectLabel
        getKeyPrefix
        getSObjectFields
        getFieldSets
        getRecordTypeInfos
        getChildRelationships

    Section 3:  Field Methods
    =========================

    These methods provide access to information about sObject
    fields.  An sObject field can be specified in any one of
    seven ways:

        <sObject>, String           fieldName       -- this represents five ways
        Schema.sObjectField         sObjectField
        Schema.DescribeFieldResult  fieldResult

    Note that 'fieldName' is the field's developer name, not
    its label.

    All Field Methods can be invoked with any of these seven
    sObject field specifications.  The methods include:

        isField
        getSObjectField
        getDescribeFieldResult
        getFieldName
        getFieldLabel
        getFieldDisplayType
        getFieldType
        getFieldSOAPType
        getFieldLength
        getPicklistEntries

    Section 4:  Field Set Methods
    =============================

    These methods provide access to information about field
    sets.  A field set can be specified in any one of six
    ways:

        <sObject>, String   fieldSetName            -- this represents five ways
        Schema.FieldSet     fieldSet

    All Field Set Methods can be invoked with any of these
    six field set specifications.  The methods include:

        isFieldSet
        getFieldSet
        getFieldSetName
        getFieldSetLabel
        getFieldSetMembers

    Section 5:  Record Type Info Methods
    ====================================

    These methods provide access to record type information.
    A record type can be specified in any one of eight ways:

        <sObject>, String       recordTypeName      -- this represents five ways
        RecordType              recordType
        Schema.RecordTypeInfo   recordTypeInfo
        Id                      recordTypeId

    Note that 'recordTypeName' is the record type's developer
    name, not its label.

    All Record Type Info Methods can be invoked with any of
    these eight record type specifications.  The methods
    include:

        isRecordType
        getRecordType
        getRecordTypeInfo
        getRecordTypeId
        getRecordTypeName
        getRecordTypeLabel
        isPersonType

    Section 6:  Child Relationship Methods
    ======================================

    These methods provide access to child relationship
    information.  A child relationship can be specified in
    any one of six ways:

        <sObject>, String           childRelationshipName   -- this represents five ways
        Schema.ChildRelationship    childRelationship

    Note that 'childRelationshipName' can be one of two things.
    It can be the relationship name, such as 'Accounts', or it
    can be the name of the field that looks up to this sObject,
    such as 'Contact.AccountId'.

    All Child Relationship Methods can be invoked with any of
    these six child relationship specifications.  The methods
    include:

        isChildRelationship
        getChildRelationship
        getChildSObjectName
        getChildSObjectType
        getChildDescribeSObjectResult
        getChildFieldName
        getChildSObjectField
        getChildDescribeFieldResult
        getChildRelationshipName

    Section 7:  Parent Relationship Methods
    =======================================

    These methods provide access to parent relationship
    information.  A parent relationship can be specified in
    any one of five ways:

        <sObject>, String   lookupFieldName         --  this represents five ways

    Note that 'lookupFieldName' is the developer name of the
    field that looks up to the parent sObject.

    All Parent Relationship Methods can be invoked with any of
    these five parent relationship specifications.  The methods
    include:

        isParentRelationship
        getParentRelationshipName
        getParentSObjectName
        getParentSObjectType
        getParentDescribeSObjectResult
        getParentSObjectFields


@author     Glyn Anderson (LiquidHub.GHA)

@version    2013-11-27  LiquidHub.GHA
    Completed first version.
@version    2014-02-04  LiquidHub.GHA
    Incorporated use of CWException error handling.
    Uses new version of CWQuery class.
@version    2014-02-08  LiquidHub.GHA
    Added getParentRelationshipName method.
@version    2014-02-27  LiquidHub.GHA
    Updated references to CWException.
@version    2014-08-07  LiquidHub.GHA
    Added 'getFieldType' method.
@version    2014-09-24  LiquidHub.GHA
    Reduced number of caching properties now that
    Summer '14 has eliminated describe limits.
    Methods that create Maps or use queries still
    cache their results.
@version    2014-09-29  LiquidHub.GHA
    Added 'getAllSObjectNames' and 'getAllSObjectTypes'
    methods.  Added additional way to represent an
    sObject using an Id.  Added the sObjectId form of
    all CWSchema methods.  Made some performance improvements.

@see        CWSchemaTest

    (c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWSchema
{
    /***********************************************************
    ************************************************************

        Section 1:  Private Static Data Structures

    ************************************************************
    ***********************************************************/

    /***********************************************************
                    map_sObjectName_sObjectType

    Caches Schema.getGlobalDescribe().
    ***********************************************************/
/*
    private static Map<String,Schema.sObjectType> map_sObjectName_sObjectType
    {
        get
        {
            if ( map_sObjectName_sObjectType == null )
            {
                map_sObjectName_sObjectType = Schema.getGlobalDescribe();
            }
            return map_sObjectName_sObjectType;
        }
    }
//*/
    /***********************************************************
                map_sObjectTypeString_DescribeSObjectResult

    Caches Schema.sObjectType.getDescribe().
    ***********************************************************/
//*
    private static Map<String,Schema.DescribeSObjectResult> map_sObjectTypeString_DescribeSObjectResult
    {
        get
        {
            if ( map_sObjectTypeString_DescribeSObjectResult == null )
            {
                map_sObjectTypeString_DescribeSObjectResult = new Map<String,Schema.DescribeSObjectResult>();
            }
            return map_sObjectTypeString_DescribeSObjectResult;
        }
    }
//*/
    /***********************************************************
                    map_sObjectTypeString_Fields

    Caches Schema.DescribeSObjectResult.fields.getMap().
    ***********************************************************/
/*
    private static Map<String,Map<String,Schema.sObjectField>> map_sObjectTypeString_Fields
    {
        get
        {
            if ( map_sObjectTypeString_Fields == null )
            {
                map_sObjectTypeString_Fields = new Map<String,Map<String,Schema.sObjectField>>();
            }
            return map_sObjectTypeString_Fields;
        }
    }
//*/
    /***********************************************************
                    map_sObjectTypeString_FieldSets

    Caches Schema.DescribeSObjectResult.fieldSets.getMap().
    ***********************************************************/
/*
    private static Map<String,Map<String,Schema.FieldSet>> map_sObjectTypeString_FieldSets
    {
        get
        {
            if ( map_sObjectTypeString_FieldSets == null )
            {
                map_sObjectTypeString_FieldSets = new Map<String,Map<String,Schema.FieldSet>>();
            }
            return map_sObjectTypeString_FieldSets;
        }
    }
//*/
    /***********************************************************
                map_sObjectTypeString_ChildRelationships

    Caches Schema.DescribeSObjectResult.getChildRelationships().
    ***********************************************************/
//*
    private static Map<String,Map<String,Schema.ChildRelationship>> map_sObjectTypeString_ChildRelationships
    {
        get
        {
            if ( map_sObjectTypeString_ChildRelationships == null )
            {
                map_sObjectTypeString_ChildRelationships = new Map<String,Map<String,Schema.ChildRelationship>>();
            }
            return map_sObjectTypeString_ChildRelationships;
        }
    }
//*/
    /***********************************************************
                map_KeyPrefix_DescribeSObjectResult

    Caches iteration over globalDescribe.
    ***********************************************************/

    private static Map<String,Schema.DescribeSObjectResult> map_KeyPrefix_DescribeSObjectResult
    {
        get
        {
            if ( map_KeyPrefix_DescribeSObjectResult == null )
            {
                map_KeyPrefix_DescribeSObjectResult = new Map<String,Schema.DescribeSObjectResult>();

                for ( String sObjectName : getAllSObjectNames() )
                {
                    Schema.DescribeSObjectResult sObjectResult = getDescribeSObjectResult( sObjectName );
                    map_KeyPrefix_DescribeSObjectResult.put( sObjectResult.getKeyPrefix(), sObjectResult );
                }
            }
            return map_KeyPrefix_DescribeSObjectResult;
        }
    }

    /***********************************************************
                map_sObjectFieldString_DescribeFieldResult

    Caches Schema.sObjectField.getDescribe().
    ***********************************************************/
/*
    private static Map<String,Schema.DescribeFieldResult> map_sObjectFieldString_DescribeFieldResult
    {
        get
        {
            if ( map_sObjectFieldString_DescribeFieldResult == null )
            {
                map_sObjectFieldString_DescribeFieldResult = new Map<String,Schema.DescribeFieldResult>();
            }
            return map_sObjectFieldString_DescribeFieldResult;
        }
    }
//*/
    /***********************************************************
                set_PicklistDisplayTypes
    ***********************************************************/

    private static Set<Schema.DisplayType> set_PicklistDisplayTypes
    {
        get
        {
            if ( set_PicklistDisplayTypes == null )
            {
                set_PicklistDisplayTypes = new Set<Schema.DisplayType>{ Schema.DisplayType.Picklist, Schema.DisplayType.MultiPicklist };
            }
            return set_PicklistDisplayTypes;
        }
    }

    /***********************************************************
                map_sObjectFieldString_PicklistEntries

    Caches Schema.DescribeFieldResult.getPicklistValues().
    ***********************************************************/
//*
    private static Map<String,Map<String,Schema.PicklistEntry>> map_sObjectFieldString_PicklistEntries
    {
        get
        {
            if ( map_sObjectFieldString_PicklistEntries == null )
            {
                map_sObjectFieldString_PicklistEntries = new Map<String,Map<String,Schema.PicklistEntry>>();
            }
            return map_sObjectFieldString_PicklistEntries;
        }
    }
//*/
    /***********************************************************
                map_FieldSetString_FieldSetMembers

    Caches Schema.FieldSet.getFields().
    ***********************************************************/
//*
    private static Map<String,Map<String,Schema.FieldSetMember>> map_FieldSetString_FieldSetMembers
    {
        get
        {
            if ( map_FieldSetString_FieldSetMembers == null )
            {
                map_FieldSetString_FieldSetMembers = new Map<String,Map<String,Schema.FieldSetMember>>();
            }
            return map_FieldSetString_FieldSetMembers;
        }
    }
//*/
    /***********************************************************
                    map_RecordTypeId_RecordType

    Caches query of RecordTypes.
    ***********************************************************/

    private static Map<Id,RecordType> map_RecordTypeId_RecordType
    {
        get
        {
            if ( map_RecordTypeId_RecordType == null )
            {
                CWQuery recordTypeQuery = CWQuery.newQuery( RecordType.getSObjectType() );
                recordTypeQuery.addAllFields();
                recordTypeQuery.newWhereClause( 'IsActive = true' );
                map_RecordTypeId_RecordType = new Map<Id,RecordType>( (List<RecordType>) recordTypeQuery.query() );
            }
            return map_RecordTypeId_RecordType;
        }
    }

    /***********************************************************
                    map_RecordTypeName_RecordType

    Caches query of RecordTypes.
    ***********************************************************/

    private static String fullRecordTypeName( String sObjectName, String recordTypeName )
    {
        return String.isNotBlank( sObjectName ) && String.isNotBlank( recordTypeName ) ? sObjectName + ':' + recordTypeName : null;
    }

    private static Map<String,RecordType> map_RecordTypeName_RecordType
    {
        get
        {
            if ( map_RecordTypeName_RecordType == null )
            {
                map_RecordTypeName_RecordType = new Map<String,RecordType>();

                for ( RecordType recordType : map_RecordTypeId_RecordType.values() )
                {
                    map_RecordTypeName_RecordType.put( fullRecordTypeName( recordType.sObjectType, recordType.DeveloperName ), recordType );
                }
            }
            return map_RecordTypeName_RecordType;
        }
    }


    /***********************************************************
    ************************************************************

        Section 2:  sObject Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
                    getGlobalDescribe method
    ***********************************************************/

    public static Map<String,Schema.sObjectType> getGlobalDescribe()
    {
        return Schema.getGlobalDescribe();
    }

    /***********************************************************
                    getAllSObjectNames method
    ***********************************************************/

    public static Set<String> getAllSObjectNames()
    {
        return getGlobalDescribe().keySet();
    }

    /***********************************************************
                    getAllSObjectTypes method
    ***********************************************************/

    public static List<Schema.sObjectType> getAllSObjectTypes()
    {
        return getGlobalDescribe().values();
    }

    /***********************************************************
                invalidObjectSpecification method
    ***********************************************************/

    private static Object invalidObjectSpecification( String method )
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid object specification.' );
    }

    /***********************************************************
                    isSObject method
    ***********************************************************/

    public static Boolean isSObject( String sObjectName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectType( sObjectName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isSObject( Schema.sObjectType sObjectType )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectType( sObjectType ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isSObject( Schema.DescribeSObjectResult sObjectResult )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getDescribeSObjectResult( sObjectResult ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isSObject( sObject anSObject )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectType( anSObject ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isSObject( Id sObjectId )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getDescribeSObjectResult( sObjectId ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    /***********************************************************
                    getSObjectName method
    ***********************************************************/

    public static String getSObjectName( String sObjectName )
    {
        return getSObjectName( getDescribeSObjectResult( sObjectName ) );
    }

    public static String getSObjectName( Schema.sObjectType sObjectType )
    {
        return getSObjectName( getDescribeSObjectResult( sObjectType ) );
    }

    public static String getSObjectName( Schema.DescribeSObjectResult sObjectResult )
    {
        return
            sObjectResult != null
        ?   sObjectResult.getName()
        :   (String) invalidObjectSpecification( 'getSObjectName' );
    }

    public static String getSObjectName( sObject anSObject )
    {
        return getSObjectName( getDescribeSObjectResult( anSObject ) );
    }

    public static String getSObjectName( Id sObjectId )
    {
        return getSObjectName( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getSObjectType method
    ***********************************************************/

    public static Schema.sObjectType getSObjectType( String sObjectName )
    {
        return getSObjectType( String.isNotBlank( sObjectName ) ? getGlobalDescribe().get( sObjectName ) : (Schema.sObjectType) null );
    }

    public static Schema.sObjectType getSObjectType( Schema.sObjectType sObjectType )
    {
        return
            sObjectType != null
        ?   sObjectType
        :   (Schema.sObjectType) invalidObjectSpecification( 'getSObjectType' );
    }

    public static Schema.sObjectType getSObjectType( Schema.DescribeSObjectResult sObjectResult )
    {
        return getSObjectType( sObjectResult != null ? sObjectResult.getSObjectType() : (Schema.sObjectType) null );
    }

    public static Schema.sObjectType getSObjectType( sObject anSObject )
    {
        return getSObjectType( anSObject != null ? anSObject.getSObjectType() : (Schema.sObjectType) null );
    }

    public static Schema.sObjectType getSObjectType( Id sObjectId )
    {
        return getSObjectType( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getDescribeSObjectResult method
    ***********************************************************/

    public static Schema.DescribeSObjectResult getDescribeSObjectResult( String sObjectName )
    {
        return getDescribeSObjectResult( getSObjectType( sObjectName ) );
    }

    public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.sObjectType sObjectType )
    {
/*
        return getDescribeSObjectResult( sObjectType != null ? sObjectType.getDescribe() : (Schema.DescribeSObjectResult) null );
/*/
        if ( sObjectType == null ) return getDescribeSObjectResult( (Schema.DescribeSObjectResult) null );

        String sObjectTypeString = String.valueOf( sObjectType );

        if ( !map_sObjectTypeString_DescribeSObjectResult.containsKey( sObjectTypeString ) )
        {
            map_sObjectTypeString_DescribeSObjectResult.put( sObjectTypeString, sObjectType.getDescribe() );
        }
        return getDescribeSObjectResult( map_sObjectTypeString_DescribeSObjectResult.get( sObjectTypeString ) );
//*/
    }

    public static Schema.DescribeSObjectResult getDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult )
    {
        return
            sObjectResult != null
        ?   sObjectResult
        :   (Schema.DescribeSObjectResult) invalidObjectSpecification( 'getDescribeSObjectResult' );
    }

    public static Schema.DescribeSObjectResult getDescribeSObjectResult( sObject anSObject )
    {
        return getDescribeSObjectResult( getSObjectType( anSObject ) );
    }

    public static Schema.DescribeSObjectResult getDescribeSObjectResult( Id sObjectId )
    {
        return
            getDescribeSObjectResult
            (   sObjectId != null
            ?   map_KeyPrefix_DescribeSObjectResult.get( getKeyPrefix( sObjectId ) )
            :   (Schema.DescribeSObjectResult) null
            );
    }

    /***********************************************************
                    getSObjectLabel method
    ***********************************************************/

    public static String getSObjectLabel( String sObjectName )
    {
        return getSObjectLabel( getDescribeSObjectResult( sObjectName ) );
    }

    public static String getSObjectLabel( Schema.sObjectType sObjectType )
    {
        return getSObjectLabel( getDescribeSObjectResult( sObjectType ) );
    }

    public static String getSObjectLabel( Schema.DescribeSObjectResult sObjectResult )
    {
        return
            sObjectResult != null
        ?   sObjectResult.getLabel()
        :   (String) invalidObjectSpecification( 'getSObjectLabel' );
    }

    public static String getSObjectLabel( sObject anSObject )
    {
        return getSObjectLabel( getDescribeSObjectResult( anSObject ) );
    }

    public static String getSObjectLabel( Id sObjectId )
    {
        return getSObjectLabel( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getKeyPrefix method
    ***********************************************************/

    public static String getKeyPrefix( String sObjectName )
    {
        return getKeyPrefix( getDescribeSObjectResult( sObjectName ) );
    }

    public static String getKeyPrefix( Schema.sObjectType sObjectType )
    {
        return getKeyPrefix( getDescribeSObjectResult( sObjectType ) );
    }

    public static String getKeyPrefix( Schema.DescribeSObjectResult sObjectResult )
    {
        return
            sObjectResult != null
        ?   sObjectResult.getKeyPrefix()
        :   (String) invalidObjectSpecification( 'getKeyPrefix' );
    }

    public static String getKeyPrefix( sObject anSObject )
    {
        return getKeyPrefix( getDescribeSObjectResult( anSObject ) );
    }

    public static String getKeyPrefix( Id sObjectId )
    {
        return sObjectId != null ? String.valueOf( sObjectId ).left( 3 ) : (String) null;
    }

    /***********************************************************
                    getSObjectFields method
    ***********************************************************/

    public static Map<String,Schema.sObjectField> getSObjectFields( String sObjectName )
    {
        return getSObjectFields( getDescribeSObjectResult( sObjectName ) );
    }

    public static Map<String,Schema.sObjectField> getSObjectFields( Schema.sObjectType sObjectType )
    {
        return getSObjectFields( getDescribeSObjectResult( sObjectType ) );
    }

    public static Map<String,Schema.sObjectField> getSObjectFields( Schema.DescribeSObjectResult sObjectResult )
    {
//*
        return
            sObjectResult != null
        ?   sObjectResult.fields.getMap()
        :   (Map<String,Schema.sObjectField>) invalidObjectSpecification( 'getSObjectFields' );
/*/
        if ( sObjectResult == null ) return (Map<String,Schema.sObjectField>) invalidObjectSpecification( 'getSObjectFields' );

        String sObjectTypeString = String.valueOf( getSObjectType( sObjectResult ) );

        if ( !map_sObjectTypeString_Fields.containsKey( sObjectTypeString ) )
        {
            map_sObjectTypeString_Fields.put( sObjectTypeString, sObjectResult.fields.getMap() );
        }
        return map_sObjectTypeString_Fields.get( sObjectTypeString );
//*/
    }

    public static Map<String,Schema.sObjectField> getSObjectFields( sObject anSObject )
    {
        return getSObjectFields( getDescribeSObjectResult( anSObject ) );
    }

    public static Map<String,Schema.sObjectField> getSObjectFields( Id sObjectId )
    {
        return getSObjectFields( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getFieldSets method
    ***********************************************************/

    public static Map<String,Schema.FieldSet> getFieldSets( String sObjectName )
    {
        return getFieldSets( getDescribeSObjectResult( sObjectName ) );
    }

    public static Map<String,Schema.FieldSet> getFieldSets( Schema.sObjectType sObjectType )
    {
        return getFieldSets( getDescribeSObjectResult( sObjectType ) );
    }

    public static Map<String,Schema.FieldSet> getFieldSets( Schema.DescribeSObjectResult sObjectResult )
    {
//*
        return
            sObjectResult != null
        ?   sObjectResult.fieldSets.getMap()
        :   (Map<String,Schema.FieldSet>) invalidObjectSpecification( 'getFieldSets' );
/*/
        if ( sObjectResult == null ) return (Map<String,Schema.FieldSet>) invalidObjectSpecification( 'getFieldSets' );

        String sObjectTypeString = String.valueOf( getSObjectType( sObjectResult ) );

        if ( !map_sObjectTypeString_FieldSets.containsKey( sObjectTypeString ) )
        {
            map_sObjectTypeString_FieldSets.put( sObjectTypeString, sObjectResult.fieldSets.getMap() );
        }
        return map_sObjectTypeString_FieldSets.get( sObjectTypeString );
//*/
    }

    public static Map<String,Schema.FieldSet> getFieldSets( sObject anSObject )
    {
        return getFieldSets( getDescribeSObjectResult( anSObject ) );
    }

    public static Map<String,Schema.FieldSet> getFieldSets( Id sObjectId )
    {
        return getFieldSets( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getRecordTypeInfos method
    ***********************************************************/

    public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( String sObjectName )
    {
        return getRecordTypeInfos( getDescribeSObjectResult( sObjectName ) );
    }

    public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.sObjectType sObjectType )
    {
        return getRecordTypeInfos( getDescribeSObjectResult( sObjectType ) );
    }

    public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Schema.DescribeSObjectResult sObjectResult )
    {
        return
            sObjectResult != null
        ?   sObjectResult.getRecordTypeInfosById()
        :   (Map<Id,Schema.RecordTypeInfo>) invalidObjectSpecification( 'getRecordTypeInfos' );
    }

    public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( sObject anSObject )
    {
        return getRecordTypeInfos( getDescribeSObjectResult( anSObject ) );
    }

    public static Map<Id,Schema.RecordTypeInfo> getRecordTypeInfos( Id sObjectId )
    {
        return getRecordTypeInfos( getDescribeSObjectResult( sObjectId ) );
    }

    /***********************************************************
                    getChildRelationships method
    ***********************************************************/

    public static Map<String,Schema.ChildRelationship> getChildRelationships( String sObjectName )
    {
        return getChildRelationships( getDescribeSObjectResult( sObjectName ) );
    }

    public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.sObjectType sObjectType )
    {
        return getChildRelationships( getDescribeSObjectResult( sObjectType ) );
    }

    public static Map<String,Schema.ChildRelationship> getChildRelationships( Schema.DescribeSObjectResult sObjectResult )
    {
/*
        if ( sObjectResult == null ) return (Map<String,Schema.ChildRelationship>) invalidObjectSpecification( 'getChildRelationships' );

        Map<String,Schema.ChildRelationship> map_ChildRelationshipName_ChildRelationship = new Map<String,Schema.ChildRelationship>();

        for ( Schema.ChildRelationship childRelationship : sObjectResult.getChildRelationships() )
        {
            String relationshipName = getChildRelationshipName( childRelationship );
            if ( relationshipName != null ) map_ChildRelationshipName_ChildRelationship.put( relationshipName, childRelationship );

            String fieldName = getChildSObjectName( childRelationship ) + '.' + getChildFieldName( childRelationship );
            map_ChildRelationshipName_ChildRelationship.put( fieldName, childRelationship );
        }
        return map_ChildRelationshipName_ChildRelationship;
/*/
        if ( sObjectResult == null ) return (Map<String,Schema.ChildRelationship>) invalidObjectSpecification( 'getChildRelationships' );

        String sObjectTypeString = String.valueOf( getSObjectType( sObjectResult ) );

        if ( !map_sObjectTypeString_ChildRelationships.containsKey( sObjectTypeString ) )
        {
            Map<String,Schema.ChildRelationship> map_ChildRelationshipName_ChildRelationship = new Map<String,Schema.ChildRelationship>();

            for ( Schema.ChildRelationship childRelationship : sObjectResult.getChildRelationships() )
            {
                String relationshipName = getChildRelationshipName( childRelationship );
                if ( relationshipName != null ) map_ChildRelationshipName_ChildRelationship.put( relationshipName, childRelationship );

                String fieldName = getChildSObjectName( childRelationship ) + '.' + getChildFieldName( childRelationship );
                map_ChildRelationshipName_ChildRelationship.put( fieldName, childRelationship );
            }
            map_sObjectTypeString_ChildRelationships.put( sObjectTypeString, map_ChildRelationshipName_ChildRelationship );
        }
        return map_sObjectTypeString_ChildRelationships.get( sObjectTypeString );
//*/
    }

    public static Map<String,Schema.ChildRelationship> getChildRelationships( sObject anSObject )
    {
        return getChildRelationships( getDescribeSObjectResult( anSObject ) );
    }

    public static Map<String,Schema.ChildRelationship> getChildRelationships( Id sObjectId )
    {
        return getChildRelationships( getDescribeSObjectResult( sObjectId ) );
    }


    /***********************************************************
    ************************************************************

        Section 3:  Field Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
                invalidFieldSpecification method
    ***********************************************************/

    private static Object invalidFieldSpecification(String method)
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid field specification.' );
    }

    /***********************************************************
                    isField method
    ***********************************************************/

    public static Boolean isField( String sObjectName, String fieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( sObjectName, fieldName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( Schema.sObjectType sObjectType, String fieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( sObjectType, fieldName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( sObjectResult, fieldName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( sObject anSObject, String fieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( anSObject, fieldName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( Id sObjectId, String fieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( sObjectId, fieldName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( Schema.sObjectField sObjectField )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( sObjectField ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isField( Schema.DescribeFieldResult fieldResult )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getSObjectField( fieldResult ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    /***********************************************************
                    getSObjectField method
    ***********************************************************/

    public static Schema.sObjectField getSObjectField( String sObjectName, String fieldName )
    {
        return getSObjectField( getDescribeSObjectResult( sObjectName ), fieldName );
    }

    public static Schema.sObjectField getSObjectField( Schema.sObjectType sObjectType, String fieldName )
    {
        return getSObjectField( getDescribeSObjectResult( sObjectType ), fieldName );
    }

    public static Schema.sObjectField getSObjectField( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getSObjectField( sObjectResult != null && String.isNotBlank( fieldName ) ? getsObjectFields( sObjectResult ).get( fieldName ) : (Schema.sObjectField) null );
    }

    public static Schema.sObjectField getSObjectField( sObject anSObject, String fieldName )
    {
        return getSObjectField( getDescribeSObjectResult( anSObject ), fieldName );
    }

    public static Schema.sObjectField getSObjectField( Id sObjectId, String fieldName )
    {
        return getSObjectField( getDescribeSObjectResult( sObjectId ), fieldName );
    }

    public static Schema.sObjectField getSObjectField( Schema.sObjectField sObjectField )
    {
        system.debug('sObjectField --> '+sObjectField);
        return
            sObjectField != null
        ?   sObjectField
        :   (Schema.sObjectField) invalidFieldSpecification( 'getSObjectField' );
    }

    public static Schema.sObjectField getSObjectField( Schema.DescribeFieldResult fieldResult )
    {
        return getSObjectField( fieldResult != null ? fieldResult.getSObjectField() : (Schema.sObjectField) null );
    }

    /***********************************************************
                    getDescribeFieldResult method
    ***********************************************************/

    public static Schema.DescribeFieldResult getDescribeFieldResult( String sObjectName, String fieldName )
    {
        return getDescribeFieldResult( getSObjectField( sObjectName, fieldName ) );
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectType sObjectType, String fieldName )
    {
        system.debug('field name --> '+fieldName );
        return getDescribeFieldResult( getSObjectField( sObjectType, fieldName ) );
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getDescribeFieldResult( getSObjectField( sObjectResult, fieldName ) );
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( sObject anSObject, String fieldName )
    {
        return getDescribeFieldResult( getSObjectField( anSObject, fieldName ) );
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( Id sObjectId, String fieldName )
    {
        return getDescribeFieldResult( getSObjectField( sObjectId, fieldName ) );
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.sObjectField sObjectField )
    {
//*
        return getDescribeFieldResult( sObjectField != null ? sObjectField.getDescribe() : (Schema.DescribeFieldResult) null );
/*/
        if ( sObjectField == null ) return getDescribeFieldResult( (Schema.DescribeFieldResult) null );

        String sObjectFieldString = String.valueOf( sObjectField );

        if ( !map_sObjectFieldString_DescribeFieldResult.containsKey( sObjectFieldString ) )
        {
            map_sObjectFieldString_DescribeFieldResult.put( sObjectFieldString, sObjectField.getDescribe() );
        }
        return getDescribeFieldResult( map_sObjectFieldString_DescribeFieldResult.get( sObjectFieldString ) );
//*/
    }

    public static Schema.DescribeFieldResult getDescribeFieldResult( Schema.DescribeFieldResult fieldResult )
    {
        return
            fieldResult != null
        ?   fieldResult
        :   (Schema.DescribeFieldResult) invalidFieldSpecification( 'getDescribeFieldResult' );
    }

    /***********************************************************
                    getFieldName method
    ***********************************************************/

    public static String getFieldName( String sObjectName, String fieldName )
    {
        return getFieldName( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static String getFieldName( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldName( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static String getFieldName( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldName( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static String getFieldName( sObject anSObject, String fieldName )
    {
        return getFieldName( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static String getFieldName( Id sObjectId, String fieldName )
    {
        return getFieldName( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static String getFieldName( Schema.sObjectField sObjectField )
    {
        return getFieldName( getDescribeFieldResult( sObjectField ) );
    }

    public static String getFieldName( Schema.DescribeFieldResult fieldResult )
    {
        return
            fieldResult != null
        ?   fieldResult.getName()
        :   (String) invalidFieldSpecification( 'getFieldName' );
    }

    /***********************************************************
                    getFieldLabel method
    ***********************************************************/

    public static String getFieldLabel( String sObjectName, String fieldName )
    {
        return getFieldLabel( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static String getFieldLabel( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldLabel( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static String getFieldLabel( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldLabel( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static String getFieldLabel( sObject anSObject, String fieldName )
    {
        return getFieldLabel( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static String getFieldLabel( Id sObjectId, String fieldName )
    {
        return getFieldLabel( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static String getFieldLabel( Schema.sObjectField sObjectField )
    {
        return getFieldLabel( getDescribeFieldResult( sObjectField ) );
    }

    public static String getFieldLabel( Schema.DescribeFieldResult fieldResult )
    {
        return
            fieldResult != null
        ?   fieldResult.getLabel()
        :   (String) invalidFieldSpecification( 'getFieldLabel' );
    }

    /***********************************************************
                    getFieldDisplayType method
    ***********************************************************/

    public static Schema.DisplayType getFieldDisplayType( String sObjectName, String fieldName )
    {
        return getFieldDisplayType( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static Schema.DisplayType getFieldDisplayType( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldDisplayType( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static Schema.DisplayType getFieldDisplayType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldDisplayType( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static Schema.DisplayType getFieldDisplayType( sObject anSObject, String fieldName )
    {
        return getFieldDisplayType( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static Schema.DisplayType getFieldDisplayType( Id sObjectId, String fieldName )
    {
        return getFieldDisplayType( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static Schema.DisplayType getFieldDisplayType( Schema.sObjectField sObjectField )
    {
        return getFieldDisplayType( getDescribeFieldResult( sObjectField ) );
    }

    public static Schema.DisplayType getFieldDisplayType( Schema.DescribeFieldResult fieldResult )
    {
        return
            fieldResult != null
        ?   fieldResult.getType()
        :   (Schema.DisplayType) invalidFieldSpecification( 'getFieldDisplayType' );
    }

    /***********************************************************
                    getFieldType method
    ***********************************************************/

    public static Type getFieldType( String sObjectName, String fieldName )
    {
        return getFieldType( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static Type getFieldType( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldType( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static Type getFieldType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldType( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static Type getFieldType( sObject anSObject, String fieldName )
    {
        return getFieldType( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static Type getFieldType( Id sObjectId, String fieldName )
    {
        return getFieldType( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static Type getFieldType( Schema.sObjectField sObjectField )
    {
        return getFieldType( getDescribeFieldResult( sObjectField ) );
    }

    public static Type getFieldType( Schema.DescribeFieldResult fieldResult )
    {
        return CWType.getType( getFieldDisplayType( fieldResult ) );
    }

    /***********************************************************
                    getFieldSOAPType method
    ***********************************************************/

    public static Schema.SOAPType getFieldSOAPType( String sObjectName, String fieldName )
    {
        return getFieldSOAPType( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static Schema.SOAPType getFieldSOAPType( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldSOAPType( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static Schema.SOAPType getFieldSOAPType( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldSOAPType( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static Schema.SOAPType getFieldSOAPType( sObject anSObject, String fieldName )
    {
        return getFieldSOAPType( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static Schema.SOAPType getFieldSOAPType( Id sObjectId, String fieldName )
    {
        return getFieldSOAPType( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static Schema.SOAPType getFieldSOAPType( Schema.sObjectField sObjectField )
    {
        return getFieldSOAPType( getDescribeFieldResult( sObjectField ) );
    }

    public static Schema.SOAPType getFieldSOAPType( Schema.DescribeFieldResult fieldResult )
    {
        return
            fieldResult != null
        ?   fieldResult.getSOAPType()
        :   (Schema.SOAPType) invalidFieldSpecification( 'getFieldSOAPType' );
    }

    /***********************************************************
                    getFieldLength method
    ***********************************************************/

    public static Integer getFieldLength( String sObjectName, String fieldName )
    {
        return getFieldLength( getDescribeFieldResult( sObjectName, fieldName ) );
    }

    public static Integer getFieldLength( Schema.sObjectType sObjectType, String fieldName )
    {
        return getFieldLength( getDescribeFieldResult( sObjectType, fieldName ) );
    }

    public static Integer getFieldLength( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getFieldLength( getDescribeFieldResult( sObjectResult, fieldName ) );
    }

    public static Integer getFieldLength( sObject anSObject, String fieldName )
    {
        return getFieldLength( getDescribeFieldResult( anSObject, fieldName ) );
    }

    public static Integer getFieldLength( Id sObjectId, String fieldName )
    {
        return getFieldLength( getDescribeFieldResult( sObjectId, fieldName ) );
    }

    public static Integer getFieldLength( Schema.sObjectField sObjectField )
    {
        return getFieldLength( getDescribeFieldResult( sObjectField ) );
    }

    public static Integer getFieldLength( Schema.DescribeFieldResult fieldResult )
    {
        return
            getFieldSOAPType( fieldResult ) == Schema.SOAPType.String
        ?   fieldResult.getLength()
        :   (Integer) CWException.errorNull( 'CWSchema.getFieldLength: Field \'' + getFieldName( fieldResult ) + '\' is not a String.' );
    }

    /***********************************************************
                    getPicklistEntries method
    ***********************************************************/

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( String sObjectName, String fieldName )
    {
        return getPicklistEntries( getSObjectField( sObjectName, fieldName ) );
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectType sObjectType, String fieldName )
    {
        return getPicklistEntries( getSObjectField( sObjectType, fieldName ) );
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeSObjectResult sObjectResult, String fieldName )
    {
        return getPicklistEntries( getSObjectField( sObjectResult, fieldName ) );
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( sObject anSObject, String fieldName )
    {
        return getPicklistEntries( getSObjectField( anSObject, fieldName ) );
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( Id sObjectId, String fieldName )
    {
        return getPicklistEntries( getSObjectField( sObjectId, fieldName ) );
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.sObjectField sObjectField )
    {
        if ( !set_PicklistDisplayTypes.contains( getFieldDisplayType( sObjectField ) ) )
        {
            return (Map<String,Schema.PicklistEntry>) CWException.errorNull( 'CWSchema.getPicklistEntries: Field \'' + getFieldName( sObjectField ) + '\' is not a Picklist.' );
        }
/*
        Map<String,Schema.PicklistEntry> map_PicklistEntryLabel_PicklistEntry = new Map<String,Schema.PicklistEntry>();

        for ( Schema.PicklistEntry picklistEntry : getDescribeFieldResult( sObjectField ).getPicklistValues() )
        {
            map_PicklistEntryLabel_PicklistEntry.put( picklistEntry.getLabel(), picklistEntry );
        }
        return map_PicklistEntryLabel_PicklistEntry;
/*/
        String sObjectFieldString = String.valueOf( sObjectField );

        if ( !map_sObjectFieldString_PicklistEntries.containsKey( sObjectFieldString ) )
        {
            Map<String,Schema.PicklistEntry> map_PicklistEntryLabel_PicklistEntry = new Map<String,Schema.PicklistEntry>();

            for ( Schema.PicklistEntry picklistEntry : getDescribeFieldResult( sObjectField ).getPicklistValues() )
            {
                map_PicklistEntryLabel_PicklistEntry.put( picklistEntry.getLabel(), picklistEntry );
            }
            map_sObjectFieldString_PicklistEntries.put( sObjectFieldString, map_PicklistEntryLabel_PicklistEntry );
        }
        return map_sObjectFieldString_PicklistEntries.get( sObjectFieldString );
//*/
    }

    public static Map<String,Schema.PicklistEntry> getPicklistEntries( Schema.DescribeFieldResult fieldResult )
    {
        return getPicklistEntries( getSObjectField( fieldResult ) );
    }


    /***********************************************************
    ************************************************************

        Section 4:  Field Set Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
                invalidFieldSetSpecification method
    ***********************************************************/

    private static Object invalidFieldSetSpecification( String method )
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid field set specification.' );
    }

    /***********************************************************
                    isFieldSet method
    ***********************************************************/

    public static Boolean isFieldSet( String sObjectName, String fieldSetName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( sObjectName, fieldSetName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isFieldSet( Schema.sObjectType sObjectType, String fieldSetName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( sObjectType, fieldSetName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( sObjectResult, fieldSetName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isFieldSet( sObject anSObject, String fieldSetName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( anSObject, fieldSetName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isFieldSet( Id sObjectId, String fieldSetName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( sObjectId, fieldSetName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isFieldSet( Schema.FieldSet fieldSet )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldSet( fieldSet ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    /***********************************************************
                    getFieldSet method
    ***********************************************************/

    public static Schema.FieldSet getFieldSet( String sObjectName, String fieldSetName )
    {
        return getFieldSet( getDescribeSObjectResult( sObjectName ), fieldSetName );
    }

    public static Schema.FieldSet getFieldSet( Schema.sObjectType sObjectType, String fieldSetName )
    {
        return getFieldSet( getDescribeSObjectResult( sObjectType ), fieldSetName );
    }

    public static Schema.FieldSet getFieldSet( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
    {
        return getFieldSet( sObjectResult != null && String.isNotBlank( fieldSetName ) ? getFieldSets( sObjectResult ).get( fieldSetName ) : (Schema.FieldSet) null );
    }

    public static Schema.FieldSet getFieldSet( sObject anSObject, String fieldSetName )
    {
        return getFieldSet( getDescribeSObjectResult( anSObject ), fieldSetName );
    }

    public static Schema.FieldSet getFieldSet( Id sObjectId, String fieldSetName )
    {
        return getFieldSet( getDescribeSObjectResult( sObjectId ), fieldSetName );
    }

    public static Schema.FieldSet getFieldSet( Schema.FieldSet fieldSet )
    {
        return
            fieldSet != null
        ?   fieldSet
        :   (Schema.FieldSet) invalidFieldSetSpecification( 'getFieldSet' );
    }

    /***********************************************************
                    getFieldSetName method
    ***********************************************************/

    public static String getFieldSetName( String sObjectName, String fieldSetName )
    {
        return getFieldSetName( getFieldSet( sObjectName, fieldSetName ) );
    }

    public static String getFieldSetName( Schema.sObjectType sObjectType, String fieldSetName )
    {
        return getFieldSetName( getFieldSet( sObjectType, fieldSetName ) );
    }

    public static String getFieldSetName( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
    {
        return getFieldSetName( getFieldSet( sObjectResult, fieldSetName ) );
    }

    public static String getFieldSetName( sObject anSObject, String fieldSetName )
    {
        return getFieldSetName( getFieldSet( anSObject, fieldSetName ) );
    }

    public static String getFieldSetName( Id sObjectId, String fieldSetName )
    {
        return getFieldSetName( getFieldSet( sObjectId, fieldSetName ) );
    }

    public static String getFieldSetName( Schema.FieldSet fieldSet )
    {
        return
            fieldSet != null
        ?   fieldSet.getName()
        :   (String) invalidFieldSetSpecification( 'getFieldSetName' );
    }

    /***********************************************************
                    getFieldSetLabel method
    ***********************************************************/

    public static String getFieldSetLabel( String sObjectName, String fieldSetName )
    {
        return getFieldSetLabel( getFieldSet( sObjectName, fieldSetName ) );
    }

    public static String getFieldSetLabel( Schema.sObjectType sObjectType, String fieldSetName )
    {
        return getFieldSetLabel( getFieldSet( sObjectType, fieldSetName ) );
    }

    public static String getFieldSetLabel( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
    {
        return getFieldSetLabel( getFieldSet( sObjectResult, fieldSetName ) );
    }

    public static String getFieldSetLabel( sObject anSObject, String fieldSetName )
    {
        return getFieldSetLabel( getFieldSet( anSObject, fieldSetName ) );
    }

    public static String getFieldSetLabel( Id sObjectId, String fieldSetName )
    {
        return getFieldSetLabel( getFieldSet( sObjectId, fieldSetName ) );
    }

    public static String getFieldSetLabel( Schema.FieldSet fieldSet )
    {
        return
            fieldSet != null
        ?   fieldSet.getLabel()
        :   (String) invalidFieldSetSpecification( 'getFieldSetLabel' );
    }

    /***********************************************************
                    getFieldSetMembers method
    ***********************************************************/

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( String sObjectName, String fieldSetName )
    {
        return getFieldSetMembers( getFieldSet( sObjectName, fieldSetName ) );
    }

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.sObjectType sObjectType, String fieldSetName )
    {
        return getFieldSetMembers( getFieldSet( sObjectType, fieldSetName ) );
    }

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.DescribeSObjectResult sObjectResult, String fieldSetName )
    {
        return getFieldSetMembers( getFieldSet( sObjectResult, fieldSetName ) );
    }

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( sObject anSObject, String fieldSetName )
    {
        return getFieldSetMembers( getFieldSet( anSObject, fieldSetName ) );
    }

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Id sObjectId, String fieldSetName )
    {
        return getFieldSetMembers( getFieldSet( sObjectId, fieldSetName ) );
    }

    public static Map<String,Schema.FieldSetMember> getFieldSetMembers( Schema.FieldSet fieldSet )
    {
/*
        if ( fieldSet == null ) return (Map<String,Schema.FieldSetMember>) invalidFieldSetSpecification( 'getFieldSetMembers' );

        Map<String,Schema.FieldSetMember> map_FieldPath_FieldSetMember = new Map<String,Schema.FieldSetMember>();

        for ( Schema.FieldSetMember fieldSetMember : fieldSet.getFields() )
        {
            map_FieldPath_FieldSetMember.put( fieldSetMember.getFieldPath(), fieldSetMember );
        }
        return map_FieldPath_FieldSetMember;
/*/
        if ( fieldSet == null ) return (Map<String,Schema.FieldSetMember>) invalidFieldSetSpecification( 'getFieldSetMembers' );

        String fieldSetString = String.valueOf( fieldSet );

        if ( !map_FieldSetString_FieldSetMembers.containsKey( fieldSetString ) )
        {
            Map<String,Schema.FieldSetMember> map_FieldPath_FieldSetMember = new Map<String,Schema.FieldSetMember>();

            for ( Schema.FieldSetMember fieldSetMember : fieldSet.getFields() )
            {
                map_FieldPath_FieldSetMember.put( fieldSetMember.getFieldPath(), fieldSetMember );
            }
            map_FieldSetString_FieldSetMembers.put( fieldSetString, map_FieldPath_FieldSetMember );
        }
        return map_FieldSetString_FieldSetMembers.get( fieldSetString );
//*/
    }


    /***********************************************************
    ************************************************************

        Section 5:  Record Type Info Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
                invalidRecordTypeSpecification method
    ***********************************************************/

    private static Object invalidRecordTypeSpecification( String method )
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid record type specification.' );
    }

    /***********************************************************
                    isRecordType method
    ***********************************************************/

    public static Boolean isRecordType( String sObjectName, String recordTypeName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( sObjectName, recordTypeName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( Schema.sObjectType sObjectType, String recordTypeName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( sObjectType, recordTypeName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( sObjectResult, recordTypeName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( sObject anSObject, String recordTypeName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( anSObject, recordTypeName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( Id sObjectId, String recordTypeName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( sObjectId, recordTypeName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( RecordType recordType )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( recordType ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( Schema.RecordTypeInfo recordTypeInfo )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getRecordType( recordTypeInfo ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isRecordType( Id recordTypeId )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = map_RecordTypeId_RecordType.containsKey( recordTypeId );
        CWException.restoreErrorHandler();
        return result;
    }

    /***********************************************************
                    getRecordType method
    ***********************************************************/

    public static RecordType getRecordType( String sObjectName, String recordTypeName )
    {
        return getRecordType( map_RecordTypeName_RecordType.get( fullRecordTypeName( sObjectName, recordTypeName ) ) );
    }

    public static RecordType getRecordType( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return getRecordType( getSObjectName( sObjectType ), recordTypeName );
    }

    public static RecordType getRecordType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return getRecordType( getSObjectName( sObjectResult ), recordTypeName );
    }

    public static RecordType getRecordType( sObject anSObject, String recordTypeName )
    {
        return getRecordType( getSObjectName( anSObject ), recordTypeName );
    }

    public static RecordType getRecordType( Id sObjectId, String recordTypeName )
    {
        return getRecordType( getSObjectName( sObjectId ), recordTypeName );
    }

    public static RecordType getRecordType( RecordType recordType )
    {
        return
            recordType != null
        ?   recordType
        :   (RecordType) invalidRecordTypeSpecification( 'getRecordType' );
    }

    public static RecordType getRecordType( Schema.RecordTypeInfo recordTypeInfo )
    {
        return getRecordType( getRecordTypeId( recordTypeInfo ) );
    }

    public static RecordType getRecordType( Id recordTypeId )
    {
        return getRecordType( map_RecordTypeId_RecordType.get( recordTypeId ) );
    }

    /***********************************************************
                    getRecordTypeInfo method
    ***********************************************************/

    public static Schema.RecordTypeInfo getRecordTypeInfo( String sObjectName, String recordTypeName )
    {
        return  getRecordTypeInfo( getRecordType( sObjectName, recordTypeName ) );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return  getRecordTypeInfo( getRecordType( sObjectType, recordTypeName ) );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return  getRecordTypeInfo( getRecordType( sObjectResult, recordTypeName ) );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( sObject anSObject, String recordTypeName )
    {
        return  getRecordTypeInfo( getRecordType( anSObject, recordTypeName ) );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( Id sObjectId, String recordTypeName )
    {
        return  getRecordTypeInfo( getRecordType( sObjectId, recordTypeName ) );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( RecordType recordType )
    {
        return getRecordTypeInfo( recordType != null ? getRecordTypeInfos( recordType.sObjectType ).get( recordType.Id ) : (Schema.RecordTypeInfo) null );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( Schema.RecordTypeInfo recordTypeInfo )
    {
        return
            recordTypeInfo != null
        ?   recordTypeInfo
        :   (Schema.RecordTypeInfo) invalidRecordTypeSpecification( 'getRecordTypeInfo' );
    }

    public static Schema.RecordTypeInfo getRecordTypeInfo( Id recordTypeId )
    {
        return getRecordTypeInfo( getRecordType( recordTypeId ) );
    }

    /***********************************************************
                    getRecordTypeId method
    ***********************************************************/

    public static Id getRecordTypeId( String sObjectName, String recordTypeName )
    {
        return getRecordTypeId( getRecordType( sObjectName, recordTypeName ) );
    }

    public static Id getRecordTypeId( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return getRecordTypeId( getRecordType( sObjectType, recordTypeName ) );
    }

    public static Id getRecordTypeId( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return getRecordTypeId( getRecordType( sObjectResult, recordTypeName ) );
    }

    public static Id getRecordTypeId( sObject anSObject, String recordTypeName )
    {
        return getRecordTypeId( getRecordType( anSObject, recordTypeName ) );
    }

    public static Id getRecordTypeId( Id sObjectId, String recordTypeName )
    {
        return getRecordTypeId( getRecordType( sObjectId, recordTypeName ) );
    }

    public static Id getRecordTypeId( RecordType recordType )
    {
        return
            recordType != null
        ?   recordType.Id
        :   (Id) invalidRecordTypeSpecification( 'getRecordTypeId' );
    }

    public static Id getRecordTypeId( Schema.RecordTypeInfo recordTypeInfo )
    {
        return
            recordTypeInfo != null
        ?   recordTypeInfo.getRecordTypeId()
        :   (Id) invalidRecordTypeSpecification( 'getRecordTypeId' );
    }

    public static Id getRecordTypeId( Id recordTypeId )
    {
        return getRecordTypeId( getRecordType( recordTypeId ) );
    }

    /***********************************************************
                    getRecordTypeName method
    ***********************************************************/

    public static String getRecordTypeName( String sObjectName, String recordTypeName )
    {
        return getRecordTypeName( getRecordType( sObjectName, recordTypeName ) );
    }

    public static String getRecordTypeName( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return getRecordTypeName( getRecordType( sObjectType, recordTypeName ) );
    }

    public static String getRecordTypeName( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return getRecordTypeName( getRecordType( sObjectResult, recordTypeName ) );
    }

    public static String getRecordTypeName( sObject anSObject, String recordTypeName )
    {
        return getRecordTypeName( getRecordType( anSObject, recordTypeName ) );
    }

    public static String getRecordTypeName( Id sObjectId, String recordTypeName )
    {
        return getRecordTypeName( getRecordType( sObjectId, recordTypeName ) );
    }

    public static String getRecordTypeName( RecordType recordType )
    {
        return
            recordType != null
        ?   recordType.DeveloperName
        :   (Id) invalidRecordTypeSpecification( 'getRecordTypeName' );
    }

    public static String getRecordTypeName( Schema.RecordTypeInfo recordTypeInfo )
    {
        return getRecordTypeName( getRecordType( recordTypeInfo ) );
    }

    public static String getRecordTypeName( Id recordTypeId )
    {
        return getRecordTypeName( getRecordType( recordTypeId ) );
    }

    /***********************************************************
                    getRecordTypeLabel method
    ***********************************************************/

    public static String getRecordTypeLabel( String sObjectName, String recordTypeName )
    {
        return getRecordTypeLabel( getRecordType( sObjectName, recordTypeName ) );
    }

    public static String getRecordTypeLabel( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return getRecordTypeLabel( getRecordType( sObjectType, recordTypeName ) );
    }

    public static String getRecordTypeLabel( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return getRecordTypeLabel( getRecordType( sObjectResult, recordTypeName ) );
    }

    public static String getRecordTypeLabel( sObject anSObject, String recordTypeName )
    {
        return getRecordTypeLabel( getRecordType( anSObject, recordTypeName ) );
    }

    public static String getRecordTypeLabel( Id sObjectId, String recordTypeName )
    {
        return getRecordTypeLabel( getRecordType( sObjectId, recordTypeName ) );
    }

    public static String getRecordTypeLabel( RecordType recordType )
    {
        return
            recordType != null
        ?   recordType.Name
        :   (Id) invalidRecordTypeSpecification( 'getRecordTypeLabel' );
    }

    public static String getRecordTypeLabel( Schema.RecordTypeInfo recordTypeInfo )
    {
        return recordTypeInfo != null ? recordTypeInfo.getName() : null;
    }

    public static String getRecordTypeLabel( Id recordTypeId )
    {
        return getRecordTypeLabel( getRecordType( recordTypeId ) );
    }

    /***********************************************************
                    isPersonType method
    ***********************************************************/

    public static Boolean isPersonType( String sObjectName, String recordTypeName )
    {
        return isPersonType( getRecordType( sObjectName, recordTypeName ) );
    }

    public static Boolean isPersonType( Schema.sObjectType sObjectType, String recordTypeName )
    {
        return isPersonType( getRecordType( sObjectType, recordTypeName ) );
    }

    public static Boolean isPersonType( Schema.DescribeSObjectResult sObjectResult, String recordTypeName )
    {
        return isPersonType( getRecordType( sObjectResult, recordTypeName ) );
    }

    public static Boolean isPersonType( sObject anSObject, String recordTypeName )
    {
        return isPersonType( getRecordType( anSObject, recordTypeName ) );
    }

    public static Boolean isPersonType( Id sObjectId, String recordTypeName )
    {
        return isPersonType( getRecordType( sObjectId, recordTypeName ) );
    }

    public static Boolean isPersonType( RecordType recordType )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = recordType != null && isField( 'RecordType', 'IsPersonType' ) && (Boolean) recordType.get( 'IsPersonType' );
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isPersonType( Schema.RecordTypeInfo recordTypeInfo )
    {
        return isPersonType( getRecordType( recordTypeInfo ) );
    }

    public static Boolean isPersonType( Id recordTypeId )
    {
        return isPersonType( getRecordType( recordTypeId ) );
    }


    /***********************************************************
    ************************************************************

        Section 6:  Child Relationship Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
            invalidChildRelationshipSpecification method
    ***********************************************************/

    private static Object invalidChildRelationshipSpecification( String method )
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid child relationship specification.' );
    }

    /***********************************************************
                    isChildRelationship method
    ***********************************************************/

    public static Boolean isChildRelationship( String sObjectName, String childRelationshipName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( sObjectName, childRelationshipName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( sObjectType, childRelationshipName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( sObjectResult, childRelationshipName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isChildRelationship( sObject anSObject, String childRelationshipName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( anSObject, childRelationshipName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isChildRelationship( Id sObjectId, String childRelationshipName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( sObjectId, childRelationshipName ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isChildRelationship( Schema.ChildRelationship childRelationship )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getChildRelationship( childRelationship ) != null;
        CWException.restoreErrorHandler();
        return result;
    }

    /***********************************************************
                    getChildRelationship method
    ***********************************************************/

    public static Schema.ChildRelationship getChildRelationship( String sObjectName, String childRelationshipName )
    {
        return getChildRelationship( getDescribeSObjectResult( sObjectName ), childRelationshipName );
    }

    public static Schema.ChildRelationship getChildRelationship( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getChildRelationship( getDescribeSObjectResult( sObjectType ), childRelationshipName );
    }

    public static Schema.ChildRelationship getChildRelationship( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getChildRelationship( sObjectResult != null ? getChildRelationships( sObjectResult ).get( childRelationshipName ) : (Schema.ChildRelationship) null );
    }

    public static Schema.ChildRelationship getChildRelationship( sObject anSObject, String childRelationshipName )
    {
        return getChildRelationship( getDescribeSObjectResult( anSObject ), childRelationshipName );
    }

    public static Schema.ChildRelationship getChildRelationship( Id sObjectId, String childRelationshipName )
    {
        return getChildRelationship( getDescribeSObjectResult( sObjectId ), childRelationshipName );
    }

    public static Schema.ChildRelationship getChildRelationship( Schema.ChildRelationship childRelationship )
    {
        return
            childRelationship != null
        ?   childRelationship
        :   (Schema.ChildRelationship) invalidChildRelationshipSpecification( 'getChildRelationship' );
    }

    /***********************************************************
                    getChildSObjectName method
    ***********************************************************/

    public static String getChildSObjectName( String sObjectName, String childRelationshipName )
    {
        return getSObjectName( getChildSObjectType( sObjectName, childRelationshipName ) );
    }

    public static String getChildSObjectName( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getSObjectName( getChildSObjectType( sObjectType, childRelationshipName ) );
    }

    public static String getChildSObjectName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getSObjectName( getChildSObjectType( sObjectResult, childRelationshipName ) );
    }

    public static String getChildSObjectName( sObject anSObject, String childRelationshipName )
    {
        return getSObjectName( getChildSObjectType( anSObject, childRelationshipName ) );
    }

    public static String getChildSObjectName( Id sObjectId, String childRelationshipName )
    {
        return getSObjectName( getChildSObjectType( sObjectId, childRelationshipName ) );
    }

    public static String getChildSObjectName( Schema.ChildRelationship childRelationship )
    {
        return getSObjectName( getChildSObjectType( childRelationship ) );
    }

    /***********************************************************
                    getChildSObjectType method
    ***********************************************************/

    public static Schema.sObjectType getChildSObjectType( String sObjectName, String childRelationshipName )
    {
        return getChildSObjectType( getChildRelationship( sObjectName, childRelationshipName ) );
    }

    public static Schema.sObjectType getChildSObjectType( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getChildSObjectType( getChildRelationship( sObjectType, childRelationshipName ) );
    }

    public static Schema.sObjectType getChildSObjectType( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getChildSObjectType( getChildRelationship( sObjectResult, childRelationshipName ) );
    }

    public static Schema.sObjectType getChildSObjectType( sObject anSObject, String childRelationshipName )
    {
        return getChildSObjectType( getChildRelationship( anSObject, childRelationshipName ) );
    }

    public static Schema.sObjectType getChildSObjectType( Id sObjectId, String childRelationshipName )
    {
        return getChildSObjectType( getChildRelationship( sObjectId, childRelationshipName ) );
    }

    public static Schema.sObjectType getChildSObjectType( Schema.ChildRelationship childRelationship )
    {
        return
            childRelationship != null
        ?   childRelationship.getChildSObject()
        :   (Schema.sObjectType) invalidChildRelationshipSpecification( 'getChildSObjectType' );
    }

    /***********************************************************
                    getChildDescribeSObjectResult method
    ***********************************************************/

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( String sObjectName, String childRelationshipName )
    {
        return getDescribeSObjectResult( getChildSObjectType( sObjectName, childRelationshipName ) );
    }

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getDescribeSObjectResult( getChildSObjectType( sObjectType, childRelationshipName ) );
    }

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getDescribeSObjectResult( getChildSObjectType( sObjectResult, childRelationshipName ) );
    }

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( sObject anSObject, String childRelationshipName )
    {
        return getDescribeSObjectResult( getChildSObjectType( anSObject, childRelationshipName ) );
    }

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Id sObjectId, String childRelationshipName )
    {
        return getDescribeSObjectResult( getChildSObjectType( sObjectId, childRelationshipName ) );
    }

    public static Schema.DescribeSObjectResult getChildDescribeSObjectResult( Schema.ChildRelationship childRelationship )
    {
        return getDescribeSObjectResult( getChildSObjectType( childRelationship ) );
    }

    /***********************************************************
                    getChildFieldName method
    ***********************************************************/

    public static String getChildFieldName( String sObjectName, String childRelationshipName )
    {
        return getFieldName( getChildSObjectField( sObjectName, childRelationshipName ) );
    }

    public static String getChildFieldName( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getFieldName( getChildSObjectField( sObjectType, childRelationshipName ) );
    }

    public static String getChildFieldName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getFieldName( getChildSObjectField( sObjectResult, childRelationshipName ) );
    }

    public static String getChildFieldName( sObject anSObject, String childRelationshipName )
    {
        return getFieldName( getChildSObjectField( anSObject, childRelationshipName ) );
    }

    public static String getChildFieldName( Id sObjectId, String childRelationshipName )
    {
        return getFieldName( getChildSObjectField( sObjectId, childRelationshipName ) );
    }

    public static String getChildFieldName( Schema.ChildRelationship childRelationship )
    {
        return getFieldName( getChildSObjectField( childRelationship ) );
    }

    /***********************************************************
                    getChildSObjectField method
    ***********************************************************/

    public static Schema.sObjectField getChildSObjectField( String sObjectName, String childRelationshipName )
    {
        return getChildSObjectField( getChildRelationship( sObjectName, childRelationshipName ) );
    }

    public static Schema.sObjectField getChildSObjectField( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getChildSObjectField( getChildRelationship( sObjectType, childRelationshipName ) );
    }

    public static Schema.sObjectField getChildSObjectField( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getChildSObjectField( getChildRelationship( sObjectResult, childRelationshipName ) );
    }

    public static Schema.sObjectField getChildSObjectField( sObject anSObject, String childRelationshipName )
    {
        return getChildSObjectField( getChildRelationship( anSObject, childRelationshipName ) );
    }

    public static Schema.sObjectField getChildSObjectField( Id sObjectId, String childRelationshipName )
    {
        return getChildSObjectField( getChildRelationship( sObjectId, childRelationshipName ) );
    }

    public static Schema.sObjectField getChildSObjectField( Schema.ChildRelationship childRelationship )
    {
        return
            childRelationship != null
        ?   childRelationship.getField()
        :   (Schema.sObjectField) invalidChildRelationshipSpecification( 'getChildSObjectField' );
    }

    /***********************************************************
                    getChildDescribeFieldResult method
    ***********************************************************/

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( String sObjectName, String childRelationshipName )
    {
        return getDescribeFieldResult( getChildSObjectField( sObjectName, childRelationshipName ) );
    }

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getDescribeFieldResult( getChildSObjectField( sObjectType, childRelationshipName ) );
    }

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getDescribeFieldResult( getChildSObjectField( sObjectResult, childRelationshipName ) );
    }

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( sObject anSObject, String childRelationshipName )
    {
        return getDescribeFieldResult( getChildSObjectField( anSObject, childRelationshipName ) );
    }

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( Id sObjectId, String childRelationshipName )
    {
        return getDescribeFieldResult( getChildSObjectField( sObjectId, childRelationshipName ) );
    }

    public static Schema.DescribeFieldResult getChildDescribeFieldResult( Schema.ChildRelationship childRelationship )
    {
        return getDescribeFieldResult( getChildSObjectField( childRelationship ) );
    }

    /***********************************************************
                    getChildRelationshipName method
    ***********************************************************/

    public static String getChildRelationshipName( String sObjectName, String childRelationshipName )
    {
        return getChildRelationshipName( getChildRelationship( sObjectName, childRelationshipName ) );
    }

    public static String getChildRelationshipName( Schema.sObjectType sObjectType, String childRelationshipName )
    {
        return getChildRelationshipName( getChildRelationship( sObjectType, childRelationshipName ) );
    }

    public static String getChildRelationshipName( Schema.DescribeSObjectResult sObjectResult, String childRelationshipName )
    {
        return getChildRelationshipName( getChildRelationship( sObjectResult, childRelationshipName ) );
    }

    public static String getChildRelationshipName( sObject anSObject, String childRelationshipName )
    {
        return getChildRelationshipName( getChildRelationship( anSObject, childRelationshipName ) );
    }

    public static String getChildRelationshipName( Id sObjectId, String childRelationshipName )
    {
        return getChildRelationshipName( getChildRelationship( sObjectId, childRelationshipName ) );
    }

    public static String getChildRelationshipName( Schema.ChildRelationship childRelationship )
    {
        return
            childRelationship != null
        ?   childRelationship.getRelationshipName()
        :   (String) invalidChildRelationshipSpecification( 'getChildRelationshipName' );
    }


    /***********************************************************
    ************************************************************

        Section 7:  Parent Relationship Methods

    ************************************************************
    ***********************************************************/

    /***********************************************************
            invalidParentRelationshipSpecification method
    ***********************************************************/

    private static Object invalidParentRelationshipSpecification( String method )
    {
        return CWException.errorNull( 'CWSchema.' + method + ': Invalid parent relationship specification.' );
    }

    /***********************************************************
                    isParentRelationship method
    ***********************************************************/

    public static Boolean isParentRelationship( String sObjectName, String lookupFieldName )
    {
        return isParentRelationship( getDescribeSObjectResult( sObjectName ), lookupFieldName );
    }

    public static Boolean isParentRelationship( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return isParentRelationship( getDescribeSObjectResult( sObjectType ), lookupFieldName );
    }

    public static Boolean isParentRelationship( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        CWException.setErrorHandler( 'CWException.IgnoreError' );
        Boolean result = getFieldDisplayType( sObjectResult, lookupFieldName ) == Schema.DisplayType.Reference;
        CWException.restoreErrorHandler();
        return result;
    }

    public static Boolean isParentRelationship( sObject anSObject, String lookupFieldName  )
    {
        return isParentRelationship( getDescribeSObjectResult( anSObject ), lookupFieldName );
    }

    public static Boolean isParentRelationship( Id sObjectId, String lookupFieldName  )
    {
        return isParentRelationship( getDescribeSObjectResult( sObjectId ), lookupFieldName );
    }

    /***********************************************************
                    getParentRelationshipName method
    ***********************************************************/

    public static String getParentRelationshipName( String sObjectName, String lookupFieldName )
    {
        return getParentRelationshipName( getDescribeSObjectResult( sObjectName ), lookupFieldName );
    }

    public static String getParentRelationshipName( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return getParentRelationshipName( getDescribeSObjectResult( sObjectType ), lookupFieldName );
    }

    public static String getParentRelationshipName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        Schema.DescribeFieldResult fieldDescribe = getDescribeFieldResult( sObjectResult, lookupFieldName );

        return fieldDescribe != null ? fieldDescribe.getRelationshipName() : null;
    }

    public static String getParentRelationshipName( sObject anSObject, String lookupFieldName  )
    {
        return getParentRelationshipName( getDescribeSObjectResult( anSObject ), lookupFieldName );
    }

    public static String getParentRelationshipName( Id sObjectId, String lookupFieldName  )
    {
        return getParentRelationshipName( getDescribeSObjectResult( sObjectId ), lookupFieldName );
    }

    /***********************************************************
                    getParentSObjectName method
    ***********************************************************/

    public static String getParentSObjectName( String sObjectName, String lookupFieldName )
    {
        return getSObjectName( getParentSObjectType( sObjectName, lookupFieldName ) );
    }

    public static String getParentSObjectName( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return getSObjectName( getParentSObjectType( sObjectType, lookupFieldName ) );
    }

    public static String getParentSObjectName( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        return getSObjectName( getParentSObjectType( sObjectResult, lookupFieldName ) );
    }

    public static String getParentSObjectName( sObject anSObject, String lookupFieldName  )
    {
        return getSObjectName( getParentSObjectType( anSObject, lookupFieldName ) );
    }

    public static String getParentSObjectName( Id sObjectId, String lookupFieldName  )
    {
        return getSObjectName( getParentSObjectType( sObjectId, lookupFieldName ) );
    }

    /***********************************************************
                    getParentSObjectType method
    ***********************************************************/

    public static Schema.sObjectType getParentSObjectType( String sObjectName, String lookupFieldName )
    {
        return getParentSObjectType( getDescribeSObjectResult( sObjectName ), lookupFieldName );
    }

    public static Schema.sObjectType getParentSObjectType( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return getParentSObjectType( getDescribeSObjectResult( sObjectType ), lookupFieldName );
    }

    public static Schema.sObjectType getParentSObjectType( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        if ( !isParentRelationship( sObjectResult, lookupFieldName ) )
        {
            return (Schema.sObjectType) invalidParentRelationshipSpecification( 'getParentSObjectType' );
        }

        Schema.sObjectType  theType     = null;

        for ( Schema.sObjectType aType : getDescribeFieldResult( sObjectResult, lookupFieldName ).getReferenceTo() )
        {
            theType = aType;
            break;
        }

        //  this line is long for code coverage reasons
        return theType != null ? theType : (Schema.sObjectType) CWException.errorNull( 'CWSchema.getParentSObjectType: Lookup field \'' + getSObjectName( sObjectResult ) + '.' + lookupFieldName + '\' has no sObjectType.' );
    }

    public static Schema.sObjectType getParentSObjectType( sObject anSObject, String lookupFieldName  )
    {
        return getParentSObjectType( getDescribeSObjectResult( anSObject ), lookupFieldName );
    }

    public static Schema.sObjectType getParentSObjectType( Id sObjectId, String lookupFieldName  )
    {
        return getParentSObjectType( getDescribeSObjectResult( sObjectId ), lookupFieldName );
    }

    /***********************************************************
                    getParentDescribeSObjectResult method
    ***********************************************************/

    public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( String sObjectName, String lookupFieldName )
    {
        return getDescribeSObjectResult( getParentSObjectType( sObjectName, lookupFieldName ) );
    }

    public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return getDescribeSObjectResult( getParentSObjectType( sObjectType, lookupFieldName ) );
    }

    public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        return getDescribeSObjectResult( getParentSObjectType( sObjectResult, lookupFieldName ) );
    }

    public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( sObject anSObject, String lookupFieldName  )
    {
        return getDescribeSObjectResult( getParentSObjectType( anSObject, lookupFieldName ) );
    }

    public static Schema.DescribeSObjectResult getParentDescribeSObjectResult( Id sObjectId, String lookupFieldName  )
    {
        return getDescribeSObjectResult( getParentSObjectType( sObjectId, lookupFieldName ) );
    }

    /***********************************************************
                    getParentSObjectFields method
    ***********************************************************/

    public static Map<String,Schema.sObjectField> getParentSObjectFields( String sObjectName, String lookupFieldName )
    {
        return getSObjectFields( getParentSObjectType( sObjectName, lookupFieldName ) );
    }

    public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.sObjectType sObjectType, String lookupFieldName )
    {
        return getSObjectFields( getParentSObjectType( sObjectType, lookupFieldName ) );
    }

    public static Map<String,Schema.sObjectField> getParentSObjectFields( Schema.DescribeSObjectResult sObjectResult, String lookupFieldName )
    {
        return getSObjectFields( getParentSObjectType( sObjectResult, lookupFieldName ) );
    }

    public static Map<String,Schema.sObjectField> getParentSObjectFields( sObject anSObject, String lookupFieldName  )
    {
        return getSObjectFields( getParentSObjectType( anSObject, lookupFieldName ) );
    }

    public static Map<String,Schema.sObjectField> getParentSObjectFields( Id sObjectId, String lookupFieldName  )
    {
        return getSObjectFields( getParentSObjectType( sObjectId, lookupFieldName ) );
    }
}