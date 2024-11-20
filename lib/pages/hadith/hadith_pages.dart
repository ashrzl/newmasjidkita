import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/hadith_controller.dart';
import 'package:new_mk_v3/pages/home_pages.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: View Hadith Collection
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Hadis Sahih Imam an-Nawawi',
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/purple_background.jpg',
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
                      child: ExpansionTile(
                        leading: Icon(Icons.book, color: Color(0xFF6B2572)),
                        title: Text(
                          hadith['englishTitle'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  hadith['englishNarrator'],
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    height: 1.4,
                                    color: Colors.teal[900],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  hadith['englishText'],
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
