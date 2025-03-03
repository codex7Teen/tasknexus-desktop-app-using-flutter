// screen_task_commencement.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/add_task_service.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/features/task_commencement/presentation/widgets/task_commencement_screen_widgets.dart';

class ScreenTaskCommencement extends StatefulWidget {
  final String taskUrn;
  final String userEmail;
  final String userName;

  const ScreenTaskCommencement({
    super.key,
    required this.taskUrn,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<ScreenTaskCommencement> createState() => _ScreenTaskCommencementState();
}

class _ScreenTaskCommencementState extends State<ScreenTaskCommencement> {
  final AddTaskService _addTaskService = AddTaskService();
  TaskModel? _taskModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    try {
      final task = await _addTaskService.getTaskByURN(
        widget.taskUrn,
        widget.userEmail,
      );
      setState(() {
        _taskModel = task;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ElegantSnackbar.show(
          context,
          message: 'Error loading task: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              TaskCommencementBloc()..add(
                InitializeTaskCommencement(
                  taskUrn: widget.taskUrn,
                  userEmail: widget.userEmail,
                ),
              ),
      child: Scaffold(
        body: BlocConsumer<TaskCommencementBloc, TaskCommencementState>(
          listener: (context, state) {
            if (state is TaskCommencementFailure) {
              ElegantSnackbar.show(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }

            if (state is TaskCommencementCompleted) {
              ElegantSnackbar.show(
                context,
                message: 'Task completed successfully!',
                type: SnackBarType.success,
              );

              // Return to home screen
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context, true);
                }
              });
            }
          },
          builder: (context, state) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_taskModel == null) {
              return const Center(
                child: Text('Task not found. Please try again.'),
              );
            }

            return Container(
              color: Colors.white,
              child: Row(
                children: [
                  // Left sidebar
                  TaskCommencementScreenWidgets.buildSidebar(
                    context: context,
                    state: state,
                    onGeneralDataTap: () {
                      if (state is TaskCommencementLoaded) {
                        context.read<TaskCommencementBloc>().add(
                          const ChangeSelectedSchool(-1),
                        );
                      }
                    },
                    onSchoolTap: (index) {
                      context.read<TaskCommencementBloc>().add(
                        ChangeSelectedSchool(index),
                      );
                    },
                    onBackToHomeTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Main content area
                  Expanded(
                    child: Column(
                      children: [
                        // Custom app bar
                        TaskCommencementScreenWidgets.buildTopBar(
                          context: context,
                          taskModel: _taskModel!,
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                        ),

                        // Content based on state
                        Expanded(
                          child: TaskCommencementScreenWidgets.buildContent(
                            context: context,
                            state: state,
                            taskUrn: widget.taskUrn,
                            userEmail: widget.userEmail,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
