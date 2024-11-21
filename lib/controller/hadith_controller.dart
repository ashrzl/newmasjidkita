import 'dart:convert';
import 'package:flutter/services.dart';

class HadithController {
  static Future<List<Map<String, dynamic>>> loadHadiths() async {
    try {
      // Load the JSON file from assets
      var response = await rootBundle.loadString('data/nawawi40.json');
      if (response.isNotEmpty) {
        // Decode the JSON data
        var res = json.decode(response);

        // Extract the 'hadiths' list from the decoded JSON
        List<dynamic> hadithList = res['hadiths'] ?? [];

        // Map the data to the desired structure
        return hadithList.map((hadith) {
          return {
            'arabic': hadith['arabic'],
            'englishTitle': hadith['english']['title'],
            'englishNarrator': hadith['english']['narrator'],
            'englishText': hadith['english']['text']
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error loading or parsing JSON: $e");
      return [];
    }
  }
}
