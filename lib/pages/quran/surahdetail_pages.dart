import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';
import 'package:quran/quran.dart' as quran;

/*
* Project: MasjidKita Mobile App - V3
* Description: Read Details of Surah in Al-Quran
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
* Version: 1.0
*/

class SurahDetailPage extends StatelessWidget {
  final int surahNumber;

  SurahDetailPage({required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quran.getSurahName(surahNumber),
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
              MaterialPageRoute(builder: (context) => QuranPage()),
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
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: quran.getVerseCount(surahNumber),
          itemBuilder: (context, index) {
            int verseNumber = index + 1;

            // Fetch the verse text and verse end symbol
            String verseText = quran.getVerse(surahNumber, verseNumber);
            String verseEndSymbol = quran.getVerseEndSymbol(verseNumber);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15.0),
                  title: Text(
                    "$verseText $verseEndSymbol", // Add verse text and end symbol together
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Scheherazade',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Ayat $verseNumber",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
