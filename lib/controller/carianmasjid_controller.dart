import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarianMasjidController extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  String currentAddress = 'Lokasi...';
  List<Mosque> mosqueResults = [];
  String searchText = '';
  Timer? _debounce;

  // Selected index for BottomNavigationBar
  int _selectedIndex = 1; // Default index

  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Fetch mosques by search term
  Future<void> searchMosques(String mosName) async {
    print('searchMosques called with keyword: $mosName');
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // Retrieve token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print('Retrieved token: $token');

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      // API request
      final url = Uri.parse('https://api.cmsb-env2.com.my/api/Tnmosques?search= $mosName');
      print('Making GET request to: $url');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // Handle the response
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data: $responseData');
        List data = responseData['data'] ?? [];
        mosqueResults = data.map((json) => Mosque.fromJson(json)).toList();
        print('Found ${mosqueResults.length} mosques');
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = e.toString();
      mosqueResults = [];
      print('Error during searchMosques: $e');
    } finally {
      isLoading = false;
      print('searchMosques completed');
      notifyListeners();
    }
  }

  Future<void> checkAndSearchMosques(String mosName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print('No token found, please log in first');
      return; // Exit if no token
    }

    // Proceed with search if token exists
    await searchMosques(mosName);
  }


  // Retrieve current location address
  Future<void> getCurrentAddress() async {
    print('getCurrentAddress called');
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location service enabled: $serviceEnabled');
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      print('Location permission status: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Requested location permission: $permission');
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Retrieved position: Latitude = ${position.latitude}, Longitude = ${position.longitude}');

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        currentAddress = '${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
        print('Current address: $currentAddress');
      } else {
        currentAddress = 'Address not found';
        print('No placemarks found');
      }
    } catch (e) {
      currentAddress = 'Failed to get location: $e';
      print('Error in getCurrentAddress: $e');
    } finally {
      notifyListeners();
    }
  }

  // Set search text and apply debounce
  void updateSearchText(String text) {
    print('updateSearchText called with: $text');
    searchText = text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      print('Executing search for: $searchText');
      searchMosques(searchText);
      checkAndSearchMosques(searchText);  // Use checkAndSearchMosques instead of searchMosques
    });
  }

  // Clean up resources
  @override
  void dispose() {
    print('CarianMasjidController disposed');
    _debounce?.cancel();
    super.dispose();
  }
}
