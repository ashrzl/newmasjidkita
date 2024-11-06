import 'package:geocoding/geocoding.dart';

class LocationModel {
  final String? address;

  LocationModel({this.address});

  factory LocationModel.fromPlacemark(Placemark placemark) {
    return LocationModel(
      address: '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}',
    );
  }
}