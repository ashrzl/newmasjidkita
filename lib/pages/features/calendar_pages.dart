import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/features/activity_pages.dart';
import 'package:new_mk_v3/pages/landing_pages.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _activities = {}; // Map to store activities for each date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
          },
        ),
        toolbarHeight: 120,
        centerTitle: true,
        title: Text(
          'Kalendar',
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // Navigate to the ActivityPage when a date is selected
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityPage(
                      selectedDay: _selectedDay,
                    ),
                  ),
                );
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
            ),
            _selectedDay != null
                ? Text(
              'Selected Day: ${_selectedDay?.toLocal()}',
              style: TextStyle(fontSize: 18),
            )
                : SizedBox(),
            _activities.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  DateTime date = _activities.keys.elementAt(index);
                  return ListTile(
                    title: Text('Activity on ${date.toLocal()}'),
                    subtitle: Text(_activities[date]!),
                  );
                },
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
