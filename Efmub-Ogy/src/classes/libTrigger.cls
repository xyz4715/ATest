/*******************************************************//**

@class		CWTrigger

@brief		CW Core Trigger Class

	This class implements Trigger functionality.

@author		Glyn Anderson	(LiquidHub.GHA)
@author		Michael Wing	(LiquidHub.EMW)
@author		Tim Smith		(LiquidHub.TRS)

@version	2013-12-23	LiquidHub.GHA
	Created.
@version	2014-02-25	LiquidHub.GHA
	Added comment headers.	Created 'hasBecome', 'isNoLonger',
	'isStill', 'hasChanged' and 'getOldRecord' methods.
@version	2014-08-04	LiquidHub.GHA
	Modified the 'event' property to use CWString.join.
	Added the method, 'isNewOrHasChanged'.
@version	2014-08-05	LiquidHub.GHA
	Added the 'disallow' and 'allow' methods.
	Added Handler inner class.
@version	2014-08-06	LiquidHub.GHA
	Added the 'reset' method.	Added static versions of 'disallow'
	and 'allow' methods.	Changed the Handler class to an interface.
	Moved 'handle' method into CWTrigger class.	Added a version of
	'handle' the dispatches according to record type.
@version	2014-10-17	LiquidHub.GHA
	Added methods 'getNewRecord', 'getNewValue', 'getOldRecord',
	'getOldValue'.	Refactored 'hasChanged', 'hasBecome', 'isStill',
	'isNoLonger'.	Deprecated 'isNewOrHasChanged'.
@version	2014-10-26	LiquidHub.EMW
	Merged in CWRollupsAutomatic
@version	2014-11-18	LiquidHub.GHA
	Removed deprecated method, 'isNewOrHasChanged'.	Added a version of
	'handle' that takes no arguments, for use when only automated rollups
	are needed.	Automated rollups are now called only once when using
	multiple record type-specific handlers.
@version	2014-11-18	LiquidHub.TRS
	Made newList and oldList empty if n/a to allow for null-safe looping
	in handlers.
@version	2015-01-27	LiquidHub.GHA
	Added 'set_Ids' property.
@version	2015-03-20	LiquidHub.GHA
	Fixed bugs with 'disallow' functionality.
@version	2015-03-23	LiquidHub.GHA
	Added support for CWCoreConfiguration__c.Disable_Triggers__c
	and CWCoreConfiguration__c.Disable_Rollups__c.
@version	2015-03-20	LiquidHub.GHA
	Added 'hasAnyChanged' and 'haveAllChanged' methods.
@version	2016-02-17	LiquidHub.GHA
	Refactored Rollup support into CWTriggerRollups class.

@see		CWTriggerTest

	(c)2013-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public without sharing class CWTrigger
{
	/*******************************************************
						members
	*******************************************************/

	//	These are all initialized by the 'CWTrigger' constructor(s)
	public String	name				{ get; private set; }
	public Boolean	isExecuting			{ get; private set; }
	public Boolean	isBefore			{ get; private set; }
	public Boolean	isAfter				{ get; private set; }
	public Boolean	isInsert			{ get; private set; }
	public Boolean	isUpdate			{ get; private set; }
	public Boolean	isDelete			{ get; private set; }
	public Boolean	isUndelete			{ get; private set; }

	public Boolean	hasOldRecords		{ get { return isUpdate || isDelete; } }
	public Boolean	hasNewRecords		{ get { return isInsert || isUpdate || isUndelete; } }
	public Boolean	hasIds				{ get { return !(isBefore && isInsert); } }

	//	These are all initialized by the 'initializeCollections' method
	public List<sObject>		newList			{ get; private set; }
	public Map<Id,sObject>		newMap			{ get; private set; }
	public List<sObject>		oldList			{ get; private set; }
	public Map<Id,sObject>		oldMap			{ get; private set; }
	public Schema.sObjectType	sObjectType		{ get; private set; }

	public List<sObject>	list_Records
	{
		get { return !isDelete ? newList : oldList; }
	}

	public Map<Id,sObject>	map_Records
	{
		get { return !isDelete ? newMap : oldMap; }
	}

	public Set<Id>			set_Ids
	{
		get { return map_Records != null ? map_Records.keySet() : null; }
	}

	public Integer	size
	{
		get { return list_Records != null ? list_Records.size() : 0; }
	}

	public Boolean isEmpty()
	{
		return size <= 0;
	}

	public String	event
	{
		get
		{
			if ( event == null )
			{
				event = sObjectType != null
				?	CWString.join
					(	new List<String>
						{	name != null ? name + ' ' : '',
							String.valueOf( sObjectType ),
							' ',
							isBefore	?	'before'
						:	isAfter		?	'after'
						:					'',
							' ',
							isInsert	?	'insert'
						:	isUpdate	?	'update'
						:	isDelete	?	'delete'
						:	isUndelete	?	'undelete'
						:					''
						}
					)
				:	null;
			}
			return event;
		}
		private set;
	}

	private static Map<String,Set<Id>>	map_TriggerFlags;

	public Boolean	flag
	{
		get { return map_TriggerFlags.containsKey( event ); }

		set
		{
			if ( event == null || !hasIds ) return;

			if ( value != true ) { map_TriggerFlags.remove( event ); return; }

			disallow( map_Records );
		}
	}

	/*******************************************************
					reset method

	This initializes all static members to simulate CWTrigger
	being newly loaded.
	*******************************************************/

	public static void reset()
	{
		map_TriggerFlags = new Map<String,Set<Id>>();
	}
	static { reset(); }

	/*******************************************************
					disallow method(s)

	This method adds the IDs of the given records to the map
	of records to exclude from future triggers.
	*******************************************************/

	public static void disallow( String event, Set<Id> ids )
	{
		if ( String.isBlank( event ) || ids == null ) return;

		if ( !map_TriggerFlags.containsKey( event ) )
		{
			map_TriggerFlags.put( event, new Set<Id>() );
		}
		map_TriggerFlags.get( event ).addAll( ids );
	}

	public static void disallow( String event, Map<Id,sObject> objects )
	{
		disallow( event, objects != null ? objects.keySet() : (Set<Id>) null );
	}

	public static void disallow( String event, List<sObject> objects )
	{
		disallow( event, objects != null ? new Map<Id,sObject>( objects ) : (Map<Id,sObject>) null );
	}

	public void disallow( Set<Id> ids )
	{
		disallow( event, ids );
	}

	public void disallow( Map<Id,sObject> objects )
	{
		disallow( event, objects );
	}

	public void disallow( List<sObject> objects )
	{
		disallow( event, objects );
	}

	/*******************************************************
					allow method(s)

	This method removes the IDs of the given records from the map
	of records to exclude from future triggers.
	*******************************************************/

	public static void allow( String event, Set<Id> ids )
	{
		if	(	String.isBlank( event )
			||	ids == null
			||	!map_TriggerFlags.containsKey( event )
			) return;

		map_TriggerFlags.get( event ).removeAll( ids );
	}

	public static void allow( String event, Map<Id,sObject> objects )
	{
		allow( event, objects != null ? objects.keySet() : (Set<Id>) null );
	}

	public static void allow( String event, List<sObject> objects )
	{
		allow( event, objects != null ? new Map<Id,sObject>( objects ) : (Map<Id,sObject>) null );
	}

	public void allow( Set<Id> ids )
	{
		allow( event, ids );
	}

	public void allow( Map<Id,sObject> objects )
	{
		allow( event, objects );
	}

	public void allow( List<sObject> objects )
	{
		allow( event, objects );
	}

	/*******************************************************
				initializeCollections method

	This method initializes the newList/newMap/oldList/oldMap
	members, filtering out any records that have already been
	processed, if necessary.	Called by constructors.
	*******************************************************/

	private void initializeCollections( List<sObject> listNew, List<sObject> listOld )
	{
		newList		= hasNewRecords ? listNew : new List<sObject>();
		sObjectType	= newList.getSObjectType();

		if ( !hasIds ) return;

		if ( !newList.isEmpty() )
		{
			newMap = new Map<Id,sObject>( newList );
			if ( flag )
			{
				for ( Id theId : map_TriggerFlags.get( event ) ) newMap.remove( theId );
				newList = newMap.values();
			}
		}

		oldList		= hasOldRecords ? listOld : new List<sObject>();
		if ( sObjectType == null ) sObjectType = oldList.getSObjectType();

		if ( !oldList.isEmpty() )
		{
			oldMap = new Map<Id,sObject>( oldList );
			if ( flag )
			{
				for ( Id theId : map_TriggerFlags.get( event ) ) oldMap.remove( theId );
				oldList = oldMap.values();
			}
		}
	}

	/*******************************************************
			CWTrigger constructors for triggers

	These constructors are used by triggers, and initialize
	the CWTrigger instance based on the Trigger class.
	The name of the trigger is an optional parameter.
	*******************************************************/

	public CWTrigger( String theName )
	{
		if ( !Trigger.isExecuting ) return;

		name = String.isNotBlank( theName ) ? theName.trim() : null;

		isExecuting = Trigger.isExecuting;
		isBefore	= Trigger.isBefore;
		isAfter		= Trigger.isAfter;
		isInsert	= Trigger.isInsert;
		isUpdate	= Trigger.isUpdate;
		isDelete	= Trigger.isDelete;
		isUndelete	= Trigger.isUndelete;

		initializeCollections( Trigger.new, Trigger.old );
	}

	public CWTrigger()
	{
		this( (String) null );
	}

	/*******************************************************
				CWTrigger constructors

	These constructors initialize the CWTrigger instance based
	on the values passed in as parameters:

	theName		[optional] the name of the trigger
	theEvent	an event, such as 'after update' or 'before insert'
	listNew		a list of the records in the trigger in their 'new' state
	listOld		a list of the records in the trigger in their 'old' state

	Note that 'listNew' and 'listOld' must contain elements of
	the same type and must be the same size.
	*******************************************************/

	public CWTrigger( String theName, String theEvent, List<sObject> listNew, List<sObject> listOld )
	{
		name = String.isNotBlank( theName ) ? theName.trim() : null;

		if ( String.isBlank( theEvent ) ) return;

		List<String> eventStrings = theEvent.trim().toLowerCase().split( '\\s+' );

		if	(	eventStrings.size() != 2
			||	!(new Set<String>{ 'before', 'after' }).contains( eventStrings[0] )
			||	!(new Set<String>{ 'insert', 'update', 'delete', 'undelete' }).contains( eventStrings[1] )
			) return;

		isExecuting	= true;
		isBefore	= eventStrings[0].equals( 'before' );
		isAfter		= eventStrings[0].equals( 'after' );
		isInsert	= eventStrings[1].equals( 'insert' );
		isUpdate	= eventStrings[1].equals( 'update' );
		isDelete	= eventStrings[1].equals( 'delete' );
		isUndelete	= eventStrings[1].equals( 'undelete' );

		if	(	(	(isInsert || isUpdate || isUndelete)
				&&	listNew == null
				)
			||	(	(isUpdate || isDelete)
				&&	listOld == null
				)
			||	(	(isUpdate)
				&&	(	listNew.getSObjectType() != listOld.getSObjectType()
					||	listNew.size() != listOld.size()
					)
				)
			) return;

		initializeCollections( listNew, listOld );
	}

	public CWTrigger( String theEvent, List<sObject> listNew, List<sObject> listOld )
	{
		this( (String) null, theEvent, listNew, listOld );
	}

	public CWTrigger( String theName, String theEvent, List<sObject> theList )
	{
		this( theName, theEvent, theList, theList );
	}

	public CWTrigger( String theEvent, List<sObject> theList )
	{
		this( (String) null, theEvent, theList, theList );
	}

	/*******************************************************
						handle method

	This method dispatches to the handler's appropriate method
	for before / after events.
	*******************************************************/

	public void handle()
	{
		handle( (CWTrigger.Handler) null );
	}

	public void handle( CWTrigger.Handler theHandler )
	{
		Handler	rollupHandler	= getRollupHandler();

		if ( isBefore && rollupHandler != null ) rollupHandler.beforeTrigger( this );
		handleTrigger( theHandler );
		if ( isAfter && rollupHandler != null ) rollupHandler.afterTrigger( this );
	}

	private void handleTrigger( CWTrigger.Handler theHandler )
	{
		if ( ((Boolean) CWCoreConfiguration.get( 'Disable_Triggers__c' )) == true || size == 0 || theHandler == null ) return;
		if ( isBefore ) theHandler.beforeTrigger( this );
		if ( isAfter ) theHandler.afterTrigger( this );
	}

	/*******************************************************
						handle method

	This method groups records by record type and dispatches
	to each record type-specific handler.
	*******************************************************/

	public void handle( Map<Id,CWTrigger.Handler> map_RecordTypeId_CWTriggerHandler )
	{
		Map<Id,List<sObject>>	map_RecordTypeId_NewRecords	= new Map<Id,List<sObject>>();
		Map<Id,List<sObject>>	map_RecordTypeId_OldRecords	= new Map<Id,List<sObject>>();

		for ( sObject record : list_Records )
		{
			Id	recordId		= (Id) record.get( 'Id' );
			Id	recordTypeId	= (Id) record.get( 'RecordTypeId' );

			if ( newMap != null || (isBefore && isInsert) )
			{
				if ( !map_RecordTypeId_NewRecords.containsKey( recordTypeId ) )
				{
					map_RecordTypeId_NewRecords.put( recordTypeId, new List<sObject>() );
				}

				if ( newMap != null )
				{
					map_RecordTypeId_NewRecords.get( recordTypeId ).add( newMap.get( recordId ) );
				}
				else
				{
					map_RecordTypeId_NewRecords.get( recordTypeId ).add( record );
				}
			}

			if ( oldMap != null )
			{
				if ( !map_RecordTypeId_OldRecords.containsKey( recordTypeId ) )
				{
					map_RecordTypeId_OldRecords.put( recordTypeId, new List<sObject>() );
				}
				map_RecordTypeId_OldRecords.get( recordTypeId ).add( oldMap.get( recordId ) );
			}
		}

		Set<Id>	set_RecordTypeIds	= new Set<Id>();
		set_RecordTypeIds.addAll( map_RecordTypeId_NewRecords.keySet() );
		set_RecordTypeIds.addAll( map_RecordTypeId_OldRecords.keySet() );

		Handler	rollupHandler	= getRollupHandler();

		if ( isBefore && rollupHandler != null ) rollupHandler.beforeTrigger( this );

		for ( Id recordTypeId : set_RecordTypeIds )
		{
			if ( !map_RecordTypeId_CWTriggerHandler.containsKey( recordTypeId ) ) continue;

			(	new CWTrigger
				(	(isBefore ? 'before ' : 'after ') + event.substringAfterLast( ' ' ),
					map_RecordTypeId_NewRecords.get( recordTypeId ),
					map_RecordTypeId_OldRecords.get( recordTypeId )
				)
			).handleTrigger( map_RecordTypeId_CWTriggerHandler.get( recordTypeId ) );
		}

		if ( isAfter && rollupHandler != null ) rollupHandler.afterTrigger( this );
	}

	/*******************************************************
				getRollupHandler method

	Returns an instance of CWTriggerRollups, if the class exists.
	*******************************************************/

	private Handler getRollupHandler()
	{
		try
		{
			return (Handler) Type.forName( 'CWTriggerRollups' ).newInstance();
		}
		catch ( Exception theException )
		{
			//	eat the error... it's OK if the class doesn't exist.
		}

		return null;
	}

	/*******************************************************
				getOldRecord method

	Given a record/Id from the trigger, this returns the
	corresponding old record, or null if there is none.
	*******************************************************/

	public sObject getOldRecord( sObject record )
	{
		return getOldRecord( record != null ? (Id) record.get( 'Id' ) : null );
	}

	public sObject getOldRecord( Id recordId )
	{
		return recordId != null && hasOldRecords ? oldMap.get( recordId ) : null;
	}

	/*******************************************************
				getOldValue method

	Given a record/Id from the trigger, this returns the value
	of a field from the corresponding old record, or null if
	there is none.
	*******************************************************/

	public Object getOldValue( sObject record, String fieldName )
	{
		record = getOldRecord( record );
		return record != null ? record.get( fieldName ) : null;
	}

	public Object getOldValue( Id recordId, String fieldName )
	{
		sObject	record = getOldRecord( recordId );
		return record != null ? record.get( fieldName ) : null;
	}

	/*******************************************************
				getNewRecord method

	Given a record/Id from the trigger, this returns the
	corresponding new record, or null if there is none.
	*******************************************************/

	public sObject getNewRecord( sObject record )
	{
		return !hasIds ? record : getNewRecord( record != null ? (Id) record.get( 'Id' ) : null );
	}

	public sObject getNewRecord( Id recordId )
	{
		return recordId != null && hasNewRecords ? newMap.get( recordId ) : null;
	}

	/*******************************************************
				getNewValue method

	Given a record/Id from the trigger, this returns the value
	of a field from the corresponding new record, or null if
	there is none.
	*******************************************************/

	public Object getNewValue( sObject record, String fieldName )
	{
		record = getNewRecord( record );
		return record != null ? record.get( fieldName ) : null;
	}

	public Object getNewValue( Id recordId, String fieldName )
	{
		sObject	record = getNewRecord( recordId );
		return record != null ? record.get( fieldName ) : null;
	}

	/*******************************************************
					hasChanged method

	Returns true if the value of the specified field of the
	new and old versions of the record are different.
	*******************************************************/

	public Boolean hasChanged( sObject record, String fieldName )
	{
		return getNewValue( record, fieldName ) != getOldValue( record, fieldName );
	}

	public Boolean hasAnyChanged( sObject record, List<String> fieldNames )
	{
		for ( String fieldName : fieldNames )
		{
			if ( hasChanged( record, fieldName ) ) return true;
		}
		return false;
	}

	public Boolean haveAllChanged( sObject record, List<String> fieldNames )
	{
		for ( String fieldName : fieldNames )
		{
			if ( !hasChanged( record, fieldName ) ) return false;
		}
		return true;
	}

	/*******************************************************
					hasBecome method

	Returns true if the value of the specified field of the new
	record is equal to the specified value AND different from the
	value of that field in the old record.
	*******************************************************/

	public Boolean hasBecome( sObject record, String fieldName, Object value )
	{
		Object	newValue = getNewValue( record, fieldName );

		return newValue == value && newValue != getOldValue( record, fieldName );
	}

	/*******************************************************
					isNoLonger method

	Returns true if the value of the specified field of the old
	record is equal to the specified value AND different from the
	value of that field in the new record.
	*******************************************************/

	public Boolean isNoLonger( sObject record, String fieldName, Object value )
	{
		Object	oldValue = getOldValue( record, fieldName );

		return oldValue == value && oldValue != getNewValue( record, fieldName );
	}

	/*******************************************************
					isStill method

	Returns true if the value of the specified field of the new
	record is equal to the specified value AND the same as the
	value of that field in the old record.
	*******************************************************/

	public Boolean isStill( sObject record, String fieldName, Object value )
	{
		Object	newValue = getNewValue( record, fieldName );

		return newValue == value && newValue == getOldValue( record, fieldName );
	}

	/*******************************************************
					debug methods

	These methods display all the records in the trigger in
	the debug log.
	*******************************************************/

	public void debug( String message )
	{
		String newRecords = 'New Records:\n';
		if ( newList.size() > 0 ) for ( sObject theRecord : newList ) newRecords += String.valueOf( theRecord ) + '\n';

		String oldRecords = 'Old Records:\n';
		if ( oldList.size() > 0 ) for ( sObject theRecord : oldList ) oldRecords += String.valueOf( theRecord ) + '\n';

		System.debug
		(	(message != null ? message + '\n' : '')
		+	event + ' (size = ' + size + ', flag = ' + flag + ')\n'
		+	(newList.size() > 0 && !isEmpty() ? newRecords : '')
		+	(oldList.size() > 0 && !isEmpty() ? oldRecords : '')
		);
	}

	public void debug()
	{
		debug( (String) null );
	}

	/*******************************************************
					Handler interface

	This interface is implemented by classes that handle triggers.
	*******************************************************/

	public interface Handler
	{
		void beforeTrigger( CWTrigger theTrigger );
		void afterTrigger( CWTrigger theTrigger );
	}
}