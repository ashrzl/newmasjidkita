import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_mk_v3/controller/prayertime_controller.dart';
import 'package:new_mk_v3/model/location_model.dart';
import 'package:new_mk_v3/model/prayer_model.dart';

/*
* Project: MasjidKita Mobile App - V3
* Description: View Prayers Time
* Author: AIMAN SHARIZAL
* Date: 19 November 20204
* Version: 1.0
*/

class PrayerTimesPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  PrayerTimesPage({required this.latitude, required this.longitude});

  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  final PrayerTimesController _controller = PrayerTimesController();
  PrayerTimesModel? _prayerTimes;
  LocationModel? _currentLocation;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _currentLocation = await _controller.fetchAddress(widget.latitude, widget.longitude);
      _prayerTimes = await _controller.fetchPrayerTimes(widget.latitude, widget.longitude);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waktu Solat', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6B2572),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _buildPrayerTimesContent(),
    );
  }

  Widget _buildPrayerTimesContent() {
    final prayerNames = ['Fajr', 'Imsak', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Color(0xFF5C0065),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMMM yyyy, h:mm a').format(DateTime.now()),
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lokasi: ${_currentLocation?.address ?? 'Fetching location...'}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: prayerNames.map((name) {
                final time = _prayerTimes?.timings[name];
                return time != null
                    ? Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: Text(time, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  ),
                )
                    : SizedBox.shrink();
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
