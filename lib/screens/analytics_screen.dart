import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseRepository.expenses;
    double total = expenses.fold(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: Text("Expenses")) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Total Expenses', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10),
                    Text('\$${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            if (expenses.isNotEmpty) _buildChart(expenses),
            Expanded(
              child: expenses.isEmpty 
                  ? Center(child: Text("No expenses logged yet."))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final e = expenses[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.attach_money),
                            ),
                            title: Text(e.category, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(e.date.toLocal().toString().split(' ')[0]),
                            trailing: Text('\$${e.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildChart(List<Expense> expenses) {
    Map<String, double> categoryMap = {};
    for (var e in expenses) {
      categoryMap[e.category] = (categoryMap[e.category] ?? 0) + e.amount;
    }

    double maxVal = categoryMap.values.isEmpty ? 1 : categoryMap.values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    return Container(
      height: 200,
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: categoryMap.entries.map((entry) {
          final heightFactor = entry.value / maxVal;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('\$${entry.value.toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Container(
                width: 32,
                height: 110 * heightFactor,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.lightBlueAccent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: 8),
              Text(entry.key, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showAddExpenseDialog() {
    String category = 'Servicing';
    String amountStr = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: category,
                items: ['Servicing', 'Fuel', 'Insurance', 'Repairs'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => category = val!,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount (\$)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => amountStr = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final double? amt = double.tryParse(amountStr);
                if (amt != null && amt > 0) {
                  await ExpenseRepository.addExpense(Expense(
                    id: Uuid().v4(),
                    category: category,
                    amount: amt,
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
