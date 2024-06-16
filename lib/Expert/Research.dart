import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langify/Expert/Research_design.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:langify/utils/color_utils.dart';

class Research extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
         backgroundColor: hexStringToColor("696E79"),
         foregroundColor: Colors.white,
      ),
       backgroundColor: hexStringToColor("696E79"),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Research').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: const CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: hexStringToColor("132D46"),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['Topic'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(doc['Description'], style: const TextStyle(fontSize: 16, color: Colors.white)),
                            const SizedBox(height: 8),
                            if (doc['Image'] != null) // Check if imageUrl field exists
                              Image.network(doc['Image'], fit: BoxFit.cover), // Display the image
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                var url = Uri.parse(doc['DocumentURL']);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('URL is invalid'),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                doc['DocumentURL'],
                                style: const TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DesignResearch()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: hexStringToColor("132D46"), // Background color of the button
                 foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Design your research'),
            ),
          ),
        ],
      ),
    );
  }
}