/*******************************************************//**

@class		CWSchedulableTest

@brief		Tests for LiquidHub Framework Schedulable Class

	Detailed description goes here.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-01-29	LiquidHub.GHA
	Created.

@see		CWSchedulable

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWSchedulableTest
{
	/*******************************************************
				TestSchedulable class
	*******************************************************/

	private class TestSchedulable extends CWSchedulable
	{
		public TestSchedulable( String name )
		{
			super( name );
		}

		public TestSchedulable()
		{
			super();
		}

		public override void cwExecute( SchedulableContext sc )
		{
			
		}
	}

	private class Strategy extends CWSchedulable.Strategy
	{
		public override Id schedule( String jobName, String cronString, CWSchedulable job )
		{
			return null;
		}

		public override void abortJob( String jobId )
		{
			
		}

		public override Set<Id> getJobsByName( Set<String> jobNames )
		{
			return null;
		}
	}

	static testMethod void testProperties()
	{
		CWTest testResult	= new CWTest( 'CWSchedulableTest::testProperties' );

		TestSchedulable	theTestSchedulable;

		//**************************************************
		//		Test schedulableName property
		//**************************************************

		theTestSchedulable	= new TestSchedulable();

		testResult.assert
		(	'default schedulableName',
			CWSchedulable.defaultName,
			theTestSchedulable.schedulableName
		);

		String firstSchedulableName	= 'firstSchedulableName';

		theTestSchedulable.schedulableName = firstSchedulableName;

		testResult.assert
		(	'first schedulableName',
			firstSchedulableName,
			theTestSchedulable.schedulableName
		);

		theTestSchedulable.schedulableName = null;

		testResult.assert
		(	'null schedulableName',
			firstSchedulableName,
			theTestSchedulable.schedulableName
		);

		theTestSchedulable.schedulableName = '';

		testResult.assert
		(	'empty schedulableName',
			firstSchedulableName,
			theTestSchedulable.schedulableName
		);

		theTestSchedulable.schedulableName = ' \t\n';

		testResult.assert
		(	'whitespace schedulableName',
			firstSchedulableName,
			theTestSchedulable.schedulableName
		);

		String secondSchedulableName	= 'secondSchedulableName';

		theTestSchedulable.schedulableName = secondSchedulableName;

		testResult.assert
		(	'second schedulableName',
			secondSchedulableName,
			theTestSchedulable.schedulableName
		);

		String constructedSchedulableName	= 'constructedSchedulableName';

		theTestSchedulable	= new TestSchedulable( constructedSchedulableName );

		testResult.assert
		(	'constructed schedulableName',
			constructedSchedulableName,
			theTestSchedulable.schedulableName
		);

		//**************************************************
		//		Test delaySeconds property
		//**************************************************

		testResult.assert
		(	'default delaySeconds',
			CWSchedulable.defaultDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		theTestSchedulable.delaySeconds = CWSchedulable.minDelaySeconds;

		testResult.assert
		(	'minimum delaySeconds',
			CWSchedulable.minDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		Integer firstDelaySeconds	= CWSchedulable.defaultDelaySeconds + 1;

		theTestSchedulable.delaySeconds = firstDelaySeconds;

		testResult.assert
		(	'first delaySeconds',
			firstDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		theTestSchedulable.delaySeconds = CWSchedulable.minDelaySeconds - 1;

		testResult.assert
		(	'sub-minimum delaySeconds',
			firstDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		theTestSchedulable.delaySeconds = 0;

		testResult.assert
		(	'zero delaySeconds',
			firstDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		theTestSchedulable.delaySeconds = -1;

		testResult.assert
		(	'negative delaySeconds',
			firstDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		Integer secondDelaySeconds	= CWSchedulable.defaultDelaySeconds + 2;

		theTestSchedulable.delaySeconds = secondDelaySeconds;

		testResult.assert
		(	'second delaySeconds',
			secondDelaySeconds,
			theTestSchedulable.delaySeconds
		);

		//**************************************************
		//		Test cronTriggerId property
		//**************************************************

		testResult.assert
		(	'default cronTriggerId',
			(Id) null,
			theTestSchedulable.cronTriggerId
		);

		//**************************************************
		//		Test previousSchedulable property
		//**************************************************

		testResult.assert
		(	'default previousSchedulable',
			(CWSchedulable) null,
			theTestSchedulable.previousSchedulable
		);

		//**************************************************
		//	Test cronString and scheduledTime properties
		//**************************************************

		testResult.assert
		(	'default cronString',
			(String) null,
			theTestSchedulable.cronString
		);

		testResult.assert
		(	'default scheduledTime',
			(DateTime) null,
			theTestSchedulable.scheduledTime
		);

		String	firstCronString	= '0 0 12 ? ? ?';

		theTestSchedulable.cronString = firstCronString;

		testResult.assert
		(	'first cronString',
			firstCronString,
			theTestSchedulable.cronString
		);

		testResult.assert
		(	'still default scheduledTime',
			(DateTime) null,
			theTestSchedulable.scheduledTime
		);

		DateTime	firstScheduledTime	= DateTime.now().addDays( 1 );
		String		secondCronString	= firstScheduledTime.format( 's m H d M ? yyyy' );

		theTestSchedulable.scheduledTime = firstScheduledTime;

		testResult.assert
		(	'still first cronString',
			firstCronString,
			theTestSchedulable.cronString
		);

		testResult.assert
		(	'first scheduledTime',
			firstScheduledTime,
			theTestSchedulable.scheduledTime
		);

		theTestSchedulable.cronString = null;

		testResult.assert
		(	'second cronString',
			secondCronString,
			theTestSchedulable.cronString
		);

		testResult.assert
		(	'still first scheduledTime',
			firstScheduledTime,
			theTestSchedulable.scheduledTime
		);

		theTestSchedulable.scheduledTime = null;

		testResult.assert
		(	'null cronString',
			(String) null,
			theTestSchedulable.cronString
		);

//*		//	Production Version
		testResult.assert
		(	'null scheduledTime',
			(DateTime) null,
			theTestSchedulable.scheduledTime
		);

/*/		//	Demonstration Version
		testResult.assert
		(	'null scheduledTime',
			firstScheduledTime,
			theTestSchedulable.scheduledTime,
			'The scheduledTime property didn\'t behave as expected.'
		);

		testResult.annotate( 'This is an annotation.' );
		testResult.fail( 'This is a failure.' );
//*/

		testResult.report();
	}
}