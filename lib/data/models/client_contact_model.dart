import 'package:hive_flutter/hive_flutter.dart';
part 'client_contact_model.g.dart';

@HiveType(typeId: 3)
class ClientContactModel {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String designation;
  
  @HiveField(2)
  final String email;
  
  ClientContactModel({
    required this.name,
    required this.designation,
    required this.email,
  });
}