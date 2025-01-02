import 'package:flutter/material.dart';
import 'package:new_mk_v3/model/senaraimasjid_model.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class MasjidListScreen extends StatefulWidget {
  @override
  _MasjidListScreenState createState() => _MasjidListScreenState();
}

class _MasjidListScreenState extends State<MasjidListScreen> {
  late Future<List<SenaraiMasjid>> _masjidListFuture;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _masjidListFuture = loadMasjidList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LandingPage()));
          },
        ),
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'Senarai Masjid',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings action
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<SenaraiMasjid>>(
        future: _masjidListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final masjidList = snapshot.data!;
          return ListView.builder(
            itemCount: masjidList.length,
            itemBuilder: (context, index) {
              final masjid = masjidList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black12),
                ),
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      masjid.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    masjid.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(masjid.subtitle),
                  onTap: () {
                    _launchURL(masjid.url);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}