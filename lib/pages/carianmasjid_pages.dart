import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/carianmasjid_controller.dart';
import 'package:provider/provider.dart';
import 'package:new_mk_v3/navigationdrawer.dart';
import 'home_pages.dart';

class CarianMasjid extends StatefulWidget {
  @override
  _CarianMasjidState createState() => _CarianMasjidState();
}

class _CarianMasjidState extends State<CarianMasjid> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce; // Add this line to declare the Timer

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Only call fetchMosques when the user stops typing for 500ms
      final provider = Provider.of<CarianMasjidController>(context, listen: false);
      provider.updateSearchText(text);
      provider.fetchMosquesByKeyword(text);
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
        currentIndex: provider.selectedIndex,
        selectedItemColor: Color(0xFF6B2572),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          provider.updateSelectedIndex(index);
        },
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
              onChanged: _onSearchChanged, // Use the debounced function
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
                    return ListTile(
                      title: Text(provider.filteredMosques[index].mosName),
                      subtitle: Text(provider.filteredMosques[index].address),
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
