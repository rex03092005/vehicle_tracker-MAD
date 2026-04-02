import 'package:flutter/material.dart';
import '../models/document.dart';
import '../models/vehicle.dart';
import 'package:uuid/uuid.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final docs = DocumentRepository.documents;

    return Scaffold(
      appBar: AppBar(title: Text("Document Vault")),
      body: docs.isEmpty
          ? Center(child: Text("No documents uploaded.\nKeep digital copies here!", textAlign: TextAlign.center))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final veh = VehicleRepository.vehicles.where((v) => v.id == doc.vehicleId);
                final vName = veh.isNotEmpty ? veh.first.name : 'Unknown Vehicle';

                return Dismissible(
                  key: Key(doc.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.delete_outline, color: Colors.white, size: 36),
                  ),
                  onDismissed: (_) async {
                    await DocumentRepository.deleteDocument(doc.id);
                    setState(() {});
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: Icon(Icons.description, color: Theme.of(context).colorScheme.onTertiaryContainer, size: 32),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(height: 6),
                                Text('$vName • ${doc.type}', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.event_busy, size: 14, color: Colors.redAccent),
                                    SizedBox(width: 6),
                                    Text('Expires: ${doc.expiryDate.toLocal().toString().split(' ')[0]}', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDocDialog,
        icon: Icon(Icons.upload_file),
        label: Text("Upload Doc"),
      ),
    );
  }

  void _showAddDocDialog() {
    final vehicles = VehicleRepository.vehicles;
    if (vehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add a vehicle first!")));
      return;
    }

    String selectedVehicle = vehicles.first.id;
    String title = '';
    String type = 'Insurance';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Document Info'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: InputDecoration(labelText: 'Vehicle'),
                  items: vehicles.map((v) => DropdownMenuItem(value: v.id, child: Text(v.name))).toList(),
                  onChanged: (val) => selectedVehicle = val!,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Document Title'),
                  onChanged: (val) => title = val,
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: InputDecoration(labelText: 'Document Type'),
                  items: ['Insurance', 'Registration', 'Emission Test', 'Service Bill', 'Other']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => type = val!,
                ),
                SizedBox(height: 16),
                Text("Note: Mocking Expiry Date to exactly +1 Year from now for prototyping purposes.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          actions: [
            TextButton(
               onPressed: () => Navigator.pop(context),
               child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (title.isNotEmpty) {
                  await DocumentRepository.addDocument(VehicleDocument(
                    id: Uuid().v4(),
                    vehicleId: selectedVehicle,
                    title: title,
                    type: type,
                    expiryDate: DateTime.now().add(Duration(days: 365)),
                  ));
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            )
          ]
        );
      }
    );
  }
}
