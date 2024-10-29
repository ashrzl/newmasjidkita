import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/login_pages.dart';
import 'package:new_mk_v3/pages/prayertimes_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
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
    _getCurrentLocation();
    SharedPreferences.getInstance().then((prefs) {
      String? savedUserName = prefs.getString('UserName');
      print('Saved username in HomePage: $savedUserName'); // Debugging print
      _loadUserInfo().then((_) {
        print(
            'Loaded user info: Token: $_authToken, UserId: $UserId'); // Debugging line
        if (_authToken != null && UserId != null) {
          fetchUserInfo();
          fetchFavoriteMosques(); // Call only if token and UserId are loaded
        } else {
          print('Token or UserId is null, skipping fetchUserInfo.');
        }
      });
    });
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

  Future<void> _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString(
          'Token'); // Make sure this matches the saved token key
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
        Uri.parse(
            'https://api.cmsb-env2.com.my/api/UserAccounts/GetUserProfile'),
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
                ? 'https://cmsb-env2.com.my${jsonResponse['data']['UaphotoUrl']}'
                : null;
          });

          print(
              'UserName: $UserName, Email: $Email, PhoneNo: $PhoneNo, Image URL: $_imageUrl');
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

  List<Map<String, dynamic>> favoriteMosques = [];

  Future<void> fetchFavoriteMosques() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.cmsb-env2.com.my/api/UserAccounts/GetUserTntLists?userId=$UserId'),
        // Include userId if required
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Fetched mosques: ${jsonResponse['data']}');
        if (jsonResponse['data'] != null &&
            jsonResponse['data']['\$values'] != null) {
          List mosques = jsonResponse['data']['\$values'];
          setState(() {
            favoriteMosques = List<Map<String, dynamic>>.from(mosques);
          });
        } else {
          print(
              'No favorite mosques found or invalid structure. Response: $jsonResponse');
        }
      } else {
        print('Failed to load favorite mosques: ${response.body}');
      }
    } catch (e) {
      print('Error fetching favorite mosques: $e');
    }
  }

  // Replace this URL with your actual API endpoint
  String hadisApiUrl = 'https://hadis.my/api/hadisharian';

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
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        break;
      case 2:
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginPage(title: '')));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lokasi Anda:", style: TextStyle(color: Colors.white)),
            Text(_currentAddress,
                style: TextStyle(fontSize: 14, color: Colors.white)),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Carian Masjid'),
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
      child: Container(
        padding: EdgeInsets.all(16), // Additional padding inside the container
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset for the shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container( // Wrap CircleAvatar in a Container
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Ensures the container is circular
                border: Border.all(color: Color(0xFF5C0065),
                    width: 5), // Set border color and width
              ),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl!) as ImageProvider<Object>
                    : AssetImage('assets/user.png') as ImageProvider<Object>,
              ),
            ),
            SizedBox(width: 12),
            Expanded( // Use Expanded to allow flexibility in the Column width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${UserName ?? "No Name"}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 8),
                  Text('Email: ${Email ?? "No Email"}',
                      style: TextStyle(fontSize: 15)),
                  SizedBox(height: 8),
                  Text('Phone: ${PhoneNo ?? "No Phone"}',
                      style: TextStyle(fontSize: 15)),
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => QiblaDirectionPage(),
                //   ),
                // );
              },
              child: _buildMenuIconWithImage('assets/qibla.png', 'Kiblat', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => QuranPage(),
                //   ),
                // );
              },
              child: _buildMenuIconWithImage('assets/read-quran.png', 'Al-Quran', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  String hadis = await fetchHadis(); // Fetch Hadis from API
                  // Show dialog with the Hadis message
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Satu Hari, Satu Hadis'),
                        content: Text(hadis),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Tutup'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  // Handle error, e.g., show a SnackBar with an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Carian Hadis Gagal.'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                }
              },
              child: _buildMenuIconWithImage('assets/hadis.png', 'Hadis', const Color(0xFF6B2572)),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   // context,
                //   // MaterialPageRoute(
                //   //   // builder: (context) => HajjUmrahPage(),
                //   // ),
                // );
              },
              child: _buildMenuIconWithImage('assets/kaabah.png', 'Haji & Umrah', const Color(0xFF6B2572)),
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
              Text('Masjid Dilanggan'),
              Text('Masjid Diikuti'),
            ],
          ),
          Container(
            height: 300,
            child: TabBarView(
              children: [
                Center(child: Text('Masjid Dilanggan')),
                // Replace with actual data if available
                favoriteMosques.isNotEmpty
                    ? ListView.builder(
                  itemCount: favoriteMosques.length,
                  itemBuilder: (context, index) {
                    final mosque = favoriteMosques[index];
                    final moduleName = mosque['ModuleName'] ?? 'Unknown';
                    Color buttonColor;

                    // Determine button color based on ModuleName
                    if (moduleName == 'KariahKITA') {
                      buttonColor =
                          Color(0xFF6B2572); // Button color for Module1
                    } else if (moduleName == 'KhairatKITA') {
                      buttonColor = Colors.green; // Button color for Module2
                    } else {
                      buttonColor = Colors
                          .grey; // Default color if ModuleName is not matched
                    }

                    return ListTile(
                      title: Text(mosque['TnName'] ?? 'Unknown Mosque'),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              moduleName,
                              overflow: TextOverflow
                                  .ellipsis, // Handle overflow
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Define your action here
                              print('Button pressed for: $moduleName');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: buttonColor, // Text color on the button
                            ),
                            child: Text(
                              moduleName, // Use ModuleName as button label
                              style: TextStyle(
                                  fontSize: 12), // Adjust font size if needed
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Center(child: Text('Tiada Masjid Diikuti')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuIconWithImage(String assetPath, String label, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}
