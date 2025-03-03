import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/add_task_service.dart';
import 'package:tasknexus/features/home/bloc/bloc/add_task_bloc.dart';
import 'package:tasknexus/features/home/presentation/widgets/add_task_screen_widgets.dart';
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
        appBar: AddTaskScreenWidgets.buildAppbar(
          isEditMode: _isEditMode,
          context: context,
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
                      AddTaskScreenWidgets.buildCard(
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
                                  child: AddTaskScreenWidgets.buildFormField(
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
                                  child: AddTaskScreenWidgets.buildFormField(
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
                            AddTaskScreenWidgets.buildFormField(
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
                      AddTaskScreenWidgets.buildCard(
                        title: 'Dates & Assignment',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dates row
                            Row(
                              children: [
                                // Commencement date
                                Expanded(
                                  child: AddTaskScreenWidgets.buildDateField(
                                    context: context,
                                    label: 'Date of Commencement',
                                    controller: _commencementDateController,
                                    hintText: 'Select start date',
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Due date
                                Expanded(
                                  child: AddTaskScreenWidgets.buildDateField(
                                    context: context,
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
                                  child: AddTaskScreenWidgets.buildFormField(
                                    label: 'Assigned To',
                                    controller: _assignedToController,
                                    hintText: 'Enter assignee name',
                                    isRequired: true,
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Assigned by - read only
                                Expanded(
                                  child: AddTaskScreenWidgets.buildFormField(
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
                      AddTaskScreenWidgets.buildCard(
                        title: 'Client Information',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Client name
                            AddTaskScreenWidgets.buildFormField(
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
                            AddTaskScreenWidgets.buildClientDetailstableHeader(),

                            // Client details rows
                            AddTaskScreenWidgets.buildCliendDetailsRow(
                              clientDetailsControllers:
                                  _clientDetailsControllers,
                              removeClientDetailRow: _removeClientDetailRow,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Submit buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //! Cancel button
                          AddTaskScreenWidgets.buildCancelButton(
                            context: context,
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
}
