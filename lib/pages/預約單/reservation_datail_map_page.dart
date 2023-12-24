import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReservationDetailMapPage extends StatefulWidget {
  final List<double> currentPosition;
  const ReservationDetailMapPage({Key? key , required this.currentPosition}) : super(key: key);

  @override
  State<ReservationDetailMapPage> createState() => _ReservationDetailMapPageState();
}

class _ReservationDetailMapPageState extends State<ReservationDetailMapPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.currentPosition != [0,0])
      _addMarker();
  }

  void _addMarker() {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('currentPosition'),
          position: LatLng(widget.currentPosition[1], widget.currentPosition[0]),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'This is your current position',
          ),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: (widget.currentPosition != [0,0]) ? GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.currentPosition[1],widget.currentPosition[0]),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        markers: markers,
      ) : Container()
    );
  }
}
