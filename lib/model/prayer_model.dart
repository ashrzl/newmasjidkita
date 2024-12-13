import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerModel {
  final String fajr;
  final String imsak;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;

  PrayerModel({
    required this.fajr,
    required this.imsak,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  // Factory constructor to create PrayerModel from JSON
  factory PrayerModel.fromJson(Map<String, dynamic> json) {
    return PrayerModel(
      fajr: json['Fajr'],
      imsak: json['Imsak'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      sunset: json['Sunset'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }

  // Method to convert PrayerModel to JSON (map)
  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr,
      'Imsak': imsak,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Sunset': sunset,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }

  // Method to fetch prayer times from API
  static Future<PrayerModel> fetchPrayerTimes(double latitude, double longitude) async {
    final String url =
        'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> rawTimings = data['data']['timings'];

      return PrayerModel.fromJson(rawTimings);
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
