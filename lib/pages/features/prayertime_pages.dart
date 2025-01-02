import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/prayer_controller.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:provider/provider.dart';

class WaktuSolatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prayerController = Provider.of<PrayerController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LandingPage()));
          },
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Waktu Solat',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings action
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Card(
              color: Colors.blue.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      prayerController.nextPrayer,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Zon: ${prayerController.currentLocation}',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${DateTime.now().toLocal().toString().split(' ')[0]}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Prayer Times List
            Expanded(
              child: ListView(
                children: [
                  _buildPrayerTimeRow(
                      'Imsak', prayerController.prayerTimes?.imsak ?? '...'),
                  SizedBox(height: 16),
                  _buildPrayerTimeRow(
                      'Fajr', prayerController.prayerTimes?.fajr ?? '...'),
                  SizedBox(height: 16),
                  _buildPrayerTimeRow(
                      'Zohor', prayerController.prayerTimes?.dhuhr ?? '...'),
                  SizedBox(height: 16),
                  _buildPrayerTimeRow(
                      'Asar', prayerController.prayerTimes?.asr ?? '...'),
                  SizedBox(height: 16),
                  _buildPrayerTimeRow(
                      'Maghrib', prayerController.prayerTimes?.maghrib ?? '...'),
                  SizedBox(height: 16),
                  _buildPrayerTimeRow(
                      'Isyak', prayerController.prayerTimes?.isha ?? '...'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          prayerController.getCurrentLocation();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  // Helper method to build a prayer time row
  Widget _buildPrayerTimeRow(String title, String time) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Text(
              time,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
