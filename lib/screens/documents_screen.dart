import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildDocCard(context, "Driver's License", "Expires: Dec 2028", Icons.badge),
          _buildDocCard(context, "Vehicle Insurance", "Policy #IN49281. Expires: Jun 2027", Icons.security),
          _buildDocCard(context, "Registration Certificate", "Valid", Icons.description),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.upload_file),
        label: Text("Upload"),
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Viewing \$title')));
        },
      ),
    );
  }
}
