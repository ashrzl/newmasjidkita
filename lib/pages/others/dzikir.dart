import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:new_mk_v3/pages/home_pages.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: List of Daily Zikir
* Author: AIMAN SHARIZAL
* Date: 21 November 20204
* Version: 1.0
*/

class DzikirPagi extends StatefulWidget {
  @override
  _DzikirPagiState createState() => _DzikirPagiState();
}

class _DzikirPagiState extends State<DzikirPagi> {
  Future<List<dynamic>> loadDzikirPagi() async {
    try {
      var response = await rootBundle.loadString('data/dzikir_pagi.json');
      if (response.isNotEmpty) {
        var res = json.decode(response);
        return res['data'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error loading or parsing JSON: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'ZIKIR HARIAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor:Color(0xFF6B2572),
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
          // Background image
          Positioned.fill(
              child: Image.asset(
                'assets/background/purple_background.jpg', // Ensure this image is in assets and declared in pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
          FutureBuilder<List<dynamic>>(
            future: loadDzikirPagi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("FutureBuilder error: ${snapshot.error}");
                return Center(child: Text('Error loading data'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data found'));
              }

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var dzikirItem = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ExpansionTile(
                      leading: Icon(Icons.book, color:Color(0xFF6B2572)),
                      title: Text(
                        dzikirItem['title'],
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
                                dzikirItem['arabic'],
                                style: TextStyle(
                                  fontSize: 24.0,
                                  height: 1.5,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amiri', // Add a custom Arabic font if possible
                                ),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                dzikirItem['latin'],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  height: 1.4,
                                  color: Colors.teal[900],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                dzikirItem['translation'],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  height: 1.4,
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
            },
          ),
        ],
      ),
    );
  }
}
