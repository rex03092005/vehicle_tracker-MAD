import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(VehicleTrackerApp());
}

class VehicleTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
