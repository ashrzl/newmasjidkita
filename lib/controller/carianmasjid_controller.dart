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
  int selectedIndex = 1;

  CarianMasjidController() {
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _checkAndStoreToken();
    await getCurrentAddress();
  }

  Future<void> _checkAndStoreToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      token = '$token'; // Replace with actual token retrieval
      await prefs.setString('token', token);
    }
  }

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // Modified function to allow searching by keyword across multiple fields
  Future<void> fetchMosquesByKeyword(String keyword) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      // Use the keyword in the query string
      final url = Uri.parse('$apiEndpoint?keyword=$keyword');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List data = responseData['data'] ?? [];

        // Map the results to Mosque objects and update both mosqueResults and filteredMosques
        mosqueResults = data.map((json) => Mosque.fromJson(json)).toList();
        filteredMosques = List.from(mosqueResults); // Display all initially
        print('$apiEndpoint?keyword=$keyword');
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = 'Error fetching data: $e';
      mosqueResults = [];
      filteredMosques = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  // Modify the search function to check for keyword matches in various fields
  void updateSearchText(String text) {
    searchText = text;
    filteredMosques = mosqueResults
        .where((mosque) =>
    mosque.mosName.toLowerCase().contains(text.toLowerCase()) ||
        mosque.address.toLowerCase().contains(text.toLowerCase()) ||
        mosque.mosEmail.toLowerCase().contains(text.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
