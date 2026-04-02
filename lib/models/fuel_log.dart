import 'dart:convert';
import '../utils/storage.dart';

class FuelLog {
  String id;
  String vehicleId;
  double liters;
  double cost;
  int odometer;
  DateTime date;

  FuelLog({required this.id, required this.vehicleId, required this.liters, required this.cost, required this.odometer, required this.date});

  Map<String, dynamic> toJson() => {'id': id, 'vehicleId': vehicleId, 'liters': liters, 'cost': cost, 'odometer': odometer, 'date': date.toIso8601String()};
  
  factory FuelLog.fromJson(Map<String, dynamic> json) => FuelLog(id: json['id'], vehicleId: json['vehicleId'], liters: json['liters'], cost: json['cost'], odometer: json['odometer'], date: DateTime.parse(json['date']));
}

class FuelRepository {
  static List<FuelLog> _fuelLogs = [];

  static Future<void> loadFuelLogs() async {
    final String? data = LocalStorage.prefs.getString('fuel');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _fuelLogs = decoded.map((e) => FuelLog.fromJson(e)).toList();
    }
  }

  static Future<void> _saveFuelLogs() async {
    final String encoded = jsonEncode(_fuelLogs.map((e) => e.toJson()).toList());
    await LocalStorage.prefs.setString('fuel', encoded);
  }

  static Future<void> addFuelLog(FuelLog log) async {
    _fuelLogs.add(log);
    await _saveFuelLogs();
  }

  static Future<void> deleteFuelLog(String id) async {
    _fuelLogs.removeWhere((e) => e.id == id);
    await _saveFuelLogs();
  }

  static List<FuelLog> get fuelLogs => _fuelLogs;
}
