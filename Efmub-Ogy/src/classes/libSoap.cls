/*******************************************************//**

@class		CWSoap

@brief		CW Core SOAP API Class

	This class implements support for SOAP based integrations.

@author		Tim Smith		(LiquidHub.TRS)
@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-08-13	LiquidHub.TRS
	Created.
@version	2014-08-20	LiquidHub.GHA
	Implemented parsing of SOAP response into a CWObject.
@version	2016-01-16	LiquidHub.GHA
	Added 'signXML' functionality in the 'createSoapDocument' method.
	Modified 'invoke' to get the certificate name from the 'stub' object.
@version	2016-01-19	LiquidHub.GHA
	Modified 'createSoapDocument' to support WS-Security.
@version	2016-01-21	LiquidHub.GHA
	First successful request/response from SOAP service with WS-Security.
@version	2016-01-25	LiquidHub.GHA
	Modified 'createNodes' to accomodate arrays of elements/primitives.
@version	2016-05-13	LiquidHub.GHA
	Fixed bug parsing response elements whose names were transformed
	with "_x", for example "return" became "return_x".

@todo		fix parsing of Dates, DateTimes.

@see		CWSoapTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWSoap
{
	/*******************************************************
						constants
	*******************************************************/

	private static final String responseField		= '%response%';

	/*******************************************************
						Client class
	*******************************************************/

	public class Client
	{
		private String				requestEndpoint;
		private Map<String,String>	requestHeaders;
		private Boolean				addNamespacesToRequest = true;

		/***************************************************
						Client constructors
		***************************************************/

		public Client( String endpoint, Map<String,String> headerMap )
		{
			requestEndpoint		= endpoint;
			requestHeaders		= new Map<String,String>();
			if ( headerMap != null ) requestHeaders.putAll( headerMap );
			requestHeaders.put( 'Accept', 'text/xml' );			//  Only accept XML as this is SOAP. Override any inadvertent accept header.
		}

		public Client( String endpoint, Boolean addNamespaces )
		{
			this( endpoint, (Map<String,String>) null );
			addNamespacesToRequest = addNamespaces;
		}

		public Client( String endpoint )
		{
			this( endpoint, (Map<String,String>) null );
			addNamespacesToRequest = true;
		}

		/***************************************************
						callout method

		Takes the request, generates the xmlDoc, and hands it
		all off to CWHttp to POST to the SOAP service.
		***************************************************/

		public CWObject callout( String soapAction, String requestNamespace, String requestName, CWObject request, String responseName, String responseType )
		{
			return callout( soapAction, requestNamespace, requestName, request, responseName, responseType, (String) null );
		}

		public CWObject callout( String soapAction, String requestNamespace, String requestName, CWObject request, String responseName, String responseType, String certificateName )
		{
			if	(	String.isBlank( soapAction )
				||	String.isBlank( requestNamespace )
				||	String.isBlank( requestName )
				||	request == null
				||	String.isBlank( responseName )
				||	String.isBlank( responseType )
				) return null;

			requestHeaders.put( 'SOAPAction', soapAction );

			CWHttp.Request	cwhttpRequest		= new CWHttp.Request( CWHttp.Method.POST, requestEndpoint, requestHeaders );
			Dom.Document	requestDocument		= createSoapDocument( requestName, requestNamespace, request, certificateName );
			Dom.Document	xmlResponse			= cwhttpRequest.send( requestDocument );
			CWObject		response			= parseResponse( xmlResponse, responseName, responseType );

			return  response;
		}

		/***************************************************
					createSoapDocument method

		Takes a CWObject input, traverses it and generates a
		SOAP compliant XML packet to send in the request.
		***************************************************/

		private Dom.Document createSoapDocument( String requestName, String requestNamespace, CWObject request, String certificateName )
		{
			String			username		= 'w24242753';
			String			password		= 'BBOMR33GXV';

			Boolean			useAirFranceSecurity	= String.isBlank( certificateName ) && String.isNotBlank( username ) && String.isNotBlank( password );

			String          ns0Prefix       = useAirFranceSecurity ? 'xsd' : 'ns0';
			String          soapPrefix      = 'soapenv',    soapNameSpace   = 'http://schemas.xmlsoap.org/soap/envelope/';
			String          dsPrefix        = 'ds',         dsNameSpace     = 'http://www.w3.org/2000/09/xmldsig#';
			String          wssePrefix      = 'wsse',       wsseNameSpace   = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
			String          wsuPrefix       = 'wsu',        wsuNameSpace    = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';

			Dom.Document    document        = new Dom.Document();
			Dom.XmlNode     envelope        = document.createRootElement( 'Envelope', soapNameSpace, soapPrefix );
			envelope.setNamespace( ns0Prefix, requestNamespace );

			Map<String,String>  namespaces  = new Map<String,String>();
			namespaces.put( requestNamespace, ns0Prefix );

			if ( useAirFranceSecurity )
			{
				Dom.XmlNode		headerNode			= envelope.addChildElement( 'Header', soapNameSpace, (String) null );
				Dom.XmlNode		securityNode		= headerNode.addChildElement( 'Security', wsseNameSpace, wssePrefix );
				securityNode.setNamespace( wsuPrefix, wsuNameSpace ); // EMW
//				securityNode.setAttributeNs( 'mustUnderstand', '0', soapNameSpace, (String) null );
				Dom.XmlNode		tokenNode			= securityNode.addChildElement( 'UsernameToken', wsseNameSpace, wssePrefix );
				tokenNode.setAttributeNs( 'Id', 'UsernameToken-256CE15C92CEB561DC14563304948416', wsuNameSpace, (String) null );
				Dom.XmlNode		usernameNode		= tokenNode.addChildElement( 'Username', wsseNameSpace, wssePrefix );
				Dom.XmlNode		usernameTextNode	= usernameNode.addTextNode( username );
				Dom.XmlNode		passwordNode		= tokenNode.addChildElement( 'Password', wsseNameSpace, wssePrefix );
				passwordNode.setAttribute( 'Type', 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText' );
				Dom.XmlNode		passwordTextNode	= passwordNode.addTextNode( password );
//				Dom.XmlNode		nonceNode			= tokenNode.addChildElement( 'Nonce', wsseNameSpace, wssePrefix );
//				nonceNode.setAttribute( 'EncodingType', '...#Base64Binary' );
//				nonceNode.setAttribute( 'ValueType', '...#X509SubjectKeyIdentifier' );
//				Dom.XmlNode		nonceTextNode		= nonceNode.addTextNode( '' );
//				Dom.XmlNode		createdNode			= tokenNode.addChildElement ( 'Created', wsuNameSpace, wsuPrefix );
//				Dom.XmlNode		createdTextNode		= createdNode.addTextNode( DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') );
			}

			Dom.XmlNode		bodyNode		= envelope.addChildElement( 'Body', soapNameSpace, (String) null );
			if ( useAirFranceSecurity )
			{
				bodyNode.setNamespace( wsuPrefix, wsuNameSpace ); // EMW
				bodyNode.setAttributeNs( 'Id', 'id-165DDBE1C090AB1645145617227576112', wsuNameSpace, (String) null );
			}
			{
				Dom.XmlNode		requestNode		= bodyNode.addChildElement( requestName, requestNamespace, (String) null );

				createNodes( (Dom.XmlNode) null, request.getMembers(), namespaces );

				for ( String namespace : namespaces.keySet() )
				{
					String	prefix	= namespaces.get( namespace );
					if ( prefix == ns0Prefix ) continue;
					envelope.setNamespace( prefix, namespace );
				}

				createNodes( requestNode, request.getMembers(), namespaces );
			}

			if ( String.isNotBlank( certificateName ) )
			{

/*				//  these are only used with the BinarySecurityToken element
				String			wsuPrefix		= 'wsu',		wsuNameSpace	= 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
				String			encodingType	= 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';
				String			valueType		= 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3';
//*/
				if ( !Test.isRunningTest() ) Crypto.signXML( 'RSA-SHA1', bodyNode, (String) null, certificateName );
				if ( Test.isRunningTest() ) bodyNode.addChildElement( 'Signature', dsNameSpace, dsPrefix );

				Dom.XmlNode		originalBody		= envelope.getChildElement( 'Body', soapNameSpace );
				envelope.removeChild( originalBody );
				Dom.XmlNode		header				= envelope.addChildElement( 'Header', soapNameSpace, (String) null );

				Dom.XmlNode		orginalSignature	= bodyNode.getChildElement( 'Signature', dsNameSpace );
				bodyNode.removeChild( orginalSignature );

				Dom.XmlNode		clonedBody			= envelope.addChildElement( 'Body', soapNameSpace, (String) null );
				TG_XmlUtils.copyAttributes( originalBody, clonedBody );
				TG_XmlUtils.copyKids( originalBody, clonedBody );

				Dom.XmlNode		security			= header.addChildElement( 'Security', wsseNameSpace, wssePrefix );

				Dom.XmlNode		clonedSignature		= security.addChildElement( orginalSignature.getName(), dsNameSpace, dsPrefix );
				TG_XmlUtils.copyAttributes( orginalSignature, clonedSignature );
				TG_XmlUtils.copyKids( orginalSignature, clonedSignature );
			}

			return document;
		}

		/***************************************************
						createNodes method

		Populates an XML node with child nodes based on the
		contents of a map.  Recurses if necessary.
		***************************************************/

		private void createNodes( Dom.XmlNode node, Map<String,Object> request, Map<String,String> namespaces )
		{
			for ( Object elementName : (List<Object>) request.get( 'field_order_type_info' ) )
			{
				List<Object>	elementTypeInfo		= (List<Object>) request.get( String.valueOf( elementName ) + '_type_info' );

				String	elementTag		= (String) elementTypeInfo[ TypeInfoIndex.ELEMENT_NAME.ordinal() ];
				Object	elementValue	= request.get( elementTag );
				if ( elementValue == null ) continue;

				String	namespace		= (String) elementTypeInfo[ TypeInfoIndex.ELEMENT_NAMESPACE.ordinal() ];
				if ( !namespaces.containsKey( namespace ) )
				{
					namespaces.put( namespace, 'ns' + String.valueOf( namespaces.size() ) );
				}

				List<Object>	elementValueArray	= elementValue instanceof List<Object> ? (List<Object>) elementValue : new List<Object>{ elementValue };

				for ( Object arrayElementObject : (List<Object>) elementValueArray )
				{
					Dom.XmlNode		childElement	= node != null ? node.addChildElement( elementTag, addNamespacesToRequest ? namespace : null, (String) null ) : null;

					if ( arrayElementObject instanceof Map<String,Object> )
					{
						createNodes( childElement, (Map<String,Object>) arrayElementObject, namespaces );
						continue;
					}

					if ( node != null ) childElement.addTextNode( String.valueOf( arrayElementObject ) );
				}
			}

			if ( node == null ) return;

			for ( String fieldKey : request.keySet() )
			{
				if ( !fieldKey.endsWith( '_att_info' ) ) continue;

				String	attributeKey	= (String) ((List<Object>) request.get( fieldKey ))[0];
				Object	attributeValue	= request.get( attributeKey );
				if ( attributeValue != null ) node.setAttribute( attributeKey, String.valueOf( attributeValue ) );
			}
		}

		/***************************************************
						parseResponse method

		This method converts a SOAP response (as a Dom.Document)
		into a CWObject structure of the given type.

		Arguments:
			Dom.Document response       the SOAP response
			String responseName         name of the response element
			String responseType         CWObject-derived type name
		***************************************************/

		private CWObject parseResponse( Dom.Document response, String responseName, String responseTypeName )
		{
			if ( response == null ) return null;

			CWObject	responseObject;

			Dom.XmlNode	envelope, body, content;

			envelope	= response.getRootElement();
			if ( envelope.getName() == 'Envelope' )
			{
				for ( Dom.XmlNode envelopeChild : envelope.getChildren() )
				{
					if ( envelopeChild.getName() != 'Body' ) continue;

					body	= envelopeChild;
					break;
				}

				if ( body != null )
				{
					for ( Dom.XmlNode bodyChild : body.getChildren() )
					{
						if ( bodyChild.getName() != responseName ) continue;

						content = bodyChild;
						break;
					}
				}
			}

			Type responseType	= Type.forName( responseTypeName );
			if ( responseType == null ) return null;

			if ( content == null )
			{
				responseObject	= (CWObject) Type.forName( responseTypeName ).newInstance();
				responseObject.put( responseField, response.toXMLString() );
				return responseObject;
			}

			Map<String,Object>	paresedResponse		= parseElement( content, responseTypeName );
			String serializedJsonText = JSON.serialize( paresedResponse );
			serializedJsonText = serializedJsonText.replace( '"false"', 'false' );
			serializedJsonText = serializedJsonText.replace( '"true"', 'true' );

			CWObject deserializedObject = (CWObject) JSON.deserialize( serializedJsonText, Type.forName( responseTypeName ) );
			
			return deserializedObject;

/*
			Map<String,Object> schema;
			for ( Dom.XmlNode fieldElement : content.getChildElements() )
			{
				if ( schema == null && fieldElement.getName() == 'schema' )
				{
					schema = (Map<String,Object>) parseSchema( fieldElement );
					continue;
				}

				List<String>    fieldelementTypeInfo    = (List<String>) responseObject.get(  );
				responseObject.put( fieldElement.getName(), parseElement( fieldElement, schema ) );
			}

			return (CWObject) JSON.deserialize( String.valueOf( responseObject ), responseType );
//*/
		}

		/***************************************************
						parseElement method

		This method parses an XML element and returns the result
		as an Object (if it's a leaf node) or a CWObject (if it
		has child elements).
		***************************************************/
/*
		private Object parseElement( Dom.XmlNode fieldElement )
		{
			return parseElement( fieldElement, (Map<String,Object>) null );
		}
//*/

		private Map<String,Object> parseElement( Dom.XmlNode element, String typeName )
		{
			Map<String,Object>			elementObject		= CWObject.newCWObject( Type.forName( typeName ).newInstance() ).getMembers();
			Map<String,String>			elementNameMap		= new Map<String,String>();
			Map<String,List<Object>>	elementTypeInfoMap	= new Map<String,List<Object>>();

			for ( Object elementName : (List<Object>) elementObject.get( 'field_order_type_info' ) )
			{
				List<Object>	elementTypeInfo		= (List<Object>) elementObject.get( String.valueOf( elementName ) + '_type_info' );
				String			elementTag			= ((String) elementTypeInfo[ TypeInfoIndex.ELEMENT_NAME.ordinal() ]).removeEnd( '_x' );
				elementNameMap.put( elementTag, String.valueOf( elementName ) );
				elementTypeInfoMap.put( elementTag, elementTypeInfo );
			}

			Integer		attributeCount	= element.getAttributeCount();
			for ( Integer attributeIndex = 0; attributeIndex < attributeCount; attributeIndex++ )
			{
				String	attributeKey	= element.getAttributeKeyAt( attributeIndex );

				if ( !elementObject.containsKey( attributeKey + '_att_info' ) ) continue;

				String	attributeKeyNs	= element.getAttributeKeyNsAt( attributeIndex );
				String	attributeValue	= element.getAttributeValue( attributeKey, attributeKeyNs );

				elementObject.put( attributeKey, attributeValue );
			}

			String			typeClass		= typeName.substringBefore( '.' );
			String			previousTag		= null;
			List<Object>	childArray		= null;

			for ( Dom.XmlNode elementChild : element.getChildElements() )
			{
				String			childTag			= elementChild.getName();
				String			childName			= elementNameMap.get( childTag );
				List<Object>	childTypeInfo		= elementTypeInfoMap.get( childTag );
				if ( childTypeInfo == null ) continue;
				String			childBaseTypeName	= (String) childTypeInfo[ TypeInfoIndex.ELEMENT_TYPE.ordinal() ];
				Type			childBaseType		= Type.forName( childBaseTypeName );
				Boolean			childIsPrimitive	= childBaseType != null && CWType.isPrimitive( childBaseType );
				String			childTypeName		= childBaseType != null ? childBaseTypeName : typeClass + '.' + childBaseTypeName;

				if ( childTag == previousTag && childArray != null )
				{
					childArray.add( childIsPrimitive ? (Object) elementChild.getText() : (Object) parseElement( elementChild, childTypeName ) );
					continue;
				}
				previousTag		= childTag;
				childArray		= null;

				if ( ((String) childTypeInfo[ TypeInfoIndex.MAX_OCCURENCES.ordinal() ]) != '1' )
				{
					childArray	= childIsPrimitive ? (List<Object>) new List<String>() : (List<Object>) new List<Map<String,Object>>();
					elementObject.put( childName, childArray );
					childArray.add( childIsPrimitive ? (Object) elementChild.getText() : (Object) parseElement( elementChild, childTypeName ) );
					continue;
				}

				elementObject.put( childName, childIsPrimitive ? (Object) elementChild.getText() : (Object) parseElement( elementChild, childTypeName ) );
			}

			return elementObject;
		}
	}

	/******************************************************
						invoke method

	This replaces the method WebServiceCallout.invoke in the
	SOAP code generated from a WSDL.
	******************************************************/

	private enum InfoArrayIndex
	{   ENDPOINT_URL,
		SOAP_ACTION,
		REQUEST_NAMESPACE,
		REQUEST_NAME,
		RESPONSE_NAMESPACE,
		RESPONSE_NAME,
		RESPONSE_TYPE,
		NUM_PARAMETERS
	}

	private enum TypeInfoIndex
	{
		ELEMENT_NAME,
		ELEMENT_NAMESPACE,
		UNKNOWN_1,
		MIN_OCCURENCES,
		MAX_OCCURENCES,
		UNKNOWN_2,
		ELEMENT_TYPE
	}

	public static void invoke( Object stub, Object request, Map<String,Object> responseMap, String[] infoArray )
	{
		invoke( stub, request, responseMap, infoArray, true );
	}

	public static void invoke( Object stub, Object request, Map<String,Object> responseMap, String[] infoArray, boolean addNamespaces )
	{
		if  (	stub == null
			||	request == null
			||	responseMap == null
			||	infoArray == null
			||	infoArray.size() != InfoArrayIndex.NUM_PARAMETERS.ordinal()
			) return;

		CWSoap.Client soapClient = new CWSoap.Client( infoArray[ InfoArrayIndex.ENDPOINT_URL.ordinal() ], addNamespaces );

		CWObject response =
			soapClient.callout
			(	infoArray[ InfoArrayIndex.SOAP_ACTION.ordinal() ],
				infoArray[ InfoArrayIndex.REQUEST_NAMESPACE.ordinal() ],
				infoArray[ InfoArrayIndex.REQUEST_NAME.ordinal() ],
				new CWObject( JSON.serialize( request ) ),
				infoArray[ InfoArrayIndex.RESPONSE_NAME.ordinal() ],
				infoArray[ InfoArrayIndex.RESPONSE_TYPE.ordinal() ],
				(String) (new CWObject( JSON.serialize( stub ) )).get( 'clientCertName_x' )
			);

		String responseKey = 'response_x';
		for ( String key : responseMap.keySet() )
		{
			responseKey = key;
			break;
		}

		responseMap.put( responseKey, response );
	}

	/*******************************************************
				isSuccessfulResponse method

	Returns true if the given CWObject response is a
	successful response.
	*******************************************************/

	public static Boolean isSuccessfulResponse( CWObject response )
	{
		return response != null && !response.getMembers().containsKey( responseField );
	}

	/*******************************************************
					getResponse method

	Returns the Dom.Document response if the given CWObject is
	an unsuccessful response.
	*******************************************************/

	public static Dom.Document getResponse( CWObject response )
	{
		if ( response == null || !response.getMembers().containsKey( responseField ) ) return null;

		Dom.Document	responseDocument	= new Dom.Document();
		responseDocument.load( (String) response.get( responseField ) );
		return responseDocument;
	}
}