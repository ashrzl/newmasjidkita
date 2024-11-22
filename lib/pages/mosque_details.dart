import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/model/mosque_model.dart';
import 'package:new_mk_v3/pages/carianmasjid_pages.dart';
import 'package:provider/provider.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Masjid Details Page
* Author: AIMAN SHARIZAL
* Date: 22 November 2024
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarianMasjidController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C0065),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
            Text("Lokasi Anda:", style: TextStyle(color: Colors.white)),
            Text(provider.currentAddress,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Masjid",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
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
                icon: Icon(Icons.favorite_border, color: Colors.red),
                onPressed: () {
                // Add to favorites
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.purple,
                //     shape: StadiumBorder(),
                //   ),
                //   onPressed: () {
                //     // KhairatKITA functionality
                //   },
                //   child: Text("KhairatKITA"),
                // ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.purple,
                //     shape: StadiumBorder(),
                //   ),
                //   onPressed: () {
                //     // KariahKITA functionality
                //   },
                //   child: Text("KariahKITA"),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
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
                        //AktivitiMasjid Tab
                        Center(
                          child: Text("Aktiviti Masjid content here"),
                        ),
                        Center(
                          //Lokasi Tab
                          child: Image.network(
                            'https://via.placeholder.com/350x150', // Replace with map image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
