import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/features/task_commencement/presentation/widgets/general_data_screen_widgets.dart';

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
      _totalSchoolsController.text =
          widget.generalData!.totalSchools.toString();
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
            // Page title section
            GeneralDataScreenWidgets.buildTitleSection(),

            const SizedBox(height: 30),

            // Form card section
            GeneralDataScreenWidgets.buildFormCard(
              areaNameController: _areaNameController,
              totalSchoolsController: _totalSchoolsController,
              formKey: _formKey,
              context: context,
            ),

            const Spacer(),

            // Submit button
            GeneralDataScreenWidgets.buildSubmitButton(
              context: context,
              isSubmitting: _isSubmitting,
              isUpdate: widget.generalData != null,
              onSubmit: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
