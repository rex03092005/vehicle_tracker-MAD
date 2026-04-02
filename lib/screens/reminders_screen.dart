import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../models/vehicle.dart';
import 'package:uuid/uuid.dart';

class RemindersScreen extends StatefulWidget {
  final Vehicle vehicle;
  RemindersScreen({required this.vehicle});

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    final reminders = ReminderRepository.getRemindersForVehicle(widget.vehicle.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vehicle.name} Reminders'),
      ),
      body: reminders.isEmpty
          ? Center(child: Text('No upcoming reminders.'))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  leading: Icon(Icons.notifications_active),
                  title: Text(reminder.title),
                  subtitle: Text("Due: ${reminder.dueDate.toLocal().toString().split(' ')[0]} - ${reminder.type}"),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        child: Icon(Icons.add_alert),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    String _title = '';
    String _type = 'servicing';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (val) => _title = val,
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: ['oil_change', 'insurance', 'servicing'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _type = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ReminderRepository.addReminder(Reminder(
                  id: Uuid().v4(),
                  vehicleId: widget.vehicle.id,
                  title: _title.isEmpty ? 'Scheduled Maintenance' : _title,
                  dueDate: DateTime.now().add(Duration(days: 30)),
                  type: _type,
                ));
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Save'),
            )
          ],
        );
      }
    );
  }
}
