/*******************************************************//**

@class		CWObject

@brief		CW Core Object Class

	This class implements a generic object, a la JavaScript,
	with dynamic members (fields).  CWObject instances are
	nestable.

@author		Glyn Anderson	(LiquidHub.GHA)
@author		Tim Smith		(LiquidHub.TRS)

@version	2014-06-07	LiquidHub.GHA
	Created.
@version	2014-08-09	LiquidHub.TRS
	Added toMultipartBody() method and helper encoding method.
@version	2014-08-12	LiquidHub.GHA
	Optimizations to 'base64EncodeFormBody()'.
@version	2014-09-04	LiquidHub.GHA
	Rewrote 'get' to return all Map<String,Object> values as CWObject,
	and all List<Map<String,Object>> values as List<CWObject>.
@version	2014-09-05	LiquidHub.GHA
	Added 'isValid' method.
@version	2014-09-30	LiquidHub.GHA
	Modified get() to return a list of one element when a list is
	expected but a single element is found.  Added optional type
	parameter so that get() will return the expected type for a
	field whose type is not pre-declared.  Modified put() and putAll()
	to return 'this' when successful and 'null' when not.  Added a
	version of allows() that takes a set of field names.  Added
	convert() methods.  Added newCWObject() factory method.  Added
	putAll( CWObject ) method.
@version	2014-10-15	LiquidHub.GHA
	Fixed mystery bug wherein 'instanceof' could not recognize a
	List<Map<String,Object>>.  Modified 'urlEncode' to use new
	method, 'CWHttp.urlEncode'.
@version	2015-12-29	LiquidHub.GHA
	Now implements the CWAccessible interface.

@see		CWObjectTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public virtual class CWObject implements CWAccessible
{
	/*******************************************************
					Field class
	*******************************************************/

	public virtual class Field
	{
		/***************************************************
						Field members
		***************************************************/

		private Type		fieldType;
		private Boolean		flag_Required;

		/***************************************************
						Field constructors
		***************************************************/

		private Field( Type theType, Boolean requiredFlag )
		{
			fieldType		= theType != null ? theType : Object.class;
			flag_Required	= requiredFlag == true;		//	null,false => false;
		}

		public Field( Type theType )
		{
			this( theType, false );
		}

		public Field()
		{
			this( Object.class );
		}

		/***************************************************
					Field member access methods
		***************************************************/

		private Type getType()
		{
			return fieldType;
		}

		private String getTypeName()
		{
			return fieldType.toString();
		}

		private Boolean isRequired()
		{
			return flag_Required;
		}
	}

	/*******************************************************
					RequiredField class
	*******************************************************/

	public class RequiredField extends Field
	{
		public RequiredField( Type theType )
		{
			super( theType, true );
		}

		public RequiredField()
		{
			super( Object.class, true );
		}
	}

	/*******************************************************
					Fields class
	*******************************************************/

	public virtual class Fields
	{
		private Map<String,Field>	map_Fields;
		private Boolean				flag_Extensible;

		public  Map<String,Field> getFields()
		{
			return map_Fields;
		}

		private Fields( Map<String,Field> fieldMap, Boolean extensible )
		{
			map_Fields		= fieldMap;
			flag_Extensible	= extensible;
		}

		public Fields( Map<String,Field> fieldMap )
		{
			this( fieldMap, false );
		}

		public Fields()
		{
			this( new Map<String,Field>(), true );
		}

		public Boolean allows( String fieldName )
		{
			return
				String.isNotBlank( fieldName )
			&&	(	map_Fields == null
				||	flag_Extensible
				||	map_Fields.containsKey( fieldName )
				);
		}

		public Boolean put( String fieldName, Field theField )
		{
			if ( theField == null || !allows( fieldName ) ) return false;

			map_Fields.put( fieldName, theField );
			return true;
		}

		public Boolean put( String fieldName, Type theType )
		{
			if ( theType == null ) return false;

			return put( fieldName, new Field( theType ) );
		}

		public Field get( String fieldName )
		{
			return String.isNotBlank( fieldName ) && map_Fields != null ? map_Fields.get( fieldName ) : null;
		}

		public Boolean remove( String fieldName )
		{
			if	(	String.isBlank( fieldName )
				||	map_Fields == null
				||	!flag_Extensible
				||	!map_Fields.containsKey( fieldName )
				) return false;

			map_Fields.remove( fieldName );
			return true;
		}
	}

	/*******************************************************
					ExtensibleFields class
	*******************************************************/

	public class ExtensibleFields extends Fields
	{
		public ExtensibleFields( Map<String,Field> fieldMap )
		{
			super( fieldMap, true );
		}

		public ExtensibleFields()
		{
			super( new Map<String,Field>(), true );
		}
	}

	/*******************************************************
					CWObject members
	*******************************************************/

	private Map<String,Object>	map_Members;

	/*******************************************************
					access methods
	*******************************************************/

	public Map<String,Object> getMembers()
	{
		return map_Members;
	}

	/*******************************************************
				CWObject constructor(s)
	*******************************************************/

	public CWObject()
	{
		map_Members = new Map<String,Object>();
	}

	public CWObject( Map<String,Object> members )
	{
		map_Members = new Map<String,Object>( members );
	}

	public CWObject( CWObject other )
	{
		this( other.map_Members );
	}

	public CWObject( String jsonInput )
	{
		map_Members = (Map<String,Object>) JSON.deserializeUntyped( jsonInput );
	}

	/*******************************************************
				CWObject factory method(s)
	*******************************************************/

	public static CWObject newCWObject( Object theObject )
	{
		return !CWType.isPrimitive( theObject ) ? new CWObject( JSON.serialize( theObject ) ) : (CWObject) null;
	}

	/*******************************************************
					getFields method
	*******************************************************/

	public virtual Fields getFields()
	{
		return null;
	}

	/*******************************************************
					getFieldType methods
	*******************************************************/

	private Type getFieldType( String fieldName, Type fallback )
	{
		Fields theFields = getFields();

		if ( theFields != null && !theFields.allows( fieldName ) ) return null;

		Field theField = theFields != null ? theFields.get( fieldName ) : null;

		return theField != null ? theField.getType() : fallback;
	}

	//	This implements the CWAccessible interface
	public Type getFieldType( String fieldName )
	{
		return getFieldType( fieldName, Object.class );
	}

	/*******************************************************
					allows method
	*******************************************************/

	public Boolean allows( String fieldName )
	{
		Fields	theFields = getFields();

		return theFields == null || theFields.allows( fieldName );
	}

	public Boolean allows( Set<String> fieldNames )
	{
		Fields	theFields = getFields();

		if ( theFields == null ) return true;

		for ( String fieldName : fieldNames ) if ( !theFields.allows( fieldName ) ) return false;

		return true;
	}

	/*******************************************************
					isValid method
	*******************************************************/

	public Boolean isValid()
	{
		Fields	theFields = getFields();
		if ( theFields == null ) return true;

		Map<String,Field> map_Fields = theFields.getFields();

		for ( String fieldName : map_Fields.keySet() )
		{
			if	(	map_Fields.get( fieldName ).isRequired()
				&&	(	!map_Members.containsKey( fieldName )
					||	map_Members.get( fieldName ) == null
					)
				) return false;
		}

		return true;
	}

	/*******************************************************
					put method
	*******************************************************/

	public CWObject put( String fieldName, Object value )
	{
		if ( !allows( fieldName ) ) return (CWObject) null;

		Object	fieldObject;

		if ( value instanceof List<CWObject> )
		{
			List<Map<String,Object>> list_MemberMaps = new List<Map<String,Object>>();
			for ( CWObject element : (List<CWObject>) value )
			{
				list_MemberMaps.add( element.map_Members );
			}
			fieldObject = (Object) list_MemberMaps;
		}
		else if ( value instanceof CWObject )
		{
			fieldObject = (Object) ((CWObject) value).map_Members;
		}
		else
		{
			fieldObject = value;
		}

		map_Members.put( fieldName, fieldObject );
		return this;
	}

	/*******************************************************
					putAll method
	*******************************************************/

	public CWObject putAll( Map<String,Object> values )
	{
		if ( values == null || !allows( values.keySet() ) ) return (CWObject) null;

		map_Members.putAll( values );
		return this;
	}

	public CWObject putAll( CWObject theObject )
	{
		return theObject == null ? putAll( theObject.map_Members ) : (CWObject) null;
	}

	/*******************************************************
					get method
	*******************************************************/

	//	This implements the CWAccessible interface
	public Object get( String fieldName )
	{
		return get( fieldName, (Type) null );
	}

	public Object get( String fieldName, Type defaultType )
	{
		if ( !allows( fieldName ) ) return null;

		Object value = map_Members.get( fieldName );

		if ( value == null ) return null;

		if ( defaultType == null ) defaultType = CWObject.class;

		Type	desiredType	= getFieldType( fieldName, defaultType );
		Type	elementType	= desiredType;
		Type	listType	= desiredType;

		if ( desiredType.getName().left(5) == 'List<' )
		{
			elementType = Type.forName( listType.getName().substringAfter( '<' ).substringBeforeLast( '>' ) );
		}
		else
		{
			listType = Type.forName( 'List<' + elementType.getName() + '>' );
		}

		Boolean	isAListOfMaps = false;

		if ( value instanceof List<Object> )
		{
			for ( Object obj : (List<Object>) value )
			{
				isAListOfMaps = ( obj instanceof Map<String,Object> );
				break;
			}
		}

		if ( isAListOfMaps )
		{
			List<CWObject>	fieldList	= (List<CWObject>) listType.newInstance();
			for ( Object obj : (List<Object>) value )
			{
				Map<String,Object> memberMap = (Map<String,Object>) obj;
				CWObject element = ((CWObject) elementType.newInstance()).putAll( memberMap );
				if ( element != null ) fieldList.add( element );
			}
			return (Object) fieldList;
		}

		if ( value instanceof Map<String,Object> )
		{
			CWObject element = ((CWObject) elementType.newInstance()).putAll( (Map<String,Object>) value );

			if ( desiredType == elementType ) return (Object) element;

			List<CWObject>	fieldList	= (List<CWObject>) listType.newInstance();
			if ( element != null ) fieldList.add( element );
			return (Object) fieldList;
		}

		if ( value instanceof List<Object> )
		{
			List<Object> valueList	= (List<Object>) listType.newInstance();
			valueList.addAll( (List<Object>) value );
			return (Object) valueList;
		}

		if ( desiredType == elementType ) return value;

		List<Object> valueList	= (List<Object>) listType.newInstance();
		valueList.add( value );
		return (Object) valueList;
	}

	/*******************************************************
					urlEncode method
	*******************************************************/

	public String urlEncode()
	{
		return CWHttp.urlEncode( this );
	}

	/*******************************************************
				toMultipartForm method
	*******************************************************/

	public Blob toMultipartForm()
	{
		String	body;
		Integer	i = 1;
		for ( String key : map_Members.keySet() )
		{
			body = encodeFormBody
			(	body,

				(	'--' + CWHttp.formDataBoundary + '\r\n'
				+	'Content-Disposition: form-data; name="file' + i + '"; filename="' + ((Attachment) map_Members.get( key )).Name + '"\r\n'
				+	'Content-Type: application/octet-stream'
				),

				((Attachment) map_Members.get( key )).Body,

				(	i++ == map_Members.keySet().size()
				?	'--' + CWHttp.formDataBoundary + '--'
				:	null
				)
			);
		}
		return EncodingUtil.base64Decode( body );
	}

	/*******************************************************
				base64EncodeFormBody method

	This method takes in the various elements, and constructs
	a properly encoded form body for decoding into a Blob
	See: http://bit.ly/Vca0HM for more information
	*******************************************************/

	private String encodeFormBody( String body, String header, Blob file, String footer )
	{
		Integer[] modConversion = new Integer[]{ 0, 2, 1 };

		//	the header and footer can't be null because we might need to prepend to them
		if ( String.isBlank( body   ) ) body   = '';
		if ( String.isBlank( header ) ) header = '';
		if ( String.isBlank( footer ) ) footer = '';

		if ( file == null ) file = Blob.valueOf( '' );

		//	if there's a body, prepend a line break to the header
		if ( body.endsWith( 'N' ) ) header = '\n' + header;

		//	pad the header to a 3 character length with two line breaks at the end
		header += '  '.left( modConversion[ Math.mod( header.length() + 4, 3 ) ] ) + '\r\n\r\n';

		//	encode the file and replace any padding with a line break
		//	if any part of the line break doesn't fit in the file, put it in the footer
		String fileEncoded = EncodingUtil.base64Encode( file );

		if ( fileEncoded.endsWith( '==' ) )
		{
			fileEncoded = fileEncoded.removeEnd( '==' ) + '0K';			//	replace '==' with '\r\n', footer is unmodified
		}
		else if ( fileEncoded.endsWith( '=' ) )
		{
			fileEncoded = fileEncoded.removeEnd( '=' ) + 'N';			//	repace '=' with '\r'. The next header will get \n if not done 
			if ( String.isNotBlank( footer ) ) footer = '\n' + footer;	//	prepend the '\n' to the footer because we're at the end
		}
		else
		{
			footer = ' \r\n' + footer;									//	file has no padding, prepend '\r\n' to the footer
		}

		return
			body
		+	EncodingUtil.base64Encode( Blob.valueOf( header ) )
		+	fileEncoded
		+	EncodingUtil.base64Encode( Blob.valueOf( footer ) );
	}

	/*******************************************************
					jsonSerialize method
	*******************************************************/

	public String jsonSerialize()
	{
		return JSON.serialize( map_Members );
	}

	/*******************************************************
					convert methods
	*******************************************************/

	public Object convert( Type theType )
	{
		return theType != null ? JSON.deserialize( jsonSerialize(), theType ) : (Object) null;
	}

	public static Object convert( CWObject theObject, Type theType )
	{
		return theObject != null ? theObject.convert( theType ) : (Object) null;
	}

	/*******************************************************
					toString method
	*******************************************************/

	public override String toString()
	{
		return jsonSerialize();
	}
}