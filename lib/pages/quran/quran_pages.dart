import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:new_mk_v3/pages/quran/surahdetail_pages.dart';
import 'package:new_mk_v3/pages/features/qiblah_pages.dart';
import 'package:quran/quran.dart' as quran;

/*
* Project: MasjidKita Mobile App - V3
* Description: View List of Surah in Al-Quran
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
* Version: 1.0
*/

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  _QuranPageState createState() => _QuranPageState();
}


class _QuranPageState extends State<QuranPage>{

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuranPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage())
        );
        break;
      case 2:
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => QiblahPage())
        // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Al-Quran',
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjusted padding for better spacing
        child: ListView.builder(
          itemCount: quran.totalSurahCount,
          itemBuilder: (context, index) {
            int surahNumber = index + 1;
            return Card(
              elevation: 8, // Slightly higher elevation for more prominence
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // More rounded corners
              ),
              color: Colors.deepPurple[50], // Soft background color for the card
              child: ListTile(
                contentPadding: const EdgeInsets.all(18.0),
                title: Text(
                  quran.getSurahName(surahNumber),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Scheherazade', // Customize font for Surah Name
                    color: Colors.blue[800], // Bold and complementary text color
                  ),
                ),
                subtitle: Text(
                  "Surah ${quran.getSurahName(surahNumber)}", // Showing Surah name in Malay
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue[900], // Arrow icon to indicate navigation
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurahDetailPage(surahNumber: surahNumber),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF20345B),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon/read-quran.png'), size: 30),
            label: 'al-quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'utama',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon/solat.png'), size: 30),
            label: 'waktu solat',
          ),
        ],
      ),
    );
  }
}
