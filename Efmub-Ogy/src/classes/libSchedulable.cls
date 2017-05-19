/*******************************************************//**

@class		CWSchedulable

@brief		CW Core Schedulable Class

	Detailed description goes here.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-01-27	LiquidHub.GHA
	Created.
@version	2014-01-28	LiquidHub.GHA
	Added ability to change name and delay, to get cronTrigger Id
	and previous CWSchedulable, and to set cron string and/or
	scheduled time.  scheduleThis method now attempts to abort
	jobs that failed to schedule properly.

@see		CWSchedulableTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public abstract class CWSchedulable implements Schedulable
{
	/*******************************************************
				defined constants
	*******************************************************/

	public static final String	defaultName				= 'CWSchedulable';
	public static final Integer	defaultDelaySeconds		= 5;
	public static final Integer	minDelaySeconds			= 2;
	public static final Integer	maxScheduleAttempts		= 10;

	/*******************************************************
				cwExecute method

	This abstract method must be overriden by the class that
	extends CWSchedulable.  It substitutes for the "execute"
	method of the Schedulable interface, and takes the same
	parameter: a SchedulableContext.
	*******************************************************/

	protected abstract void cwExecute( SchedulableContext sc );

	/*******************************************************
				execute method

	This method is required to implement the Schedulable
	interface.  When called, it passes its SchedulableContext
	parameter to the "cwExecute" method implemented by the
	class that extends CWSchedulable.
	*******************************************************/

	public void execute( SchedulableContext sc )
	{
		cwExecute( sc );
	}

	/*******************************************************
				CWSchedulable members
	*******************************************************/

	public	String	schedulableName
	{
		get { return schedulableName != null ? schedulableName : defaultName; }
		set { if ( String.isNotBlank( value ) ) schedulableName = value; }
	}

	public	Integer	delaySeconds
	{
		get { return delaySeconds != null ? delaySeconds : defaultDelaySeconds; }
		set { if ( value != null && value >= minDelaySeconds ) delaySeconds = value; }
	}

	public	Id		cronTriggerId
	{
		get;
		private set;
	}

	public	CWSchedulable	previousSchedulable
	{
		get;
		private set;
	}

	public	DateTime	scheduledTime
	{
		get;
		set;
	}

	public	String		cronString
	{
		get
		{
			return
				cronString		!= null	?	cronString
			:	scheduledTime	!= null	?	scheduledTime.format( 's m H d M ? yyyy' )
			:								null;
		}
		set;
	}

	/*******************************************************
				CWSchedulable constructors

	These constructors are protected and can only be called
	by the class that extends CWSchedulable.  One cannot
	construct a CWSchedulable object directly.
	*******************************************************/

	protected CWSchedulable( String name )
	{
		schedulableName = name;
	}

	protected CWSchedulable()
	{
		//	nothing to do here...
	}

	/*******************************************************
				scheduleThis method

	This method allows a CWSchedulable object to schedule itself.

	It returns the Id of the CronTrigger record created by the
	"System.schedule" method.
	*******************************************************/

	private Id scheduleThis()
	{
		Set<String> set_badJobNames = new Set<String>();

		for ( Integer numScheduleAttempts = 0; numScheduleAttempts < maxScheduleAttempts; numScheduleAttempts++ )
		{
			DateTime now		= DateTime.now();
			DateTime soonest	= now.addSeconds( delaySeconds );

			if ( scheduledTime == null || scheduledTime < soonest ) scheduledTime = soonest;

			cronTriggerId = null;

			String	jobName =
				schedulableName
			+	'-'
			+	now.format( 'yyyy-MM-dd HH:mm:ss.SSS' )
			+	String.valueOf( Math.random() );

			try
			{
				cronTriggerId = theSystem.schedule( jobName, cronString, this );
				break;
			}
			catch ( Exception e )
			{
				set_badJobNames.add( jobName );
			}
		}

		if	(	!set_badJobNames.isEmpty()
			&&	Limits.getLimitQueries() - Limits.getQueries() >= 1
			)
		{
			for ( Id jobId : theSystem.getJobsByName( set_badJobNames ) )
			{
				theSystem.abortJob( jobId );
			}
		}

		return cronTriggerId;
	}

	/*******************************************************
				scheduleNext method

	This method allows one CWSchedulable object to schedule
	another CWSchedulable object according to the values in
	the object to be scheduled.  Note that the object to be
	scheduled can be "this" - i.e. the object doing the
	scheduling (a CWSchedulable object can schedule itself).

	It returns the Id of the CronTrigger record created by the
	"System.schedule" method.
	*******************************************************/

	protected Id scheduleNext( CWSchedulable theJob )
	{
		if ( theJob == null ) return null;

		theJob.previousSchedulable = this;

		return theJob.scheduleThis();
	}

	/*******************************************************
				schedule method

	This method is a public, override-able interface for
	scheduling a CWSchedulable object.

	It returns the Id of the CronTrigger record created by the
	"System.schedule" method.
	*******************************************************/

	public virtual Id schedule()
	{
		return scheduleNext( this );
	}

	/*******************************************************
				Strategy class

	This virtual class provides an overridable interface to
	the System methods "schedule" and "abortJob", as well as
	a method for querying scheduled jobs by name.

	The methods should be overridden by test methods to allow
	controlled functional testing.
	*******************************************************/

	public virtual class Strategy
	{
		public virtual Id schedule( String jobName, String cronString, CWSchedulable job )
		{
			return System.schedule( jobName, cronString, job );
		}

		public virtual void abortJob( String jobId )
		{
			System.abortJob( jobId );
		}

		public virtual Set<Id> getJobsByName( Set<String> jobNames )
		{
			return (new Map<Id,CronTrigger>( [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name IN :jobNames] )).keySet();
		}
	}

	/*******************************************************
				strategy property

	The strategy property defaults to a Strategy object unless
	overridden by the calling module.
	*******************************************************/

	public	Strategy	theSystem
	{
		private get { return theSystem != null ? theSystem : new Strategy(); }
		set;
	}
}