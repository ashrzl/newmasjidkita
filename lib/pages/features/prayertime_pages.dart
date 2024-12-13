import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/prayer_controller.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:provider/provider.dart';

class WaktuSolatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerController>(context);
    controller.getCurrentLocation(); // Ensure location is fetched

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Waktu Solat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Scheherazade',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to the settings page or handle the settings action
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SettingsPage()),
              // );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        toolbarHeight: 120,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Location
            Text(
              'Zon: ${controller.currentLocation}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Next Prayer Time
            Text(
              controller.nextPrayer,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),

            // Prayer Times List
            controller.prayerTimes == null
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  List<String> prayerTimes = [
                    'Fajr', 'Imsak', 'Sunrise', 'Dhuhr', 'Asr', 'Sunset', 'Maghrib', 'Isha'
                  ];
                  String prayerName = prayerTimes[index];
                  String prayerTime = controller.prayerTimes!.toJson()[prayerName] ?? '';
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        prayerName,
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        prayerTime,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
