/*******************************************************//**

@class		CWType

@brief		CW Core Type Class

	Description goes here.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-02-03	LiquidHub.GHA
	Created.
@version	2014-02-04	LiquidHub.GHA
	Cleaned up DisplayType/SOAPType/Type tables.
	Added conversionError method to make use of CWException.
@version	2014-03-03	LiquidHub.GHA
	Added type checking methods and predicates.  Made numeric
	conversions more null-safe.
@version	2014-08-02	LiquidHub.GHA
	Added isConstructable method.
@version	2014-08-06	LiquidHub.GHA
	Added isNumeric and isOrdered methods.
@version	2014-08-07	LiquidHub.GHA
	Added getPrimitiveType and isPrimitive methods.
@version	2014-09-30	LiquidHub.GHA
	Added isPrimitive( Object ) method.

@see		CWTypeTest

	(c)2014-2016 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWType
{
	/*******************************************************
				type checking methods
	*******************************************************/

	public static Boolean isBlob( Object theObject )
	{
		return theObject != null && theObject instanceof Blob;
	}

	public static Boolean isBoolean( Object theObject )
	{
		return theObject != null && theObject instanceof Boolean;
	}

	public static Boolean isDate( Object theObject )
	{
		return theObject != null && theObject instanceof Date;
	}

	public static Boolean isDateTime( Object theObject )
	{
		return theObject != null && theObject instanceof DateTime;
	}

	public static Boolean isDecimal( Object theObject )
	{
		return theObject != null && theObject instanceof Decimal;
	}

	public static Boolean isDouble( Object theObject )
	{
		return theObject != null && theObject instanceof Double;
	}

	public static Boolean isId( Object theObject )
	{
		return theObject != null && theObject instanceof Id;
	}

	public static Boolean isInteger( Object theObject )
	{
		return theObject != null && theObject instanceof Integer;
	}

	public static Boolean isLong( Object theObject )
	{
		return theObject != null && theObject instanceof Long;
	}

	public static Boolean isObject( Object theObject )
	{
		return theObject != null;
	}

	public static Boolean isSObject( Object theObject )
	{
		return theObject != null && theObject instanceof sObject;
	}

	public static Boolean isString( Object theObject )
	{
		return theObject != null && theObject instanceof String;
	}

	public static Boolean isTime( Object theObject )
	{
		return theObject != null && theObject instanceof Time;
	}

	/*******************************************************
				type checking predicates
	*******************************************************/

	public class IsBlob extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isBlob( theObject );
		}
	}

	public class IsBoolean extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isBoolean( theObject );
		}
	}

	public class IsDate extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isDate( theObject );
		}
	}

	public class IsDateTime extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isDateTime( theObject );
		}
	}

	public class IsDecimal extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isDecimal( theObject );
		}
	}

	public class IsDouble extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isDouble( theObject );
		}
	}

	public class IsId extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isId( theObject );
		}
	}

	public class IsInteger extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isInteger( theObject );
		}
	}

	public class IsLong extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isLong( theObject );
		}
	}

	public class IsObject extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isObject( theObject );
		}
	}

	public class IsSObject extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isSObject( theObject );
		}
	}

	public class IsString extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isString( theObject );
		}
	}

	public class IsTime extends CWPredicate
	{
		public override Boolean test( Object theObject )
		{
			return isTime( theObject );
		}
	}

	/*******************************************************
				isPrimitive( Type )
				isConstructable( Type )
	*******************************************************/

	private static Set<Type>	set_PrimitiveTypes
	{
		get
		{
			if ( set_PrimitiveTypes == null )
			{
				set_PrimitiveTypes = new Set<Type>
				{	Blob		.class,
					Boolean		.class,
					Date		.class,
					DateTime	.class,
					Decimal		.class,
					Double		.class,
					Id			.class,
					Integer		.class,
					Long		.class,
					String		.class,
					Time		.class
				};
			}
			return set_PrimitiveTypes;
		}
		private set;
	}

	public static Boolean isPrimitive( Type theType )
	{
		return set_PrimitiveTypes.contains( theType );
	}

	public static Boolean isConstructable( Type theType )
	{
		return theType != null && !set_PrimitiveTypes.contains( theType );
	}

	/*******************************************************
				isNumeric( Type )
	*******************************************************/

	private static Set<Type>	set_NumericTypes
	{
		get
		{
			if ( set_NumericTypes == null )
			{
				set_NumericTypes = new Set<Type>
				{	Decimal		.class,
					Double		.class,
					Integer		.class,
					Long		.class
				};
			}
			return set_NumericTypes;
		}
		private set;
	}

	public static Boolean isNumeric( Type theType )
	{
		return set_NumericTypes.contains( theType );
	}

	/*******************************************************
				isOrdered( Type )
	*******************************************************/

	private static Set<Type>	set_OrderedTypes
	{
		get
		{
			if ( set_OrderedTypes == null )
			{
				set_OrderedTypes = new Set<Type>
				{	Date		.class,
					DateTime	.class,
					Decimal		.class,
					Double		.class,
					Integer		.class,
					Long		.class,
					Time		.class
				};
			}
			return set_OrderedTypes;
		}
		private set;
	}

	public static Boolean isOrdered( Type theType )
	{
		return	set_OrderedTypes.contains( theType );
	}

	/*******************************************************
				getPrimitiveType( Object )
	*******************************************************/

	public static Type getPrimitiveType( Object theObject )
	{
		return
			theObject == null				?	null
		:	theObject instanceof Blob		?	Blob		.class
		:	theObject instanceof Boolean	?	Boolean		.class
		:	theObject instanceof Date		?	Date		.class
		:	theObject instanceof DateTime	?	DateTime	.class
		:	theObject instanceof Integer	?	Integer		.class
		:	theObject instanceof Long		?	Long		.class
		:	theObject instanceof Double		?	Double		.class
		:	theObject instanceof Decimal	?	Decimal		.class
		:	theObject instanceof Id			?	Id			.class
		:	theObject instanceof String		?	String		.class
		:	theObject instanceof Time		?	Time		.class
		:	theObject instanceof sObject	?	sObject		.class
		:										Object		.class;
	}

	public static Boolean isPrimitive( Object theObject )
	{
		return isPrimitive( getPrimitiveType( theObject ) );
	}

	/*******************************************************
				getDisplayTypes( Schema.SOAPType )
	*******************************************************/

	private static Map<Schema.SOAPType,Set<Schema.DisplayType>> map_SOAPType_DisplayTypes
	{
		get
		{
			if ( map_SOAPType_DisplayTypes != null ) return map_SOAPType_DisplayTypes;

			map_SOAPType_DisplayTypes = new Map<Schema.SOAPType,Set<Schema.DisplayType>>
			{	Schema.SOAPType.AnyType			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.AnyType		},
				Schema.SOAPType.Base64Binary	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Base64		},
				Schema.SOAPType.Boolean			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Boolean		},
				Schema.SOAPType.Date			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Date			},
				Schema.SOAPType.DateTime		=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.DateTime		},
				Schema.SOAPType.Double			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Currency,
																					Schema.DisplayType.Double,
																					Schema.DisplayType.Percent		},
				Schema.SOAPType.Id				=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Id,
																					Schema.DisplayType.Reference	},
				Schema.SOAPType.Integer			=>	new Set<Schema.DisplayType>	{									},
				Schema.SOAPType.String			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.ComboBox,
																					Schema.DisplayType.Email,
																					Schema.DisplayType.EncryptedString,
																					Schema.DisplayType.MultiPicklist,
																					Schema.DisplayType.Phone,
																					Schema.DisplayType.Picklist,
																					Schema.DisplayType.String,
																					Schema.DisplayType.TextArea,
																					Schema.DisplayType.URL			},
				Schema.SOAPType.Time			=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Time			}
			};
			return map_SOAPType_DisplayTypes;
		}
		private set;
	}

	public static Set<Schema.DisplayType> getDisplayTypes( Schema.SOAPType soapType )
	{
		return map_SOAPType_DisplayTypes.get( soapType );
	}

	/*******************************************************
				getDisplayTypes( Type )
	*******************************************************/

	private static Map<Type,Set<Schema.DisplayType>> map_Type_DisplayTypes
	{
		get
		{
			if ( map_Type_DisplayTypes != null ) return map_Type_DisplayTypes;

			map_Type_DisplayTypes = new Map<Type,Set<Schema.DisplayType>>
			{
				Blob	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Base64		},
				Boolean	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Boolean		},
				Date	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Date			},
				DateTime.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.DateTime		},
				Decimal	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Currency,
																	Schema.DisplayType.Double,
																	Schema.DisplayType.Percent		},
				Double	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Currency,
																	Schema.DisplayType.Double,
																	Schema.DisplayType.Percent		},
				Id		.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Id,
																	Schema.DisplayType.Reference	},
				Integer	.class	=>	new Set<Schema.DisplayType>	{									},
				Long	.class	=>	new Set<Schema.DisplayType>	{									},
				Object	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.AnyType,
																	Schema.DisplayType.Base64,
																	Schema.DisplayType.Boolean,
																	Schema.DisplayType.ComboBox,
																	Schema.DisplayType.Currency,
																	Schema.DisplayType.Date,
																	Schema.DisplayType.DateTime,
																	Schema.DisplayType.Double,
																	Schema.DisplayType.Email,
																	Schema.DisplayType.EncryptedString,
																	Schema.DisplayType.Id,
																	Schema.DisplayType.Location,
																	Schema.DisplayType.MultiPicklist,
																	Schema.DisplayType.Percent,
																	Schema.DisplayType.Phone,
																	Schema.DisplayType.Picklist,
																	Schema.DisplayType.Reference,
																	Schema.DisplayType.String,
																	Schema.DisplayType.TextArea,
																	Schema.DisplayType.Time,
																	Schema.DisplayType.URL			},
				String	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.ComboBox,
																	Schema.DisplayType.Email,
																	Schema.DisplayType.EncryptedString,
																	Schema.DisplayType.MultiPicklist,
																	Schema.DisplayType.Phone,
																	Schema.DisplayType.Picklist,
																	Schema.DisplayType.String,
																	Schema.DisplayType.TextArea,
																	Schema.DisplayType.URL,
																	Schema.DisplayType.Time			},
				Time	.class	=>	new Set<Schema.DisplayType>	{	Schema.DisplayType.Time			}
			};
			return map_Type_DisplayTypes;
		}
		private set;
	}

	public static Set<Schema.DisplayType> getDisplayTypes( Type theType )
	{
		return map_Type_DisplayTypes.get( theType );
	}

	/*******************************************************
				getSOAPType( Schema.DisplayType )
	*******************************************************/

	private static Map<Schema.DisplayType,Schema.SOAPType> map_DisplayType_SOAPType
	{
		get
		{
			if ( map_DisplayType_SOAPType != null ) return map_DisplayType_SOAPType;

			map_DisplayType_SOAPType = new Map<Schema.DisplayType,Schema.SOAPType>
			{	Schema.DisplayType.AnyType			=>	Schema.SOAPType.AnyType,
				Schema.DisplayType.Base64			=>	Schema.SOAPType.Base64Binary,
				Schema.DisplayType.Boolean			=>	Schema.SOAPType.Boolean,
				Schema.DisplayType.ComboBox			=>	Schema.SOAPType.String,
				Schema.DisplayType.Currency			=>	Schema.SOAPType.Double,
				Schema.DisplayType.Date				=>	Schema.SOAPType.Date,
				Schema.DisplayType.DateTime			=>	Schema.SOAPType.DateTime,
				Schema.DisplayType.Double			=>	Schema.SOAPType.Double,
				Schema.DisplayType.Email			=>	Schema.SOAPType.String,
				Schema.DisplayType.EncryptedString	=>	Schema.SOAPType.String,
				Schema.DisplayType.Id				=>	Schema.SOAPType.Id,
				Schema.DisplayType.Location			=>	Schema.SOAPType.AnyType,
				Schema.DisplayType.MultiPicklist	=>	Schema.SOAPType.String,
				Schema.DisplayType.Percent			=>	Schema.SOAPType.Double,
				Schema.DisplayType.Phone			=>	Schema.SOAPType.String,
				Schema.DisplayType.Picklist			=>	Schema.SOAPType.String,
				Schema.DisplayType.Reference		=>	Schema.SOAPType.Id,
				Schema.DisplayType.String			=>	Schema.SOAPType.String,
				Schema.DisplayType.TextArea			=>	Schema.SOAPType.String,
				Schema.DisplayType.Time				=>	Schema.SOAPType.Time,
				Schema.DisplayType.URL				=>	Schema.SOAPType.String
			};
			return map_DisplayType_SOAPType;
		}
		private set;
	}

	public static Schema.SOAPType getSOAPType( Schema.DisplayType displayType )
	{
		return map_DisplayType_SOAPType.get( displayType );
	}

	/*******************************************************
				getSOAPTypes( Type )
	*******************************************************/

	private static Map<Type,Set<Schema.SOAPType>> map_Type_SOAPTypes
	{
		get
		{
			if ( map_Type_SOAPTypes != null ) return map_Type_SOAPTypes;

			map_Type_SOAPTypes = new Map<Type,Set<Schema.SOAPType>>
			{	Blob	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Base64Binary	},
				Boolean	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Boolean			},
				Date	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Date			},
				DateTime.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.DateTime		},
				Decimal	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Double,
																Schema.SOAPType.Integer			},
				Double	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Double,
																Schema.SOAPType.Integer			},
				Id		.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Id				},
				Long	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Integer			},
				Integer	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Integer			},
				Object	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.AnyType,
																Schema.SOAPType.Base64Binary,
																Schema.SOAPType.Boolean,
																Schema.SOAPType.Date,
																Schema.SOAPType.DateTime,
																Schema.SOAPType.Double,
																Schema.SOAPType.ID,
																Schema.SOAPType.Integer,
																Schema.SOAPType.String,
																Schema.SOAPType.Time			},
				String	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Id,
																Schema.SOAPType.String			},
				Time	.class	=> new Set<Schema.SOAPType>	{	Schema.SOAPType.Time			}
			};
			return map_Type_SOAPTypes;
		}
		private set;
	}

	public static Set<Schema.SOAPType> getSOAPTypes( Type theType )
	{
		return map_Type_SOAPTypes.get( theType );
	}

	/*******************************************************
				getType( Schema.DisplayType )
	*******************************************************/

	private static Map<Schema.DisplayType,Type> map_DisplayType_Type
	{
		get
		{
			if ( map_DisplayType_Type != null ) return map_DisplayType_Type;

			map_DisplayType_Type = new Map<Schema.DisplayType,Type>
			{	Schema.DisplayType.AnyType			=>	Object	.class,
				Schema.DisplayType.Base64			=>	Blob	.class,
				Schema.DisplayType.Boolean			=>	Boolean	.class,
				Schema.DisplayType.ComboBox			=>	String	.class,
				Schema.DisplayType.Currency			=>	Double	.class,
				Schema.DisplayType.Date				=>	Date	.class,
				Schema.DisplayType.DateTime			=>	DateTime.class,
				Schema.DisplayType.Double			=>	Double	.class,
				Schema.DisplayType.Email			=>	String	.class,
				Schema.DisplayType.EncryptedString	=>	String	.class,
				Schema.DisplayType.Id				=>	Id		.class,
				Schema.DisplayType.Location			=>	Object	.class,
				Schema.DisplayType.MultiPicklist	=>	String	.class,
				Schema.DisplayType.Percent			=>	Double	.class,
				Schema.DisplayType.Phone			=>	String	.class,
				Schema.DisplayType.Picklist			=>	String	.class,
				Schema.DisplayType.Reference		=>	Id		.class,
				Schema.DisplayType.String			=>	String	.class,
				Schema.DisplayType.TextArea			=>	String	.class,
				Schema.DisplayType.Time				=>	Time	.class,
				Schema.DisplayType.URL				=>	String	.class
			};
			return map_DisplayType_Type;
		}
		private set;
	}

	public static Type getType( Schema.DisplayType displayType )
	{
		return map_DisplayType_Type.get( displayType );
	}

	/*******************************************************
				getType( Schema.SOAPType )
	*******************************************************/

	private static Map<Schema.SOAPType,Type> map_SOAPType_Type
	{
		get
		{
			if ( map_SOAPType_Type != null ) return map_SOAPType_Type;

			map_SOAPType_Type = new Map<Schema.SOAPType,Type>
			{	Schema.SOAPType.AnyType			=>	Object	.class,
				Schema.SOAPType.Base64Binary	=>	Blob	.class,
				Schema.SOAPType.Boolean			=>	Boolean	.class,
				Schema.SOAPType.Date			=>	Date	.class,
				Schema.SOAPType.DateTime		=>	DateTime.class,
				Schema.SOAPType.Double			=>	Double	.class,
				Schema.SOAPType.Id				=>	Id		.class,
				Schema.SOAPType.Integer			=>	Integer	.class,
				Schema.SOAPType.String			=>	String	.class,
				Schema.SOAPType.Time			=>	Time	.class
			};
			return map_SOAPType_Type;
		}
		private set;
	}

	public static Type getType( Schema.SOAPType soapType )
	{
		return map_SOAPType_Type.get( soapType );
	}

	/*******************************************************
				toDecimal methods
	*******************************************************/

	public static Decimal toDecimal( Decimal x )
	{
		return x;
	}

	public static Decimal toDecimal( Double x )
	{
		return x != null ? (Decimal) x : null;
	}

	public static Decimal toDecimal( Long x )
	{
		return x != null ? (Decimal) x : null;
	}

	public static Decimal toDecimal( Integer x )
	{
		return x != null ? (Decimal) x : null;
	}

	public static List<Decimal> toDecimal( List<Decimal> list_x )
	{
		return list_x != null ? list_x.clone() : null;
	}

	public static List<Decimal> toDecimal( List<Double> list_x )
	{
		if ( list_x == null ) return null;

		List<Decimal> list_Decimals = new List<Decimal>();
		for ( Double x : list_x )
		{
			list_Decimals.add( toDecimal( x ) );
		}
		return list_Decimals;
	}

	public static List<Decimal> toDecimal( List<Long> list_x )
	{
		if ( list_x == null ) return null;

		List<Decimal> list_Decimals = new List<Decimal>();
		for ( Long x : list_x )
		{
			list_Decimals.add( toDecimal( x ) );
		}
		return list_Decimals;
	}

	public static List<Decimal> toDecimal( List<Integer> list_x )
	{
		if ( list_x == null ) return null;

		List<Decimal> list_Decimals = new List<Decimal>();
		for ( Integer x : list_x )
		{
			list_Decimals.add( toDecimal( x ) );
		}
		return list_Decimals;
	}

	/*******************************************************
				toDouble methods
	*******************************************************/

	public static Double toDouble( Decimal x )
	{
		return x != null ? (Double) x : null;
	}

	public static Double toDouble( Double x )
	{
		return x;
	}

	public static Double toDouble( Long x )
	{
		return x != null ? (Double) x : null;
	}

	public static Double toDouble( Integer x )
	{
		return x != null ? (Double) x : null;
	}

	public static List<Double> toDouble( List<Decimal> list_x )
	{
		if ( list_x == null ) return null;

		List<Double> list_Doubles = new List<Double>();
		for ( Decimal x : list_x )
		{
			list_Doubles.add( toDouble( x ) );
		}
		return list_Doubles;
	}

	public static List<Double> toDouble( List<Double> list_x )
	{
		return list_x != null ? list_x.clone() : null;
	}

	public static List<Double> toDouble( List<Long> list_x )
	{
		if ( list_x == null ) return null;

		List<Double> list_Doubles = new List<Double>();
		for ( Long x : list_x )
		{
			list_Doubles.add( toDouble( x ) );
		}
		return list_Doubles;
	}

	public static List<Double> toDouble( List<Integer> list_x )
	{
		if ( list_x == null ) return null;

		List<Double> list_Doubles = new List<Double>();
		for ( Integer x : list_x )
		{
			list_Doubles.add( toDouble( x ) );
		}
		return list_Doubles;
	}

	/*******************************************************
				toLong methods
	*******************************************************/

	private static Decimal	maxLongAsDecimal	=  9223372036854775807.0;
	private static Decimal	minLongAsDecimal	= -9223372036854775808.0;
	private static Double	maxLongAsDouble		=  9223372036854775807.0;	//	9223372036854776832.0
	private static Double	minLongAsDouble		= -9223372036854775808.0;

	public static Long toLong( Decimal x )
	{
		if ( x == null ) return null;
		if ( x >= minLongAsDecimal && x <= maxLongAsDecimal ) return x.longValue();
		return (Integer) conversionError( 'toLong', 'Decimal', x );
	}

	public static Long toLong( Double x )
	{
		if ( x == null ) return null;
		if ( x >= minLongAsDouble && x <= maxLongAsDouble ) return x.longValue();
		return (Integer) conversionError( 'toLong', 'Double', x );
	}

	public static Long toLong( Long x )
	{
		return x;
	}

	public static Long toLong( Integer x )
	{
		return x != null ? (Long) x : null;
	}

	public static List<Long> toLong( List<Decimal> list_x )
	{
		if ( list_x == null ) return null;

		List<Long> list_Longs = new List<Long>();
		for ( Decimal x : list_x )
		{
			list_Longs.add( toLong( x ) );
		}
		return list_Longs;
	}

	public static List<Long> toLong( List<Double> list_x )
	{
		if ( list_x == null ) return null;

		List<Long> list_Longs = new List<Long>();
		for ( Double x : list_x )
		{
			list_Longs.add( toLong( x ) );
		}
		return list_Longs;
	}

	public static List<Long> toLong( List<Long> list_x )
	{
		return list_x != null ? list_x.clone() : null;
	}

	public static List<Long> toLong( List<Integer> list_x )
	{
		if ( list_x == null ) return null;

		List<Long> list_Longs = new List<Long>();
		for ( Integer x : list_x )
		{
			list_Longs.add( toLong( x ) );
		}
		return list_Longs;
	}

	/*******************************************************
				toInteger methods
	*******************************************************/

	private static Decimal	maxIntegerAsDecimal		=  2147483647.0;
	private static Decimal	minIntegerAsDecimal		= -2147483648.0;
	private static Double	maxIntegerAsDouble		=  2147483647.0;
	private static Double	minIntegerAsDouble		= -2147483648.0;
	private static Long		maxIntegerAsLong		=  2147483647L;
	private static Long		minIntegerAsLong		= -2147483648L;

	public static Integer toInteger( Decimal x )
	{
		if ( x == null ) return null;
		if ( x >= minIntegerAsDecimal && x <= maxIntegerAsDecimal ) return x.intValue();
		return (Integer) conversionError( 'toInteger', 'Decimal', x );
	}

	public static Integer toInteger( Double x )
	{
		if ( x == null ) return null;
		if ( x >= minIntegerAsDouble && x <= maxIntegerAsDouble ) return x.intValue();
		return (Integer) conversionError( 'toInteger', 'Double', x );
	}

	public static Integer toInteger( Long x )
	{
		if ( x == null ) return null;
		if ( x >= minIntegerAsLong && x <= maxIntegerAsLong ) return x.intValue();
		return (Integer) conversionError( 'toInteger', 'Long', x );
	}

	public static Integer toInteger( Integer x )
	{
		return x;
	}

	public static List<Integer> toInteger( List<Decimal> list_x )
	{
		if ( list_x == null ) return null;

		List<Integer> list_Integers = new List<Integer>();
		for ( Decimal x : list_x )
		{
			list_Integers.add( toInteger( x ) );
		}
		return list_Integers;
	}

	public static List<Integer> toInteger( List<Double> list_x )
	{
		if ( list_x == null ) return null;

		List<Integer> list_Integers = new List<Integer>();
		for ( Double x : list_x )
		{
			list_Integers.add( toInteger( x ) );
		}
		return list_Integers;
	}

	public static List<Integer> toInteger( List<Long> list_x )
	{
		if ( list_x == null ) return null;

		List<Integer> list_Integers = new List<Integer>();
		for ( Long x : list_x )
		{
			list_Integers.add( toInteger( x ) );
		}
		return list_Integers;
	}

	public static List<Integer> toInteger( List<Integer> list_x )
	{
		return list_x != null ? list_x.clone() : null;
	}

	/*******************************************************
				conversionError method
	*******************************************************/

	private static Object conversionError( String method, String sourceType, Object x )
	{
		return CWException.errorNull( 'CWType.' + method + ': Error converting from ' + sourceType + ' (' + String.valueOf( x ) + ')' );
	}
}