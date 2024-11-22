import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:new_mk_v3/pages/mosque_details.dart';
import 'package:provider/provider.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: Carian Masjid Page
* Author: AIMAN SHARIZAL
* Date: 21 November 20204
* Version: 1.0
* Additional Notes:
* - Display List of tenants
*/

class CarianMasjid extends StatefulWidget {
  @override
  CarianMasjidState createState() => CarianMasjidState();
}

class CarianMasjidState extends State<CarianMasjid> {
  final TextEditingController _searchController = TextEditingController();
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
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty
          ? Center(child: Text(provider.errorMessage, style: TextStyle(color: Colors.red, fontSize: 22)))
          : _buildBody(provider),
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

  Widget _buildBody(CarianMasjidController provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF5C0065),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                provider.updateSearchText(value); // Real-time local filtering
              },
              onSubmitted: (value) {
                provider.fetchMosquesByKeyword(value); // Fetch from API
              },
              decoration: InputDecoration(
                hintText: 'Carian Masjid',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.mic, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carian Masjid',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Jumlah Masjid Dijumpai: ${provider.filteredMosques.length}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10.0),
                Divider(thickness: 1, color: Colors.grey),
                SizedBox(height: 20.0),
                provider.filteredMosques.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.filteredMosques.length,
                  itemBuilder: (context, index) {
                    final mosque = provider.filteredMosques[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                mosque.mosLogoUrl.isNotEmpty == true
                                    ? mosque.mosLogoUrl
                                    : 'assets/icon/MasjidKITALogo.png', // Fallback image
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10), // Add spacing between image and ListTile
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    mosque.mosName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                                  ),
                                  subtitle: Text(
                                    mosque.address,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                                  ),
                                ),
                              ),
                              // Pin location icon
                        IconButton(
                          icon: Icon(Icons.location_on, color: Color(0xFF6B2572)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MasjidDetails(mosque: mosque),
                              ),
                            );
                          },
                        ),
                        // Heart icon
                              IconButton(
                                icon: Icon(Icons.favorite_border, color: Colors.red), // Heart icon
                                onPressed: () {
                                  // Implement functionality for heart click (e.g., mark as favorite)
                                },
                              ),
                            ],
                          ),
                          const Divider( // Divider added below each result
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Text('Tiada Masjid dijumpai.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
