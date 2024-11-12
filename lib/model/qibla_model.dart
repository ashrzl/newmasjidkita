import 'dart:async';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class QiblahModel {
  final _locationStreamController = StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  Future<void> checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  void dispose() {
    _locationStreamController.close();
  }

  Future<bool> getDeviceSupport() async {
    final deviceSupport = await FlutterQiblah.androidDeviceSensorSupport();
    return deviceSupport ?? false;  // If the result is null, return false by default
  }

}
