import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:new_mk_v3/pages/quran/surahdetail_pages.dart';
import 'package:quran/quran.dart' as quran;

class QuranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Al-Quran",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Scheherazade', // Customize font for Arabic context
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        backgroundColor: Color(0xFF6B2572),
        centerTitle: true,
        elevation: 10, // Added elevation for a modern shadow effect
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
                    color: Color(0xFF6B2572), // Bold and complementary text color
                  ),
                ),
                subtitle: Text(
                  "Surah ${quran.getSurahName(surahNumber)}", // Showing Surah name in Malay
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF6B2572), // Arrow icon to indicate navigation
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
    );
  }
}
