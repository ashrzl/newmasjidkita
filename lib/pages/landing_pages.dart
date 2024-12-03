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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side logo
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Main logo
                              Image.asset(
                                'assets/icon/kariahKITA.png',
                                width: 150,
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isExpanded
                                    ? 'Sistem Pengurusan Kariah yang dibangunkan '
                                    'bagi menguruskan hal ehwal keahlian dan pembayaran ahli qariah secara digital. '
                                    : 'Sistem Pengurusan Kariah yang dibangunkan bagi menguruskan...',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    isExpanded ? 'Tutup' : 'Baca Lagi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isExpanded
                                    ? 'Sistem Pengurusan Khairat Kematian yang dibangunkan '
                                    'bagi membantu anak kariah mengurus khairat kematian '
                                    'di masjid dan surau yang berdaftar di bawah MasjidKITA. '
                                    : 'Sistem Pengurusan Khairat Kematian yang dibangunkan...',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    isExpanded ? 'Tutup' : 'Baca Lagi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/icon/khairatKITA.png',
                                width: 150,
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side logo
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Main logo
                              Image.asset(
                                'assets/icon/MasjidKITA-Logo.png',
                                width: 150,
                                height: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isExpanded
                                    ?'Sistem Pengurusan Infaq yang dibina, '
                                    'bagi memberi peluang kepada pengguna '
                                    'untuk berkongsi rezeki bersama masjid dan surau '
                                    'yang mendaftar dibawah MasjidKITA.'
                                    : 'Sistem Pengurusan Infaq yang dibina...',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    isExpanded ? 'Tutup' : 'Baca Lagi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
}
