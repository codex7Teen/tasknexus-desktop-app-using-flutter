import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/features/task_commencement/presentation/widgets/school_data_screen_widgets.dart';

class SchoolDataScreen extends StatefulWidget {
  final String taskUrn;
  final String userEmail;
  final int schoolIndex;
  final GeneralDataModel generalData;

  const SchoolDataScreen({
    super.key,
    required this.taskUrn,
    required this.userEmail,
    required this.schoolIndex,
    required this.generalData,
  });

  @override
  State<SchoolDataScreen> createState() => _SchoolDataScreenState();
}

class _SchoolDataScreenState extends State<SchoolDataScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _establishedDateController =
      TextEditingController();

  String _selectedSchoolType = '';
  List<String> _selectedCurriculum = [];
  List<String> _selectedGrades = [];

  bool _isSubmitting = false;
  bool _isCompleting = false;

  // School types dropdown options
  final List<String> _schoolTypes = [
    'Public',
    'Private',
    'Govt Aided',
    'Special',
  ];

  // Curriculum options for multiple selection
  final List<String> _curriculumOptions = ['CBSE', 'ICSE', 'IB', 'State Board'];

  // Grades options for multiple selection
  final List<String> _gradesOptions = [
    'Primary',
    'Secondary',
    'Higher Secondary',
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    // Load existing data if available
    _loadExistingData();
  }

  void _loadExistingData() {
    final schoolData = widget.generalData.schools[widget.schoolIndex];

    if (schoolData.name.isNotEmpty) {
      _schoolNameController.text = schoolData.name;
      _selectedSchoolType = schoolData.type;
      _selectedCurriculum = List.from(schoolData.curriculum);
      _establishedDateController.text = schoolData.establishedDate;
      _selectedGrades = List.from(schoolData.grades);
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _establishedDateController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _submitForm({bool completeTask = false}) {
    if (_formKey.currentState!.validate()) {
      // Additional validation
      if (!SchoolDataScreenWidgets.validateSelections(
        context: context,
        selectedSchoolType: _selectedSchoolType,
        selectedCurriculum: _selectedCurriculum,
        selectedGrades: _selectedGrades,
      )) {
        return;
      }

      setState(() {
        _isSubmitting = true;
        if (completeTask) _isCompleting = true;
      });

      // Update school data through bloc
      context.read<TaskCommencementBloc>().add(
        UpdateSchoolData(
          taskUrn: widget.taskUrn,
          schoolIndex: widget.schoolIndex,
          schoolName: _schoolNameController.text.trim(),
          schoolType: _selectedSchoolType,
          curriculum: _selectedCurriculum,
          establishedDate: _establishedDateController.text.trim(),
          grades: _selectedGrades,
          userEmail: widget.userEmail,
        ),
      );

      // If completing the task, add the complete task event
      if (completeTask) {
        context.read<TaskCommencementBloc>().add(
          CompleteTask(taskUrn: widget.taskUrn, userEmail: widget.userEmail),
        );
      }

      setState(() {
        _isSubmitting = false;
        if (completeTask) _isCompleting = false;
      });
    }
  }

  bool _isAllDataComplete() {
    // Check if all schools have data filled
    for (final school in widget.generalData.schools) {
      if (school.name.isEmpty ||
          school.type.isEmpty ||
          school.curriculum.isEmpty ||
          school.establishedDate.isEmpty ||
          school.grades.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School header
          SchoolDataScreenWidgets.buildHeader(schoolIndex: widget.schoolIndex),
          const SizedBox(height: 20),

          // Tabs
          SchoolDataScreenWidgets.buildTabBar(tabController: _tabController),
          const SizedBox(height: 24),

          // Form content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SchoolDataScreenWidgets.buildOverviewTab(
                  formKey: _formKey,
                  schoolNameController: _schoolNameController,
                  establishedDateController: _establishedDateController,
                  selectedSchoolType: _selectedSchoolType,
                  selectedCurriculum: _selectedCurriculum,
                  selectedGrades: _selectedGrades,
                  schoolTypes: _schoolTypes,
                  curriculumOptions: _curriculumOptions,
                  gradesOptions: _gradesOptions,
                  onSchoolTypeChanged: (value) {
                    setState(() {
                      _selectedSchoolType = value;
                    });
                  },
                  toggleCurriculum: (curriculum) {
                    setState(() {
                      if (_selectedCurriculum.contains(curriculum)) {
                        _selectedCurriculum.remove(curriculum);
                      } else {
                        _selectedCurriculum.add(curriculum);
                      }
                    });
                  },
                  toggleGrade: (grade) {
                    setState(() {
                      if (_selectedGrades.contains(grade)) {
                        _selectedGrades.remove(grade);
                      } else {
                        _selectedGrades.add(grade);
                      }
                    });
                  },
                  context: context,
                  isSubmitting: _isSubmitting,
                  isCompleting: _isCompleting,
                  isAllDataComplete: _isAllDataComplete(),
                  onSave: () => _submitForm(),
                  onFinish: () => _submitForm(completeTask: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
