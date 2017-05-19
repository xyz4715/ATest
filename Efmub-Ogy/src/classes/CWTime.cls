/*******************************************************//**

@class		CWTime

@brief		CW Core Time Class

	This class provides functionality related to Time, Date,
	DateTime and BusinessHours.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-08-12	LiquidHub.GHA
	Created.
@version	2014-10-20	LiquidHub.GHA
	Changed Weekday enum values to uppercase.

@see		CWTimeTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWTime
{
	public static DateTime now
	{
		get
		{
			if ( now == null )
			{
				now = DateTime.now();
			}
			return now;
		}
		private set;
	}

	public static void setNow( DateTime theDateTime )
	{
		now = theDateTime;
	}

	public static Date today
	{
		get { return now.date(); }
	}

	public static Time currentTime
	{
		get { return now.time(); }
	}

	public enum Weekday
	{
		SUNDAY,
		MONDAY,
		TUESDAY,
		WEDNESDAY,
		THURSDAY,
		FRIDAY,
		SATURDAY
	}

	//	returns the Weekday for the first day of the given year
	//	valid for years between 2001 and 2099 inclusive
	//	note that 2001 began on a Monday
	public static Weekday firstDayOfYear( Integer theYear )
	{
		if ( theYear < 2001 || theYear > 2099 ) return null;
		theYear -= 2001;
		return Weekday.values()[ Math.mod( theYear + theYear/4 + Weekday.Monday.ordinal(), 7 ) ];
	}

	//	returns the Weekday for the given date
	public static Weekday dayOfWeek( Date theDate )
	{
		if ( theDate == null ) return null;
		Weekday firstDay = firstDayOfYear( theDate.year() );
		if ( firstDay == null ) return null;
		return Weekday.values()[ Math.mod( firstDay.ordinal() + theDate.dayOfYear() - 1, 7 ) ];
	}

	public static Weekday currentDayOfWeek()
	{
		return dayOfWeek( today );
	}

	public static BusinessHours businessHours
	{
		get
		{
			if ( businessHours == null )
			{
				CWQuery		businessHoursQuery	= CWQuery.newQuery( 'BusinessHours' );
				businessHoursQuery.addAllFields();
				businessHoursQuery.newWhereClause( 'IsDefault = true AND IsActive = true' );

				for ( BusinessHours hours : (List<BusinessHours>) businessHoursQuery.query() )
				{
					businessHours = hours;
					break;
				}
			}
			return businessHours;
		}
	}

	public static Time startTime( Date theDate )
	{
		Weekday theDayOfWeek = dayOfWeek( theDate );

		return
			theDayOfWeek == Weekday.SUNDAY		?	businessHours.SundayStartTime
		:	theDayOfWeek == Weekday.MONDAY		?	businessHours.MondayStartTime
		:	theDayOfWeek == Weekday.TUESDAY		?	businessHours.TuesdayStartTime
		:	theDayOfWeek == Weekday.WEDNESDAY	?	businessHours.WednesdayStartTime
		:	theDayOfWeek == Weekday.THURSDAY	?	businessHours.ThursdayStartTime
		:	theDayOfWeek == Weekday.FRIDAY		?	businessHours.FridayStartTime
		: /*theDayOfWeek == Weekday.SATURDAY	?*/	businessHours.SaturdayStartTime;
	}

	public static DateTime startDateTime( Date theDate )
	{
		return DateTime.newInstance( theDate, startTime( theDate ) );
	}

	public static Time endTime( Date theDate )
	{
		Weekday theDayOfWeek = dayOfWeek( theDate );

		return
			theDayOfWeek == Weekday.SUNDAY		?	businessHours.SundayEndTime
		:	theDayOfWeek == Weekday.MONDAY		?	businessHours.MondayEndTime
		:	theDayOfWeek == Weekday.TUESDAY		?	businessHours.TuesdayEndTime
		:	theDayOfWeek == Weekday.WEDNESDAY	?	businessHours.WednesdayEndTime
		:	theDayOfWeek == Weekday.THURSDAY	?	businessHours.ThursdayEndTime
		:	theDayOfWeek == Weekday.FRIDAY		?	businessHours.FridayEndTime
		: /*theDayOfWeek == Weekday.SATURDAY	?*/	businessHours.SaturdayEndTime;
	}

	public static DateTime endDateTime( Date theDate )
	{
		return DateTime.newInstance( theDate, endTime( theDate ) );
	}

	public static Boolean isBusinessDay( Date theDate )
	{
		return
			startTime( theDate ) != null
		&&	endTime( theDate ) != null
		&&	System.BusinessHours.isWithin( businessHours.Id, startDateTime( theDate ) );	//	this will be false on holidays
	}

	public static Boolean isDuringBusinessHours( DateTime theDateTime )
	{
		return System.BusinessHours.isWithin( businessHours.Id, theDateTime );
	}

	public static Long lengthOfBusinessDay( Date theDate )
	{
		Time theStartTime	= startTime( theDate );
		Time theEndTime		= endTime( theDate );

		if ( theStartTime == null || theEndTime == null ) return 0L;

		Long startMilliseconds	= ((theStartTime.hour()*60L	+ theStartTime.minute())*60L	+ theStartTime.second())*1000L	+ theStartTime.millisecond();
		Long endMilliseconds	= ((theEndTime  .hour()*60L	+ theEndTime  .minute())*60L	+ theEndTime  .second())*1000L	+ theEndTime  .millisecond();

		return endMilliseconds - startMilliseconds;
	}

	public static Date addBusinessDays( Date theDate, Integer numDays )
	{
		if ( theDate == null || numDays == null || numDays <= 0 ) return null;

		for ( Integer daysOffset = 0; daysOffset < numDays; daysOffset++ )
		{
			//	find the next date that is a business day
			do
			{
				theDate = theDate.addDays( 1 );
			}
			while ( !isBusinessDay( theDate ) );
		}
		return theDate;
	}

	public static Date nextBusinessDay( Date theDate )
	{
		return addBusinessDays( theDate, 1 );
	}

}