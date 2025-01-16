import 'package:flutter/material.dart';
import 'package:new_mk_v3/model/senaraimasjid_model.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';

class MasjidDetailScreen extends StatefulWidget {
  @override
  _MasjidDetailScreenState createState() => _MasjidDetailScreenState();
}

class _MasjidDetailScreenState extends State<MasjidDetailScreen> {
  late Future<List<SenaraiMasjid>> _masjidListFuture;

  @override
  void initState() {
    super.initState();
    _masjidListFuture = loadMasjidList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()));
          },
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Senarai Masjid',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings action
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<SenaraiMasjid>>(
        future: _masjidListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final masjid = snapshot.data![0]; // Assuming you want to display the first masjid
            return Column(
              children: [
                Container(
                  height: 300, // Adjust the height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(masjid.background),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30), // Add horizontal padding
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Column(
                      children: [
                        Text(
                          masjid.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Lokasi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF073C62)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Add other widgets below the background image here
              ],
            );
          }
        },
      ),
    );
  }
}
