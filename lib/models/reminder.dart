import 'dart:convert';
import '../utils/storage.dart';

class Reminder {
  String id;
  String vehicleId;
  String title;
  DateTime dueDate;
  String type; // 'oil_change', 'insurance', 'servicing'

  Reminder({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.dueDate,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'type': type,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    vehicleId: json['vehicleId'],
    title: json['title'],
    dueDate: DateTime.parse(json['dueDate']),
    type: json['type'],
  );
}

class ReminderRepository {
  static List<Reminder> _reminders = [];

  static Future<void> loadReminders() async {
    final String? data = LocalStorage.prefs.getString('reminders');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _reminders = decoded.map((r) => Reminder.fromJson(r)).toList();
    }
  }

  static Future<void> _saveReminders() async {
    final String encoded = jsonEncode(_reminders.map((r) => r.toJson()).toList());
    await LocalStorage.prefs.setString('reminders', encoded);
  }

  static List<Reminder> get reminders => _reminders;

  static Future<void> addReminder(Reminder reminder) async {
    _reminders.add(reminder);
    await _saveReminders();
  }

  static List<Reminder> getRemindersForVehicle(String vehicleId) {
    return _reminders.where((r) => r.vehicleId == vehicleId).toList();
  }
}
