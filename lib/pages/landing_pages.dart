import 'package:flutter/material.dart';
import 'package:new_mk_v3/qiblah_pages.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';
import 'package:new_mk_v3/pages/login_pages.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isExpanded = false;
  int _selectedIndex = 2;

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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PrayerTimesPage()),
      // );
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LandingPage())
        );
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QiblahPage())
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'assets/icon/MasjidKITA-Logo.png',
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
                  '"Hati yang paling bernilai adalah yang tetap dekat dengan Allah, bahkan ketika sedang sakit."',
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
                        'Solat seterusnya Asar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '4:27 PM',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Zon: Puchong, Selangor\nJumaat, 29 Disember 2024',
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
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => LoginPage(title: '')),
                          // );
                        },
                        child: Text(
                            'Lihat semua',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
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
            icon: ImageIcon(AssetImage('assets/icon/solat.png'), size: 30),
            label: 'waktu solat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'utama',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icon/qibla.png'),size: 30),
            label: 'kiblat',
          ),
          BottomNavigationBarItem(
            icon: PopupMenuButton<int>(
              icon: Icon(Icons.more_horiz_rounded, size: 30),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.chat_rounded, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('forum'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('kalendar'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_added_rounded, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('tempahan'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text('kongsi'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle the selected menu item
                switch (value) {
                  case 1:
                    print('Menu Item 1 selected');
                    break;
                  case 2:
                    print('Menu Item 2 selected');
                    break;
                  case 3:
                    print('Menu Item 3 selected');
                    break;
                  case 4:
                    print('Menu Item 4 selected');
                    break;
                }
              },
            ),
            label: 'lagi',
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
                _buildModulIcon('assets/icon/MasjidKITA-Logo.png'),
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
                _buildMenuIcon('assets/icon/qibla.png', 'Kiblat', const Color(0xFF073C62)),
                SizedBox(width: 16),
                _buildMenuIcon('assets/icon/calendar.png', 'Kalendar', const Color(0xFF073C62)),
                SizedBox(width: 16),
                _buildMenuIcon('assets/icon/chat.png', 'Forum', const Color(0xFF073C62)),
                SizedBox(width: 16),
                _buildMenuIcon('assets/icon/booking.png', 'Tempahan', const Color(0xFF073C62)),
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
          child: Image.asset(assetPath, height: 100, width: 100),
        ),
      ],
    );
  }

  Widget _buildMenuIcon(String assetPath, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Image.asset(assetPath, height: 60, width: 60, color: color),
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
