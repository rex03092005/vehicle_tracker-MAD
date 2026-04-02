import 'package:flutter/material.dart';
import '../models/fuel_log.dart';
import '../models/vehicle.dart';
import 'package:uuid/uuid.dart';

class FuelTrackerScreen extends StatefulWidget {
  @override
  _FuelTrackerScreenState createState() => _FuelTrackerScreenState();
}

class _FuelTrackerScreenState extends State<FuelTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    final logs = FuelRepository.fuelLogs.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Fuel Economy Tracker")),
      body: logs.isEmpty
          ? Center(child: Text("No fuel entries yet. Keep moving!"))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final veh = VehicleRepository.vehicles.where((v) => v.id == log.vehicleId);
                final vName = veh.isNotEmpty ? veh.first.name : 'Unknown Vehicle';

                return Dismissible(
                  key: Key(log.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.delete_outline, color: Colors.white, size: 36),
                  ),
                  onDismissed: (_) async {
                    await FuelRepository.deleteFuelLog(log.id);
                    setState(() {});
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(vName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('\$${log.cost.toStringAsFixed(2)}', style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoBlock(Icons.local_gas_station, '${log.liters.toStringAsFixed(1)} L'),
                              _infoBlock(Icons.speed, '${log.odometer} km'),
                              _infoBlock(Icons.calendar_today, log.date.toLocal().toString().split(' ')[0]),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddFuelDialog,
        icon: Icon(Icons.add),
        label: Text("Add Fuel"),
      ),
    );
  }

  Widget _infoBlock(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showAddFuelDialog() {
    final vehicles = VehicleRepository.vehicles;
    if (vehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add a vehicle first!")));
      return;
    }

    String selectedVehicle = vehicles.first.id;
    String litersStr = '';
    String costStr = '';
    String odoStr = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Fuel Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: InputDecoration(labelText: 'Vehicle'),
                  items: vehicles.map((v) => DropdownMenuItem(value: v.id, child: Text(v.name))).toList(),
                  onChanged: (val) => selectedVehicle = val!,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Liters / Gallons'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => litersStr = val,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Total Cost (\$)'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => costStr = val,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Odometer Reading'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => odoStr = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final liters = double.tryParse(litersStr);
                final cost = double.tryParse(costStr);
                final odo = int.tryParse(odoStr);

                if (liters != null && cost != null && odo != null) {
                  await FuelRepository.addFuelLog(FuelLog(
                    id: Uuid().v4(),
                    vehicleId: selectedVehicle,
                    liters: liters,
                    cost: cost,
                    odometer: odo,
                    date: DateTime.now(),
                  ));
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            )
          ],
        );
      }
    );
  }
}
