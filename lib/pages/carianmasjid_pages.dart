import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:new_mk_v3/model/mosque_model.dart';
import 'dart:async'; // Import for Timer
import 'dart:convert';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarianMasjid extends StatefulWidget {
  @override
  _CarianMasjidState createState() => _CarianMasjidState();
}

class _CarianMasjidState extends State<CarianMasjid> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  String _currentAddress = 'Lokasi...';
  List<Mosque> _mosqueResults = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;
  Timer? _debounce; // Define a Timer for debouncing

  @override
  void initState() {
    super.initState();
    searchMosques(""); // Load all mosques initially
    _getCurrentLocation();
  }

  // Custom debounce function
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMosques(query);
    });
  }

  // Fetch mosques by search term
  Future<void> searchMosques(String tnName) async {
    setState(() {
      _isSearching = true;
    });

    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Retrieved token: $token');  // Debugging line to check token retrieval

    if (token == null || token.isEmpty) {
      print('Error: No token found');
      setState(() {
        _isSearching = false;
      });
      return;
    }

    // Now you can proceed to make the API request using the token
    final url = Uri.parse(
      'https://api.cmsb-env2.com.my/api/UserAccounts/GetUserTntLists?search=$tnName',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Add the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List data = responseData['data'] ?? [];

        setState(() {
          _mosqueResults = data.map((json) => Mosque.fromJson(json)).toList();
          _isSearching = false;
        });
      } else {
        print('API Error: ${response.statusCode}');
        setState(() {
          _isSearching = false;
        });
      }
    } catch (error) {
      print('Request failed: $error');
      setState(() {
        _isSearching = false;
      });
    }
  }



  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

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

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
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
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C0065),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
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
      endDrawer: Drawer(
        child: ProfileScreen(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF5C0065),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged, // Use the custom debouncer
                    decoration: InputDecoration(
                      hintText: 'Carian Masjid',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carian Masjid',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      'Jumlah Masjid Dijumpai: ${_mosqueResults.length}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20.0),
                    _isSearching
                        ? Center(child: CircularProgressIndicator())
                        : _mosqueResults.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _mosqueResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_mosqueResults[index].mosName),
                          subtitle: Text(_mosqueResults[index].address),
                        );
                      },
                    )
                        : Text('Tiada Masjid dijumpai.'),
                  ],
                ),
              ),
            ),
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
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
