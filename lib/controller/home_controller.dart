import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_mk_v3/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Controller for Retrieving User Info, Subscribe Mosque & Favourite Mosque
* Author: AIMAN SHARIZAL
* Date: 21 November 20204
* Version: 1.0
*/

class HomeController {
  String? authToken;
  String? userId;

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('Token');
    userId = prefs.getString('UserId');
  }

  Future<User?> fetchUserInfo() async {
    if (authToken == null || userId == null) return null;

    final response = await http.get(
      Uri.parse('https://api.cmsb-env2.com.my/api/UserAccounts/GetUserProfile'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse['data']);
    } else {
      // Handle error cases
      return null;
    }
  }
}
