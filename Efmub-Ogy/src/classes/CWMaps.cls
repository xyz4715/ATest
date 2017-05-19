/*******************************************************//**

@class		CWMaps

@brief		CW Core Google Maps Class

	This class implements Google Maps for embedding in web pages.

@author		Glyn Anderson (LiquidHub.GHA)

@version	2014-10-12	LiquidHub.GHA
	Created.

@todo		Increase browser compatibility

@see		CWMapsTest

	(c)2014-2015 LiquidHub.  All Rights Reserved.  Unauthorized use is prohibited.

	This is a component of CW Core (tm), LiquidHub's middleware library for Salesforce.

***********************************************************/

public class CWMaps
{
	/*******************************************************
					googleMapsAPI property

	Returns the URL of the required version of the Google Maps
	API, including the appropriate API key, if any.
	*******************************************************/

	public static	String		googleMapsAPI
	{
		get
		{
			String	key = (String) CWCoreConfiguration.get( 'Google_API_Key__c' );
			return 'https://maps.googleapis.com/maps/api/js?v=3' + (key != null ? '&key=' + key : '');
		}
	}

	/*******************************************************
					GoogleMap class

	Represents a client-side Map object.
	*******************************************************/

	public class GoogleMap
	{
		private	Double					latitude;
		private	Double					longitude;
		private	Integer					zoom;
		private	List<GoogleMapsMarker>	markers;

		public GoogleMap( Double lat, Double lng, Integer zume )
		{
			latitude	= lat;
			longitude	= lng;
			zoom		= zume;
			markers		= new List<GoogleMapsMarker>();
		}

		public GoogleMap( Decimal lat, Decimal lng, Integer zume )
		{
			this( Double.valueOf( lat ), Double.valueOf( lng ), zume );
		}

		public void add( GoogleMapsMarker marker )
		{
			if ( marker != null ) markers.add( marker );
		}

		public String	embed
		{
			get
			{
				List<String>	strings		= new List<String>();

				strings.add( 'function( options, returnMap ) { '																);
				strings.add(	 'google.maps.event.addDomListener( window, "load", function() { '								);
				strings.add(		 'var mapObject = new Object(); '															);
				strings.add(		 'mapObject.elementId = (options && options.elementId) || options || "map_canvas"; '		);
				strings.add(		 'mapObject.map = new google.maps.Map( document.getElementById( mapObject.elementId ), { '	);
				strings.add(			 'center: { lat: ' + latitude + ', lng: ' + longitude + ' }, '							);
				strings.add(			 'zoom: (options && options.zoom) || ' + zoom + ', '									);
				strings.add(			 'scrollwheel: false '																	);
				strings.add(		 '} ); '																					);
				strings.add(		 'mapObject.infoWindow = new google.maps.InfoWindow( { '									);
				strings.add(		 '} ); '																					);
				strings.add(		 'mapObject.markers = new Array(); '														);

				Integer	index = 0;
				for ( GoogleMapsMarker marker : markers ) strings.add( marker.embed( index++ ) );

				strings.add(		 'google.maps.event.addListener( mapObject.map, "click", function() { '						);
				strings.add(			 'mapObject.infoWindow.close(); '														);
				strings.add(			 'mapObject.infoWindowMarker = null; '													);
				strings.add(		 '} ); '																					);
				strings.add(		 'mapObject.infoWindowMarker = null; '														);
				strings.add(		 'if ( returnMap ) returnMap( mapObject ); '												);
				strings.add(	 '} ); '																						);
				strings.add( '}'																								);

				return CWString.join( strings );
			}
		}
	}

	/*******************************************************
					GoogleMapsMarker class

	Represents a client-side Marker object.
	*******************************************************/

	public class GoogleMapsMarker
	{
		private	Double	latitude;
		private	Double	longitude;
		private	String	title;
		private	String	content;

		public GoogleMapsMarker( Double lat, Double lng )
		{
			latitude	= lat;
			longitude	= lng;
		}

		public GoogleMapsMarker( Decimal lat, Decimal lng )
		{
			this( Double.valueOf( lat ), Double.valueOf( lng ) );
		}

		public void setTitle( String theTitle )
		{
			title	= theTitle;
		}

		public void setContent( String theContent )
		{
			content	= theContent;
		}

		private String embed( Integer index )
		{
			List<String>	strings		= new List<String>();

			strings.add( 'mapObject.markers[' + index + '] = new google.maps.Marker( { '		);
			strings.add(	 'map: mapObject.map, '												);
			if ( title != null ) strings.add(	 'title: "' + title.escapeEcmaScript() + '", '	);
			strings.add(	 'position: { lat: ' + latitude + ', lng: ' + longitude + ' } '		);
			strings.add( '} ); '																);

			if ( content != null )
			{
				strings.add( 'google.maps.event.addListener( mapObject.markers[' + index + '], "click", function() { '	);
				strings.add(	 'if ( mapObject.infoWindowMarker === this ) { '										);
				strings.add(		 'mapObject.infoWindow.close(); '													);
				strings.add(		 'mapObject.infoWindowMarker = null; '												);
				strings.add(	 '} else { '																			);
				strings.add(		 'mapObject.infoWindow.setContent( "' + content.escapeEcmaScript() + '" ); '		);
				strings.add(		 'mapObject.infoWindow.open( mapObject.map, mapObject.markers[' + index + '] ); '	);
				strings.add(		 'mapObject.infoWindowMarker = this; '												);
				strings.add(	 '} '																					);
				strings.add( '} ); '																					);
			}

			return CWString.join( strings );
		}
	}
}