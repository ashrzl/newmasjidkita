import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:new_mk_v3/pages/home_pages.dart'; // Import intl package

class PrayerTimesPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  PrayerTimesPage({required this.latitude, required this.longitude});

  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  Map<String, dynamic>? prayerTimes;
  bool isLoading = true;
  String? errorMessage;
  String? _currentAddress;

  // Define the list of prayer names to display
  final List<String> prayerNames = [
    'Fajr',
    'Imsak',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha'];

  @override
  void initState() {
    super.initState();
    _fetchAddress();
    _fetchPrayerTimes();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied');
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
          '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place
              .country ?? ''}';
        });
      } else {
        setState(() {
          _currentAddress = 'Address not found';
        });
      }
    } catch (e) {
      print('Failed to get location: $e');
      setState(() {
        _currentAddress = 'Failed to get location';
      });
    }
  }

  Future<void> _fetchAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(widget.latitude, widget.longitude);
      setState(() {
        _currentAddress = "${placemarks[0].locality}, ${placemarks[0].country}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Location not available";
      });
    }
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      final url = Uri.parse(
          'http://api.aladhan.com/v1/timings?latitude=${widget.latitude}&longitude=${widget.longitude}&method=2');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          prayerTimes = data['data']['timings'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch prayer times. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waktu Solat', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF6B2572),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : prayerTimes == null
          ? Center(child: Text(errorMessage ?? 'Error loading data'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: Color(0xFF5C0065),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display current date and time instead of "Prayer Times"
                    Text(
                      DateFormat('d MMMM yyyy, h:mm a').format(DateTime.now()), // Format the date and time
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lokasi: ${_currentAddress ?? 'Fetching location...'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: prayerNames.map((prayerName) {
                  // Check if the prayer time exists in the fetched data
                  if (prayerTimes!.containsKey(prayerName)) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(prayerName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        trailing: Text(prayerTimes![prayerName], style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      ),
                    );
                  } else {
                    return SizedBox.shrink(); // Return an empty widget if the prayer time doesn't exist
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
