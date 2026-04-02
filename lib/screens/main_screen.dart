import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'vehicle_list_screen.dart';
import 'analytics_screen.dart';
import 'documents_screen.dart';
import '../main.dart'; // For theme toggle

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    VehicleListScreen(),
    AnalyticsScreen(),
    DocumentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = VehicleTrackerApp.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("AutoCare Premium"),
        actions: [
          IconButton(
            icon: Icon(themeProvider!.isDark() ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.directions_car_rounded), label: 'Vehicles'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Expenses'),
          NavigationDestination(icon: Icon(Icons.folder_shared_rounded), label: 'Docs'),
        ],
      ),
    );
  }
}
