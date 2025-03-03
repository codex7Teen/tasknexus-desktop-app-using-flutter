import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';

class GeneralDataScreen extends StatefulWidget {
  final String taskUrn;
  final String userEmail;
  final GeneralDataModel? generalData;

  const GeneralDataScreen({
    super.key,
    required this.taskUrn,
    required this.userEmail,
    this.generalData,
  });

  @override
  State<GeneralDataScreen> createState() => _GeneralDataScreenState();
}

class _GeneralDataScreenState extends State<GeneralDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _areaNameController = TextEditingController();
  final TextEditingController _totalSchoolsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // If editing existing data, populate the fields
    if (widget.generalData != null) {
      _areaNameController.text = widget.generalData!.areaName;
      _totalSchoolsController.text = widget.generalData!.totalSchools.toString();
    }
  }

  @override
  void dispose() {
    _areaNameController.dispose();
    _totalSchoolsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final areaName = _areaNameController.text.trim();
      final totalSchools = int.parse(_totalSchoolsController.text.trim());

      // Validate total schools limit
      if (totalSchools <= 0 || totalSchools > 5) {
        ElegantSnackbar.show(
          context,
          message: 'Total schools must be between 1 and 5',
          type: SnackBarType.error,
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Save data through bloc
      context.read<TaskCommencementBloc>().add(
        SaveGeneralData(
          taskUrn: widget.taskUrn,
          areaName: areaName,
          totalSchools: totalSchools,
          userEmail: widget.userEmail,
        ),
      );

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              'General Data',
              style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter the general information for this task.',
              style: AppTextstyles.enterNameAndPasswordText.copyWith(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),

            // Form card
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
                    // Area name field
                    _buildFormLabel('Name of the Area'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _areaNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter area name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the area name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Total number of schools field
                    _buildFormLabel('Total No. of Schools (Max 5)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _totalSchoolsController,
                      decoration: InputDecoration(
                        hintText: 'Enter number of schools (1-5)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.school_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the number of schools';
                        }
                        
                        final number = int.tryParse(value);
                        if (number == null) {
                          return 'Please enter a valid number';
                        }
                        
                        if (number < 1 || number > 5) {
                          return 'Number of schools must be between 1 and 5';
                        }
                        
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Information panel
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Note:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'For each school entered, a separate button will be created in the sidebar. '
                            'You can navigate to each school to enter specific details.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Submit button
            Center(
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.generalData != null ? 'Update General Data' : 'Save General Data',
                          style: AppTextstyles.enterNameAndPasswordText.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                ),
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