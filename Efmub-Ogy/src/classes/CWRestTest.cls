/*******************************************************//**

@class		CWRestTest

@brief		CWRest Test Class. Leverages Mock HTTP service
			from CWHttpTest.

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-31	LiquidHub.TRS
	Created.
@version	2014-11-11	LiquidHub.TRS
	Resolved error on bearer authentication.

@see		CWRest, CWHttpTest

@todo		Increase coverage from 50% to 100%
@todo		Add coverage for CWRest.Server

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWRestTest
{
	/*******************************************************
					Unit Test Constants
	*******************************************************/

	private static final String		API_KEY				= 'TestAPIKey';
	private static final String		CLIENT_ID			= 'TestClientID';
	private static final String		CLIENT_SECRET		= 'TestClientSecret';
	private static final String		USERNAME			= 'TestUsername';
	private static final String		PASSWORD			= 'TestPassword';
	private static final String		ENCRYPTION_KEY_32	= 'TestEncryptionKeyTestEncryptionK';

	/*******************************************************
					cwRestUnitTest Method
	*******************************************************/

	static testMethod void cwRestUnitTest()
	{
		////	Begin Test
		CWTest		testResults		= new CWTest( 'CWRestTest' );
		String		testingMethod;

		testResults.startTest();
		// Set mock callout class 
		Test.setMock( HttpCalloutMock.class, new CWHttpTest() );

		CWRest.Client	client		= new CWRest.Client( CWHttpTest.ENDPOINT, new Map<String,String>{'Accept'=>'application/json'} );

		////	GET Request Test
		testingMethod				= 'GETRequest';
		CWObject	getResponse		= new CWObject( (String) client.get() );

		////	GET Request Asserts
		testResults.assert
		(	testingMethod,
			CWHttpTest.GET_METHOD_STRING,
			getResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		////	POST Request Test
		testingMethod				= 'POSTRequest';
		CWObject	postResponse	= new CWObject( (String) client.post( CWHttpTest.REQUEST_OBJECT, CWHttp.ContentType.JSON ) );

		////	POST Request Asserts
		testResults.assert
		(	testingMethod,
			CWHttpTest.POST_METHOD_STRING,
			postResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		////	PUT Request Test
		testingMethod				= 'PUTRequest';
		CWObject	putResponse		= new CWObject( (String) client.put( CWHttpTest.REQUEST_OBJECT, CWHttp.ContentType.JSON ) );

		////	PUT Request Asserts
		testResults.assert
		(	testingMethod,
			CWHttpTest.PUT_METHOD_STRING,
			putResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		////	DELETE Request Test
		testingMethod				= 'DELRequest';
		CWObject	delResponse		= new CWObject( (String) client.del() );

		////	DELETE Request Asserts
		testResults.assert
		(	testingMethod,
			CWHttpTest.DEL_METHOD_STRING,
			delResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		////	Signed Token Authorization Test
		testingMethod				= 'SignedTokenAuthorization';
		String		input			= 'Username='+USERNAME+'&ApiKey='+API_KEY;
		CWRest.SignedTokenAuthorization	signedToken	= new CWRest.SignedTokenAuthorization( input, CWSecurity.Method.ENCRYPT, CWSecurity.Algorithm.AES256, ENCRYPTION_KEY_32 );

		////	Signed Token Authorization Asserts
		testResults.assert
		(	testingMethod,
			String.isNotBlank( signedToken.getValue() ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		////	Bearer Authorization Test
		testingMethod							= 'BearerAuthorization';
		CWRest.BearerAuthorization	authToken	= new CWRest.BearerAuthorization( CWHttp.Method.GET, CWHttpTest.ENDPOINT, USERNAME, PASSWORD, CLIENT_ID, CLIENT_SECRET, CWHttp.ContentType.JSON );

		////	Bearer Authorization Asserts
		testResults.assert
		(	testingMethod,
			String.isBlank( authToken.getValue() ),		//	Not yet implemented
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		testResults.report();
	}
}