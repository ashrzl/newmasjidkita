import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_mk_v3/controller/home_controller.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:new_mk_v3/model/user_model.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/carianmasjid_pages.dart';
import 'package:new_mk_v3/pages/dzikir.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:new_mk_v3/pages/prayertimes_pages.dart';
import 'package:new_mk_v3/pages/qiblah_pages.dart';
import 'package:new_mk_v3/pages/quran/quran_pages.dart';

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
  Position? _currentPosition;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

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

  static const String hadisApiUrl = 'https://hadis.my/api/hadisharian';

  Future<String> fetchHadis() async {
    try {
      // Log the start of the API call
      print('Fetching Hadis from $hadisApiUrl');

      final response = await http.get(Uri.parse(hadisApiUrl));

      // Log the status code received
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Log the response body for debugging
        print('Response body: ${response.body}');

        final data = json.decode(response.body);

        // Log the decoded data
        print('Decoded data: $data');

        // Access the list of Hadis from the "data" key
        if (data.containsKey('data') && data['data'].isNotEmpty) {
          // Extract the first Hadis from the list
          String hadis = data['data'][0]['hadis'];
          return hadis;
        } else {
          throw Exception('No Hadis found in the response data');
        }
      } else {
        // Handle unexpected status codes
        print('Error: Received status code ${response.statusCode}');
        throw Exception('Failed to load Hadis: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log any exceptions that occur during the process
      print('Exception occurred: $e');
      throw Exception('Failed to fetch Hadis due to an error: $e');
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
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CarianMasjid()));
        break;
      case 2:
      // Navigate to the profile page (you'll need to create this)
        break;
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
              ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}'
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                  child: _buildMenuIconWithImage('assets/solat.png', 'Waktu Solat', const Color(0xFF6B2572)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QiblahPage()),
                    );
                  },
                  child: _buildMenuIconWithImage('assets/qibla.png', 'Kiblat', const Color(0xFF6B2572)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuranPage()),
                    );
                  },
                  child: _buildMenuIconWithImage('assets/read-quran.png', 'Al-Quran', const Color(0xFF6B2572)),
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      String hadis = await fetchHadis(); // Fetch Hadis from API
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Satu Hari, Satu Hadis'),
                            content: Text(hadis),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load Hadis.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: _buildMenuIconWithImage('assets/hadis.png', 'Hadis', const Color(0xFF6B2572)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DzikirPagi())
                    );
                  },
                  child: _buildMenuIconWithImage('assets/zikir.png', 'Zikir', const Color(0xFF6B2572)),
                ),
              ],
            ),
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
                              : 'assets/MasjidKITALogo.png', // Fallback image
                          width: 60, // Adjust size as needed
                          height: 60, // Adjust size as needed
                          fit: BoxFit.cover, // Adjust fit as needed
                        ),
                        const SizedBox(width: 12), // Space between logo and name
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
                              : 'assets/MasjidKITALogo.png', // Fallback image
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
          child: Image.asset(assetPath, height: 38, width: 38, color: color),
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
