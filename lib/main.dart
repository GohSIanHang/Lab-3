import 'dart:async';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MaterialApp(home: MyApp()));
double latitude, longitude;
String curaddress;
double screenHeight, screenWidth;
Position _currentPosition;
Completer<GoogleMapController> _controller = Completer();
GoogleMapController gmcontroller;
CameraPosition _home;
MarkerId markerId1 = MarkerId("12");
Set<Marker> markers = Set();
CameraPosition _userpos;
double latitude1, longitude2;
String curaddress1;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    latitude1 = 6.4676929;
    longitude2 = 100.5067673;
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        home: Scaffold(
            body: new Stack(children: <Widget>[
      Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/map.PNG"),
            fit: BoxFit.fill,
          ),
        ),
        child: InkWell(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 1),
                      child: SizedBox(width: 2, child: Container())),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                      Colors.blueGrey[900],
                      Colors.blueGrey[800],
                      Colors.blueGrey[900],
                    ])),
                    height: screenHeight / 2.3,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Google Maps",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          minWidth: 80,
                          height: 80,
                          color: Colors.green[600],
                          onPressed: () => {_loadMapDialog()},
                          child: Icon(
                            MdiIcons.locationEnter,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: Container(
                            child: Text(
                              "Current Address: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decorationStyle: TextDecorationStyle.wavy,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text("  "),
                            Flexible(
                              child: Text(
                                curaddress ?? "Address not set",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: Container(
                            child: Text(
                              "Latitude: " + latitude1.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                                decorationStyle: TextDecorationStyle.wavy,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                            child: Text(
                              "Longitude: " + longitude2.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                                decorationStyle: TextDecorationStyle.wavy,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
                ],
              ))
            ],
          ),
        ),
      )
    ])));
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(latitude1, longitude2);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    final CameraPosition _currPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        bearing: 0,
        tilt: 0,
        zoom: 17);

    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currPosition));
    print("${first.featureName} : ${first.addressLine}");
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(
                  "Select Your Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  Text(
                    curaddress +
                        "\n\nLatitude: " +
                        latitude1.toString() +
                        "\nLongitude: " +
                        longitude2.toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 80,
                        height: 30,
                        child: Text('Find Me'),
                        color: Colors.green,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          _getLocation();
                        },
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 80,
                        height: 30,
                        child: Text('Close'),
                        color: Colors.red,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {markers.clear(), Navigator.of(context).pop(false)},
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude1 = loc.latitude;
      longitude2 = loc.longitude;
      _getLocationfromlatlng(latitude1, longitude2, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 17,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude1, longitude2),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }
}
