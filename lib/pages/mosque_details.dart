import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'package:new_mk_v3/pages/carianmasjid_pages.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:provider/provider.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Carian Masjid Page
* Author: AIMAN SHARIZAL
* Date: 21 November 2024
* Version: 1.0
* Additional Notes:
* - Display List of tenants
*/

class MasjidDetails extends StatefulWidget {
  const MasjidDetails({super.key});
  @override
  MasjidDetailsState createState() => MasjidDetailsState();
}

class MasjidDetailsState extends State<MasjidDetails>{

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent redundant navigation

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => CarianMasjidController(),
              child: CarianMasjid(),
            ),
          ),
        );
        break;
      case 2:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfilePage()), // Replace with your profile page
      // );
        break;
    }
  }

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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lokasi Anda:", style: TextStyle(color: Colors.white)),
            Text(provider.currentAddress, style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      endDrawer: Drawer(child: ProfileScreen()),
      body: Center(child: Text('Masjid Details')),  // Replace with your body widget
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Utama'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Carian Masjid'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex, // The currently selected index
        selectedItemColor: Color(0xFF6B2572),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
