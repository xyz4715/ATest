/*******************************************************//**

@class    CWHttp

@brief    CW Core HTTP Class

	This class implements support for web callouts using HTTP.

@author		Glyn Anderson	(LiquidHub.GHA)
@author		Tim Smith		(LiquidHub.TRS)

@version	2014-08-01	LiquidHub.GHA
	Created.
@version	2014-08-10	LiquidHub.TRS
	Added support for Content-Type = 'multipart/form-data'
@version	2014-08-13	LiquidHub.TRS
	Added support for Content-Type = 'text/xml' for
	SOAP requests
@version	2014-10-15	LiquidHub.GHA
	Added 'urlEncode' and 'getEndpoint' methods.  Added headers
	and comments.
@version	2014-11-23	LiquidHub.TRS
	Added URL Rewrite method for use with force.com sites. 
	Assumes pattern: /page/param1/value1/param2/value2/...
@version	2016-01-21	LiquidHub.GHA
	

@see	CWHttpTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWHttp
{
	/*******************************************************
					HTTP Method enumeration
	*******************************************************/

	public enum Method
	{
		POST,
		GET,
		PUT,
		DEL,		//	can't use "DELETE" because it is a reserved word in Apex
		PATCH,		//	PATCH is used by the Salesforce REST API
		HEAD		//	for completeness
	}

	/*******************************************************
				map from Method to String
	*******************************************************/

	private static Map<Method,String> map_Method_String
	{
		get
		{
			if ( map_Method_String == null )
			{
				map_Method_String = new Map<Method,String>
				{  Method.POST		=>  'POST',
					Method.GET		=>  'GET',
					Method.PUT		=>  'PUT',
					Method.DEL		=>  'DELETE',
					Method.PATCH	=>  'PATCH',
					Method.HEAD		=>  'HEAD'
				};
			}
			return map_Method_String;
		}
		private set;
	}

	/*******************************************************
			map from String to Method - UNUSED
	*******************************************************/
/*
	private static Map<String,Method> map_String_Method
	{
		get
		{
			if ( map_String_Method == null )
			{
				map_String_Method = new Map<String,Method>();
				for ( Method key : map_Method_String.keySet() )
				{
					map_String_Method.put( map_Method_String.get( key ), key );
				}
			}
			return map_String_Method;
		}
		private set;
	}
//*/
	/*******************************************************
				HTTP Content Type enumeration
	*******************************************************/

	public enum ContentType
	{
		PARAMETERS,
		URLENCODED,
		MULTIPART,
		XML,
		JSON
	}

	private static final ContentType	defaultContentType		= ContentType.JSON;
	private static final String			contentTypeHeaderKey	= 'Content-Type';
	public  static final String			formDataBoundary		= '----CWFormBoundary';

	/*******************************************************
				map from ContentType to String
	*******************************************************/

	private static Map<ContentType,String> map_ContentType_String
	{
		get
		{
			if ( map_ContentType_String == null )
			{
				map_ContentType_String = new Map<ContentType,String>
				{  ContentType.PARAMETERS	=>	(String) null,
					ContentType.URLENCODED	=>	'application/x-www-form-urlencoded',
					ContentType.MULTIPART	=>	'multipart/form-data; boundary=' + formDataBoundary,
					ContentType.XML			=>	'text/xml; charset=UTF-8',
					ContentType.JSON		=>	'application/json'
				};
			}
			return map_ContentType_String;
		}
		private set;
	}

	/*******************************************************
			map from String to ContentType - UNUSED
	*******************************************************/
/*
	private static Map<String,ContentType> map_String_ContentType
	{
		get
		{
			if ( map_String_ContentType == null )
			{
				map_String_ContentType = new Map<String,ContentType>();
				for ( ContentType key : map_ContentType_String.keySet() )
				{
					map_String_ContentType.put( map_ContentType_String.get( key ), key );
				}
			}
			return map_String_ContentType;
		}
		private set;
	}
//*/

	/*******************************************************
					urlEncode method(s)
	*******************************************************/

	public static String urlEncode( String key, String value )
	{
		if ( String.isBlank( key ) || String.isBlank( value ) ) return (String) CWException.errorNull( 'CWRest.urlEncode: empty key or value.' );

		return EncodingUtil.urlEncode( key, 'UTF-8' ) + '=' + EncodingUtil.urlEncode( value, 'UTF-8' );
	}

	public static String urlEncode( Map<String,Object> parameters )
	{
		if ( parameters == null ) return (String) CWException.errorNull( 'CWRest.urlEncode: null parameters map.' );

		List<String> encodedParameters = new List<String>();

		for ( String key : parameters.keySet() )
		{
			if ( key == null ) continue;
			String value = String.valueOf( parameters.get( key ) );
			if ( value == null ) continue;

			encodedParameters.add( urlEncode( key, value ) );
		}
		return CWString.join( encodedParameters, '&' );
	}

	public static String urlEncode( CWObject parameters )
	{
		if ( parameters == null ) return (String) CWException.errorNull( 'CWRest.urlEncode: null parameters CWObject.' );

		return urlEncode( parameters.getMembers() );
	}

	/*******************************************************
					getEndpoint method
	*******************************************************/

	public static String getEndpoint( String serverUrl, Map<String,String> parameters )
	{
		if ( String.isBlank( serverUrl ) ) return (String) CWException.errorNull( 'CWRest.getEndpoint: null server URL.' );

		String  urlParameters  = parameters != null ? urlEncode( parameters ) : null;

		return String.isNotBlank( urlParameters ) ? serverUrl + '?' + urlParameters : serverUrl;
	}

	/*******************************************************
						Request class
	*******************************************************/

	public class Request
	{
		/***************************************************
						members
		***************************************************/

		private Method				requestMethod;
		private String				requestEndpoint;
		private Map<String,String>	requestHeaders;

		/***************************************************
						Request constructor(s)
		***************************************************/

		public Request( Method method, String endpoint, Map<String,String> headers )
		{
			requestMethod		= method;
			requestEndpoint		= endpoint;
			requestHeaders		= headers != null ? headers : new Map<String,String>();
		}

		public Request( Method method, String endpoint )
		{
			this( method, endpoint, (Map<String,String>) null );
		}

		/***************************************************
						HTTP request method(s)
		***************************************************/

		private HttpRequest createHttpRequest( ContentType contentType )
		{
			HttpRequest theRequest = new HttpRequest();
			theRequest.setMethod( map_Method_String.get( requestMethod ) );
			theRequest.setEndpoint( requestEndpoint );

			String contentTypeHeaderValue = map_ContentType_String.get( contentType );

			if ( String.isNotBlank( contentTypeHeaderValue ) )
			{
				requestHeaders.put( contentTypeHeaderKey, contentTypeHeaderValue );
			}
			else
			{
				requestHeaders.remove( contentTypeHeaderKey );
			}

			for ( String key : requestHeaders.keySet() )
			{
				theRequest.setHeader( key, requestHeaders.get( key ) );
			}

			return theRequest;
		}

		/***************************************************
						HTTP response method(s)
		***************************************************/

		private HttpResponse getHttpResponse( HttpRequest theRequest )
		{
			return (new Http()).send( theRequest );
		}

		/***************************************************
						send method(s)
		***************************************************/

		public String send( CWObject body, ContentType contentType )
		{
			if ( body != null && contentType == null ) contentType = defaultContentType;

			HttpRequest theRequest = createHttpRequest( contentType );

			if ( body != null )
			{
				if ( contentType == CWHttp.ContentType.PARAMETERS )
				{
					String parameters = requestEndpoint.substringAfter( '?' );    //  returns '' if there is no '?'

					parameters =
						String.isNotBlank( parameters )
					?  parameters + '&' + body.urlEncode()
					:  body.urlEncode();

					theRequest.setEndpoint( requestEndpoint.substringBefore( '?' ) + '?' + parameters );
				}

				if ( contentType == CWHttp.ContentType.URLENCODED )
				{
					theRequest.setBody( body.urlEncode() );
				}

				if ( contentType == CWHttp.ContentType.MULTIPART )
				{
					theRequest.setBodyAsBlob( body.toMultipartForm() );
				}

				if ( contentType == CWHttp.ContentType.JSON )
				{
					theRequest.setBody( body.jsonSerialize() );
				}
			}

			return getHttpResponse( theRequest ).getBody();
		}

		public String send( CWObject body )
		{
			return send( body, (ContentType) null );
		}

		public String send()
		{
			return send( (CWObject) null, (ContentType) null );
		}

		/***************************************************
					send method for XML
		***************************************************/

		public Dom.Document send( Dom.Document xmlDoc )
		{
			HttpRequest		theRequest		= createHttpRequest( ContentType.XML );
			theRequest.setBody( xmlDoc.toXMLString().replace( '\n', '' ) );
//*
System.debug( theRequest );
System.debug( theRequest.getBody() );
//*/
			HttpResponse  theResponse;
			try
			{
				theResponse		= getHttpResponse( theRequest );
			}
            catch (Exception theException1)
			{
				//fisrt thing is to try again
                System.debug('catch and retry ' + theException1);
				try
				{
					theResponse		= getHttpResponse( theRequest );
				}
                catch (Exception theException2)
				{
                    System.debug('catch and catch ' + theException2);
                    return createDomDocument(theException2.getMessage(), (HttpResponse)null);
				}
			}
//*
System.debug( theResponse );
System.debug( theResponse.getBody() );
//*/
			try
			{
				return theResponse.getBodyDocument();
			}
            catch ( Exception theException )
            {
                System.debug('catch ' + theException);
            }
			return createDomDocument((String)null, theResponse);
		}
	
		private Dom.Document createDomDocument( String exceptionMsg, HttpResponse theResponse)
		{
			Dom.Document	document		= new Dom.Document();
			Dom.XmlNode		httpResponse	= document.createRootElement( 'HttpResponse', (String) null, (String) null );
			String statusCodeString = theResponse == null ? 'There is no Response' : String.valueOf(theResponse.getStatusCode());
			String statusString = theResponse == null ? exceptionMsg : theResponse.getStatus();
			httpResponse.setAttribute( 'Status', statusCodeString );
			httpResponse.setAttribute( 'Msg', statusString );

			List<String> theHeaderKeys = theResponse == null ? new List<String>() : theResponse.getHeaderKeys();
			for ( String headerKey : theHeaderKeys )
			{
				Dom.XmlNode		httpHeader	= httpResponse.addChildElement( 'HttpHeader', (String) null, (String) null );
				httpHeader.setAttribute( 'Key', headerKey );
				httpHeader.setAttribute( 'Value', theResponse.getHeader( headerKey ) );
			}

			Dom.XmlNode		httpBody	= httpResponse.addChildElement( 'HttpBody', (String) null, (String) null );
			if ( theResponse != null ) httpBody.addTextNode( theResponse.getBody() );
			if ( exceptionMsg != null ) httpBody.addTextNode( exceptionMsg );
			return document;
		}
	}

	/***********************************************************
					URL Rewrite Methods
	***********************************************************/

	public static PageReference rewriteUrl( PageReference friendlyUrl, Set<String> pages )
	{
		List<String>  paramValues    = CWString.toLowerCase( CWString.removeStart( friendlyUrl.getUrl(), '/' ) ).split( '/' );

		if ( paramValues.size() > 2 && pages.contains( paramValues[0] ) )
		{
			String  page  = paramValues[0];
			paramValues.remove(0);

			Map<String,String>  paramValueMap  = new Map<String,String>();
			for ( Integer i = 0 ; i < paramValues.size() - 1; i = i + 2 )
			{
				paramValueMap.put( paramValues[i], paramValues[i+1] );
			}

			if ( !paramValueMap.values().isEmpty() )
			{
				return new PageReference( CWString.addPrefix( CWHttp.getEndpoint( page, paramValueMap ), '/' ) );
			}
		}

		return null;
	}
}