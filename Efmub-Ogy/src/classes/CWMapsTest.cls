/*******************************************************//**

@class		CWMapsTest

@brief		Tests for CWMaps Class

	The CWMapsTest class contains the test methods for the
	CWMaps class.

@author		Glyn Anderson	(LiquidHub.GHA)

@version	2014-12-17	LiquidHub.GHA
	Created.

@see		CWMaps

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

@isTest
private class CWMapsTest
{
	private class Location
	{
		Double	latitude;
		Double	longitude;
		String	tooltip;
		String	information;

		public Location( Decimal lat, Decimal lng, String tip, String info )
		{
			latitude	= Double.valueOf( lat );
			longitude	= Double.valueOf( lng );
			tooltip		= tip;
			information	= info;
		}
	}

	private static testMethod void testCWMaps()
	{
		String	api	= CWMaps.googleMapsAPI;

		List<Location> locations = new List<Location>
		{
			new Location( 35.0841158,	-106.6482634,	'LiquidHub',		'This is where we work.' ),
			new Location( 35.0927408,	-106.6369599,	'TriCore',			'This is the client\'s location.' ),
			new Location( 35.141657,	-106.602438,	'Century Rio 24',	'This is a movie theater.' )
		};

		Double	minLat, maxLat;
		Double	minLng, maxLng;
		for ( Location loc : locations )
		{
			if ( minLat == null || loc.latitude < minLat ) minLat = loc.latitude;
			if ( maxLat == null || maxLat < loc.latitude ) maxLat = loc.latitude;
			if ( minLng == null || loc.longitude < minLng ) minLng = loc.longitude;
			if ( maxLng == null || maxLng < loc.longitude ) maxLng = loc.longitude;
		}
		Double	centerLat = ( minLat + maxLat ) / 2.0;
		Double	centerLng = ( minLng + maxLng ) / 2.0;

		CWMaps.GoogleMap	demoMap = new CWMaps.GoogleMap( Decimal.valueOf( centerLat ), Decimal.valueOf( centerLng ), 12 );
							demoMap = new CWMaps.GoogleMap( centerLat, centerLng, 12 );

		for ( Location loc : locations )
		{
			CWMaps.GoogleMapsMarker marker	= new CWMaps.GoogleMapsMarker( Decimal.valueOf( loc.latitude ), Decimal.valueOf( loc.longitude ) );
									marker	= new CWMaps.GoogleMapsMarker( loc.latitude, loc.longitude );
			marker.setTitle( loc.tooltip );
			marker.setContent( loc.information );
			demoMap.add( marker );
		}

		String	javaScript	= demoMap.embed;
	}
}