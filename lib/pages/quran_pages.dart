import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:new_mk_v3/pages/surahdetail_pages.dart';
import 'package:quran/quran.dart' as quran;

class QuranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Al-Quran",
          style: TextStyle(
            fontSize: 24,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: quran.totalSurahCount,
          itemBuilder: (context, index) {
            int surahNumber = index + 1;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  quran.getSurahName(surahNumber),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Scheherazade', // Customize font for Surah Name
                  ),
                ),
                subtitle: Text(
                  "Surah ${quran.getSurahName(surahNumber)}", // This will show the Surah name in Malay
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
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
