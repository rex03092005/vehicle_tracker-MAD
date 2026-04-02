import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  Widget build(BuildContext context) {
    final vehicles = VehicleRepository.vehicles;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicles'),
      ),
      body: vehicles.isEmpty
          ? Center(child: Text('No vehicles added yet.'))
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return ListTile(
                  leading: Icon(Icons.directions_car),
                  title: Text(vehicle.name),
                  subtitle: Text('${vehicle.make} ${vehicle.model} - ${vehicle.licensePlate}'),
                  onTap: () {
                    // Navigate to details/reminders later
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          );
          setState(() {}); // Refresh list
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
