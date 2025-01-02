import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:new_mk_v3/pages/quran/surahdetail_pages.dart';
import 'package:quran/quran.dart' as quran;

/*
* Project: MasjidKita Mobile App - V3
* Description: View List of Surah in Al-Quran
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
* Version: 1.0
*/

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  int _itemsToShow = 28; // Number of items to display initially
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading process (replace with actual data fetching if needed)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _loadMoreItems() async {
    if (_itemsToShow >= quran.totalSurahCount) return; // Stop if already displaying all Surahs

    setState(() {
      _isLoading = true;
    });

    // Simulate loading process
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _itemsToShow = (_itemsToShow + 28 > quran.totalSurahCount)
          ? quran.totalSurahCount
          : _itemsToShow + 28; // Ensure it does not exceed the total count
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Al-Quran',
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
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        toolbarHeight: 100,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadMoreItems,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: (_itemsToShow > quran.totalSurahCount)
                    ? quran.totalSurahCount
                    : _itemsToShow,
                itemBuilder: (context, index) {
                  int surahNumber = index + 1;
                  return Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.deepPurple[50],
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(18.0),
                      title: Text(
                        quran.getSurahName(surahNumber),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Scheherazade',
                          color: Colors.blue[800],
                        ),
                      ),
                      subtitle: Text(
                        "Surah ${quran.getSurahName(surahNumber)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue[900],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SurahDetailPage(surahNumber: surahNumber),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/icon/brownquran.png', // Replace with your image path
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Papar $_itemsToShow dari ${quran.totalSurahCount} Surah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
