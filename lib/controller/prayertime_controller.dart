import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:new_mk_v3/model/location_model.dart';
import 'package:new_mk_v3/model/prayer_model.dart';

class PrayerTimesController {
  Future<PrayerTimesModel?> fetchPrayerTimes(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PrayerTimesModel.fromJson(data);
      } else {
        print('Failed to fetch prayer times: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
      return null;
    }
  }

  Future<LocationModel?> fetchAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return LocationModel.fromPlacemark(placemarks[0]);
      }
      return LocationModel(address: "Location not available");
    } catch (e) {
      print('Error fetching address: $e');
      return LocationModel(address: "Location not available");
    }
  }
}
