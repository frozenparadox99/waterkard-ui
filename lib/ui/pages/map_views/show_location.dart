import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowLocationScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  ShowLocationScreen(this.latitude,this.longitude);

  @override
  _ShowLocationScreenState createState() => _ShowLocationScreenState();
}

class _ShowLocationScreenState extends State<ShowLocationScreen> {



  Set<Marker> _markers = {};



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 15
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController _controller){
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("id-1"),
        position: LatLng(widget.latitude, widget.longitude),
      ));
    });
  }

}