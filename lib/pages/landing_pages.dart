import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/prayer_controller.dart';
import 'package:new_mk_v3/model/video_model.dart';
import 'package:new_mk_v3/pages/features/calendar_pages.dart';
import 'package:new_mk_v3/pages/features/senaraimasjid_pages.dart';
import 'package:new_mk_v3/pages/features/listvideo_pages.dart';
import 'package:new_mk_v3/pages/features/prayertime_pages.dart';
import 'package:new_mk_v3/pages/features/qiblah_pages.dart';
import 'package:new_mk_v3/pages/features/videodetail_pages.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isExpanded = false;
  int _selectedIndex = 0;
  late Future<List<Video>> _videos;
  String quote = "Loading...";
  final PageController _pageController = PageController();
  late PrayerController prayerController;


  @override
  void initState() {
    super.initState();
    fetchQuote();
    prayerController = Provider.of<PrayerController>(context, listen: false);
    _videos = loadVideos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchQuote() async {
    final response = await http.get(Uri.parse('https://zenquotes.io/api/today'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quote = data[0]['q'];
      });
    } else {
      setState(() {
        quote = "Failed to load quote.";
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
        break;
      case 1:
        _showBottomDrawer();
        break;
    }
  }

  void _showBottomDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to adjust its height
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6, // Adjust the height as needed
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Makes the column take only as much space as needed
                children: [
                  const Text(
                    'Teroka',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icon/mklogo.png', height: 100),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MasjidKITA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text(
                                'Memaparkan senarai masjid',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('MasjidKITA'),
                                          content: const Text(
                                            'Memaparkan senarai masjid yang berdaftar dibawah MasjidKITA',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Seterusnya'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                        MaterialPageRoute(builder: (context) => MasjidListScreen()),
                      );
                    },
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icon/kariahKITA.png', height: 100),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'KariahKITA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text(
                                'Sistem Pengurusan Kariah yang dibangunkan ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('KariahKITA'),
                                          content: const Text(
                                            'Sistem Pengurusan Kariah yang dibangunkan bagi '
                                                'membantu dalam pengurusan rekod anak kariah di masjid '
                                                'atau surau yang berdaftar dalam MasjidKITA. '
                                                'Sumbangan masjid dan pembayaran khairat kematian juga boleh diakses oleh anak kariah',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Seterusnya'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Additional onTap action if needed.
                    },
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icon/khairatKITA.png', height: 100),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'KhairatKITA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text(
                                'Membantu anak kariah menguruskan ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('KhairatKITA'),
                                          content: const Text(
                                            'Membantu anak kariah mengurus khairat '
                                                'kematian di masjid dan surau '
                                                'yang berdaftar di bawah MasjidKITA',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Seterusnya'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Additional onTap action if needed.
                    },
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icon/pusaraKITA.png', height: 100),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PusaraKITA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text(
                                'Pengurusan Pusara oleh anak kariah ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('PusaraKITA'),
                                          content: const Text(
                                            'Pengurusan Pusara oleh anak kariah '
                                                'serta sistem untuk plot tanah kubur',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Seterusnya'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Additional onTap action if needed.
                    },
                  ),
                  const Divider(thickness: 2),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icon/infaqKITA.png', height: 100),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'InfaqKITA',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const Text(
                                'Sistem Infaq bagi memberi platform',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('InfaqKITA'),
                                          content: const Text(
                                            'Sistem Infaq bagi memberi platform '
                                                'kepada ahli berdaftar bawah '
                                                'MasjidKITA dan orang ramai '
                                                'untuk berkongsi rezeki.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Seterusnya'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Additional onTap action if needed.
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PrayerController>(context);
    controller.getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        toolbarHeight: 100,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/icon/mklogo.png', height: 50),
                ),
                Expanded( // This ensures the text takes available space and prevents overflow
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "MasjidKITA",
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage(title: '')),
                      );
                    },
                    child: const Icon(Icons.account_circle, size: 40, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '"$quote"',
                  style: const TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Card(
                    color: Colors.blue.shade50,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            prayerController.nextPrayer,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Zon: ${prayerController.currentLocation}',
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${DateTime.now().toLocal().toString().split(' ')[0]}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuIcons(),
              const SizedBox(height: 16),
              FutureBuilder<List<Video>>(
                future: _videos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading videos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No videos found'));
                  }
                  final videos = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Video Terkini',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoListPage(videos: videos),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16.0),
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
                        height: 200,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: videos.length,
                              itemBuilder: (context, index) {
                                final video = videos[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VideoDetailPage(videoUrl: video.url),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: video.id.toString(),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        image: DecorationImage(
                                          image: AssetImage(video.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: _pageController,
                                  count: videos.length,
                                  effect: WormEffect(
                                    dotHeight: 8.0,
                                    dotWidth: 8.0,
                                    spacing: 4.0,
                                    activeDotColor: Colors.blue,
                                    dotColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Berita/Pengumuman',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black54,
                          tabs: [
                            Tab(text: 'Berita'),
                            Tab(text: 'Pengumuman'),
                          ],
                        ),
                        Container(
                          height: 300, // Set appropriate height for TabBarView content
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.article),
                                    title: Text('Berita ${index + 1}'),
                                    subtitle: Text('Ini adalah kandungan berita ${index + 1}.'),
                                  );
                                  },
                              ),
                              ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.announcement),
                                    title: Text('Pengumuman ${index + 1}'),
                                    subtitle: Text('Ini adalah kandungan pengumuman ${index + 1}.'),
                                  );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF20345B),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'Utama',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view, size: 30),
            label: 'Teroka',
          ),
          BottomNavigationBarItem(
            icon: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert, size: 30),
              onSelected: (int value) {
                // Handle the selected menu item
                if (value == 1) {
                  // Perform an action for option 1
                } else if (value == 2) {
                  // Perform an action for option 2
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 20),
                      SizedBox(width: 8),
                      Text("Tatapan"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.help, size: 20),
                      SizedBox(width: 8),
                      Text("Bantuan"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.call, size: 20),
                      SizedBox(width: 8),
                      Text("Hubungi Kami"),
                    ],
                  ),
                ),
              ],
            ),
            label: 'Lagi',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WaktuSolatPage(),
                ),
              );
            },
            child: _buildMenuIcon(
                'assets/icon/solat.png',
                'Waktu Solat',
                const Color(0xFF073C62)
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QiblahPage(),
                ),
              );
            },
            child: _buildMenuIcon(
                'assets/icon/qibla.png',
                'Kiblat',
                const Color(0xFF073C62)
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranPage(),
                ),
              );
            },
            child: _buildMenuIcon(
                'assets/icon/read-quran.png',
                'Al-Quran',
                const Color(0xFF073C62)
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ForumPage(),
              //   ),
              // );
            },
            child: _buildMenuIcon(
                'assets/icon/chat.png',
                'Forum Masjid',
                const Color(0xFF073C62)
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(title: '',),
                ),
              );
            },
            child: _buildMenuIcon(
                'assets/icon/calendar.png',
                'Kalendar Masjid',
                const Color(0xFF073C62)
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => (),
              //   ),
              // );
            },
            child: _buildMenuIcon(
                'assets/icon/booking.png',
                'Tempahan Masjid',
                const Color(0xFF073C62)
            ),
          ),
        ],
      ),
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
