// task_commencement_model.dart
import 'package:hive_flutter/adapters.dart';
import 'package:tasknexus/data/models/school_data_model.dart';
part 'general_data_model.g.dart';

@HiveType(typeId: 4)
class GeneralDataModel extends HiveObject {
  static const String boxName = 'GeneralData_db';
  
  @HiveField(0)
  final String taskUrn; // Reference to the associated task
  
  @HiveField(1)
  final String areaName;
  
  @HiveField(2)
  final int totalSchools;
  
  @HiveField(3)
  final List<SchoolDataModel> schools;
  
  @HiveField(4)
  final String userEmail;
  
  GeneralDataModel({
    required this.taskUrn,
    required this.areaName,
    required this.totalSchools,
    required this.schools,
    required this.userEmail,
  });
  
  // Copy with method
  GeneralDataModel copyWith({
    String? taskUrn,
    String? areaName,
    int? totalSchools,
    List<SchoolDataModel>? schools,
    String? userEmail,
  }) {
    return GeneralDataModel(
      taskUrn: taskUrn ?? this.taskUrn,
      areaName: areaName ?? this.areaName,
      totalSchools: totalSchools ?? this.totalSchools,
      schools: schools ?? this.schools,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}