import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarianMasjidController extends ChangeNotifier {
  static const apiEndpoint = 'https://api.cmsb-env2.com.my/api/Tnmosques';

  bool isLoading = false;
  String errorMessage = '';
  String currentAddress = 'Lokasi...';
  List<Mosque> mosqueResults = [];
  List<Mosque> filteredMosques = [];
  String searchText = '';
  int selectedIndex = 1;

  Timer? _debounce;

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

  // Modify the search function to dynamically show results
  void updateSearchText(String text) {
    searchText = text.trim();

    // Clear results when the search field is empty
    if (searchText.isEmpty) {
      filteredMosques = [];
      notifyListeners();
      return;
    }

    // Cancel any existing debounce timer
    _debounce?.cancel();

    // Show instant results from current mosqueResults
    filteredMosques = mosqueResults
        .where((mosque) =>
        mosque.mosName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();

    // Set up debounce to fetch new results
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchMosquesByKeyword(searchText);
    });
  }

  Future<void> fetchMosquesByKeyword(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) return;

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      final url = Uri.parse('$apiEndpoint?keyword=$keyword');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> mosqueData = responseData['\$values'] ?? [];
        mosqueResults = mosqueData.map((json) => Mosque.fromJson(json)).toList();

        // Update filteredMosques with the latest results
        filteredMosques = mosqueResults
            .where((mosque) =>
            mosque.mosName.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
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
}
