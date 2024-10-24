import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  // Position? _currentPosition;
  String _currentAddress = 'Fetching location...';
  String? _authToken;
  String? UserName;
  String? Email;
  String? PhoneNo;
  String? _imageUrl;
  String? UserId;

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    SharedPreferences.getInstance().then((prefs) {
      String? savedUserName = prefs.getString('UserName');
      print('Saved username in HomePage: $savedUserName'); // Debugging print
      _loadUserInfo().then((_) {
        print('Loaded user info: Token: $_authToken, UserId: $UserId'); // Debugging line
        if (_authToken != null && UserId != null) {
          fetchUserInfo(); // Call only if token and UserId are loaded
        } else {
          print('Token or UserId is null, skipping fetchUserInfo.');
        }
      });
    });
  }

  Future<void> _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('Token'); // Make sure this matches the saved token key
      UserId = prefs.getString('UserId'); // Load UserId from SharedPreferences
    });

    print('Loaded Token: $_authToken, UserId: $UserId'); // Debugging line
  }

  Future<void> fetchUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('Token');
      String? userId = prefs.getString('UserId');

      print('Logged in user: $userId');

      if (token == null || userId == null) {
        print('No token or UserId found, user not logged in.');
        return;
      }

      final response = await http.get(
        Uri.parse('https://test.cmsbstaging.com.my/web-api/api/UserAccounts/GetUserProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('User Info API response: $jsonResponse');

        if (jsonResponse['data'] != null) {
          setState(() {
            UserName = jsonResponse['data']['Uaname'] ?? 'Unknown User';
            Email = jsonResponse['data']['Email'] ?? 'No Email';
            PhoneNo = jsonResponse['data']['PhoneNo'] ?? 'No Phone';
            _imageUrl = jsonResponse['data']['UaphotoUrl'] != null
                ? 'https://test.cmsbstaging.com.my${jsonResponse['data']['UaphotoUrl']}'
                : null;
          });

          print('UserName: $UserName, Email: $Email, PhoneNo: $PhoneNo, Image URL: $_imageUrl');
        } else {
          print('No user data found in the response.');
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized error
        print('Token expired or unauthorized access');
      } else {
        print('Failed to load user info: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }


  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //
  //   if (placemarks.isNotEmpty) {
  //     Placemark place = placemarks[0];
  //     String address = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
  //
  //     setState(() {
  //       _currentPosition = position;
  //       _currentAddress = address.isNotEmpty ? address : 'Address not found';
  //     });
  //   } else {
  //     setState(() {
  //       _currentAddress = 'Address not found';
  //     });
  //   }
  // }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigate based on the selected index
    switch (index) {
      case 0:
      // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
      // Navigate to the search page (implement this page)
        break;
      case 2:
      // Navigate to the profile page (implement this page)
        break;
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
            _buildFeatureIcons(),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6B2572),
        onTap: _onItemTapped,
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: _imageUrl != null
                ? NetworkImage(_imageUrl!) as ImageProvider<Object>
                : AssetImage('assets/user.png') as ImageProvider<Object>,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${UserName ?? "No Name"}', style: TextStyle(fontSize: 15)), // Handle null safely
              SizedBox(height: 8),
              Text('Email: ${Email ?? "No Email"}', style: TextStyle(fontSize: 15)), // Handle null safely
              SizedBox(height: 8),
              Text('Phone: ${PhoneNo ?? "No Phone Number"}', style: TextStyle(fontSize: 15)), // Handle null safely
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMenuIconWithImage('assets/solat.png', 'Waktu Solat', const Color(0xFF6B2572)),
            SizedBox(width: 16),
            _buildMenuIconWithImage('assets/qibla.png', 'Kiblat', const Color(0xFF6B2572)),
            SizedBox(width: 16),
            _buildMenuIconWithImage('assets/read-quran.png', 'Al-Quran', const Color(0xFF6B2572)),
            SizedBox(width: 16),
            _buildMenuIconWithImage('assets/hadis.png', 'Hadis', const Color(0xFF6B2572)),
            SizedBox(width: 16),
            _buildMenuIconWithImage('assets/kaabah.png', 'Haji & Umrah', const Color(0xFF6B2572)),
          ],
        ),
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
              Text('Masjid Dilanggan'),
              Text('Masjid Diikuti'),
            ],
          ),
          Container(
            height: 300,
            child: const TabBarView(
              children: [
                Center(child: Text('Masjid Dilanggan')),
                Center(child: Text('Masjid Diikuti')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIconWithImage(String assetPath, String label, Color color) {
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
