import 'package:flutter/material.dart';
import 'package:new_mk_v3/pages/features/calendar_pages.dart';

class ActivityPage extends StatefulWidget {
  final DateTime? selectedDay;

  ActivityPage({required this.selectedDay});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktiviti Baharu', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[900],
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CalendarPage()));
          },
        ),
        toolbarHeight: 120,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title input
              _buildTextField(
                controller: titleController,
                hintText: 'Masukkan Nama Aktiviti',
                label: 'Nama Aktiviti',
                icon: Icons.title,
              ),
              SizedBox(height: 10),
              // Description input
              _buildTextField(
                controller: descriptionController,
                hintText: 'Masukkan Butiran',
                label: 'Butiran',
                icon: Icons.description,
                maxLines: 3,
              ),
              SizedBox(height: 15),
              // Start Date and End Date
              Row(
                children: [
                  _buildDateTimeButton(
                    label: 'Tarikh Mula',
                    selectedDate: _startDate,
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _startDate) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  _buildDateTimeButton(
                    label: 'Tarikh Tamat',
                    selectedDate: _endDate,
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != _endDate) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Start Time
              Row(
                children: [
                  _buildTimeButton(
                    label: 'Masa Mula',
                    time: _startTime,
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _startTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null && pickedTime != _startTime) {
                        setState(() {
                          _startTime = pickedTime;
                        });
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  _buildTimeButton(
                    label: 'Masa Tamat',
                    time: _endTime,
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _endTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null && pickedTime != _endTime) {
                        setState(() {
                          _endTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        _startDate != null &&
                        _endDate != null &&
                        _startTime != null &&
                        _endTime != null) {
                      // Here you can save the activity data
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, color: Colors.white)
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue[900]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue[900]!),
        ),
      ),
    );
  }

  // Helper method to build DateTime selection buttons
  Widget _buildDateTimeButton({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        backgroundColor: Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: Text(
        selectedDate == null ? label : '$label: ${selectedDate.toLocal()}',
        style: TextStyle(color: Colors.blue[900], fontSize: 16),
      ),
    );
  }

  // Helper method to build Time selection buttons
  Widget _buildTimeButton({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.0),
        backgroundColor: Colors.blue[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: Text(
        time == null ? label : '$label: ${time.format(context)}',
        style: TextStyle(color: Colors.blue[900], fontSize: 16),
      ),
    );
  }
}
