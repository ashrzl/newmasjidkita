import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:new_mk_v3/pages/features/activity_pages.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _now = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  // Special dates mapped with their corresponding events
  final Map<DateTime, List<String>> _specialDates = {
    DateTime(2020, 1, 11): ['Special Event 1'],
    DateTime(2025, 1, 9): ['Ceramah Ustaz Azhar Idrus'],
    DateTime(2025, 5, 15): ['Special Event 2'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _specialDates[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalendar Masjid',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        elevation: 4.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(height: 16),
            if (_getEventsForDay(_selectedDate).isNotEmpty)
              Text(
                'Events: ${_getEventsForDay(_selectedDate).join(', ')}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              )
            else
              const Text(
                'No events on this day.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ActivityPage and pass the selected date
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityPage(selectedDay: _selectedDate),
            ),
          );
        },
        tooltip: 'Tambah Aktiviti',
        child: const Icon(Icons.add),
      ),
    );
  }
}
