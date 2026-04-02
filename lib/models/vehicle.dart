import 'dart:convert';
import '../utils/storage.dart';

class Vehicle {
  String id;
  String name;
  String make;
  String model;
  String licensePlate;

  Vehicle({
    required this.id,
    required this.name,
    required this.make,
    required this.model,
    required this.licensePlate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'make': make,
    'model': model,
    'licensePlate': licensePlate,
  };

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json['id'],
    name: json['name'],
    make: json['make'],
    model: json['model'],
    licensePlate: json['licensePlate'],
  );
}

class VehicleRepository {
  static List<Vehicle> _vehicles = [];

  static Future<void> loadVehicles() async {
    final String? data = LocalStorage.prefs.getString('vehicles');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _vehicles = decoded.map((v) => Vehicle.fromJson(v)).toList();
    }
  }

  static Future<void> _saveVehicles() async {
    final String encoded = jsonEncode(_vehicles.map((v) => v.toJson()).toList());
    await LocalStorage.prefs.setString('vehicles', encoded);
  }

  static List<Vehicle> get vehicles => _vehicles;

  static Future<void> addVehicle(Vehicle vehicle) async {
    _vehicles.add(vehicle);
    await _saveVehicles();
  }

  static Future<void> deleteVehicle(String id) async {
    _vehicles.removeWhere((v) => v.id == id);
    await _saveVehicles();
  }
}
