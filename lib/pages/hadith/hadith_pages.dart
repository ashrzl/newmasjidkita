import 'package:flutter/material.dart';
import 'package:new_mk_v3/controller/hadith_controller.dart';
import 'package:new_mk_v3/pages/home_pages.dart';

class HadithPages extends StatefulWidget {
  @override
  _HadithPagesState createState() => _HadithPagesState();
}

class _HadithPagesState extends State<HadithPages> {
  // Method to load both Hadith collections
  // Future<List<String>> loadAllHadiths() async {
  //   List<String> allHadiths = [];
  //   try {
  //     List<String> bukhariTitles = await HadithController.loadHadithBukhari();
  //     allHadiths.addAll(bukhariTitles);
  //
  //     List<String> nawawiTitles = await HadithController.loadHadithNawawi();
  //     allHadiths.addAll(nawawiTitles);
  //   } catch (e) {
  //     print("Error loading hadith collections: $e");
  //   }
  //
  //   return allHadiths;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'KOLEKSI HADIS SAHIH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6B2572),
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/purple_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // FutureBuilder<List<String>>(
          //   // future: loadAllHadiths(),  // Call the combined method
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError) {
          //       print("FutureBuilder error: ${snapshot.error}");
          //       return Center(child: Text('Error loading titles'));
          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //       return Center(child: Text('No titles found'));
          //     }
          //
          //     return ListView.builder(
          //       physics: BouncingScrollPhysics(),
          //       padding: EdgeInsets.all(8.0),
          //       itemCount: snapshot.data!.length,
          //       itemBuilder: (context, index) {
          //         return Card(
          //           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          //           color: Colors.white.withOpacity(0.9),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //           elevation: 4.0,
          //           child: ListTile(
          //             leading: Icon(Icons.book, color: Color(0xFF6B2572)),
          //             title: Text(
          //               snapshot.data![index],
          //               style: TextStyle(
          //                 fontSize: 16.0,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.black,
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

}
