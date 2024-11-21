import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/controller/home_controller.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:new_mk_v3/model/user_model.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/carianmasjid_pages.dart';
import 'package:new_mk_v3/pages/doa.dart';
import 'package:new_mk_v3/pages/dzikir.dart';
import 'package:new_mk_v3/pages/hadith/hadith_pages.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:new_mk_v3/pages/prayertimes_pages.dart';
import 'package:new_mk_v3/pages/qiblah_pages.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Personal Task Center - PTC
* Author: AIMAN SHARIZAL
* Date: 21 November 20204
* Version: 1.0
* Additional Notes:
* - Display User Profile
* - List of subscription and favourite
* - My Istiqomah Features: Solat, Al-quran, Hadis & Amalan Harian
*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  User? _user;
  List<Mosque> _favoriteMosques = [];
  List<Mosque> _subscribeMosques = [];
  String _currentAddress = 'Lokasi...';
  Position? _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _requestLocationPermission();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.loadUserInfo();
    _user = await _controller.fetchUserInfo();
    // _favoriteMosques = await _controller.fetchFavoriteMosques();
    _subscribeMosques = await _controller.fetchSubscribeMosques();
    setState(() {});
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
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(create: (_) => CarianMasjidController(),
                child: CarianMasjid(),
              ),
            ),
        );
        break;
      case 2:
      // Navigate to the profile page (you'll need to create this)
        break;
    }
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with accessing location
      _getCurrentLocation();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Handle denied permission
      // You can show a dialog or inform the user to grant permission from settings
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Get the current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemarks using the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Ensure that the widget is still in the widget tree before calling setState
      if (mounted) {
        setState(() {
          _currentPosition = position; // Update _currentPosition here
          // Optionally, update the address as well if placemarks is not empty
          _currentAddress = placemarks.isNotEmpty
              ? '${placemarks[0].locality}, '
              '${placemarks[0].administrativeArea}, '
              '${placemarks[0].country}'
              : 'Address not found';
        });
      }
    } catch (e) {
      // Handle the error appropriately
      print("Failed to get location: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C0065),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(title: '')));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lokasi Anda:", style: TextStyle(color: Colors.white)),
            Text(_currentAddress, style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      endDrawer: Drawer(child: ProfileScreen()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildProfileSection(),
            SizedBox(height: 15.0),
            _buildFeatureIcons(context),
            SizedBox(height: 50),
            _buildTabBarSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Utama'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Carian Masjid'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex, // The currently selected index
        selectedItemColor: Color(0xFF6B2572), // The color of the selected item
        onTap: _onItemTapped, // Handle the tap on an item
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Color(0xFF5C0065),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Carian Masjid',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Icon(Icons.mic, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Container(
        height: 170,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight, // Align pencil icon to bottom right
              children: [
                // CircleAvatar with a border
                Container(
                  width: 80, // Adjust width for the border
                  height: 80, // Adjust height for the border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF6B2572), width: 3), // Border color and width
                  ),
                  child: CircleAvatar(
                    backgroundImage: _user?.imageUrl != null
                        ? NetworkImage(_user!.imageUrl!)
                        : AssetImage('assets/icon/user.png') as ImageProvider,
                    radius: 40.0,
                  ),
                ),
                // Pencil icon for updating profile picture
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: Container(
                //     height: 40.0,
                //     width: 40.0,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(color: Color(0xFF5C0065), width: 3),
                //       color: Colors.white,
                //     ),
                //     child: IconButton(
                //       icon: Icon(Icons.edit, color: Color(0xFF6B2572), size: 20.0),
                //       onPressed: () {
                //         // Define the action when the icon is pressed
                //         // For example, show a dialog to update the profile picture
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Center( // This will vertically center the content
                child: Column(
                  mainAxisSize: MainAxisSize.min, // This ensures the column takes minimum vertical space
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_user?.username ?? "No Name", style: TextStyle(fontSize: 15)),
                    SizedBox(height: 8),
                    Text(_user?.email ?? "No Email", style: TextStyle(fontSize: 15)),
                    SizedBox(height: 8),
                    Text(_user?.phoneNo ?? "No Phone", style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildFeatureIcons(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Scroll left when the left arrow is clicked
                  _scrollController.animateTo(
                    _scrollController.offset - 150,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrayerTimesPage(
                                latitude: position.latitude,
                                longitude: position.longitude,
                              ),
                            ),
                          );
                        },
                        child: _buildMenuIconWithImage(
                          'assets/icon/mosque.png',
                          'Waktu Solat',
                          const Color(0xFF6B2572),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => QiblahPage()),
                      //     );
                      //   },
                      //   child: _buildMenuIconWithImage(
                      //     'assets/icon/qibla.png',
                      //     'Kiblat',
                      //     const Color(0xFF6B2572),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuranPage()),
                          );
                        },
                        child: _buildMenuIconWithImage(
                          'assets/icon/read-quran.png',
                          'Al-Quran',
                          const Color(0xFF6B2572),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HadithPages()),
                          );
                        },
                        child: _buildMenuIconWithImage(
                          'assets/icon/hadis.png',
                          'Hadis',
                          const Color(0xFF6B2572),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: Text("Zikir & Doa")),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DzikirPagi()),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icon/zikir.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Zikir Harian",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DoaPage()),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/icon/praying.png',
                                              width: 80,
                                              height: 80,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Doa Harian",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: _buildMenuIconWithImage(
                          'assets/icon/tasbih.png',
                          'Amalan Harian',
                          const Color(0xFF6B2572),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Scroll right when the right arrow is clicked
                  _scrollController.animateTo(
                    _scrollController.offset + 150,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTabBarSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Color(0xFF6B2572),
            labelColor: Color(0xFF6B2572),
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Masjid Dilanggan'),
              Tab(text: 'Masjid Diikuti'),
            ],
          ),
          Container(
            height: 300,
            child: TabBarView(
              children: [
                // "Masjid Dilanggan" tab content
                _buildMosqueSubscribeList(_subscribeMosques),
                // "Masjid Diikuti" tab content
                _buildMosqueFavouriteList(_favoriteMosques), // Replace with actual data for this tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMosqueFavouriteList(List<Mosque> mosques) {
    return mosques.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0), // Adds padding for spacing around the text
          child: Text(
            'Jumlah Masjid Diikuti: ${mosques.length}',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        // The ListView with dividers
        Expanded(
          child: ListView.separated(
            itemCount: mosques.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final mosque = mosques[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Display the mosque logo
                        Image.asset(
                          mosque.mosLogoUrl?.isNotEmpty == true
                              ? mosque.mosLogoUrl!
                              : 'assets/icon/MasjidKITALogo.png', // Fallback image
                          width: 60, // Adjust size as needed
                          height: 60, // Adjust size as needed
                          fit: BoxFit.cover, // Adjust fit as needed
                        ),
                        const SizedBox(width: 12),// Space between logo and name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mosque.mosName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              if (mosque.address.isNotEmpty ?? false)
                                Column(
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      mosque.address,
                                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    )
        : const Center(child: Text('Tiada Masjid Diikuti')); // Displayed when the list is empty
  }

  Widget _buildMosqueSubscribeList(List<Mosque> mosques) {
    return mosques.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0), // Adds padding for spacing around the text
          child: Text(
            'Jumlah Masjid Dilanggan: ${mosques.length}',
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        const Divider(thickness: 1, color: Colors.grey),
        // The ListView with dividers
        Expanded(
          child: ListView.separated(
            itemCount: mosques.length,
            separatorBuilder: (context, index) =>
            const Divider(thickness: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final mosque = mosques[index];

              // Determine the button color based on moduleName
              Color buttonColor;
              if (mosque.moduleName == 'KariahKITA') {
                buttonColor = const Color(0xFF6B2572);
              } else if (mosque.moduleName == 'KhairatKITA') {
                buttonColor = Colors.green;
              } else {
                buttonColor = Colors.grey;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Display the mosque logo
                        Image.asset(
                          mosque.mosLogoUrl?.isNotEmpty == true
                              ? mosque.mosLogoUrl!
                              : 'assets/icon/MasjidKITALogo.png', // Fallback image
                          width: 60, // Adjust size as needed
                          height: 60, // Adjust size as needed
                          fit: BoxFit.cover, // Adjust fit as needed
                        ),
                        const SizedBox(width: 12), // Space between logo and name
                        Expanded( // Wrap mosque name with Expanded to prevent overflow
                          child: Text(
                            mosque.tnName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis, // Prevent text overflow
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
                      children: [
                        TextButton(
                          onPressed: () {
                            // Define the action when the button is pressed
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white, // Set text color to white
                          ),
                          child: Text(mosque.moduleName ?? 'Default Module'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    )
        : const Center(child: Text('Tiada Masjid Dilanggan')); // Displayed when the list is empty
  }

  Widget _buildMenuIconWithImage(String assetPath, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Image.asset(assetPath, height: 55, width: 55, color: color),
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
