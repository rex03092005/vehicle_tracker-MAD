import 'dart:convert';
import '../utils/storage.dart';

class VehicleDocument {
  String id;
  String vehicleId;
  String title;
  String type;
  DateTime expiryDate;

  VehicleDocument({required this.id, required this.vehicleId, required this.title, required this.type, required this.expiryDate});

  Map<String, dynamic> toJson() => {'id': id, 'vehicleId': vehicleId, 'title': title, 'type': type, 'expiryDate': expiryDate.toIso8601String()};
  
  factory VehicleDocument.fromJson(Map<String, dynamic> json) => VehicleDocument(id: json['id'], vehicleId: json['vehicleId'], title: json['title'], type: json['type'], expiryDate: DateTime.parse(json['expiryDate']));
}

class DocumentRepository {
  static List<VehicleDocument> _documents = [];

  static Future<void> loadDocuments() async {
    final String? data = LocalStorage.prefs.getString('documents');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _documents = decoded.map((e) => VehicleDocument.fromJson(e)).toList();
    }
  }

  static Future<void> _saveDocuments() async {
    final String encoded = jsonEncode(_documents.map((e) => e.toJson()).toList());
    await LocalStorage.prefs.setString('documents', encoded);
  }

  static Future<void> addDocument(VehicleDocument doc) async {
    _documents.add(doc);
    await _saveDocuments();
  }

  static Future<void> deleteDocument(String id) async {
    _documents.removeWhere((e) => e.id == id);
    await _saveDocuments();
  }

  static List<VehicleDocument> get documents => _documents;
}
