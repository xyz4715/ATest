/*******************************************************//**

@class		CWHttpTest

@brief		CWHttp Test Class

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-31	LiquidHub.TRS
	Created.
@version	2014-11-11	LiquidHub.TRS
	Resolved error on attachment creation.
@version	2014-11-23	LiquidHub.TRS
	Increase coverage for rewriteURL method

@see		CWHttp

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public class CWHttpTest implements HttpCalloutMock
{
	/*******************************************************
					Unit Test Constants
	*******************************************************/

	public static final	String				ENDPOINT				= 'http://test.cwhttp.com/';
	public static final	String				GET_METHOD_STRING		= 'GET';
	public static final	String				POST_METHOD_STRING		= 'POST';
	public static final	String				PUT_METHOD_STRING		= 'PUT';
	public static final	String				DEL_METHOD_STRING		= 'DELETE';
	public static final	Map<String,String>	URL_PARAMS				= new Map<String,String>{'key'=>'val'};
	public static final	String				ENDPOINT_WITH_PARAMS	= 'http://test.cwhttp.com/?key=val';
	public static final	CWObject			REQUEST_OBJECT			= new CWObject('{"key":"val"}');
	private static		Dom.Document		XML_REQUEST				= new Dom.Document();
	{
		XML_REQUEST.load( '<?xml version="1.0" encoding="UTF-8"?><null/>' );
	}
	private static final	String				FRIENDLY_URL			= '/page/param1/val1/param2/val2';
	private static final	String				FALSE_FRIENDLY_URL		= '/test/param1/val1/param2/val2';
	private static final	String				REWRITEN_URL			= '/page?param1=val1&param2=val2';
	private static final	Set<String> 		PAGE_SET				= new Set<String>{'page'};

	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwHttpUnitTest()
	{
		/***************************************************
					Create Records for Test
		***************************************************/

		CWObject			recordsForTest	= CWAttachment.createRecordsForTest();
		List<Attachment>	attachments		= CWAttachment.getAllAttachmentsWithBodies( ( (Contact) recordsForTest.get( 'contact' ) ).Id );

		/***************************************************
						Begin Test
		***************************************************/

		CWTest	testResults		= new CWTest( 'CWHttpTest' );
		String	testingMethod;

		testResults.startTest();
		// Set mock callout class
		Test.setMock( HttpCalloutMock.class, new CWHttpTest() );

		/***************************************************
						GET Request Test
		***************************************************/

		testingMethod							= 'GETRequest';
		CWHttp.Request	getRequest				= new CWHttp.Request( CWHttp.Method.GET, ENDPOINT );
		CWObject		getResponse				= new CWObject( (String) getRequest.send( REQUEST_OBJECT, CWHttp.ContentType.PARAMETERS ) );
		String			endpointWithParams		= CWHttp.getEndpoint( ENDPOINT, URL_PARAMS );
		CWHttp.Request	getRequestWithParams	= new CWHttp.Request( CWHttp.Method.GET, endpointWithParams );
		CWObject		getResponseWithParams	= new CWObject( (String) getRequestWithParams.send( REQUEST_OBJECT, CWHttp.ContentType.PARAMETERS ) );

		/***************************************************
						GET Request Asserts
		***************************************************/

		testResults.assert
		(	testingMethod,
			GET_METHOD_STRING,
			getResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		testResults.assert
		(	testingMethod,
			ENDPOINT_WITH_PARAMS,
			endpointWithParams,
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		testResults.assert
		(	testingMethod,
			GET_METHOD_STRING,
			getResponseWithParams.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						POST Request Test
		***************************************************/

		testingMethod						= 'POSTRequest';
		CWHttp.Request	postRequest 		= new CWHttp.Request( CWHttp.Method.POST, ENDPOINT, new Map<String,String>{ 'Accept' => 'application/json' } );
		CWObject		postResponse		= new CWObject( (String) postRequest.send( REQUEST_OBJECT ) );

		/***************************************************
						POST Request Asserts
		***************************************************/

		testResults.assert
		(	testingMethod,
			POST_METHOD_STRING,
			postResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						POST Request Test XML
		***************************************************/

		testingMethod						= 'POSTXMLRequest';
		CWHttp.Request	postXMLRequest 		= new CWHttp.Request( CWHttp.Method.POST, ENDPOINT, new Map<String,String>{ 'Accept' => 'application/xml' } );
		Dom.Document	postXMLResponse		= postXMLRequest.send( XML_REQUEST );

		/***************************************************
						POST Request Asserts XML
		***************************************************/

		testResults.assert
		(	testingMethod,
			XML_REQUEST.toXmlString(),
			postXMLResponse.toXmlString(),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						POST Request Test Multipart
		***************************************************/

		testingMethod						= 'POSTMultipartRequest';
		CWObject		multipartRequestObj	= new CWObject( new Map<String,Attachment>( attachments ) );
		CWHttp.Request	postMultiRequest 	= new CWHttp.Request( CWHttp.Method.POST, ENDPOINT, new Map<String,String>{ 'Accept' => 'application/json' } );
		CWObject		postMultiResponse	= new CWObject( (String) postMultiRequest.send( multipartRequestObj, CWHttp.ContentType.MULTIPART ) );

		/***************************************************
						POST Request Asserts Multipart
		***************************************************/

		testResults.assert
		(	testingMethod,
			POST_METHOD_STRING,
			postMultiResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						PUT Request Test
		***************************************************/

		testingMethod						= 'PUTRequest';
		CWHttp.Request	putRequest 			= new CWHttp.Request( CWHttp.Method.PUT, ENDPOINT );
		CWObject		putResponse			= new CWObject( (String) putRequest.send( REQUEST_OBJECT, CWHttp.ContentType.URLENCODED ) );

		/***************************************************
						PUT Request Asserts
		***************************************************/

		testResults.assert
		(	testingMethod,
			PUT_METHOD_STRING,
			putResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						DEL Request Test
		***************************************************/

		testingMethod						= 'DELRequest';
		CWHttp.Request	delRequest 			= new CWHttp.Request( CWHttp.Method.DEL, ENDPOINT );
		CWObject		delResponse			= new CWObject( (String) delRequest.send() );

		/***************************************************
						DEL Request Asserts
		***************************************************/

		testResults.assert
		(	testingMethod,
			DEL_METHOD_STRING,
			delResponse.get( 'method' ),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString()
		);

		/***************************************************
						Rewrite Test
		***************************************************/

		testingMethod								= 'mapRequestUrl';
		PageReference	friendlyReference			= new PageReference( FRIENDLY_URL ); 
		PageReference	falseFriendlyReference		= new PageReference( FALSE_FRIENDLY_URL );
		PageReference	rewrittenURL				= CWHttp.rewriteURL( friendlyReference, PAGE_SET );
		PageReference	nullPageReference			= CWHttp.rewriteURL( falseFriendlyReference, PAGE_SET );

		/***************************************************
						Rewrite Asserts
		***************************************************/

		testResults.assert
		(	testingMethod,
			REWRITEN_URL,
			rewrittenURL.getUrl(),
			testingMethod + ' unexpected response.\n' + testResults.getErrorString() + '\n'
		+	'Expected: ' + REWRITEN_URL + '. Received: ' + rewrittenURL.getUrl()
		);

		testResults.assert
		(	testingMethod,
			null,
			nullPageReference,
			testingMethod + ' unexpected response.\n' + testResults.getErrorString() + '\n'
		+	'Expected: null. Received: ' + nullPageReference
		);

		testResults.report();
	}

	/*******************************************************
					Mock Response Method
	*******************************************************/

	public HTTPResponse respond( HTTPRequest req )
	{
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader( 'Content-Type', 'application/json' );

		String	method	= req.getMethod();
		res.setBody
		(
			method == POST_METHOD_STRING && req.getHeader( 'Accept' ) == 'application/xml'
		?	XML_REQUEST.toXmlString()
		:	'{"method":"' + method + '"}'
		);

		res.setStatusCode( 200 );
		return res;
	}
}