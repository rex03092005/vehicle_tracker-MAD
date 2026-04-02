import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'add_vehicle_screen.dart';
import 'reminders_screen.dart';

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  @override
  Widget build(BuildContext context) {
    final vehicles = VehicleRepository.vehicles;

    return Scaffold(
      body: vehicles.isEmpty
          ? Center(child: Text('No vehicles added yet.'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 6,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RemindersScreen(vehicle: vehicle)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(Icons.directions_car_filled, size: 40, color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicle.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 6),
                                Text('${vehicle.make} ${vehicle.model}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(vehicle.licensePlate, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.orange[900], letterSpacing: 1.5)),
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
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
