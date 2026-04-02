import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maintenance Expenses (This Year)', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            _buildExpenseBar('Oil Change', 120, Colors.orange),
            SizedBox(height: 10),
            _buildExpenseBar('General Servicing', 300, Colors.blue),
            SizedBox(height: 10),
            _buildExpenseBar('Insurance', 500, Colors.green),
            SizedBox(height: 10),
            _buildExpenseBar('Parts/Repairs', 150, Colors.red),
            SizedBox(height: 30),
            Text('Total: \$1070', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseBar(String label, double amount, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label),
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: 20,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            width: amount,
            child: Text('\$$amount', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
