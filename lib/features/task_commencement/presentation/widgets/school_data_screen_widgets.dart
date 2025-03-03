import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';

class SchoolDataScreenWidgets {
  static Widget buildHeader({required int schoolIndex}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.school, size: 32),
            const SizedBox(width: 12),
            Text(
              'School-${schoolIndex + 1} Data',
              style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Please provide details for this school',
          style: AppTextstyles.enterNameAndPasswordText.copyWith(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  static Widget buildTabBar({required TabController tabController}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: tabController,
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Tab(text: 'Overview'),
          ),
        ],
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.blackColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        labelStyle: AppTextstyles.enterNameAndPasswordText,
      ),
    );
  }

  static Widget buildOverviewTab({
    required GlobalKey<FormState> formKey,
    required TextEditingController schoolNameController,
    required TextEditingController establishedDateController,
    required String selectedSchoolType,
    required List<String> selectedCurriculum,
    required List<String> selectedGrades,
    required List<String> schoolTypes,
    required List<String> curriculumOptions,
    required List<String> gradesOptions,
    required Function(String) onSchoolTypeChanged,
    required Function(String) toggleCurriculum,
    required Function(String) toggleGrade,
    required BuildContext context,
    required bool isSubmitting,
    required bool isCompleting,
    required bool isAllDataComplete,
    required VoidCallback onSave,
    required VoidCallback onFinish,
  }) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // School name field
                    buildFormLabel('Name of the School'),
                    const SizedBox(height: 8),
                    buildSchoolNameField(schoolNameController),
                    const SizedBox(height: 24),

                    // School type dropdown
                    buildFormLabel('Type of the School'),
                    const SizedBox(height: 8),
                    buildSchoolTypeDropdown(
                      selectedType: selectedSchoolType,
                      schoolTypes: schoolTypes,
                      onChanged: onSchoolTypeChanged,
                    ),
                    const SizedBox(height: 24),

                    // Curriculum multi-select
                    buildFormLabel('Curriculum (Multiple Selection)'),
                    const SizedBox(height: 8),
                    buildCurriculumSelection(
                      selectedCurriculum: selectedCurriculum,
                      curriculumOptions: curriculumOptions,
                      toggleCurriculum: toggleCurriculum,
                    ),
                    const SizedBox(height: 24),

                    // Established date picker
                    buildFormLabel('Established on'),
                    const SizedBox(height: 8),
                    buildDatePicker(
                      context: context,
                      controller: establishedDateController,
                    ),
                    const SizedBox(height: 24),

                    // Grades multi-select
                    buildFormLabel(
                      'Grades Present in the School (Multiple Selection)',
                    ),
                    const SizedBox(height: 8),
                    buildGradesSelection(
                      selectedGrades: selectedGrades,
                      gradesOptions: gradesOptions,
                      toggleGrade: toggleGrade,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Action buttons
            buildActionButtons(
              isSubmitting: isSubmitting,
              isCompleting: isCompleting,
              isAllDataComplete: isAllDataComplete,
              onSave: onSave,
              onFinish: onFinish,
            ),
            const SizedBox(height: 24),

            // Completion note
            if (!isAllDataComplete) buildCompletionNote(),
          ],
        ),
      ),
    );
  }

  static Widget buildFormLabel(String label) {
    return Text(
      label,
      style: AppTextstyles.enterNameAndPasswordText.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  static Widget buildSchoolNameField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter school name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.school_outlined),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the school name';
        }
        return null;
      },
    );
  }

  static Widget buildSchoolTypeDropdown({
    required String selectedType,
    required List<String> schoolTypes,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedType.isEmpty ? null : selectedType,
          hint: const Text('Select school type'),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items:
              schoolTypes.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  static Widget buildCurriculumSelection({
    required List<String> selectedCurriculum,
    required List<String> curriculumOptions,
    required Function(String) toggleCurriculum,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          curriculumOptions.map((curriculum) {
            final isSelected = selectedCurriculum.contains(curriculum);
            return FilterChip(
              label: Text(curriculum),
              selected: isSelected,
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[800],
              backgroundColor: Colors.grey[100],
              onSelected: (bool selected) {
                toggleCurriculum(curriculum);
              },
            );
          }).toList(),
    );
  }

  static Widget buildDatePicker({
    required BuildContext context,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select date',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: Colors.grey[50],
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please select establishment date';
        }
        return null;
      },
      onTap: () => _selectDate(context, controller),
    );
  }

  static Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.blackColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  static Widget buildGradesSelection({
    required List<String> selectedGrades,
    required List<String> gradesOptions,
    required Function(String) toggleGrade,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          gradesOptions.map((grade) {
            final isSelected = selectedGrades.contains(grade);
            return FilterChip(
              label: Text(grade),
              selected: isSelected,
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[800],
              backgroundColor: Colors.grey[100],
              onSelected: (bool selected) {
                toggleGrade(grade);
              },
            );
          }).toList(),
    );
  }

  static Widget buildActionButtons({
    required bool isSubmitting,
    required bool isCompleting,
    required bool isAllDataComplete,
    required VoidCallback onSave,
    required VoidCallback onFinish,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Save button
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                isSubmitting && !isCompleting
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      'Save',
                      style: AppTextstyles.enterNameAndPasswordText.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
          ),
        ),
        const SizedBox(width: 20),

        // Finish button
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: (isSubmitting || !isAllDataComplete) ? null : onFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                isCompleting
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      'Finish',
                      style: AppTextstyles.enterNameAndPasswordText.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  static Widget buildCompletionNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Important:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'All school data must be completed before finishing the task. '
            'Please complete data for all schools.',
            style: TextStyle(color: Colors.amber[800], fontSize: 14),
          ),
        ],
      ),
    );
  }

  static bool validateSelections({
    required BuildContext context,
    required String selectedSchoolType,
    required List<String> selectedCurriculum,
    required List<String> selectedGrades,
  }) {
    if (selectedSchoolType.isEmpty) {
      ElegantSnackbar.show(
        context,
        message: 'Please select school type',
        type: SnackBarType.error,
      );
      return false;
    }

    if (selectedCurriculum.isEmpty) {
      ElegantSnackbar.show(
        context,
        message: 'Please select at least one curriculum',
        type: SnackBarType.error,
      );
      return false;
    }

    if (selectedGrades.isEmpty) {
      ElegantSnackbar.show(
        context,
        message: 'Please select at least one grade',
        type: SnackBarType.error,
      );
      return false;
    }

    return true;
  }
}
