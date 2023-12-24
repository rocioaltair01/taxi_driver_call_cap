import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryDetailMapPage extends StatefulWidget {
  final List<num> currentPosition;
  const HistoryDetailMapPage({Key? key , required this.currentPosition}) : super(key: key);

  @override
  State<HistoryDetailMapPage> createState() => _HistoryDetailMapPageState();
}

class _HistoryDetailMapPageState extends State<HistoryDetailMapPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker();
  }

  void _addMarker() {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('currentPosition'),
          position: LatLng(widget.currentPosition[1].toDouble(), widget.currentPosition[0].toDouble()),
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.currentPosition[1].toDouble(),widget.currentPosition[0].toDouble()),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        markers: markers,
      ),
    );
  }
}
