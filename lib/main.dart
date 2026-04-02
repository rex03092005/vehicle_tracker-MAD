import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/storage.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(VehicleTrackerApp());
}

class VehicleTrackerApp extends StatefulWidget {
  static _VehicleTrackerAppState? of(BuildContext context) => context.findAncestorStateOfType<_VehicleTrackerAppState>();
  @override
  _VehicleTrackerAppState createState() => _VehicleTrackerAppState();
}

class _VehicleTrackerAppState extends State<VehicleTrackerApp> {
  bool _isDark = true;

  void toggleTheme() {
    setState(() { _isDark = !_isDark; });
  }

  bool isDark() => _isDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCare Premium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(),
    );
  }
}
