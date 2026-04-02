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
}

// Simple in-memory storage for the exam
class VehicleRepository {
  static final List<Vehicle> _vehicles = [];

  static List<Vehicle> get vehicles => _vehicles;

  static void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
  }
}
