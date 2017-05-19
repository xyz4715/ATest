/*******************************************************//**

@class		CWRest

@brief		CW Core RESTful Interface Class

	This class implements support for using RESTful Interfaces,
	both as a client and a server.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-06-07	LiquidHub.GHA
	Created.
@version	2014-08-01	LiquidHub.GHA
	Added Client, Server, Request, Method, ContentType,
	and other inner classes.
@version	2014-08-10	LiquidHub.TRS
	Expanded on Client class to leverage CWHttp for get,
	post, put, and delete. Added SignedTokenAuthorization class.
@version	2014-10-15	LiquidHub.GHA
	Reworked class to enable a long-lived client, with routes
	and parameters passed into the get/post/put/del methods.
	Clients now incorporate Authorizations.  Took a stab at
	BearerAuthorization.
@version	2015-02-04	LiquidHub.GHA
	Added support for 'HEAD' method.

@todo	Better automate token/auth handling in Client
@todo	Impelment REST Server support

@see		CWRestTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWRest
{
	/*******************************************************
						Client class
	*******************************************************/

	public class Client
	{
		private	String				clientUrl;
		private	Map<String,String>	clientHeaders;
		private	Map<String,String>	clientParameters;

		/***************************************************
						Client constructors
		***************************************************/

		public Client( String baseUrl, Map<String,String> headers, Map<String,String> parameters, Authorization authorize )
		{
			clientUrl			= baseUrl;
			clientHeaders		= headers    != null ? headers.clone()    : new Map<String,String>();
			clientParameters	= parameters != null ? parameters.clone() : new Map<String,String>();

			if ( authorize != null ) clientHeaders.put( 'Authorization', authorize.getValue() );
		}

		public Client( String baseUrl, Map<String,String> headers, Map<String,String> parameters )
		{
			this( baseUrl, headers, parameters, (Authorization) null );
		}

		public Client( String baseUrl, Map<String,String> headers, Authorization authorize )
		{
			this( baseUrl, headers, (Map<String,String>) null, authorize );
		}

		public Client( String baseUrl, Map<String,String> headers )
		{
			this( baseUrl, headers, (Map<String,String>) null, (Authorization) null );
		}

		public Client( String baseUrl, Authorization authorize )
		{
			this( baseUrl, (Map<String,String>) null, (Map<String,String>) null, authorize );
		}

		public Client( String baseUrl )
		{
			this( baseUrl, (Map<String,String>) null, (Map<String,String>) null, (Authorization) null );
		}

		/***************************************************
						getEndpoint method
		***************************************************/

		private String getEndpoint( String route, Map<String,String> parameters )
		{
			Map<String,String>	allParameters	= clientParameters.clone();
			if ( parameters != null ) allParameters.putAll( parameters );

			String	serverUrl	= String.isNotBlank( route ) ? clientUrl + route : clientUrl;

			return CWHttp.getEndpoint( serverUrl, allParameters );
		}

		/***************************************************
						get method(s)
		***************************************************/

		public String get( String route, Map<String,String> parameters )
		{
			return (new CWHttp.Request( CWHttp.Method.GET, getEndpoint( route, parameters ), clientHeaders )).send();
		}

		public String get( String route )
		{
			return get( route, (Map<String,String>) null );
		}

		public String get( Map<String,String> parameters )
		{
			return get( (String) null, parameters );
		}

		public String get()
		{
			return get( (String) null, (Map<String,String>) null );
		}

		/***************************************************
						post method(s)
		***************************************************/

		public String post( String route, Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return (new CWHttp.Request( CWHttp.Method.POST, getEndpoint( route, parameters ), clientHeaders )).send( body, contentType );
		}

		public String post( String route, CWObject body, CWHttp.ContentType contentType )
		{
			return post( route, (Map<String,String>) null, body, contentType );
		}

		public String post( Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return post( (String) null, parameters, body, contentType );
		}

		public String post( CWObject body, CWHttp.ContentType contentType )
		{
			return post( (String) null, (Map<String,String>) null, body, contentType );
		}

		/***************************************************
						put method(s)
		***************************************************/

		public String put( String route, Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return (new CWHttp.Request( CWHttp.Method.PUT, getEndpoint( route, parameters ), clientHeaders )).send( body, contentType );
		}

		public String put( String route, CWObject body, CWHttp.ContentType contentType )
		{
			return put( route, (Map<String,String>) null, body, contentType );
		}

		public String put( Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return put( (String) null, parameters, body, contentType );
		}

		public String put( CWObject body, CWHttp.ContentType contentType )
		{
			return put( (String) null, (Map<String,String>) null, body, contentType );
		}

		/***************************************************
						del method(s)
		***************************************************/

		public String del( String route, Map<String,String> parameters )
		{
			return (new CWHttp.Request( CWHttp.Method.DEL, getEndpoint( route, parameters ), clientHeaders )).send();
		}

		public String del( String route )
		{
			return del( route, (Map<String,String>) null );
		}

		public String del( Map<String,String> parameters )
		{
			return del( (String) null, parameters );
		}

		public String del()
		{
			return del( (String) null, (Map<String,String>) null );
		}

		/***************************************************
						patch method(s)
		***************************************************/

		public String patch( String route, Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return (new CWHttp.Request( CWHttp.Method.PATCH, getEndpoint( route, parameters ), clientHeaders )).send( body, contentType );
		}

		public String patch( String route, CWObject body, CWHttp.ContentType contentType )
		{
			return patch( route, (Map<String,String>) null, body, contentType );
		}

		public String patch( Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return patch( (String) null, parameters, body, contentType );
		}

		public String patch( CWObject body, CWHttp.ContentType contentType )
		{
			return patch( (String) null, (Map<String,String>) null, body, contentType );
		}

		/***************************************************
						head method(s)
		***************************************************/

		public String head( String route, Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return (new CWHttp.Request( CWHttp.Method.HEAD, getEndpoint( route, parameters ), clientHeaders )).send( body, contentType );
		}

		public String head( String route, CWObject body, CWHttp.ContentType contentType )
		{
			return head( route, (Map<String,String>) null, body, contentType );
		}

		public String head( Map<String,String> parameters, CWObject body, CWHttp.ContentType contentType )
		{
			return head( (String) null, parameters, body, contentType );
		}

		public String head( CWObject body, CWHttp.ContentType contentType )
		{
			return head( (String) null, (Map<String,String>) null, body, contentType );
		}
	}

	/*******************************************************
					Authorization class

	This serves as an abstract base class for the various types
	of Authorization classes.
	*******************************************************/

	public abstract class Authorization
	{
		public abstract String getValue();
	}

	/*******************************************************
				BearerAuthorization class
	*******************************************************/

	public class BearerAuthorization extends Authorization
	{
		private String	token;

		public BearerAuthorization
		(	CWHttp.Method		method,
			String				serverUrl,
			String				username,
			String				password,
			String				clientId,
			String				clientSecret,
			CWHttp.ContentType	contentType,
			Map<String,String>	parameters
		)
		{
			CWObject	body	= new CWObject();
			body.put( 'grant_type',		'password' );
			body.put( 'username',		username );
			body.put( 'password',		password );
			body.put( 'client_id',		clientId );
			body.put( 'client_secret',	clientSecret );

			CWObject response = new CWObject( (new CWHttp.Request( method, CWHttp.getEndpoint( serverUrl, parameters ) )).send( body, contentType ) );
			token = (String) response.get( 'access_token' );
		}

		public BearerAuthorization
		(	CWHttp.Method		method,
			String				serverUrl,
			String				username,
			String				password,
			String				clientId,
			String				clientSecret,
			CWHttp.ContentType	contentType
		)
		{
			this( method, serverUrl, username, password, clientId, clientSecret, contentType, (Map<String,String>) null );
		}

		public override String getValue()
		{
			return String.isNotBlank( token ) ? 'Bearer ' + token : (String) null;
		}
	}

	/*******************************************************
				SignedTokenAuthorization class
	*******************************************************/

	public class SignedTokenAuthorization extends Authorization
	{
		private String token;

		public SignedTokenAuthorization
		(	Object					input,
			CWSecurity.Method		method,
			CWSecurity.Algorithm	algorithm,
			String					key,
			String					vector
		)
		{
			CWSecurity.Krypto krypto = new CWSecurity.Krypto( method, key, vector );
			token = EncodingUtil.urlEncode( EncodingUtil.base64Encode( krypto.encrypt( algorithm, input ) ), 'UTF-8' );
		}

		public SignedTokenAuthorization
		(	Object					input,
			CWSecurity.Method		method,
			CWSecurity.Algorithm	algorithm,
			String					key
		)
		{
			this( input, method, algorithm, key, (String) null );
		}

		public override String getValue()
		{
			return String.isNotBlank( token ) ? token : (String) null;
		}
	}



	/******************************************************/

	public class Server
	{
		
	}

	public virtual class Route
	{
		public virtual Object doGet()		{ return unsupportedMethod(); }
		public virtual Object doPost()		{ return unsupportedMethod(); }
		public virtual Object doPut()		{ return unsupportedMethod(); }
		public virtual Object doDelete()	{ return unsupportedMethod(); }
		public virtual Object doPatch()		{ return unsupportedMethod(); }
		public virtual Object doHead()		{ return unsupportedMethod(); }

		public Object dispatch( String method )
		{
			return
				method == 'GET'		?	doGet()
			:	method == 'POST'	?	doPost()
			:	method == 'PUT'		?	doPut()
			:	method == 'DELETE'	?	doDelete()
			:	method == 'PATCH'	?	doPatch()
			:	method == 'HEAD'	?	doHead()
			:							unsupportedMethod();
		}

		public virtual Object unsupportedMethod()
		{
			//	do some actual error handling here
			return null;
		}
	}

	public virtual class Version
	{
		private Map<String,Route> map_Routes;

		public Version( Map<String,Route> routes )
		{
			map_Routes = routes;
		}

		public Object dispatch( String routeName )
		{
			Route	theRoute	= map_Routes.get( routeName );

			return theRoute != null ? theRoute.dispatch( RestContext.request.httpMethod ) : unsupportedRoute();
		}

		public virtual Object unsupportedRoute()
		{
			//	do some actual error handling here
			return null;
		}
	}

	private String				theUrlMapping;
	private Map<String,Version>	map_Versions;

	public CWRest( String urlMapping, Map<String,Version> versions )
	{
		theUrlMapping	= urlMapping;
		map_Versions	= versions;
	}

	public Object dispatch()
	{
		String	fullRoute	= RestContext.request.requestURI.substringAfter( theUrlMapping ).removeEnd( '/' );
		String	versionName	= fullRoute.substringBefore( '/' );
		String	routeName	= fullRoute.substringAfter( '/' );

		Version	theVersion	= map_Versions.get( versionName );

		return theVersion != null ? theVersion.dispatch( routeName ) : unsupportedVersion();
	}

	public virtual Object unsupportedVersion()
	{
		//	do some actual error handling here
		return null;
	}

	/******************************************************/

	private static CWRest myRestService = new CWRest
	(	'myRestService',
		new Map<String,CWRest.Version>
		{
		/************************/
		/*		Version 1		*/
		/************************/
			'v1'
		=>	new CWRest.Version
			(	new Map<String,CWRest.Route>
				{	'firstRoute'		=>	new FirstV1Route(),
					'secondRoute'		=>	new SecondV1Route(),
					//	and so on...
					'lastRoute'			=>	new LastV1Route()
				}
			),

		/************************/
		/*		Version 2		*/
		/************************/
			'v2'
		=>	new CWRest.Version
			(	new Map<String,CWRest.Route>
				{	'firstRoute'		=>	new FirstV2Route(),
					'secondRoute'		=>	new SecondV2Route(),
					//	and so on...
					'lastRoute'			=>	new LastV2Route()
				}
			)
		}
	);

	public class FirstV1Route extends CWRest.Route
	{
		public override Object doGet() { return 'Hi!'; }
	}
	public class SecondV1Route extends CWRest.Route {}
	public class LastV1Route extends CWRest.Route {}
	public class FirstV2Route extends CWRest.Route {}
	public class SecondV2Route extends CWRest.Route {}
	public class LastV2Route extends CWRest.Route {}

	public static Object httpGet()
	{
		return myRestService.dispatch();
	}

	public static Object httpPost()
	{
		return myRestService.dispatch();
	}

	public static Object httpPut()
	{
		return myRestService.dispatch();
	}

	public static Object httpDelete()
	{
		return myRestService.dispatch();
	}
}