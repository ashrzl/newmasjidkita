import 'dart:convert';
import 'package:flutter/services.dart';

class HadithController {
  // static Future<List<String>> loadHadithBukhari() async {
  //   try {
  //     var response = await rootBundle.loadString('data/hadith/');
  //     if (response.isNotEmpty) {
  //       var res = json.decode(response);
  //
  //       List<String> titles = [];
  //       if (res['data'] != null) {
  //         titles.add(res['data']['name'] ?? 'No Title');
  //       }
  //
  //       return titles;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print("Error loading or parsing JSON: $e");
  //     return [];
  //   }
  // }

  static Future<List<String>> loadHadithNawawi() async {
    // Similar structure for loading Hadith Nawawi
    try {
      var response = await rootBundle.loadString('data/hadith/nawawi40.json');
      if (response.isNotEmpty) {
        var res = json.decode(response);

        List<String> titles = [];
        if (res['data'] != null) {
          titles.add(res['data']['english']['title'] ?? 'No Title');
        }

        return titles;
      } else {
        return [];
      }
    } catch (e) {
      print("Error loading or parsing JSON: $e");
      return [];
    }
  }
}
