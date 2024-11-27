import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_mk_v3/model/mosque_model.dart';
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

  Future<List<Mosque>> fetchSubscribeMosques() async {
    // Log the start of the fetch operation
    print("Fetching subscribe mosques...");

    final response = await http.get(
      Uri.parse('https://api.cmsb-env2.com.my/api/UserAccounts/GetUserTntLists'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    // Log the response status code
    print("Response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Log the response body
      print("Response body: ${response.body}");

      final jsonResponse = jsonDecode(response.body);

      // Navigate to the 'data' key first
      if (jsonResponse.containsKey('data') && jsonResponse['data'].containsKey('\$values')) {
        final List<dynamic> mosquesData = jsonResponse['data']['\$values'];

        // Log the number of mosques received
        print("Number of mosques found: ${mosquesData.length}");

        // Map the mosques data to Mosque objects
        try {
          return mosquesData.map((item) {
            print("Parsing mosque item: $item"); // Log each mosque item being parsed
            return Mosque.fromJson(item);
          }).toList();
        } catch (e) {
          print("Error parsing mosque items: $e"); // Catch any parsing errors
          return [];
        }
      } else {
        print("Response does not contain 'data' or '\$values' key.");
        return [];
      }
    } else {
      print("Failed to fetch mosques: ${response.reasonPhrase}"); // Log the error message
      return [];
    }
  }

  // Future<List<Mosque>> fetchFavoriteMosques() async {
  //   // Log the start of the fetch operation
  //   print("Fetching favorite mosques...");
  //
  //   final response = await http.get(
  //     Uri.parse('https://api.cmsb-env2.com.my/api/Tnmosques'),
  //     headers: {
  //       'Authorization': 'Bearer $authToken',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //
  //   // Log the response status code
  //   print("Response status code: ${response.statusCode}");
  //
  //   if (response.statusCode == 200) {
  //     // Log the response body
  //     print("Response body: ${response.body}");
  //
  //     final jsonResponse = jsonDecode(response.body);
  //
  //     // Check if '$values' key exists in the response
  //     if (jsonResponse.containsKey('\$values')) {
  //       final List<dynamic> mosquesData = jsonResponse['\$values'];
  //
  //       // Log the number of mosques received
  //       print("Number of mosques found: ${mosquesData.length}");
  //
  //       // Map the mosques data to Mosque objects
  //       try {
  //         return mosquesData.map((item) {
  //           print("Parsing mosque item: $item"); // Log each mosque item being parsed
  //           return Mosque.fromJson(item);
  //         }).toList();
  //       } catch (e) {
  //         print("Error parsing mosque items: $e"); // Catch any parsing errors
  //         return [];
  //       }
  //     } else {
  //       print("Response does not contain '\$values' key.");
  //       return [];
  //     }
  //   } else {
  //     print("Failed to fetch mosques: ${response.reasonPhrase}"); // Log the error message
  //     return [];
  //   }
  // }
}
