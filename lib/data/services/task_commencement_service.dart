import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/data/models/school_data_model.dart';
import 'package:tasknexus/data/services/task_service.dart';

class TaskCommencementService {
  final TaskService _taskService = TaskService();

  //! Save general task data and initialize school list
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

      // Initialize an empty list of schools
      final List<SchoolDataModel> schools = List.generate(
        totalSchools,
        (index) => SchoolDataModel(
          name: '',
          type: '',
          curriculum: [],
          establishedDate: '',
          grades: [],
        ),
      );

      final generalData = GeneralDataModel(
        taskUrn: taskUrn,
        areaName: areaName,
        totalSchools: totalSchools,
        schools: schools,
        userEmail: userEmail,
      );

      // Store task data using `taskUrn` as the key
      await box.put(taskUrn, generalData);

      // Update task status to "In Progress"
      await _taskService.updateTaskStatus(taskUrn, userEmail, 'In Progress');

      return true;
    } catch (e) {
      log('Error saving general data: $e');
      return false;
    }
  }

  //! Update specific school data within the task
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
        log('No general data found for taskUrn: $taskUrn');
        return false;
      }

      // Ensure school index is within valid range
      if (schoolIndex < 0 || schoolIndex >= generalData.schools.length) {
        log('Invalid school index: $schoolIndex');
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

      // Replace the existing school data at `schoolIndex`
      final List<SchoolDataModel> updatedSchools = List.from(
        generalData.schools,
      );
      updatedSchools[schoolIndex] = updatedSchool;

      // Save updated general data
      final updatedGeneralData = generalData.copyWith(schools: updatedSchools);
      await box.put(taskUrn, updatedGeneralData);

      return true;
    } catch (e) {
      log('Error updating school data: $e');
      return false;
    }
  }

  //! Retrieve general task data using taskUrn
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

  //! Mark task as completed
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
