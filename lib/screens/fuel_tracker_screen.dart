import 'package:flutter/material.dart';

class FuelTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fuel Economy Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_gas_station, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("Fuel logging coming soon!", style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            Text("Track MPG and cost per mile."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add fuel log feature mock!')));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
