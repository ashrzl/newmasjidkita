import 'package:flutter/material.dart';
import 'package:new_mk_v3/splashscreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized before async work
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