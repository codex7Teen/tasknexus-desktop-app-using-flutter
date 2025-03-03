// task_commencement_service.dart
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/data/models/school_data_model.dart';
import 'package:tasknexus/data/services/task_service.dart';

class TaskCommencementService {
  final TaskService _taskService = TaskService();

  // Save general data and initialize school data
  Future<bool> saveGeneralData({
    required String taskUrn,
    required String areaName,
    required int totalSchools,
    required String userEmail,
  }) async {
    try {
      final box = await Hive.openBox<GeneralDataModel>(
        GeneralDataModel.boxName,
      );

      // Create empty schools list based on total schools count
      final List<SchoolDataModel> schools = [];
      for (int i = 0; i < totalSchools; i++) {
        schools.add(
          SchoolDataModel(
            name: '',
            type: '',
            curriculum: [],
            establishedDate: '',
            grades: [],
          ),
        );
      }

      final generalData = GeneralDataModel(
        taskUrn: taskUrn,
        areaName: areaName,
        totalSchools: totalSchools,
        schools: schools,
        userEmail: userEmail,
      );

      // Use taskUrn as the key for storage
      await box.put(taskUrn, generalData);

      // Update task status to In Progress
      await _taskService.updateTaskStatus(taskUrn, userEmail, 'In Progress');

      return true;
    } catch (e) {
      log('Error saving general data: $e');
      return false;
    }
  }

  // Update school data
  Future<bool> updateSchoolData({
    required String taskUrn,
    required int schoolIndex,
    required String schoolName,
    required String schoolType,
    required List<String> curriculum,
    required String establishedDate,
    required List<String> grades,
    required String userEmail,
  }) async {
    try {
      final box = await Hive.openBox<GeneralDataModel>(
        GeneralDataModel.boxName,
      );
      final generalData = box.get(taskUrn);

      if (generalData == null) {
        return false;
      }

      // Create updated school data
      final updatedSchool = SchoolDataModel(
        name: schoolName,
        type: schoolType,
        curriculum: curriculum,
        establishedDate: establishedDate,
        grades: grades,
      );

      // Update specific school in the list
      final List<SchoolDataModel> updatedSchools = List.from(
        generalData.schools,
      );
      updatedSchools[schoolIndex] = updatedSchool;

      // Create updated general data
      final updatedGeneralData = generalData.copyWith(schools: updatedSchools);

      // Save updated data
      await box.put(taskUrn, updatedGeneralData);

      return true;
    } catch (e) {
      log('Error updating school data: $e');
      return false;
    }
  }

  // Get general data by task URN
  Future<GeneralDataModel?> getGeneralData(String taskUrn) async {
    try {
      final box = await Hive.openBox<GeneralDataModel>(
        GeneralDataModel.boxName,
      );
      return box.get(taskUrn);
    } catch (e) {
      log('Error getting general data: $e');
      return null;
    }
  }

  // Complete task
  Future<bool> completeTask(String taskUrn, String userEmail) async {
    try {
      await _taskService.updateTaskStatus(taskUrn, userEmail, 'Completed');
      return true;
    } catch (e) {
      log('Error completing task: $e');
      return false;
    }
  }
}
