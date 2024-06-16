import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langify/Expert/Quizmaker_home.dart';
import 'package:langify/utils/color_utils.dart';


class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
         backgroundColor: hexStringToColor("696E79"),
         foregroundColor: Colors.white,
      ),
       backgroundColor: hexStringToColor("696E79"),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        
                         print('Card tapped');
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
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
                                  Text(doc['quizName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 8),
                                   if (doc['Image'] != null) // Check if imageUrl field exists
                              Image.network(doc['Image'], fit: BoxFit.cover), // Display the image
                                  const SizedBox(height: 8),
                                  Text(doc['quizDescription'], style: const TextStyle(fontSize: 16, color: Colors.white)),
                                  const SizedBox(height: 8),
                               Wrap(
                                     spacing: 8.0, // Gap between adjacent chips.
                                     runSpacing: 4.0, // Gap between lines.
                                    children: (doc['quizTags'] as List<dynamic>)
                                    .map<Widget>((tag) => Chip(
                                    label: Text(tag),
                                    ))
                                 .toList(),
                                 ),
                                  const SizedBox(height: 8),
                                  Text(doc['quizID'], style: const TextStyle(fontSize: 14, color: Colors.white)),
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
                  MaterialPageRoute(builder: (context) => QuizMakerHome()),
                );
              },
              style: ElevatedButton.styleFrom(
                 backgroundColor: hexStringToColor("132D46"), // Background color of the button
                  foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create a new quiz'),
            ),
          ),
        ],
      ),
    );
  }
}