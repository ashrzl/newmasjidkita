import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/features/videodetail_pages.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';

class VideoListPage extends StatelessWidget {
  final List<Map<String, String>> videos;

  VideoListPage({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Senarai Video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Scheherazade',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to the settings page or handle the settings action
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SettingsPage()),
              // );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        toolbarHeight: 120,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];

          // Safe access to the keys in the map
          final String? thumbnail = video['thumbnail'];
          final String? url = video['url'];

          // Check if any required field is null
          if (thumbnail == null || url == null) {
            return SizedBox.shrink();
          }

          return GestureDetector(
            onTap: () {
              // Navigate to the VideoDetailPage when the thumbnail is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoDetailPage(videoUrl: url),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  thumbnail,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
