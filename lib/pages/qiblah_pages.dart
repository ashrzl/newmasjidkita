import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class QiblahCompassPage extends StatefulWidget {
  @override
  _QiblahCompassPageState createState() => _QiblahCompassPageState();
}

class _QiblahCompassPageState extends State<QiblahCompassPage> {
  String? _currentAddress;
  bool _isFetchingLocation = true;

  @override
  void initState() {
    super.initState();
    _determineLocation();
  }

  Future<void> _determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get the current location
    final position = await Geolocator.getCurrentPosition();
    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final place = placemarks.first;

      setState(() {
        _currentAddress = "${place.locality}, ${place.administrativeArea}";
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Could not determine location";
        _isFetchingLocation = false;
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: Text("Arah Kiblat",style: TextStyle(color: Colors.white)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background1.jpg'), // Set your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder(
            future: _checkLocationPermission(),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || _isFetchingLocation) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == true) {
                return StreamBuilder(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final direction = snapshot.data!;
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${direction.offset.toStringAsFixed(1)}°",
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _currentAddress ?? "Loading location...",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Transform.rotate(
                              angle: direction.qiblah,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/compass.png', // Replace with your compass image asset
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 15,
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Color(0xFF6A1B9A),
                                      size: 50,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    child: Image.asset(
                                      'assets/qiblaneedle.png', // Replace with your Kaaba icon asset
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("Location permission required."));
              }
            },
          ),
        ],
      ),
    );
  }
}
