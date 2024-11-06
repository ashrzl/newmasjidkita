import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/quran_pages.dart';
import 'package:quran/quran.dart' as quran;

class SurahDetailPage extends StatelessWidget {
  final int surahNumber;

  SurahDetailPage({required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quran.getSurahName(surahNumber),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuranPage()));
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6B2572),
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
