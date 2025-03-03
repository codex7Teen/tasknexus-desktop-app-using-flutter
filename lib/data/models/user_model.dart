import 'package:hive_flutter/adapters.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  static const String boxName = 'User_db';
  
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String password;
  
  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });
}