import 'package:flutter/material.dart';

class ServiceCentersScreen extends StatelessWidget {
  final List<Map<String, String>> centers = [
    {'name': 'AutoCare Pro', 'distance': '1.2 km', 'rating': '4.8'},
    {'name': 'Quick Fix Garage', 'distance': '3.5 km', 'rating': '4.2'},
    {'name': 'Elite Motor Service', 'distance': '4.1 km', 'rating': '4.5'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Service Centers'),
      ),
      body: ListView.builder(
        itemCount: centers.length,
        itemBuilder: (context, index) {
          final center = centers[index];
          return ListTile(
            leading: Icon(Icons.build_circle, size: 40, color: Colors.blueGrey),
            title: Text(center['name']!),
            subtitle: Text('\${center['distance']} | Rating: \${center['rating']}'),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Appointment booked at \${center['name']}!')));
              },
              child: Text('Book'),
            ),
          );
        },
      ),
    );
  }
}
