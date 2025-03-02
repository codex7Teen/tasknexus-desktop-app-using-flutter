import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/add_task_service.dart';
import 'package:tasknexus/features/home/bloc/bloc/add_task_bloc.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';

class ScreenAddTask extends StatefulWidget {
  final String? taskUrn;
  final String userEmail;
  final String userName;

  const ScreenAddTask({
    super.key,
    this.taskUrn,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<ScreenAddTask> createState() => _ScreenAddTaskState();
}

class _ScreenAddTaskState extends State<ScreenAddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _urnController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _commencementDateController =
      TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _assignedByController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();

  // Client details controllers list
  final List<List<TextEditingController>> _clientDetailsControllers = [];

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();

    final addTaskService = AddTaskService();

    // Set initial values
    _isEditMode = widget.taskUrn != null;
    _assignedByController.text = widget.userName;

    // Add initial row for client details
    _addClientDetailRow();

    // If in edit mode, load the task data
    if (_isEditMode) {
      context.read<AddTaskBloc>().add(
        AddTaskLoadExisting(urn: widget.taskUrn!, userEmail: widget.userEmail),
      );
    } else {
      // Generate a random URN for new task
      context.read<AddTaskBloc>().add(
        AddTaskInitial(currentUserName: widget.userName),
      );

      // Generate URN using service
      _urnController.text = addTaskService.generateURN();
    }
  }

  void _addClientDetailRow() {
    _clientDetailsControllers.add([
      TextEditingController(), // Name
      TextEditingController(), // Designation
      TextEditingController(), // Email
    ]);
    setState(() {});
  }

  void _removeClientDetailRow(int index) {
    if (_clientDetailsControllers.length > 1) {
      for (var controller in _clientDetailsControllers[index]) {
        controller.dispose();
      }
      _clientDetailsControllers.removeAt(index);
      setState(() {});
    } else {
      ElegantSnackbar.show(
        context,
        message: 'At least one client contact is required',
        type: SnackBarType.warning,
      );
    }
  }

  void _populateFormWithTask(TaskModel task) {
    _taskNameController.text = task.name;
    _urnController.text = task.urn;
    _descriptionController.text = task.description;
    _commencementDateController.text = task.commencementDate;
    _dueDateController.text = task.dueDate;
    _assignedToController.text = task.assignedTo;
    _assignedByController.text = task.assignedBy;
    _clientNameController.text = task.clientName;

    // Clear existing client details rows except the first one
    if (_clientDetailsControllers.length > 1) {
      for (int i = 1; i < _clientDetailsControllers.length; i++) {
        for (var controller in _clientDetailsControllers[i]) {
          controller.dispose();
        }
      }
      _clientDetailsControllers.removeRange(
        1,
        _clientDetailsControllers.length,
      );
    }

    // Clear the first row controllers
    for (var controller in _clientDetailsControllers[0]) {
      controller.clear();
    }

    // Add client contacts from task
    if (task.clientContacts.isNotEmpty) {
      // Set first contact to existing row
      _clientDetailsControllers[0][0].text = task.clientContacts[0].name;
      _clientDetailsControllers[0][1].text = task.clientContacts[0].designation;
      _clientDetailsControllers[0][2].text = task.clientContacts[0].email;

      // Add additional rows for remaining contacts
      for (int i = 1; i < task.clientContacts.length; i++) {
        final newRow = [
          TextEditingController(text: task.clientContacts[i].name),
          TextEditingController(text: task.clientContacts[i].designation),
          TextEditingController(text: task.clientContacts[i].email),
        ];
        _clientDetailsControllers.add(newRow);
      }
    }

    setState(() {});
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_isEditMode) {
        // Update existing task
        context.read<AddTaskBloc>().add(
          AddTaskUpdate(
            taskName: _taskNameController.text,
            urn: _urnController.text,
            description: _descriptionController.text,
            commencementDate: _commencementDateController.text,
            dueDate: _dueDateController.text,
            assignedTo: _assignedToController.text,
            assignedBy: _assignedByController.text,
            clientName: _clientNameController.text,
            clientDetailsControllers: _clientDetailsControllers,
            userEmail: widget.userEmail,
          ),
        );
      } else {
        // Save new task
        context.read<AddTaskBloc>().add(
          AddTaskSave(
            taskName: _taskNameController.text,
            urn: _urnController.text,
            description: _descriptionController.text,
            commencementDate: _commencementDateController.text,
            dueDate: _dueDateController.text,
            assignedTo: _assignedToController.text,
            assignedBy: _assignedByController.text,
            clientName: _clientNameController.text,
            clientDetailsControllers: _clientDetailsControllers,
            userEmail: widget.userEmail,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _urnController.dispose();
    _descriptionController.dispose();
    _commencementDateController.dispose();
    _dueDateController.dispose();
    _assignedToController.dispose();
    _assignedByController.dispose();
    _clientNameController.dispose();

    // Dispose all client details controllers
    for (var row in _clientDetailsControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! ADDTASK BLOC LISTENER
    return BlocListener<AddTaskBloc, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          // Show success message and navigate back
          ElegantSnackbar.show(
            context,
            message: state.message,
            type: SnackBarType.success,
          );
          Future.delayed(
            Duration(milliseconds: 500),
            () => Navigator.pop(context, true),
          );
        } else if (state is AddTaskFailure) {
          // Show error message
          ElegantSnackbar.show(
            context,
            message: state.error,
            type: SnackBarType.error,
          );
        } else if (state is AddTaskLoaded) {
          // Populate form with loaded task data
          _populateFormWithTask(state.task);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditMode ? 'Edit Task' : 'Add New Task',
            style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 22),
          ),
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // User profile button - consistent across screens
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.blackColor.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.blackColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<AddTaskBloc, AddTaskState>(
          builder: (context, state) {
            if (state is AddTaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container(
              color: Colors.grey[50],
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task information card
                      _buildCard(
                        title: 'Task Information',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Task name and URN row
                            Row(
                              children: [
                                // Task name
                                Expanded(
                                  flex: 2,
                                  child: _buildFormField(
                                    label: 'Task Name',
                                    controller: _taskNameController,
                                    hintText: 'Enter task name',
                                    isRequired: true,
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // URN - read only
                                Expanded(
                                  flex: 1,
                                  child: _buildFormField(
                                    label: 'Unique Reference Number (URN)',
                                    controller: _urnController,
                                    hintText: 'Auto-generated',
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Description field
                            _buildFormField(
                              label: 'Detailed Description',
                              controller: _descriptionController,
                              hintText:
                                  'Enter detailed description of the task',
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Dates and assignment card
                      _buildCard(
                        title: 'Dates & Assignment',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dates row
                            Row(
                              children: [
                                // Commencement date
                                Expanded(
                                  child: _buildDateField(
                                    label: 'Date of Commencement',
                                    controller: _commencementDateController,
                                    hintText: 'Select start date',
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Due date
                                Expanded(
                                  child: _buildDateField(
                                    label: 'Due Date',
                                    controller: _dueDateController,
                                    hintText: 'Select due date',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Assignment row
                            Row(
                              children: [
                                // Assigned to
                                Expanded(
                                  child: _buildFormField(
                                    label: 'Assigned To',
                                    controller: _assignedToController,
                                    hintText: 'Enter assignee name',
                                    isRequired: true,
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Assigned by - read only
                                Expanded(
                                  child: _buildFormField(
                                    label: 'Assigned By',
                                    controller: _assignedByController,
                                    hintText: 'Current user',
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Client information card
                      _buildCard(
                        title: 'Client Information',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Client name
                            _buildFormField(
                              label: 'Client Name',
                              controller: _clientNameController,
                              hintText: 'Enter client name',
                              isRequired: true,
                            ),
                            const SizedBox(height: 20),

                            // Client details header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Client Contacts',
                                  style: AppTextstyles.authFieldHeadings
                                      .copyWith(fontSize: 16),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _addClientDetailRow,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Contact'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blackColor,
                                    foregroundColor: AppColors.whiteColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // Client details table header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Designation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ), // Space for action button
                                ],
                              ),
                            ),

                            // Client details rows
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _clientDetailsControllers.length,
                                separatorBuilder:
                                    (context, index) => Divider(height: 1),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        // Name field
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller:
                                                _clientDetailsControllers[index][0],
                                            validator: (value) {
                                              // Only validate if any of the fields in this row has text
                                              if (_clientDetailsControllers[index][0]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][1]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][2]
                                                      .text
                                                      .isNotEmpty) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                }
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Contact name',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),

                                        // Designation field
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller:
                                                _clientDetailsControllers[index][1],
                                            validator: (value) {
                                              // Only validate if any of the fields in this row has text
                                              if (_clientDetailsControllers[index][0]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][1]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][2]
                                                      .text
                                                      .isNotEmpty) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                }
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Role/Position',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),

                                        // Email field
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            controller:
                                                _clientDetailsControllers[index][2],
                                            validator: (value) {
                                              // Only validate if any of the fields in this row has text
                                              if (_clientDetailsControllers[index][0]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][1]
                                                      .text
                                                      .isNotEmpty ||
                                                  _clientDetailsControllers[index][2]
                                                      .text
                                                      .isNotEmpty) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                } else if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                ).hasMatch(value)) {
                                                  return 'Enter valid email';
                                                }
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Email address',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),

                                        // Remove button
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red[700],
                                          ),
                                          onPressed:
                                              () =>
                                                  _removeClientDetailRow(index),
                                          tooltip: 'Remove contact',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Submit buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.blackColor),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          //! S A V E B U T T O N
                          Expanded(
                            child: CustomBlackButton(
                              buttonTitle:
                                  _isEditMode ? 'Update Task' : 'Save Task',
                              onTap: _handleFormSubmit,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper widget to build form fields
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isRequired = false,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextstyles.authFieldHeadings.copyWith(fontSize: 14),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[100] : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: maxLines > 1 ? 15 : 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blackColor, width: 1.5),
            ),
          ),
          validator:
              isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }

  // Helper widget to build date fields
  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextstyles.authFieldHeadings.copyWith(fontSize: 14),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true, // Date is selected via date picker
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              final formattedDate =
                  '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
              controller.text = formattedDate;
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.blackColor, width: 1.5),
            ),
            suffixIcon: Icon(Icons.calendar_today, size: 20),
          ),
          validator:
              isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }

  // Helper widget to build cards for sections
  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),

          // Card content
          Padding(padding: const EdgeInsets.all(16), child: content),
        ],
      ),
    );
  }
}
