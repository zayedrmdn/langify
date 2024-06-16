import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:langify/Expert/Coursemaker_home.dart';
import 'package:langify/utils/color_utils.dart';

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses Page'),
        backgroundColor: hexStringToColor("696E79"),
         foregroundColor: Colors.white,
      ),
      backgroundColor: hexStringToColor("696E79"),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        print('Course card tapped');
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                         color: hexStringToColor("132D46"),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['courseName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                    SizedBox(height: 8),
                                    if (doc['Image'] != null) // Check if imageUrl field exists
                                      Image.network(doc['Image'], fit: BoxFit.cover), // Display the image
                                    SizedBox(height: 8),
                                    Text(doc['courseDescription'], style: TextStyle(fontSize: 16, color: Colors.white)),
                                    SizedBox(height: 8),
                                    Text(doc['courseID'], style: TextStyle(fontSize: 14, color: Colors.white)),
                                    SizedBox(height: 8),
                                    Wrap(
                                      children: List<Widget>.from(doc['courseTags'].map((tag) => Chip(label: Text(tag,)))),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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
                  MaterialPageRoute(builder: (context) => CoursemakerHome()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: hexStringToColor("132D46"), // Background color of the button
                  foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Create a new course'),
            ),
          ),
        ],
      ),
    );
  }
}