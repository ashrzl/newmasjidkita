import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/hadith_controller.dart';
import 'package:new_mk_v3/pages/hadith/hadith_details.dart';
import 'package:new_mk_v3/pages/home_pages.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: View Hadith Collection
* Author: AIMAN SHARIZAL
* Date: 21 November 2024
* Version: 1.0
*/

class HadithPages extends StatefulWidget {
  @override
  _HadithPagesState createState() => _HadithPagesState();
}

class _HadithPagesState extends State<HadithPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          '40 Hadis Sahih',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6B2572),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/quran-background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: HadithController.loadHadiths(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading Hadith'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Hadith found'));
              } else {
                List<Map<String, dynamic>> hadiths = snapshot.data!;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    var hadith = hadiths[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF6B2572),
                          child: Text(
                            '${index + 1}', // Display the Hadith number
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          hadith['englishTitle'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HadithDetailsPage(hadith: hadith),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
