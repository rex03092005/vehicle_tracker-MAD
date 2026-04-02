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
}

class ReminderRepository {
  static final List<Reminder> _reminders = [];

  static List<Reminder> get reminders => _reminders;

  static void addReminder(Reminder reminder) {
    _reminders.add(reminder);
  }

  static List<Reminder> getRemindersForVehicle(String vehicleId) {
    return _reminders.where((r) => r.vehicleId == vehicleId).toList();
  }
}
