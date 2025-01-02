import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => LandingPage(),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // Use MediaQuery for full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/gif/lanterns.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200), // Add empty space above
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo slightly to the right
                      Padding(
                        padding: const EdgeInsets.all(100), // Push the image slightly to the right
                        child: Image.asset(
                          'assets/icon/mklogo.png', // Replace with your logo's path
                          width: 250, // Adjust the size as needed
                          height: 250,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Text('v3.0.0', style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}