import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_mk_v3/model/prayer_model.dart';

class PrayerController extends ChangeNotifier {
  String _currentLocation = 'Lokasi...';
  String get currentLocation => _currentLocation;

  String _nextPrayer = 'Perkiraan solat seterusnya...';
  String get nextPrayer => _nextPrayer;

  PrayerModel? _prayerTimes;
  PrayerModel? get prayerTimes => _prayerTimes;

  // Get user's current location and prayer times
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return Future.error('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return Future.error('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      _currentLocation = '${place.locality}, ${place.administrativeArea}';
      notifyListeners();

      // Fetch prayer times for the current location
      await fetchPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Fetch prayer times using the PrayerModel
  Future<void> fetchPrayerTimes(double latitude, double longitude) async {
    try {
      PrayerModel prayerTimes = await PrayerModel.fetchPrayerTimes(latitude, longitude);
      _prayerTimes = prayerTimes;
      _nextPrayer = getNextPrayer(prayerTimes);
      notifyListeners();
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
  }

  // Determine the next prayer time
  String getNextPrayer(PrayerModel prayerTimes) {
    DateTime now = DateTime.now();
    List<String> prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (String prayer in prayerNames) {
      String prayerTime = prayerTimes.toJson()[prayer] ?? '';
      if (prayerTime.isNotEmpty) {
        DateTime prayerDateTime = DateTime.parse('${now.year}-${now.month}-${now.day} $prayerTime:00');
        if (prayerDateTime.isAfter(now)) {
          return 'Solat Seterusnya: $prayer pada $prayerTime';
        }
      }
    }
    return 'No more prayers today';
  }
}
