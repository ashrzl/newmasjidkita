import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:new_mk_v3/pages/carianmasjid_pages.dart';
import 'package:provider/provider.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Masjid Details Page
* Author: AIMAN SHARIZAL
* Date: 25 November 2024
* Version: 1.0
* Additional Notes:
* - Display location, activity and information
*/

class MasjidDetails extends StatefulWidget {
  final Mosque mosque;

  const MasjidDetails({required this.mosque, Key? key}) : super(key: key);

  @override
  MasjidDetailsState createState() => MasjidDetailsState();
}

class MasjidDetailsState extends State<MasjidDetails> {
  List<String> mosqueActivities = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
  }

  // Simulate fetching mosque activities
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarianMasjidController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C0065),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CarianMasjid()),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Lokasi Anda:", style: TextStyle(color: Colors.white)),
            Text(provider.currentAddress,
                style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Masjid",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.mosque.mosLogoUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/icon/MasjidKITALogo.png');
                  },
                ),
              ),
              title: Text(widget.mosque.mosName),
              subtitle: Text(widget.mosque.address),
              trailing: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.red),
                onPressed: () {
                  // Add to favorites
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.purple,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.purple,
                    tabs: [
                      Tab(text: "Aktiviti Masjid"),
                      Tab(text: "Lokasi Masjid"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Aktiviti Masjid Tab
                        Center(
                          child: mosqueActivities.isEmpty
                              ? const Text(
                            "Tiada Aktiviti",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                              : ListView.builder(
                            itemCount: mosqueActivities.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(mosqueActivities[index]),
                              );
                            },
                          ),
                        ),
                        // Lokasi Tab
                        Center(
                          // child: Image.network(
                          //   'https://via.placeholder.com/350x150', // Replace with actual map image URL
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
