import 'dart:convert';
import '../utils/storage.dart';

class Expense {
  String id;
  String category;
  double amount;
  DateTime date;

  Expense({required this.id, required this.category, required this.amount, required this.date});

  Map<String, dynamic> toJson() => {'id': id, 'category': category, 'amount': amount, 'date': date.toIso8601String()};

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(id: json['id'], category: json['category'], amount: json['amount'], date: DateTime.parse(json['date']));
}

class ExpenseRepository {
  static List<Expense> _expenses = [];

  static Future<void> loadExpenses() async {
    final String? data = LocalStorage.prefs.getString('expenses');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _expenses = decoded.map((e) => Expense.fromJson(e)).toList();
    }
  }

  static Future<void> _saveExpenses() async {
    final String encoded = jsonEncode(_expenses.map((e) => e.toJson()).toList());
    await LocalStorage.prefs.setString('expenses', encoded);
  }

  static Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpenses();
  }

  static Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
  }

  static List<Expense> get expenses => _expenses;
}
