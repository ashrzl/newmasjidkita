import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:new_mk_v3/model/qibla_model.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:new_mk_v3/utils/loading_error_widget.dart';

class QiblahPage extends StatefulWidget {
  @override
  _QiblahPageState createState() => _QiblahPageState();
}

class _QiblahPageState extends State<QiblahPage> {
  final QiblahModel _qiblahModel = QiblahModel();
  late Future<bool> _deviceSupport;

  @override
  void initState() {
    super.initState();
    _deviceSupport = _qiblahModel.getDeviceSupport();
    _qiblahModel.checkLocationStatus();

    // Show calibration message when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCalibrationDialog());
  }

  @override
  void dispose() {
    _qiblahModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5C0065),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: const Text('Arah Kiblat', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<bool>(
        future: _deviceSupport,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotate,
                backgroundColor: Colors.blue,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }

          if (snapshot.data == true) {
            return _buildQiblahCompassWidget();
          } else {
            return Center(child: Text('Error: Device not supported.'));
          }
        },
      ),
    );
  }

  Widget _buildQiblahCompassWidget() {
    return StreamBuilder<LocationStatus>(
      stream: _qiblahModel.stream,
      builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotate,
            ),
          );
        }

        if (snapshot.data?.enabled == true) {
          switch (snapshot.data!.status) {
            case LocationPermission.always:
            case LocationPermission.whileInUse:
              return StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballClipRotate,
                      ),
                    );
                  }

                  final qiblahDirection = snapshot.data;
                  double direction = qiblahDirection?.qiblah ?? 0.0;

                  // Normalize the direction to be within 0-360 degrees
                  direction = direction % 360;

                  // Format direction to two decimal places
                  String directionText = direction.toStringAsFixed(2);

                  // Debug log to confirm angle value
                  print("Normalized Qiblah angle in degrees: $directionText");

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          // Convert angle to radians and apply negative rotation for compass alignment
                          angle: (direction * (pi / 180)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/qiblah.png',
                            fit: BoxFit.contain,
                            height: 300, // Adjust size as needed
                            alignment: Alignment.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Qiblah Angle: $directionText°",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

            case LocationPermission.denied:
            case LocationPermission.deniedForever:
              return LocationErrorWidget(
                error: "Please enable Location service",
                callback: _qiblahModel.checkLocationStatus,
              );
            default:
              return const SizedBox();
          }
        } else {
          return LocationErrorWidget(
            error: "Please enable Location service",
            callback: _qiblahModel.checkLocationStatus,
          );
        }
      },
    );
  }

  void _showCalibrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kalibrasi Kompas Anda"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/compassgif.gif'),
              Text(
                  'Untuk memastikan arah Kiblat yang tepat, '
                      'sila kalibrasi kompas anda dengan memutar peranti anda dalam gerakan lapan.'
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
