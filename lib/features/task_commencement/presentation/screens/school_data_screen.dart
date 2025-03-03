import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';

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

class _SchoolDataScreenState extends State<SchoolDataScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _establishedDateController = TextEditingController();
  
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
  final List<String> _curriculumOptions = [
    'CBSE',
    'ICSE',
    'IB',
    'State Board',
  ];
  
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
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _establishedDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }
  
  void _toggleCurriculum(String curriculum) {
    setState(() {
      if (_selectedCurriculum.contains(curriculum)) {
        _selectedCurriculum.remove(curriculum);
      } else {
        _selectedCurriculum.add(curriculum);
      }
    });
  }
  
  void _toggleGrade(String grade) {
    setState(() {
      if (_selectedGrades.contains(grade)) {
        _selectedGrades.remove(grade);
      } else {
        _selectedGrades.add(grade);
      }
    });
  }
  
  void _submitForm({bool completeTask = false}) {
    if (_formKey.currentState!.validate()) {
      // Additional validation for multiple selections
      if (_selectedSchoolType.isEmpty) {
        ElegantSnackbar.show(
          context,
          message: 'Please select school type',
          type: SnackBarType.error,
        );
        return;
      }
      
      if (_selectedCurriculum.isEmpty) {
        ElegantSnackbar.show(
          context,
          message: 'Please select at least one curriculum',
          type: SnackBarType.error,
        );
        return;
      }
      
      if (_selectedGrades.isEmpty) {
        ElegantSnackbar.show(
          context,
          message: 'Please select at least one grade',
          type: SnackBarType.error,
        );
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
          CompleteTask(
            taskUrn: widget.taskUrn,
            userEmail: widget.userEmail,
          ),
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
          Row(
            children: [
              const Icon(Icons.school, size: 32),
              const SizedBox(width: 12),
              Text(
                'School-${widget.schoolIndex + 1} Data',
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
          const SizedBox(height: 20),
          
          // Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blackColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: AppTextstyles.enterNameAndPasswordText,
            ),
          ),
          const SizedBox(height: 24),
          
          // Form content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
                    _buildFormLabel('Name of the School'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _schoolNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter school name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                    ),
                    const SizedBox(height: 24),
                    
                    // School type dropdown
                    _buildFormLabel('Type of the School'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[50],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSchoolType.isEmpty ? null : _selectedSchoolType,
                          hint: const Text('Select school type'),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: _schoolTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedSchoolType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Curriculum multi-select
                    _buildFormLabel('Curriculum (Multiple Selection)'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _curriculumOptions.map((curriculum) {
                        final isSelected = _selectedCurriculum.contains(curriculum);
                        return FilterChip(
                          label: Text(curriculum),
                          selected: isSelected,
                          selectedColor: Colors.blue[100],
                          checkmarkColor: Colors.blue[800],
                          backgroundColor: Colors.grey[100],
                          onSelected: (bool selected) {
                            _toggleCurriculum(curriculum);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Established date picker
                    _buildFormLabel('Established on'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _establishedDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Select date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.grey[50],
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select establishment date';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 24),
                    
                    // Grades multi-select
                    _buildFormLabel('Grades Present in the School (Multiple Selection)'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _gradesOptions.map((grade) {
                        final isSelected = _selectedGrades.contains(grade);
                        return FilterChip(
                          label: Text(grade),
                          selected: isSelected,
                          selectedColor: Colors.green[100],
                          checkmarkColor: Colors.green[800],
                          backgroundColor: Colors.grey[100],
                          onSelected: (bool selected) {
                            _toggleGrade(grade);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Save button
                SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _submitForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting && !_isCompleting
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
                    onPressed: (_isSubmitting || !_isAllDataComplete()) 
                        ? null 
                        : () => _submitForm(completeTask: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blackColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isCompleting
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
            ),
            const SizedBox(height: 24),
            
            // Completion note
            if (!_isAllDataComplete())
              Container(
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
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: AppTextstyles.enterNameAndPasswordText.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}