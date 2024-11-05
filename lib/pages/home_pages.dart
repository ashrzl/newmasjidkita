import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_mk_v3/controller/home_controller.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:new_mk_v3/model/user_model.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:new_mk_v3/pages/prayertimes_pages.dart';
import 'package:new_mk_v3/pages/qiblah_pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  User? _user;
  List<Mosque> _favoriteMosques = [];
  List<Mosque> _subscribeMosques = [];
  String _currentAddress = 'Fetching location...';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.loadUserInfo();
    _user = await _controller.fetchUserInfo();
    _favoriteMosques = await _controller.fetchFavoriteMosques();
    _subscribeMosques = await _controller.fetchSubscribeMosques();
    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied');
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
          '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place
              .country ?? ''}';
        });
      } else {
        setState(() {
          _currentAddress = 'Address not found';
        });
      }
    } catch (e) {
      print('Failed to get location: $e');
      setState(() {
        _currentAddress = 'Failed to get location';
      });
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
        currentIndex: 0, // Set your selected index here
        selectedItemColor: Color(0xFF6B2572),
        onTap: (index) {
          // Handle bottom navigation taps here
        },
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
                        : AssetImage('assets/user.png') as ImageProvider,
                    radius: 40.0,
                  ),
                ),
                // Pencil icon for updating profile picture
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF5C0065), width: 3),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF6B2572), size: 20.0),
                      onPressed: () {
                        // Define the action when the icon is pressed
                        // For example, show a dialog to update the profile picture
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
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
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrayerTimesPage(latitude: position.latitude, longitude: position.longitude),
                  ),
                );
              },
              child: _buildMenuIconWithImage('assets/solat.png', 'Waktu Solat', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QiblahCompassPage()),
                );
              },
              child: _buildMenuIconWithImage('assets/qibla.png', 'Kiblat', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to Al-Quran page
              },
              child: _buildMenuIconWithImage('assets/read-quran.png', 'Al-Quran', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                // Fetch and display Hadis
              },
              child: _buildMenuIconWithImage('assets/hadis.png', 'Hadis', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to  Zikir page
              },
              child: _buildMenuIconWithImage('assets/zikir.png', 'Zikir', const Color(0xFF6B2572)),
            ),
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
        ? ListView.builder(
      itemCount: mosques.length,
      itemBuilder: (context, index) {
        final mosque = mosques[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adds margin for spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mosque.mosName,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4), // Spacing between name and address
              Text(
                mosque.address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600], // Optional color for address text
                ),
              ),
              SizedBox(height: 8), // Spacing before divider
              if (index < mosques.length - 1) // Avoid divider after the last item
                const Divider(thickness: 1, color: Colors.grey),
            ],
          ),
        );
      },
    )
        : Center(child: Text('Tiada Masjid Diikuti'));
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
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        Divider(thickness: 1, color: Colors.grey),
        Expanded(
          child: ListView.builder(
            itemCount: mosques.length,
            itemBuilder: (context, index) {
              final mosque = mosques[index];

              // Determine the button color based on moduleName
              Color buttonColor;
              if (mosque.moduleName == 'KariahKITA') {
                buttonColor = Color(0xFF6B2572);
              } else if (mosque.moduleName == 'KhairatKITA') {
                buttonColor = Colors.green;
              } else {
                buttonColor = Colors.grey;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adds margin for spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.tnName,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
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
                    const Divider(thickness: 1, color: Colors.grey), // Adds a divider to separate each item
                  ],
                ),
              );
            },
          ),
        ),
      ],
    )
        : Center(child: Text('Tiada Masjid Dilanggan'));
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
