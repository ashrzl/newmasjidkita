import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:compassx/compassx.dart';

class QiblahPage extends StatefulWidget {
  @override
  _QiblahPageState createState() => _QiblahPageState();
}

class _QiblahPageState extends State<QiblahPage> {
  double? deviceHeading;  // The current heading of the device (from the compass)
  double? userLat;
  double? userLon;
  double? qiblahDirection;  // The calculated Qiblah direction (bearing)
  bool isLocationFetched = false; // Flag to track if location and direction are fetched

  // Qiblah coordinates (Kaaba's lat, lon)
  final double qiblahLat = 21.4225;
  final double qiblahLon = 39.8262;

  @override
  void initState() {
    super.initState();
    _startCompassListener();
  }

  // Start listening to the compass
  void _startCompassListener() {
    CompassX.events.listen((CompassXEvent event) {
      setState(() {
        deviceHeading = event.heading;
      });
    });
  }

  // Get current location and calculate Qiblah direction
  Future<void> _getLocationAndCalculateQiblah() async {
    // If location has been already fetched, no need to fetch again
    if (isLocationFetched) return;

    // Get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLat = position.latitude;
      userLon = position.longitude;
      isLocationFetched = true; // Mark location as fetched
    });

    if (userLat != null && userLon != null) {
      // Calculate the Qiblah direction (bearing) using the Haversine formula
      double qiblahBearing = _calculateQiblahBearing(userLat!, userLon!, qiblahLat, qiblahLon);
      setState(() {
        qiblahDirection = qiblahBearing;
      });
    }
  }

  // Calculate the Qiblah bearing from the user's location to the Kaaba
  double _calculateQiblahBearing(double userLat, double userLon, double qiblahLat, double qiblahLon) {
    // Convert degrees to radians
    double lat1 = userLat * pi / 180;
    double lon1 = userLon * pi / 180;
    double lat2 = qiblahLat * pi / 180;
    double lon2 = qiblahLon * pi / 180;

    // Calculate the bearing using the formula
    double deltaLon = lon2 - lon1;
    double x = sin(deltaLon) * cos(lat2);
    double y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);

    // Calculate the angle (bearing) and convert to degrees
    double bearing = atan2(x, y) * 180 / pi;

    // Normalize the bearing to be between 0 and 360
    if (bearing < 0) {
      bearing += 360;
    }

    return bearing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qiblah Direction")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to fetch location and calculate Qiblah
            ElevatedButton(
              onPressed: () async {
                // Fetch location and calculate Qiblah only if not fetched before
                if (!isLocationFetched) {
                  await _getLocationAndCalculateQiblah();
                }
              },
              child: Text("Get Qiblah Direction"),
            ),
            SizedBox(height: 30),
            // Show current location (latitude and longitude)
            userLat == null || userLon == null
                ? CircularProgressIndicator()
                : Column(
              children: [
                Text("Current Location:"),
                Text("Latitude: ${userLat!.toStringAsFixed(4)}"),
                Text("Longitude: ${userLon!.toStringAsFixed(4)}"),
              ],
            ),
            SizedBox(height: 30),
            // Show Qiblah direction and the arrow
            qiblahDirection == null || deviceHeading == null
                ? CircularProgressIndicator()
                : Column(
              children: [
                // Rotate the arrow to show the Qiblah direction
                Transform.rotate(
                  angle: _calculateRotationAngle(),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 100,
                    color: _isHeadingTowardsQiblah()
                        ? Colors.green // Green when pointing towards Qiblah
                        : Colors.blue, // Default color
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Qiblah Direction: ${qiblahDirection!.toStringAsFixed(2)}°",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calculate the rotation angle for the arrow to point towards Qiblah
  double _calculateRotationAngle() {
    if (deviceHeading != null && qiblahDirection != null) {
      // Normalize the heading difference to be between 0 and 360 degrees
      double headingDifference = (deviceHeading! - qiblahDirection!);
      if (headingDifference < 0) {
        headingDifference += 360;
      }
      return headingDifference * pi / 180;  // Convert to radians for Transform.rotate
    }
    return 0.0;
  }

  // Determine if the device is pointing towards the Qiblah
  bool _isHeadingTowardsQiblah() {
    if (deviceHeading != null && qiblahDirection != null) {
      // Calculate the angle difference between the device heading and Qiblah direction
      double angleDifference = (deviceHeading! + qiblahDirection!).abs();
      if (angleDifference > 180) {
        angleDifference = 360 - angleDifference;  // Ensure the smallest angle difference
      }
      return angleDifference < 10.0;  // Tolerance of 10 degrees
    }
    return false;
  }
}
