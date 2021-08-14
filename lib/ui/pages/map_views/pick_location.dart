import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocation extends StatefulWidget {
  double longi;
  double lati;
   PickLocation(this.lati, this.longi);

  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {

  // double _lat = 24.4;
  // double _lng = 77.6;

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.white,),
              onPressed: (){
                if(_markers.isEmpty){
                  SnackBar betterSnackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("Please select a location first"),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(betterSnackBar);
                }else{
                  Navigator.pop(context, _markers.first.position);
                }

              }
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.lati, widget.longi),
            zoom: 18
        ),
        onTap: (latlng){
          print(latlng);
          setState(() {
            _markers.clear();
            _markers.add(Marker(
              markerId: MarkerId("id-1"),
              position: latlng,
            ));
          });
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController _controller){}

}