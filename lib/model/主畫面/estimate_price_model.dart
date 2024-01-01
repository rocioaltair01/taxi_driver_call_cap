class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Bounds {
  final Location northeast;
  final Location southwest;

  Bounds({required this.northeast, required this.southwest});

  factory Bounds.fromJson(Map<String, dynamic> json) {
    return Bounds(
      northeast: Location.fromJson(json['northeast']),
      southwest: Location.fromJson(json['southwest']),
    );
  }
}

class Distance {
  final String text;
  final int value;

  Distance({required this.text, required this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'],
      value: json['value'],
    );
  }
}

class Duration {
  final String text;
  final int value;

  Duration({required this.text, required this.value});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      text: json['text'],
      value: json['value'],
    );
  }
}

class PolylineInfo {
  String points;

  PolylineInfo({required this.points});

  factory PolylineInfo.fromJson(Map<String, dynamic> json) {
    return PolylineInfo(
      points: json['points'],
    );
  }
}

class Step {
  Distance distance;
  Duration duration;
  Location endLocation;
  String htmlInstructions;
  Location startLocation;
  String travelMode;
  PolylineInfo polyline;

  Step({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.startLocation,
    required this.travelMode,
    required this.polyline,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      distance: Distance.fromJson(json['distance']),
      duration: Duration.fromJson(json['duration']),
      endLocation: Location.fromJson(json['end_location']),
      htmlInstructions: json['html_instructions'],
      startLocation: Location.fromJson(json['start_location']),
      travelMode: json['travel_mode'],
      polyline: PolylineInfo.fromJson(json['polyline']),
    );
  }
}

class Leg {
  final Distance distance;
  final Duration duration;
  final String endAddress;
  final Location endLocation;
  final String startAddress;
  final Location startLocation;
  final  List<Step> step;

  Leg({required this.distance, required this.duration,required this.endAddress, required this.endLocation, required this.startAddress, required this.startLocation,required this.step, });

  factory Leg.fromJson(Map<String, dynamic> json) {
    List<dynamic> stepsJson = json['steps'];
    List<Step> parsedSteps = stepsJson.map((step) => Step.fromJson(step)).toList();

    return Leg(
      distance: Distance.fromJson(json['distance']),
      duration: Duration.fromJson(json['duration']),
      endAddress: json['end_address'],
      endLocation: Location.fromJson(json['end_location']),
      startAddress: json['start_address'],
      startLocation: Location.fromJson(json['start_location']),
      step: parsedSteps
    );
  }
}

class Route {
  final Bounds bounds;
  final String copyrights;
  final List<Leg> legs;

  Route({required this.bounds, required this.copyrights, required this.legs});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      bounds: Bounds.fromJson(json['bounds']),
      copyrights: json['copyrights'],
      legs: List<Leg>.from(
        json['legs'].map(
              (leg) => Leg.fromJson(leg),
        ),
      ),
    );
  }
}

class GeocodedWaypoint {
  final String geocoderStatus;
  final String placeId;
  final List<String> types;

  GeocodedWaypoint({
    required this.geocoderStatus,
    required this.placeId,
    required this.types,
  });

  factory GeocodedWaypoint.fromJson(Map<String, dynamic> json) {
    return GeocodedWaypoint(
      geocoderStatus: json['geocoder_status'],
      placeId: json['place_id'],
      types: List<String>.from(json['types']),
    );
  }
}

class RoutesResponse {
  final List<GeocodedWaypoint> geocodedWaypoints;
  final List<Route> routes;

  RoutesResponse({
    required this.geocodedWaypoints,
    required this.routes,
  });

  factory RoutesResponse.fromJson(Map<String, dynamic> json) {
    return RoutesResponse(
      geocodedWaypoints: List<GeocodedWaypoint>.from(
        json['geocoded_waypoints'].map(
              (waypoint) => GeocodedWaypoint.fromJson(waypoint),
        ),
      ),
      routes: List<Route>.from(
        json['routes'].map(
              (route) => Route.fromJson(route),
        ),
      ),
    );
  }
}


class Place {
  final String formattedAddress;
  final PlaceGeometry geometry;
  final String icon;
  final String iconBackgroundColor;
  final String iconMaskBaseUri;
  final String name;
  //final List<PlacePhoto> photos;
  final String placeId;
  final String reference;
  final List<String> types;
  //final double? rating; // Optional field
  //final int? userRatingsTotal; // Optional field

  Place({
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    //required this.photos,
    required this.placeId,
    required this.reference,
    required this.types,
    //this.rating,
    // this.userRatingsTotal,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      formattedAddress: json['formatted_address'],
      geometry: PlaceGeometry.fromJson(json['geometry']),
      icon: json['icon'],
      iconBackgroundColor: json['icon_background_color'],
      iconMaskBaseUri: json['icon_mask_base_uri'],
      name: json['name'],
      // photos: (json['photos'] as List)
      //     .map((photoJson) => PlacePhoto.fromJson(photoJson))
      //     .toList(),
      placeId: json['place_id'],
      reference: json['reference'],
      types: List<String>.from(json['types']),
      // rating: json['rating']?.toDouble(),
      //userRatingsTotal: json['user_ratings_total'],
    );
  }
}

class PlaceGeometry {
  final PlaceLocation location;
  final PlaceViewport viewport;

  PlaceGeometry({
    required this.location,
    required this.viewport,
  });

  factory PlaceGeometry.fromJson(Map<String, dynamic> json) {
    return PlaceGeometry(
      location: PlaceLocation.fromJson(json['location']),
      viewport: PlaceViewport.fromJson(json['viewport']),
    );
  }
}

class PlaceLocation {
  final double lat;
  final double lng;

  PlaceLocation({
    required this.lat,
    required this.lng,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class PlaceViewport {
  final PlaceLocation northeast;
  final PlaceLocation southwest;

  PlaceViewport({
    required this.northeast,
    required this.southwest,
  });

  factory PlaceViewport.fromJson(Map<String, dynamic> json) {
    return PlaceViewport(
      northeast: PlaceLocation.fromJson(json['northeast']),
      southwest: PlaceLocation.fromJson(json['southwest']),
    );
  }
}

class PlacePhoto {
  final int height;
  final List<String> htmlAttributions;
  final String photoReference;
  final int width;

  PlacePhoto({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  factory PlacePhoto.fromJson(Map<String, dynamic> json) {
    return PlacePhoto(
      height: json['height'],
      htmlAttributions: List<String>.from(json['html_attributions']),
      photoReference: json['photo_reference'],
      width: json['width'],
    );
  }
}
