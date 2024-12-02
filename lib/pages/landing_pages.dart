import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Background color of the AppBar
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        toolbarHeight: 120, // Increase height to fit content
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.asset(
                      'assets/icon/masjidKITA-logo.png', // Replace with your image asset path
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '"Hati yang paling bernilai adalah yang tetap dekat dengan Allah, bahkan ketika sedang sakit."',
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Kata Mutiara Islamik',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Prayer Time Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solat seterusnya Asar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '4:27 PM',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Zon: Puchong, Selangor\nJumaat, 29 Disember 2024',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true, // Prevents GridView from expanding infinitely
                physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: [
                  _buildCustomCard('assets/icon/kariahKITA.png', 'KARIAH KITA'),
                  _buildCustomCard('assets/icon/khairatKITA.png', 'KHAIRAT KITA'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 8.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.book, 'Al-Quran'),
            _buildNavItem(Icons.access_time, 'Waktu Solat'),
            _buildNavItem(Icons.holiday_village, 'Forum'),
            _buildNavItem(Icons.calendar_today, 'Kalendar'),
            _buildNavItem(Icons.share, 'Kongsi'),
          ],
        ),
      ),
    );
  }

  // Helper to build a card with an image
  Widget _buildCustomCard(String imagePath, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Icon on the left
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                height: 50, // Adjust height to fit your design
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8), // Add spacing between the logo and content
            // Content (Text or Placeholder) on the right
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 50, // Adjust height to fit your design
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a navigation item
  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue[900]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.blue[900], fontSize: 12),
        ),
      ],
    );
  }
}
