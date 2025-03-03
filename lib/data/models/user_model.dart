import 'package:hive_flutter/adapters.dart';

part 'user_model.g.dart';

// Hive type annotation with a unique typeId
@HiveType(typeId: 1)
class UserModel extends HiveObject {
  // Box name for storing User data
  static const String boxName = 'User_db';

  // Fields to be stored in Hive
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  // Constructor to initialize user data
  UserModel({required this.name, required this.email, required this.password});
}
