class PrayerTimesModel {
  final Map<String, dynamic> timings;

  PrayerTimesModel({required this.timings});

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(timings: json['data']['timings']);
  }
}