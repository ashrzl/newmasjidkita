import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/hadith/hadith_pages.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: View Hadith Collection
* Author: AIMAN SHARIZAL
* Date: 21 November 2024
* Version: 1.0
*/

class HadithDetailsPage extends StatelessWidget {
  final Map<String, dynamic> hadith;

  const HadithDetailsPage({Key? key, required this.hadith}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Background similar to image
      appBar: AppBar(
        title: Text(
          '40 Hadis Sahih', // Updated title from the image
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6B2572), // Match the app bar color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HadithPages()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purpleAccent[100], // Light container color
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Title
                Center(
                  child: Text(
                    hadith['englishTitle'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Arabic Text
                Text(
                  hadith['arabic'],
                  style: TextStyle(
                    fontSize: 28.0,
                    height: 1.8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri', // Arabic font
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 20.0),
                // English Narrator
                Text(
                  hadith['englishNarrator'],
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.4,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20.0),
                // English Explanation
                Text(
                  hadith['englishText'],
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
