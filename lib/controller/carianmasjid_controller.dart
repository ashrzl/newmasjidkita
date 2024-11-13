import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_mk_v3/model/mosque_model.dart';

class CarianMasjidController extends ChangeNotifier {
  static const apiEndpoint = 'https://api.cmsb-env2.com.my/api/Tnmosques';

  bool isLoading = false;
  String errorMessage = '';
  String currentAddress = 'Lokasi...';
  List<Mosque> mosqueResults = [];
  List<Mosque> filteredMosques = [];
  String searchText = '';

  // Selected index for BottomNavigationBar
  int selectedIndex = 1;

  // Initialize provider data
  CarianMasjidController() {
    getCurrentAddress();
  }

  // Update selected index and notify listeners
  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Fetch mosques by search term
  Future<void> fetchMosques(String searchQuery) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // Retrieve token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print('Token after store: $token');
      print('Token retrived: $token');  // Add this line for debugging

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      // Test SharedPreferences functionality by passing the token
      await testSharedPreferences(token);  // Pass the token here

      // API request
      final url = Uri.parse('$apiEndpoint?search=$searchQuery');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List data = responseData['data'] ?? [];
        mosqueResults = data.map((json) => Mosque.fromJson(json)).toList();
        filteredMosques = List.from(mosqueResults); // Initialize filtered results
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = 'Error fetching data: $e';
      mosqueResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // Retrieve and set current location address
  Future<void> getCurrentAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      currentAddress = placemarks.isNotEmpty
          ? '${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}'
          : 'Address not found';
    } catch (e) {
      currentAddress = 'Failed to get location: $e';
    } finally {
      notifyListeners();
    }
  }

  // Update filtered mosques based on search text
  void updateSearchText(String text) {
    searchText = text;
    filteredMosques = mosqueResults.where((mosque) => mosque.mosName.toLowerCase().contains(text.toLowerCase())).toList();
    notifyListeners();
  }

  // Test SharedPreferences functionality
// Test SharedPreferences functionality with token passed as parameter
  Future<void> testSharedPreferences(String tokenToStore) async {
    // Save the token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenToStore);

    // Retrieve the token
    String? tokenAfterStore = prefs.getString('token');
    print("Token after store: $tokenAfterStore");

    // Retrieve the token again
    String? tokenRetrieved = prefs.getString('token');
    print("Token retrieved = $tokenRetrieved");
  }

}
