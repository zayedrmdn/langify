import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'unit_detail_page.dart'; // Import the UnitDetailPage

class UnitListPage extends StatefulWidget {
 final String courseName;

 const UnitListPage({required this.courseName, Key? key}) : super(key: key);

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
    print('Fetching units for courseID: ${widget.courseName}');
    final unitsSnapshot = await FirebaseFirestore.instance
        .collection('Courses')
        .doc(widget.courseName)
        .collection('units')
        .get()
        .timeout(const Duration(seconds: 10)); // Implementing a timeout

    if (unitsSnapshot.docs.isNotEmpty) {
      final fetchedUnits = unitsSnapshot.docs.map((doc) {
        // Validation check example
        if (!doc.exists || doc.data() == null) {
          throw Exception("Document does not exist or is null");
        }
        return {
          'unitID': doc.id,
          'courseID': doc['courseID'],
          'imageUrl': doc['imageUrl'],
          'unitContent': doc['unitContent'],
          'unitDescription': doc['unitDescription'],
          'unitName': doc['unitName'],
          'unitURL': doc['unitURL'],
        };
      }).toList();

      setState(() => units = fetchedUnits);
      print('Fetched units: $units');
    } else {
      print('No units found for courseID: ${widget.courseName}');
    }
  } on FirebaseException catch (e) {
    print('Firebase error fetching units: $e');
    // Optionally, update the UI to show an error message
  } catch (e) {
    print('Error fetching units: $e');
    // Optionally, update the UI to show an error message
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
