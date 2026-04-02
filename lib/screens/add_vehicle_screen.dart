import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'package:uuid/uuid.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _make = '';
  String _model = '';
  String _licensePlate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nickname (e.g. Daily Commuter)'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Make (e.g. Toyota)'),
                validator: (value) => value!.isEmpty ? 'Please enter make' : null,
                onSaved: (value) => _make = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model (e.g. Camry)'),
                validator: (value) => value!.isEmpty ? 'Please enter model' : null,
                onSaved: (value) => _model = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'License Plate'),
                validator: (value) => value!.isEmpty ? 'Please enter license plate' : null,
                onSaved: (value) => _licensePlate = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newVehicle = Vehicle(
                      id: Uuid().v4(),
                      name: _name,
                      make: _make,
                      model: _model,
                      licensePlate: _licensePlate,
                    );
                    VehicleRepository.addVehicle(newVehicle);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Vehicle'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
