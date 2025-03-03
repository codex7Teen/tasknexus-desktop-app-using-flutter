import 'package:hive_flutter/hive_flutter.dart';
part 'school_data_model.g.dart';

@HiveType(typeId: 5)
class SchoolDataModel extends HiveObject {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String type; // Public / Private / Govt Aided / Special
  
  @HiveField(2)
  final List<String> curriculum; // CBSE / ICSE / IB / State Board
  
  @HiveField(3)
  final String establishedDate;
  
  @HiveField(4)
  final List<String> grades; // Primary / Secondary / Higher Secondary
  
  SchoolDataModel({
    required this.name,
    required this.type,
    required this.curriculum,
    required this.establishedDate,
    required this.grades,
  });
  
  // Copy with method
  SchoolDataModel copyWith({
    String? name,
    String? type,
    List<String>? curriculum,
    String? establishedDate,
    List<String>? grades,
  }) {
    return SchoolDataModel(
      name: name ?? this.name,
      type: type ?? this.type,
      curriculum: curriculum ?? this.curriculum,
      establishedDate: establishedDate ?? this.establishedDate,
      grades: grades ?? this.grades,
    );
  }
}