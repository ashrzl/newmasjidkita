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
  late Future<List<Map<String, dynamic>>> _hadiths;

  @override
  void initState() {
    super.initState();
    _hadiths = HadithController.loadHadiths();  // Load the list of hadiths
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'HADIS SAHIH IMAM an-NAWAWI',  // Set your desired static title here
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
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
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/purple_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: FutureBuilder<List<Map<String, dynamic>>>(  // This is correct for loading the list of hadiths
              future: _hadiths,  // Loads the hadiths from the controller
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No Hadiths available');
                } else {
                  var hadithList = snapshot.data!;
                  return ListView.builder(
                    itemCount: hadithList.length,
                    itemBuilder: (context, index) {
                      var hadith = hadithList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${hadith['arabic']}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 15),
                              Text(
                                '${hadith['englishNarrator']}',
                                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 10),
                              Text(
                                hadith['englishText'],
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
