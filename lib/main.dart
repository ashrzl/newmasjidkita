import 'package:flutter/material.dart';
import 'package:new_mk_v3/splashscreen.dart';
import 'package:provider/provider.dart';
import 'controller/prayer_controller.dart'; // Import the prayer controller

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PrayerController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MasjidKITA',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(), // Page that consumes PrayerController
      ),
    );
  }
}
