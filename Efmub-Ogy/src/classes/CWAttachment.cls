/*******************************************************//**

@class		CWAttachment

@brief		CW Core Attachment Class

Query
	getAllAttachments
	getAllAttachmentsWithBodies

Conversion / Creation
	toCWObject

Describe
	getFileSize

@author		Tim Smith		(LiquidHub.TRS)
@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-08-11	LiquidHub.TRS
	Created.
@version	2014-09-19	LiquidHub.GHA
	Added 'CreatedDate' to the list of fields returned.

@todo	Lots

@see		CWAttachmentTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWAttachment
{
	/***********************************************************
						constants
	***********************************************************/

	private static List<String> attachmentFieldSetWithoutBody	= new List<String>{ 'Id', 'Name', 'ContentType', 'BodyLength', 'CreatedDate' };
	private static List<String> attachmentFieldSetWithBody		= new List<String>{ 'Id', 'Name', 'ContentType', 'Body', 'BodyLength', 'CreatedDate' };

	/***********************************************************
					getAllAttachments methods

	Takes an sObjectId and returns list<Attachment>. Can query
	with or without Body. If used in a VF getter, it's best not
	to include Body so as not to blow up viewstate. 
	***********************************************************/

	public static List<Attachment> getAllAttachments( Id sObjectId )
	{
		return getAllAttachments( sObjectId, attachmentFieldSetWithoutBody );
	}

	public static List<Attachment> getAllAttachmentsWithBodies( Id sObjectId )
	{
		return getAllAttachments( sObjectId, attachmentFieldSetWithBody );
	}

	private static List<Attachment> getAllAttachments( Id sObjectId, List<String> fieldSet )
	{
		CWQuery attachmentQuery = CWQuery.newQuery( Attachment.getSObjectType() );
		attachmentQuery.add( fieldSet );
		attachmentQuery.newWhereClause( 'ParentId = \''+sObjectId+'\'' );
		attachmentQuery.orderByDescending( 'CreatedDate' );
		return (List<Attachment>) attachmentQuery.query();
	}

	/***********************************************************
					getAttachmentBodies methods

	Takes a list of Attachments without bodies and re-queries to
	get the bodies. Useful when a subset of getAllAttachments
	needs bodies in order to download, use in callout, etc.
	***********************************************************/

	public static List<Attachment> getAttachmentBodies( List<Attachment> attachments )
	{
		Set<Id> attachmentIds = (new Map<Id,Attachment>( attachments )).keyset();
		return getAttachmentBodies( attachmentIds );
	}

	public static List<Attachment> getAttachmentBodies( Set<Id> attachmentIds )
	{
		CWQuery attachmentQuery = CWQuery.newQuery( Attachment.getSObjectType() );
		attachmentQuery.add( attachmentFieldSetWithBody );
		attachmentQuery.newWhereClause().isIn( 'Id', new List<Id>( attachmentIds ) );
		attachmentQuery.orderByDescending( 'CreatedDate' );
		return (List<Attachment>) attachmentQuery.query();
	}

	/***********************************************************
					getFileSize methods

	Takes the file size property of the attachment and returns
	a formatted string representation. 
	***********************************************************/

	public static String getFileSize( Attachment a )
	{
		return a != null ? CWString.fileSize( a.BodyLength ) : '0 Bytes';
	}

	/***********************************************************
					toCWObject method

	Converts a list of attachments to CWObject
	***********************************************************/

	public static CWObject toCWObject( List<Attachment> attachments )
	{
		return new CWObject( new Map<String,Attachment>( attachments ) );
	}

	/*******************************************************
					Unit Test Supporting Methods
	*******************************************************/

	public static CWObject createRecordsForTest()
	{
		/***************************************************
					Create Records for Test
		***************************************************/
		CWObject objectsForTest = new CWObject();

		Contact c =
			new Contact
			(	FirstName		= 'John',
				LastName		= 'Doe',
				Fax				= '15555555555'
			);
		insert c;
		objectsForTest.put( 'contact', c );

		List<Attachment>	attachments 		= new List<Attachment>();
		Integer				attachmentCount		= 4;
		String				fileName			= 'Test File';
		Blob				fileBody			= Blob.valueOf( 'This is a text file' );
		String				fileSizeString		= '' + fileBody.size() + ' Bytes';

		for ( Integer i = 0; i < attachmentCount; i++ )
		{
			attachments.add
			(	new Attachment
				(	Name 			= fileName + ' ' + i,
					Body 			= fileBody,
					ParentId		= c.Id
				)
			);
		}
		insert attachments;

		objectsForTest.put( 'attachments',		attachments );
		objectsForTest.put( 'attachmentCount',	attachmentCount );
		objectsForTest.put( 'fileSizeString',	fileSizeString );

		return objectsForTest;
	}

}