/*******************************************************//**

@class		CWRandomTest

@brief		Test Code for the CWRandom Class

	Test code for the CWRandom class.
	Note that there are no asserts in this test class,
	as all results are random!

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-09-17	LiquidHub.GHA
	Created.

@see		CWRandom

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWRandomTest
{
	static testMethod void testCWRandom()
	{
		{
			Double	low		= 10.0;
			Double	high	= 20.0;
			Double	value	= CWRandom.random( low, high );
					value	= CWRandom.random( high, low );
		}

		{
			Integer	low		= 10;
			Integer	high	= 20;
			Integer	value	= CWRandom.random( low, high );
					value	= CWRandom.random( high, low );
		}

		{
			Double	chance	= 25.0;
			Boolean	maybe	= CWRandom.percentChance( chance );
		}

		{
			Integer	chance	= 25;
			Boolean	maybe	= CWRandom.percentChance( chance );
		}

		{
			Boolean	maybe	= CWRandom.coinFlip();
		}

		List<Integer> numbers	= new List<Integer>{ 1, 2, 3, 4, 5, 6, 7, 8, 9 };
		CWRandom.randomize( CWRandom.randomize( numbers ) ).toList();
	}
}