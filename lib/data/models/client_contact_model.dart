import 'package:hive_flutter/hive_flutter.dart';

part 'client_contact_model.g.dart';

// Hive model for client contact details
@HiveType(typeId: 3)
class ClientContactModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String designation;

  @HiveField(2)
  final String email;

  // Constructor to initialize contact details
  ClientContactModel({
    required this.name,
    required this.designation,
    required this.email,
  });
}
