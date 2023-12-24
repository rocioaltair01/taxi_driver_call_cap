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
