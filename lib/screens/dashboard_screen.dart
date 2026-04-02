import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../models/reminder.dart';
import 'add_vehicle_screen.dart';
import 'service_centers_screen.dart';
import 'analytics_screen.dart';
import 'fuel_tracker_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vehiclesCount = VehicleRepository.vehicles.length;
    final reminders = ReminderRepository.reminders;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Header Card with Gradient
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Color(0xFF651FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10)),
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      SizedBox(height: 8),
                      Text("Your Garage looks great.", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ]
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.directions_car_filled, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          Text("Dashboard Summary", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildSummaryCard(context, "Vehicles", "$vehiclesCount", Icons.garage, Colors.blue)),
              SizedBox(width: 16),
              Expanded(child: _buildSummaryCard(context, "Alerts", "${reminders.length}", Icons.notifications_active, Colors.orangeAccent)),
            ],
          ),
          
          SizedBox(height: 32),
          Text("Quick Actions", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 0.85,
            children: [
              _buildActionItem(context, Icons.add_circle, "Add Car", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddVehicleScreen()));
              }),
              _buildActionItem(context, Icons.build_circle, "Book\nService", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceCentersScreen()));
              }),
              _buildActionItem(context, Icons.monetization_on, "Expenses", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyticsScreen()));
              }),
              _buildActionItem(context, Icons.local_gas_station, "Fuel Log", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FuelTrackerScreen()));
              }),
            ],
          ),
          
          SizedBox(height: 32),
          Text("Upcoming Reminders", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          
          reminders.isEmpty 
            ? Center(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("No upcoming alerts. Everything is perfectly maintained!"),
            ))
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reminders.length > 3 ? 3 : reminders.length, // limit to 3 items
                itemBuilder: (ctx, i) {
                  return Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                      title: Text(reminders[i].title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Due by: ${reminders[i].dueDate.toLocal().toString().split(' ')[0]}"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  );
                },
              )
        ],
      )
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 4)),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 36),
          SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(icon, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }
}
