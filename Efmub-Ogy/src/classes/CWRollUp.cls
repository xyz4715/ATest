/*******************************************************//**

@class		CWRollUp

@brief		CW Core Framework Roll-Up Class

	This class computes roll-up summary values from a collection
	of sObjects.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-08-06	LiquidHub.GHA
	Created.
@version	2014-09-24	LiquidHub.GHA
	Reworked to use CWProcessor.

@see		CWRollUpTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWRollUp
{
	/*******************************************************
					Count processor
	*******************************************************/

	public class Count extends CWProcessor
	{
		private Type	fieldType;
		private String	fieldName;
		private String	resultKey;
		private Integer	count;

		private Count( Type fieldType, String fieldName, String resultKey )
		{
			this.fieldType	= fieldType;
			this.fieldName	= fieldName;
			this.resultKey	= resultKey;
			this.count		= 0;
		}

		public Count( String sObjectName, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectName, fieldName ), fieldName, resultKey );
		}

		public Count( Schema.sObjectType sObjectType, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectType, fieldName ), fieldName, resultKey );
		}

		public Count( Schema.DescribeSObjectResult sObjectResult, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectResult, fieldName ), fieldName, resultKey );
		}

		public Count( sObject anSObject, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( anSObject, fieldName ), fieldName, resultKey );
		}

		public Count( Schema.sObjectField sObjectField, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectField ), CWSchema.getFieldName( sObjectField ), resultKey );
		}

		public Count( Schema.DescribeFieldResult fieldResult, String resultKey )
		{
			this( CWSchema.getFieldType( fieldResult ), CWSchema.getFieldName( fieldResult ), resultKey );
		}

		public override void process( Object anObject )
		{
			if ( fieldType != null )
			{
				Object	value	= ((sObject) anObject).get( fieldName );
				if ( value != null ) count++;
			}
		}

		public override String getResultKey()
		{
			return resultKey;
		}

		public override Object getResultValue()
		{
			return (Object) count;
		}
	}

	/*******************************************************
					count method
	*******************************************************/

	public static Integer count( List<sObject> inputRecords, String fieldName )
	{
		return (Integer) CWProcessor.process( inputRecords, new CWRollUp.Count( inputRecords.getSObjectType(), fieldName, 'count' ) ).get( 'count' );
	}

	/*******************************************************
					Sum processor
	*******************************************************/

	public class Sum extends CWProcessor
	{
		private Type	fieldType;
		private String	fieldName;
		private String	resultKey;
		private Double	sum;

		private Sum( Type fieldType, String fieldName, String resultKey )
		{
			this.fieldType	= CWType.isNumeric( fieldType ) ? fieldType : null;
			this.fieldName	= fieldName;
			this.resultKey	= resultKey;
			this.sum		= 0;
		}

		public Sum( String sObjectName, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectName, fieldName ), fieldName, resultKey );
		}

		public Sum( Schema.sObjectType sObjectType, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectType, fieldName ), fieldName, resultKey );
		}

		public Sum( Schema.DescribeSObjectResult sObjectResult, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectResult, fieldName ), fieldName, resultKey );
		}

		public Sum( sObject anSObject, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( anSObject, fieldName ), fieldName, resultKey );
		}

		public Sum( Schema.sObjectField sObjectField, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectField ), CWSchema.getFieldName( sObjectField ), resultKey );
		}

		public Sum( Schema.DescribeFieldResult fieldResult, String resultKey )
		{
			this( CWSchema.getFieldType( fieldResult ), CWSchema.getFieldName( fieldResult ), resultKey );
		}

		public override void process( Object anObject )
		{
			if ( fieldType != null )
			{
				Double	value	= (Double) ((sObject) anObject).get( fieldName );
				if ( value != null ) sum += value;
			}
		}

		public override String getResultKey()
		{
			return resultKey;
		}

		public override Object getResultValue()
		{
			return (Object) sum;
		}
	}

	/*******************************************************
					sum method
	*******************************************************/

	public static Double sum( List<sObject> inputRecords, String fieldName )
	{
		return (Double) CWProcessor.process( inputRecords, new CWRollUp.Sum( inputRecords.getSObjectType(), fieldName, 'sum' ) ).get( 'sum' );
	}

	/*******************************************************
					Average processor
	*******************************************************/

	public class Average extends CWProcessor
	{
		private Type	fieldType;
		private String	fieldName;
		private String	resultKey;
		private Double	sum;
		private Integer	count;

		private Average( Type fieldType, String fieldName, String resultKey )
		{
			this.fieldType	= CWType.isNumeric( fieldType ) ? fieldType : null;
			this.fieldName	= fieldName;
			this.resultKey	= resultKey;
			this.sum		= 0;
			this.count		= 0;
		}

		public Average( String sObjectName, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectName, fieldName ), fieldName, resultKey );
		}

		public Average( Schema.sObjectType sObjectType, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectType, fieldName ), fieldName, resultKey );
		}

		public Average( Schema.DescribeSObjectResult sObjectResult, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectResult, fieldName ), fieldName, resultKey );
		}

		public Average( sObject anSObject, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( anSObject, fieldName ), fieldName, resultKey );
		}

		public Average( Schema.sObjectField sObjectField, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectField ), CWSchema.getFieldName( sObjectField ), resultKey );
		}

		public Average( Schema.DescribeFieldResult fieldResult, String resultKey )
		{
			this( CWSchema.getFieldType( fieldResult ), CWSchema.getFieldName( fieldResult ), resultKey );
		}

		public override void process( Object anObject )
		{
			if ( fieldType != null )
			{
				Double	value	= (Double) ((sObject) anObject).get( fieldName );
				if ( value != null )
				{
					sum += value;
					count++;
				}
			}
		}

		public override String getResultKey()
		{
			return resultKey;
		}

		public override Object getResultValue()
		{
			return (Object) (sum / (Double) count);
		}
	}

	/*******************************************************
					average method
	*******************************************************/

	public static Double average( List<sObject> inputRecords, String fieldName )
	{
		return (Double) CWProcessor.process( inputRecords, new CWRollUp.Average( inputRecords.getSObjectType(), fieldName, 'average' ) ).get( 'average' );
	}

	/*******************************************************
					Minimum processor
	*******************************************************/

	public class Minimum extends CWProcessor
	{
		private Type	fieldType;
		private String	fieldName;
		private String	resultKey;
		private Object	minimum;

		private Minimum( Type fieldType, String fieldName, String resultKey )
		{
			this.fieldType	= CWCompare.isComparable( fieldType ) ? fieldType : null;
			this.fieldName	= fieldName;
			this.resultKey	= resultKey;
			this.minimum	= null;
		}

		public Minimum( String sObjectName, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectName, fieldName ), fieldName, resultKey );
		}

		public Minimum( Schema.sObjectType sObjectType, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectType, fieldName ), fieldName, resultKey );
		}

		public Minimum( Schema.DescribeSObjectResult sObjectResult, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectResult, fieldName ), fieldName, resultKey );
		}

		public Minimum( sObject anSObject, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( anSObject, fieldName ), fieldName, resultKey );
		}

		public Minimum( Schema.sObjectField sObjectField, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectField ), CWSchema.getFieldName( sObjectField ), resultKey );
		}

		public Minimum( Schema.DescribeFieldResult fieldResult, String resultKey )
		{
			this( CWSchema.getFieldType( fieldResult ), CWSchema.getFieldName( fieldResult ), resultKey );
		}

		public override void process( Object anObject )
		{
			if ( fieldType != null )
			{
				Object	value	= ((sObject) anObject).get( fieldName );
				if ( CWCompare.compareNullIsLarge( fieldType, minimum, value ) > 0 ) minimum = value;
			}
		}

		public override String getResultKey()
		{
			return resultKey;
		}

		public override Object getResultValue()
		{
			return minimum;
		}
	}

	/*******************************************************
					minimum method
	*******************************************************/

	public static Object minimum( List<sObject> inputRecords, String fieldName )
	{
		return CWProcessor.process( inputRecords, new CWRollUp.Minimum( inputRecords.getSObjectType(), fieldName, 'minimum' ) ).get( 'minimum' );
	}

	/*******************************************************
					Maximum processor
	*******************************************************/

	public class Maximum extends CWProcessor
	{
		private Type	fieldType;
		private String	fieldName;
		private String	resultKey;
		private Object	maximum;

		private Maximum( Type fieldType, String fieldName, String resultKey )
		{
			this.fieldType	= CWCompare.isComparable( fieldType ) ? fieldType : null;
			this.fieldName	= fieldName;
			this.resultKey	= resultKey;
			this.maximum	= null;
		}

		public Maximum( String sObjectName, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectName, fieldName ), fieldName, resultKey );
		}

		public Maximum( Schema.sObjectType sObjectType, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectType, fieldName ), fieldName, resultKey );
		}

		public Maximum( Schema.DescribeSObjectResult sObjectResult, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectResult, fieldName ), fieldName, resultKey );
		}

		public Maximum( sObject anSObject, String fieldName, String resultKey )
		{
			this( CWSchema.getFieldType( anSObject, fieldName ), fieldName, resultKey );
		}

		public Maximum( Schema.sObjectField sObjectField, String resultKey )
		{
			this( CWSchema.getFieldType( sObjectField ), CWSchema.getFieldName( sObjectField ), resultKey );
		}

		public Maximum( Schema.DescribeFieldResult fieldResult, String resultKey )
		{
			this( CWSchema.getFieldType( fieldResult ), CWSchema.getFieldName( fieldResult ), resultKey );
		}

		public override void process( Object anObject )
		{
			if ( fieldType != null )
			{
				Object	value	= ((sObject) anObject).get( fieldName );
				if ( CWCompare.compareNullIsSmall( fieldType, maximum, value ) < 0 ) maximum = value;
			}
		}

		public override String getResultKey()
		{
			return resultKey;
		}

		public override Object getResultValue()
		{
			return maximum;
		}
	}

	/*******************************************************
					maximum method
	*******************************************************/

	public static Object maximum( List<sObject> inputRecords, String fieldName )
	{
		return CWProcessor.process( inputRecords, new CWRollUp.Maximum( inputRecords.getSObjectType(), fieldName, 'maximum' ) ).get( 'maximum' );
	}
}