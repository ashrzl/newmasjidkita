import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:new_mk_v3/pages/mosque_details.dart';
import 'package:provider/provider.dart';

class CarianMasjid extends StatefulWidget {
  @override
  CarianMasjidState createState() => CarianMasjidState();
}

class CarianMasjidState extends State<CarianMasjid> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce; // Timer for debouncing input
  int _selectedIndex = 1;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
      // Implement Profile navigation here
        break;
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Debounce API calls to avoid spamming requests
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final provider = Provider.of<CarianMasjidController>(context, listen: false);
      if (value.trim().isEmpty) {
        provider.updateSearchText(value); // Local filtering
      } else {
        provider.fetchMosquesByKeyword(value); // Fetch from API
      }
    });
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
        currentIndex: _selectedIndex,
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
              focusNode: _focusNode,
              onChanged: _onSearchChanged, // Debounced search
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
                Text('Carian Masjid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                SizedBox(height: 20.0),
                Text('Jumlah Masjid Dijumpai: ${provider.filteredMosques.length}', style: TextStyle(fontSize: 16.0)),
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
                      child: ListTile(
                        leading: Image.asset(
                          mosque.mosLogoUrl.isNotEmpty
                              ? mosque.mosLogoUrl
                              : 'assets/icon/MasjidKITALogo.png', // Fallback image
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          mosque.mosName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          mosque.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            IconButton(
                              icon: Icon(Icons.favorite_border, color: Colors.red),
                              onPressed: () {
                                // Implement functionality for favorite
                              },
                            ),
                          ],
                        ),
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
