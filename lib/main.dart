import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:new_mk_v3/splashscreen.dart';

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized before async work
  await requestLocationPermission(); // Request location permission before launching the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MasjidKita',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Ensure SplashScreen is implemented
    );
  }
}
