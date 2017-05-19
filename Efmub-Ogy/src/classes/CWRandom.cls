/*******************************************************//**

@class		CWRandom

@brief		CW Core Random Class

	The CWRandom class provides random number generation and
	collection randomization functionality.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-09-17	LiquidHub.GHA
	Created.

@see		CWRandomTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWRandom
{
	/*******************************************************
				random methods (Double versions)

	Unlike the standard Math.random() method, these methods
	take optional arguments.  Specify an upperBound to get a
	number from 0 to upperBound-1.  Specify both a lowerBound
	and an upperBound to get a number between lowerBound and
	upperBound-1.
	*******************************************************/

	public static Double random()
	{
		return Math.random();
	}

	public static Double random( Double upperBound )
	{
		return upperBound * random();
	}

	public static Double random( Double lowerBound, Double upperBound )
	{
		return
			lowerBound < upperBound
		?	random( upperBound - lowerBound ) + lowerBound
		:	random( lowerBound - upperBound ) + upperBound;
	}

	/*******************************************************
				random methods (Integer versions)

	These methods are identical to their Double counterparts
	above, but take Integer arguments and return Integer values.
	*******************************************************/

	public static Integer random( Integer upperBound )
	{
		return Integer.valueOf( Math.floor( random( Double.valueOf( upperBound ) ) ) );
	}

	public static Integer random( Integer lowerBound, Integer upperBound )
	{
		return
			lowerBound < upperBound
		?	random( upperBound - lowerBound ) + lowerBound
		:	random( lowerBound - upperBound ) + upperBound;
	}

	/*******************************************************
					percentChance methods

	These methods take a percentage (a number from 0 to 100
	inclusive), and returns true that percent of the time.
	*******************************************************/

	public static Boolean percentChance( Double percent )
	{
		return random( Double.valueOf( 100.0 ) ) < percent;
	}

	public static Boolean percentChance( Integer percent )
	{
		return random( 100 ) < percent;
	}

	/*******************************************************
					probability method

	This method takes a probability (a number from 0.0 to 1.0
	inclusive), and returns true with that probability.
	*******************************************************/

	public static Boolean probability( Double probability )
	{
		return random() < probability;
	}

	/*******************************************************
					coinFlip method

	This method returns true half the time.
	*******************************************************/

	public static Boolean coinFlip()
	{
		return probability( Double.valueOf( 0.5 ) );
	}

	/*******************************************************
					RandomIterable class

	This class is used to create a CWIterable that iterates
	its elements in a random order.
	*******************************************************/

	private class RandomIterable extends CWIterable
	{
		public RandomIterable( Iterable<Object> anIterable )
		{
			super( anIterable );
		}

		public override Iterator<Object> Iterator()
		{
			return new RandomIterator( theIterable );
		}
	}

	/*******************************************************
					RandomIterator class

	This class is used to iterate elements in a random order.
	*******************************************************/

	private class RandomIterator implements Iterator<Object>
	{
		private List<Object>	theList;

		public RandomIterator( Iterable<Object> anIterable )
		{
			theList		= new List<Object>();

			Iterator<Object>	theIterator = anIterable.Iterator();
			while ( theIterator.hasNext() )
			{
				theList.add( theIterator.next() );
			}
		}

		public Boolean hasNext()
		{
			return !theList.isEmpty();
		}

		public Object next()
		{
			return hasNext() ? theList.remove( CWRandom.random( theList.size() ) ) : null;
		}
	}

	/*******************************************************
					randomize methods

	These methods return a CWIterable that iterates the elements
	of the wrapped collection in a random order.
	*******************************************************/

	private static CWIterable randomize( Iterable<Object> anIterable )
	{
		return anIterable != null ? new RandomIterable( anIterable ) : null;
	}

	public static CWIterable randomize( CWIterable anIterable )
	{
		return randomize( (Iterable<Object>) anIterable );
	}

	public static CWIterable randomize( List<Object> anIterable )
	{
		return randomize( (Iterable<Object>) anIterable );
	}
}