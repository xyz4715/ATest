/*******************************************************//**

@class		CWSoapTest

@brief		CWSoap Test Class

@author		Tim Smith (LiquidHub.TRS)

@version	2014-08-30	LiquidHub.TRS
	Created.

@see		CWSoap

@todo		Asserts

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
public class CWSoapTest implements HttpCalloutMock
{
	/*******************************************************
					Test Method
	*******************************************************/

	static testMethod void cwSoapUnitTest()
	{
		////	Begin Test
		CWTest testResults		= new CWTest( 'CWSoapTest' );
		String testingMethod;

		testResults.startTest();
		// Set mock callout class 
		Test.setMock( HttpCalloutMock.class, new CWSoapTest() );

		////	invoke method test
		TestSoap	soap			= new TestSoap();
		CWObject	responseObject	= soap.test();
		soap.testNullRequest();
		soap.testFailedParse();

		testResults.stopTest();
		testResults.report();
	}

	/*******************************************************
			   SOAP Constants and Objects for testing
	*******************************************************/

	public static final String	ENDPOINT		= 'http://test.soapservice.com/';
	public static final String	REQUEST_NAME	= 'Test';
	public static final String	ACTION			= 'http://soapservice.com/';
	public static final String	ACTION_NAME		= ACTION+REQUEST_NAME;
	public static final String	RESPONSE_NAME	= REQUEST_NAME+'Response';
	public static final String	RESPONSE_TYPE	= 'CWSoapTest.SoapResponseObjectForTest';

	public static final String 	RESPONSE_XML	=
		'<?xml version="1.0" encoding="UTF-8"?>'
	+	'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" '
	+		'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
	+		'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
	+		'<soap:Body>'
	+			'<TestResponse xmlns="http://soapservice.com/">'
	+				'<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">'
	+					'<xs:complexType>'
	+						'<xs:sequence>'
	+							'<xs:element name="stringVal" type="xs:string"/>'
	+							'<xs:element name="integerVal" type="xs:integer"/>'
	+							'<xs:element name="doubleVal" type="xs:decimal"/>'
	+							'<xs:element name="booleanVal" type="xs:boolean"/>'
	+							'<xs:element name="datetimeVal" type="xs:datetime"/>'
	+							'<xs:element name="dateVal" type="xs:date"/>'
	+							'<xs:element name="timeVal" type="xs:time"/>'
	+							'<xs:element name="obj">'
	+							'<xs:element name="stringVal" type="xs:string"/>'
	+							'<xs:element name="integerVal" type="xs:integer"/>'
	+							'</xs:element>'
	+						'</xs:sequence>'
	+					'</xs:complexType>'
	+				'</xs:schema>'
	+				'<stringVal>Test</stringVal>'
	+				'<integerVal>11</integerVal>'
	+				'<doubleVal>1.11</doubleVal>'
	+				'<booleanVal>true</booleanVal>'
	+				'<datetimeVal>2014-08-31T19:23:45.636Z</datetimeVal>'
	+				'<dateVal>2014-08-31</dateVal>'
	+				'<timeVal>13:23:45.636Z</timeVal>'
	+				'<obj>'
	+					'<StringVal>Test</StringVal>'
	+					'<IntegerVal>11</IntegerVal>'
	+				'</obj>'
	+				'<StatusFlag>Success</StatusFlag>'
	+				'<StatusMsg />'
	+			'</TestResponse>'
	+		'</soap:Body>'
	+	'</soap:Envelope>';

	public class SoapRequestObjectForTest extends CWObject
	{
		public String									val1					= 'Test';
		public String									val2					= 'Test2';
		public CWSoapTest.SoapRequestChildObjectForTest	obj1					= new CWSoapTest.SoapRequestChildObjectForTest();
		private String[] 								field_order_type_info	= new String[]{'val1','val2','obj1'};
	}

	public class SoapRequestChildObjectForTest extends CWObject
	{
		public String		val1					= 'Test';
		public String		val2					= 'Test2';
		private String[]	field_order_type_info 	= new String[]{'val1','val2'};
	}

	public class SoapResponseObjectForTest extends CWObject
	{
		public String										StringVal;
		public String										IntegerVal;
		public String										DoubleVal;
		public String										BooleanVal;
		public String										DatetimeVal;
		public String										DateVal;
		public String										TimeVal;
		public CWSoapTest.SoapResponseChildObjectForTest	Obj;
	}

	public class SoapResponseChildObjectForTest extends CWObject
	{
		public String	StringVal;
		public String	IntegerVal;
	}

	public class TestSoap
	{
		public CWObject test()
		{
			CWSoapTest.SoapRequestObjectForTest		request_x		= new SoapRequestObjectForTest();
			CWObject								response_x;
			Map<String, CWObject> 					response_map_x	= new Map<String,CWObject>();
			response_map_x.put( 'response_x', response_x );
			CWSoap.invoke
			(	this,
				request_x,
				response_map_x,
				new String[]
				{	ENDPOINT,
					ACTION_NAME,
					ACTION,
					REQUEST_NAME,
					ACTION,
					RESPONSE_NAME,
					RESPONSE_TYPE
				}
			);
			response_x = response_map_x.get( 'response_x' );
			return response_x;
		}

		public CWObject testNullRequest()
		{
			CWSoapTest.SoapRequestObjectForTest		request_x		= null;
			CWObject								response_x;
			Map<String, CWObject> 					response_map_x	= new Map<String,CWObject>();
			response_map_x.put( 'response_x', response_x );
			CWSoap.invoke
			(	this,
				request_x,
				response_map_x,
				new String[]
				{	ENDPOINT,
					ACTION_NAME,
					ACTION,
					REQUEST_NAME,
					ACTION,
					'',
					''
				}
			);
			response_x = response_map_x.get( 'response_x' );
			return response_x;
		}

		public CWObject testFailedParse()
		{
			CWSoapTest.SoapRequestObjectForTest		request_x		= new SoapRequestObjectForTest();
			CWObject								response_x;
			Map<String, CWObject> 					response_map_x	= new Map<String,CWObject>();
			response_map_x.put( 'response_x', response_x );
			CWSoap.invoke
			(	this,
				request_x,
				response_map_x,
				new String[]
				{	ENDPOINT,
					ACTION_NAME,
					ACTION,
					REQUEST_NAME,
					ACTION,
					'',
					''
				}
			);
			response_x = response_map_x.get( 'response_x' );
			return response_x;
		}
	}

	/*******************************************************
					Mock Response Method
	*******************************************************/

	public HTTPResponse respond( HTTPRequest req )
	{
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader( 'Content-Type', 'application/xml' );

		if ( req.getHeader( 'Soapaction' ) == ACTION_NAME )
		{
			res.setBody( RESPONSE_XML );
		}

		res.setStatusCode( 200 );
		return res;
	}
}