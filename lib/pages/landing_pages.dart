import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/prayer_controller.dart';
import 'package:new_mk_v3/pages/features/calendar_pages.dart';
import 'package:new_mk_v3/pages/features/listvideo_pages.dart';
import 'package:new_mk_v3/pages/features/prayertime_pages.dart';
import 'package:new_mk_v3/pages/features/qiblah_pages.dart';
import 'package:new_mk_v3/pages/features/videodetail_pages.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
* Project: MasjidKita Mobile App - V3
* Description: A Landing Page for public user
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
* Version: 3.0
* Details: Public user: user that not subscribe with MasjidKITA
*/

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isExpanded = false;
  int _selectedIndex = 1;

  String quote = "Loading...";

  final List<Map<String, String>> videos = [
    {'id': '1', 'thumbnail': 'assets/videoagama.png', 'url': 'https://www.youtube.com/watch?v=GeouFcney4c'},
    {'id': '2', 'thumbnail': 'assets/videoagama2.png', 'url': 'https://www.youtube.com/watch?v=LM_UNHTJESs'},
  ];


  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  // Fetch quote from API
  Future<void> fetchQuote() async {
    final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quote = data[0]['q'];  // Extract the quote from the response
      });
    } else {
      setState(() {
        quote = "Failed to load quote.";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuranPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage())
        );
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WaktuSolatPage())
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerController>(context);
    controller.getCurrentLocation(); // Ensure location is fetched
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        toolbarHeight: 120,
        flexibleSpace: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Image.asset(
                        'assets/icon/mklogo.png',
                        height: 50,
                      ),
                    ),
                  ),
                  Spacer(), // Pushes the icon to the right
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(title: '')),
                        );
                      },
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '"$quote"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Prayer Time Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.nextPrayer,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Zon: ${controller.currentLocation}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildModulIcons(),
            const SizedBox(height: 20),
            _buildMenuIcons(),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                            'Video Terkini',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => VideoListPage(videos: videos)),
                          );
                        },
                        child: Text(
                            'Lagi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200, // Height for the carousel
                  child: PageView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoDetailPage(videoUrl: video['url']!),
                            ),
                          );
                        },
                        child: Hero(
                          tag: video['id']!,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: AssetImage(video['thumbnail']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF20345B),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon/read-quran.png'), size: 30),
            label: 'al-quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'utama',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon/solat.png'), size: 30),
            label: 'waktu solat',
          ),
        ],
      ),
    );
  }

  Widget _buildModulIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              children: [
                _buildModulIcon('assets/icon/kariahKITA.png'),
                SizedBox(width: 16),
                _buildModulIcon('assets/icon/khairatKITA.png'),
                SizedBox(width: 16),
                _buildModulIcon('assets/icon/mklogo.png'),
                SizedBox(width: 16),
                _buildModulIcon('assets/icon/pusaraKITA.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QiblahPage()),
                    );
                  },
                  child: _buildMenuIcon(
                    'assets/icon/qibla.png',
                    'Kiblat',
                    const Color(0xFF073C62),
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate to KalendarPage (replace with your page)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()), // Example page
                    );
                  },
                  child: _buildMenuIcon(
                    'assets/icon/calendar.png',
                    'Kalendar',
                    const Color(0xFF073C62),
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate to ForumPage (replace with your page)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ),
                    // );
                  },
                  child: _buildMenuIcon(
                    'assets/icon/chat.png',
                    'Forum',
                    const Color(0xFF073C62),
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    // Navigate to BookingPage (replace with your page)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ),
                    // );
                  },
                  child: _buildMenuIcon(
                    'assets/icon/booking.png',
                    'Tempahan',
                    const Color(0xFF073C62),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulIcon(String assetPath,) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Image.asset(assetPath, height: 90, width: 90),
        ),
      ],
    );
  }

  Widget _buildMenuIcon(String assetPath, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Image.asset(assetPath, height: 50, width: 50, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

}
