import 'dart:convert';
import 'package:flutter/services.dart';

class HadithController {
  static Future<List<Map<String, dynamic>>> loadHadiths() async {
    try {
      var response = await rootBundle.loadString('data/');
      if (response.isNotEmpty) {
        var res = json.decode(response);
        List<dynamic> hadithList = res['hadiths'] ?? [];
        return hadithList.map((hadith) {
          return {
            'arabic': hadith['arabic'],
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
