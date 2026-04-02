import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';
import 'utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(VehicleTrackerApp());
}

class VehicleTrackerApp extends StatefulWidget {
  static _VehicleTrackerAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_VehicleTrackerAppState>();

  @override
  _VehicleTrackerAppState createState() => _VehicleTrackerAppState();
}

class _VehicleTrackerAppState extends State<VehicleTrackerApp> {
  ThemeMode _themeMode = LocalStorage.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
        LocalStorage.setDarkMode(true);
      } else {
        _themeMode = ThemeMode.light;
        LocalStorage.setDarkMode(false);
      }
    });
  }

  bool isDark() => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoCare Premium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: LoginScreen(),
    );
  }
}
