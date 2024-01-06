import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants.dart';
import '../../../model/user_data_singleton.dart';
import '../../../model/主畫面/estimate_price_model.dart';
import '../../../respository/主畫面/directions_api_request.dart';
import '../../../util/shared_util.dart';

class CountPricePage extends StatefulWidget {
  final List<TextEditingController> addressFieldControllers;
  const CountPricePage({super.key,  required this.addressFieldControllers});

  @override
  State<CountPricePage> createState() => _CountPricePageState();
}

class _CountPricePageState extends State<CountPricePage> {
  late GoogleMapController mapController;
  List<RoutesResponse> routesResponseList = [];
  bool isLoading = true;
  Set<Polyline> _polylines = {};
  bool switchValue = true;
  final DirectionsAPIRequest apiRequest = DirectionsAPIRequest();
  List<LatLng> markerLatLngList = [];

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = PolylinePoints().decodePolyline(encoded)
        .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
        .toList();
    return points;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    List<LatLng> polylineCoordinatesCenter = [
      LatLng(routesResponseList[0].routes[0].bounds.northeast.lat, routesResponseList[0].routes[0].bounds.northeast.lng), // San Francisco
      LatLng(routesResponseList[0].routes[0].bounds.southwest.lat, routesResponseList[0].routes[0].bounds.southwest.lng),
    ];

    LatLngBounds bounds = _calculateBounds(polylineCoordinatesCenter);
    if (mapController != null)
    {
      mapController.animateCamera(CameraUpdate.newLatLngBounds(
        bounds,
        50.0, // Padding
      ));
    }
  }

  Future<void> getDirections() async {
    int count = 0;

    while (count < widget.addressFieldControllers.length - 1) {
      String origin = widget.addressFieldControllers[count].text;
      String destination = widget.addressFieldControllers[count+1].text;

      String waypoints = '';
      String token = debug_google_api_key;
      bool avoidHighways = !switchValue;
      dynamic directionsData = await apiRequest.estimateDirections(
        origin,
        destination,
        waypoints,
        token,
        avoidHighways,
      );

      if (directionsData.containsKey("error")) {
        print("hey error ${directionsData["error"]}");
      } else {
        try {
          print("directionsData 1 $directionsData");
          RoutesResponse re = RoutesResponse.fromJson(directionsData);
          routesResponseList.add(re);
        } catch (e) {
          print("eeee $e");
        }
      }
      setState(() {
        isLoading = false;
      });
      count++;
    }
    _drawPoly();
  }

  void _drawPoly() {
    List<List<LatLng>> polylines = [];
    int count = 0;

    while (count < routesResponseList.length) {
      int len = routesResponseList[count].routes[0].legs[0].step.length;
      markerLatLngList.add(LatLng(
          routesResponseList[count].routes[0].legs[0].step[0].startLocation.lat,
          routesResponseList[count].routes[0].legs[0].step[0].startLocation.lng));
      markerLatLngList.add(LatLng(
          routesResponseList[count].routes[0].legs[0].step[len-1].endLocation.lat,
          routesResponseList[count].routes[0].legs[0].step[len-1].endLocation.lng));

      routesResponseList[count].routes[0].legs[0].step.forEach((element) {
        List<LatLng> polylineCoordinatesa = [
          LatLng(element.startLocation.lat, element.startLocation.lng),
          LatLng(element.endLocation.lat, element.endLocation.lng),
        ];

        LatLngBounds poly_line = _calculateBoundsPoly(polylineCoordinatesa);
        polylines.add([
          poly_line.northeast,
          poly_line.southwest
        ]);
      });

      addPolylines(polylines);
      count++;
    }
  }

  LatLngBounds _calculateBoundsPoly(List<LatLng> polylineCoordinates) {
    LatLng north = LatLng(0,0);
    LatLng south = LatLng(0,0);

    if (polylineCoordinates[0].latitude > polylineCoordinates[1].latitude)
    {
      north = polylineCoordinates[0];
      south = polylineCoordinates[1];
    } else {
      north = polylineCoordinates[1];
      south = polylineCoordinates[0];
    }
    return LatLngBounds(
      southwest: south,
      northeast: north,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getDirections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _buildMarkers(),
        initialData: Set.of(<Marker>[]),
        builder: (context, snapshot) => Scaffold(
            appBar: AppBar(
              title: Text('預估路線'),
            ),
            body: isLoading ? Container() : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: (routesResponseList.isNotEmpty) ? _calculateBoundsCenter(_polylines) : LatLng(0, 0),
                    zoom: 16.0,
                  ),
                  polylines: _polylines,
                  markers: snapshot.data!,
                ),
                Positioned(
                  top: 10,
                  left: (MediaQuery.of(context).size.width - 220) / 2,
                  child: Container(
                      width: 220,
                      padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                      //color: Colors.white,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // Border radius
                      ),
                      child: Center(
                        child: Container(
                          child:  Row(
                            children: [
                              Text(
                                '高速公路路徑',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              Expanded(child: Container()),
                              Switch(
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    _polylines = {};
                                    routesResponseList = [];
                                    switchValue = value;
                                    getDirections();
                                  });
                                },
                                activeTrackColor: Colors.redAccent,
                                activeColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),
                Positioned(
                    left: 0,
                    bottom: 30,
                    right: 0,
                    child:Padding(
                      padding: EdgeInsets.all(12),
                      child:  Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12), // Border radius
                                ),
                                width: 150,
                                child: Column(
                                  children: [
                                    Expanded(child: Text("金額:${routesResponseList.fold<String>("0.0", (prev, response) {
                                      if (response.routes.isNotEmpty &&
                                          response.routes[0].legs.isNotEmpty &&
                                          response.routes[0].legs[0].distance != null) {
                                        String distanceText = response.routes[0].legs[0].distance.text.replaceFirst(' 公里', '');
                                        //distanceText = response.routes[0].legs[0].distance.text.replaceFirst(' 公尺', '');
                                        double distanceValue = double.parse(distanceText);
                                        CalculatedInfo calculateInfo = UserDataSingleton.instance.setting.calculatedInfo;
                                        double price = calculateTotalCost(
                                            calculateInfo.perKmOfFare,
                                            calculateInfo.perMinOfFare,
                                            calculateInfo.initialFare,
                                            calculateInfo.upPerKmOfFare,
                                            calculateInfo.extraFare,calculateInfo.lowestFare,
                                            distanceValue,
                                            response.routes[0].legs[0].duration.value);
                                        return price.toInt().toString();
                                      }
                                      return "0"; // If the property is not available, return the accumulated value
                                    }).toString()} 元"),),
                                    Expanded(child: Text("公里數:${routesResponseList.fold<String>("0 km", (prev, response) {
                                      if (response.routes.isNotEmpty &&
                                          response.routes[0].legs.isNotEmpty &&
                                          response.routes[0].legs[0].distance != null) {
                                        try {
                                          String distanceText = response.routes[0].legs[0].distance.text.replaceFirst(' 公里', '');
                                          return response.routes[0].legs[0].distance.text ?? "0 km";
                                        } catch (e) {
                                          print('Error parsing distance: $e');
                                        }
                                      }
                                      return prev;
                                    })}"),),
                                    Expanded(child: Text("行車時間:${routesResponseList.fold<String>("0", (prev, response) {
                                      if (response!.routes.isNotEmpty &&
                                          response!.routes[0].legs.isNotEmpty &&
                                          response!.routes[0].legs[0].duration != null) {
                                        try {
                                          return response?.routes[0].legs[0].duration.text ?? "0 分鐘";
                                        } catch (e) {
                                          print('Error parsing distance: $e');
                                        }
                                      }
                                      return "0 分鐘"; // If the property is not available, return the accumulated value
                                    })}"),)
                                  ],
                                ),
                              ),
                            ),
                            Container(width: 18,),
                            Expanded(
                                child: Column(
                                  children: [
                                    Expanded(child: Container()),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            side: BorderSide(color: Colors.black, width: 1),// Adjust the value as needed
                                          ),
                                          primary: Colors.white,
                                          minimumSize: Size(double.infinity, 50),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            openGoogleMap();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/map.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            Container(width: 6,),
                                            Text(
                                              'Google map',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black
                                              ),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    )
                )
              ],
            )
        )
    );
  }

  void addPolylines(List<List<LatLng>> listOfPolylines) {
    for (var polylineCoordinates in listOfPolylines) {
      PolylineId id = PolylineId('poly${_polylines.length + 1}');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        width: 3,
        points: polylineCoordinates,
      );

      setState(() {
        _polylines.add(polyline);
      });
    }
  }

  void openGoogleMap() async {
    String startAddress = widget.addressFieldControllers[0].text;
    String endAddress = widget.addressFieldControllers[widget.addressFieldControllers.length-1].text;
    if (startAddress.isNotEmpty && endAddress.isNotEmpty) {
      String url = 'https://www.google.com/maps/dir/?api=1&origin=$startAddress&destination=$endAddress';
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Please enter start and end addresses');
    }
  }

  LatLng _calculateBoundsCenter(Set<Polyline> polylines) {
    List<LatLng> polylineCoordinates = [];
    for (Polyline polyline in polylines) {
      polylineCoordinates.addAll(polyline.points);
    }

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in polylineCoordinates) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    LatLng southwest = LatLng(minLat, minLng);
    LatLng northeast = LatLng(maxLat, maxLng);
    return LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> polylineCoordinates) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in polylineCoordinates) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    LatLng southwest = LatLng(minLat, minLng);
    LatLng northeast = LatLng(maxLat, maxLng);
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  Future<Set<Marker>> _buildMarkers() async{
    List<Marker> markers = <Marker>[];
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)), 'assets/images/marker.png');

    markerLatLngList.forEach((element) {
      Marker startMarker = Marker(
          markerId: MarkerId('start${element.longitude}'),
          position: element,
          // infoWindow: InfoWindow(title: 'Start'),
          icon: icon
      );
      markers.add(startMarker);
    });
    return markers.toSet();
  }
}
