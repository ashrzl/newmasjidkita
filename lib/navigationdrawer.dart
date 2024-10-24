import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/login_pages.dart';


import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = -1; // Variable to track the selected tile

  // Function to handle logout
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved preferences (session data)

    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: 'Log Masuk')),
          (Route<dynamic> route) => false, // Remove all previous routes
    );
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Log Keluar Berjaya!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _scaffoldKey,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildListTile(
            context,
            index: 0,
            title: 'Kemaskini Profil',
            icon: Icons.person_outline,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          buildListTile(
            context,
            index: 1,
            title: 'Ubah Katalaluan',
            icon: Icons.lock_outline,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          buildListTile(
            context,
            index: 2,
            title: 'Hubungi Kami',
            icon: Icons.phone_outlined,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          buildListTile(
            context,
            index: 3,
            title: 'Bantuan',
            icon: Icons.help_outline,
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          Spacer(), // Push the logout button to the bottom
          buildListTile(
            context,
            index: 4,
            title: 'Log Keluar',
            icon: Icons.logout,
            onTap: () {
              setState(() {
                _selectedIndex = 4;
              });
              _logout(); // Trigger the logout process
            },
          ),
        ],
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, {
        required int index,
        required String title,
        required IconData icon,
        required Function onTap,
      }) {
    bool isSelected = _selectedIndex == index;
    return Card(
      color: isSelected ? Colors.purple : Colors.white, // Change color if selected
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black, // Change text color
          ),
        ),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Color(0xFF6B2572), // Change icon color
        ),
        onTap: () => onTap(), // Execute the onTap function
      ),
    );
  }
}
