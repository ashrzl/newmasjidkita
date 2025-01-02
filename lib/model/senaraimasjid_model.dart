import 'dart:convert';
import 'package:flutter/services.dart';

class SenaraiMasjid {
  final int id;
  final String title;
  final String subtitle;
  final String url;
  final String image;

  SenaraiMasjid({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.image,
  });

  factory SenaraiMasjid.fromJson(Map<String, dynamic> json) {
    return SenaraiMasjid(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      url: json['url'],
      image: json['image'],
    );
  }
}

Future<List<SenaraiMasjid>> loadMasjidList() async {
  try {
    final String response = await rootBundle.loadString('assets/data/masjid.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => SenaraiMasjid.fromJson(json)).toList();
  } catch (e) {
    print("Error loading data: $e");
    return [];
  }
}