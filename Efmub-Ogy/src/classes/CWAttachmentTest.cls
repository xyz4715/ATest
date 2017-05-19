/*******************************************************//**

@class		CWAttachmentTest

@brief		CWAttachment Test Class

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-30	LiquidHub.TRS
	Created.

@see		CWAttachment

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWAttachmentTest
{
	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwAttachmentUnitTest()
	{
		////	Create Records for Test
		CWObject	objectsForTest		= CWAttachment.createRecordsForTest();
		Contact		c					= (Contact) objectsForTest.get( 'contact' );
		Integer		attachmentCount		= (Integer) objectsForTest.get( 'attachmentCount' );
		String		fileSizeString		= (String) objectsForTest.get( 'fileSizeString' );

		////	Begin Test
		CWTest testResults = new CWTest( 'CWAttachmentTest' );
		String testingMethod;

		testResults.startTest();

		////	getAllAttachments methods test
		List<Attachment>	attWithoutBodies	= CWAttachment.getAllAttachments( c.Id );
		List<Attachment>	attWithBodies		= CWAttachment.getAllAttachmentsWithBodies( c.Id );

		////	getAllAttachments methods test assertions
		testingMethod = 'getAllAttachments';
		Map<String,Object>	attachmentMap =
			!attWithoutBodies.isEmpty()
		?	(Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( attWithoutBodies[0] ) )
		:	null;

		testResults.assert
		(	testingMethod,
			attWithoutBodies.size() == attachmentCount
		&&	attachmentMap != null
		&&	attachmentMap.containsKey( 'Id' )
		&&	attachmentMap.containsKey( 'Name' )
		&&	!attachmentMap.containsKey( 'Body' )
		&&	attachmentMap.containsKey( 'BodyLength' ),
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		testingMethod = 'getAllAttachmentsWithBodies';
		attachmentMap =
			!attWithBodies.isEmpty()
		?	(Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( attWithBodies[0] ) )
		:	null;

		testResults.assert
		(	testingMethod,
			attWithoutBodies.size() == attachmentCount
		&&	attachmentMap != null
		&&	attachmentMap.containsKey( 'Id' )
		&&	attachmentMap.containsKey( 'Name' )
		&&	attachmentMap.containsKey( 'Body' )
		&&	attachmentMap.containsKey( 'BodyLength' ),
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	getAttachmentBodies methods test
		attWithoutBodies = CWAttachment.getAttachmentBodies( attWithoutBodies );

		////	getAllAttachments methods test assertions
		testingMethod = 'getAttachmentBodies';
		attachmentMap =
			!attWithoutBodies.isEmpty()
		?	(Map<String,Object>) JSON.deserializeUntyped( JSON.serialize( attWithoutBodies[0] ) )
		:	null;

		testResults.assert
		(	testingMethod,
			attWithoutBodies.size()	== attachmentCount
		&&	attachmentMap != null
		&&	attachmentMap.containsKey( 'Id' )
		&&	attachmentMap.containsKey( 'Name' )
		&&	attachmentMap.containsKey( 'Body' )
		&&	attachmentMap.containsKey( 'BodyLength' ),
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	getFileSize methods test
		String testByteSizeString =
			!attWithoutBodies.isEmpty()
		?	CWAttachment.getFileSize( attWithoutBodies[0] )
		:	'';

		Attachment	aKB					= (Attachment) JSON.deserialize( '{"BodyLength":1024, "Name":"Test File 0"}', Attachment.class );
		String		testKBSizeString	= CWAttachment.getFileSize( aKB );
		Attachment	aMB					= (Attachment) JSON.deserialize( '{"BodyLength":' + (1024*1024) + ', "Name":"Test File 0"}', Attachment.class );
		String		testMBSizeString	= CWAttachment.getFileSize( aMB );
		Attachment	aGB					= (Attachment) JSON.deserialize( '{"BodyLength":' + (1024*1024*1024) + ', "Name":"Test File 0"}', Attachment.class );
		String		testGBSizeString	= CWAttachment.getFileSize( aGB );

		////	getAllAttachments methods test assertions
		testingMethod = 'getFileSize';

		testResults.assert
		(	testingMethod,
			fileSizeString,
			testByteSizeString,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		testResults.assert
		(	testingMethod,
			testKBSizeString	== '1.00 KB'
		&&	testMBSizeString	== '1.00 MB'
		&&	testGBSizeString	== '1.00 GB',
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		////	toCWObject method test
		Object cwObj = CWAttachment.toCWObject( attWithoutBodies );

		////	toCWObject methods test assertions
		testingMethod = 'toCWObject';
		testResults.assert
		(	testingMethod,
			cwObj instanceOf CWObject,
			testingMethod + ' unexpected result.\n' + testResults.getErrorString()
		);

		testResults.report();
	}
}