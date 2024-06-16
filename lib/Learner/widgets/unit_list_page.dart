import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'unit_detail_page.dart'; // Import the UnitDetailPage

class UnitListPage extends StatefulWidget {
  final String courseID;

  const UnitListPage({required this.courseID, super.key});

  @override
  _UnitListPageState createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  List<Map<String, dynamic>> units = [];

  @override
  void initState() {
    super.initState();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    try {
      print('Fetching units for courseID: ${widget.courseID}');
      QuerySnapshot unitsSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.courseID)
          .collection('units')
          .get();

      if (unitsSnapshot.docs.isNotEmpty) {
        setState(() {
          units = unitsSnapshot.docs
              .map((doc) => {
                    'unitID': doc.id,
                    'courseID': doc['courseID'],
                    'imageUrl': doc['imageUrl'],
                    'unitContent': doc['unitContent'],
                    'unitDescription': doc['unitDescription'],
                    'unitName': doc['unitName'],
                    'unitURL': doc['unitURL'],
                  })
              .toList();
        });
        print('Fetched units: $units');
      } else {
        print('No units found for courseID: ${widget.courseID}');
      }
    } catch (e) {
      print('Error fetching units: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: units.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                return Card(
                  child: ListTile(
                    title: Text(unit['unitName']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnitDetailPage(unit: unit),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
