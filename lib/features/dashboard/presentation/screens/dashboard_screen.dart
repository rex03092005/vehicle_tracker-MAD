import 'package:flutter/material.dart';

class EnhancedDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AutoCare Pro Enterprise')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch, size: 100, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 24),
            Text(
              'Enterprise Architecture Active',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
