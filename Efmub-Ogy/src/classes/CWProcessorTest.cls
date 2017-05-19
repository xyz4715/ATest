/*******************************************************//**

@class		CWProcessorTest

@brief		Tests for CWProcessor Class

	The CWProcessorTest class contains the test methods for the
	CWProcessor class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-12-17	LiquidHub.GHA
	Created.

@todo		Use CWTest

@see		CWProcessor

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWProcessorTest
{
	private class Total extends CWProcessor
	{
		Decimal	result;

		public Total()
		{
			result = 0;
		}

		public override String	getResultKey()		{ return 'Total'; }
		public override Object	getResultValue()	{ return result; }

		public override void process( Object theObject )
		{
			result += ((CWTestObject__c) theObject).Number_8_0__c;
		}
	}

	private class Count extends CWProcessor
	{
		Integer	result;

		public Count()
		{
			result = 0;
		}

		public override String	getResultKey()		{ return 'Count'; }
		public override Object	getResultValue()	{ return result; }

		public override void process( Object theObject )
		{
			result++;
		}
	}

	private class NoResult extends CWProcessor
	{
		public override void process( Object theObject ) {}
	}

	private static testMethod void testCWProcessor()
	{
		List<CWTestObject__c>	testObjects		= new List<CWTestObject__c>
		{
			new CWTestObject__c( Number_8_0__c = 1 ),
			new CWTestObject__c( Number_8_0__c = 2 ),
			new CWTestObject__c( Number_8_0__c = 4 ),
			new CWTestObject__c( Number_8_0__c = 8 )
		};

		CWObject
			result	= CWProcessor.process( testObjects, new Total() );
			result	= CWProcessor.process( new CWIterable( (List<Object>) testObjects ), new Total() );
			result	= CWProcessor.process( testObjects, new Total(), result );
			result	= CWProcessor.process( new CWIterable( (List<Object>) testObjects ), new Total(), result );
			result	= CWProcessor.process( testObjects, new List<CWProcessor>{ new Total(), new Count() } );
			result	= CWProcessor.process( new CWIterable( (List<Object>) testObjects ), new List<CWProcessor>{ new Total(), new Count() } );
			result	= CWProcessor.process( testObjects, new List<CWProcessor>{ new Total(), new Count() }, result );
			result	= CWProcessor.process( new CWIterable( (List<Object>) testObjects ), new List<CWProcessor>{ new Total(), new Count() }, result );

		System.assert( (Decimal) result.get( 'Total' ) == 15 );
		System.assert( (Integer) result.get( 'Count' ) ==  4 );

		CWProcessor.process( testObjects, new NoResult() );
	}
}