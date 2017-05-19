/*******************************************************//**

@class		CWTimeTest

@brief		Test Class for CWTime and related classes

	This class implements support for web callouts using HTTP.

@author		Janeen Anderson		(ClosedWon.JDA)

@version 	2014-12-17	ClosedWon.JDA
	Created.

@todo		Add assertions (93% covered)

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest(seeAllData=true)
public class CWTimeTest
{
	private static testMethod void testCWTime()
	{
		CWTest		testResults		= new CWTest( 'CWTimeTest 1' );
		DateTime	TestDateTime	= DateTime.newInstance( 2012, 11, 5, 16, 0, 0 );	//	November 5, 2012 4pm GMT

		testResults.startTest();

		CWTime		aTimeOBJ	= new CWTime();
		DateTime	TestNow		= CWTime.now;
		CWTime.setNow( TestDateTime );

		Date	TestDate		= CWTime.today;			//	assert TestDate is Nov, 5 2012
		Time	TestTime		= CWTime.currentTime;	//	assert Time is 4pm GMT plus a little
		CWTime.firstDayOfYear( 2012 );					//	assert Sunday
		CWTime.dayOfWeek( TestDate );					//	assert Monday
		CWTime.currentDayOfWeek();						//	assert Monday

		BusinessHours	theBIZHours		= CWTime.businessHours;
		CWTime.startTime( TestDate );
		CWTime.endTime( TestDate );
		CWTime.startDateTime( TestDate );
		CWTime.endDateTime( TestDate );
		CWTime.isBusinessDay( TestDate );
		CWTime.isDuringBusinessHours( TestDate );
		CWTime.lengthOfBusinessDay( TestDate );
		CWTime.addBusinessDays( TestDate, 5 );
		CWTime.nextBusinessDay( TestDate );

		testResults.stopTest();
		testResults.report();
	}
}