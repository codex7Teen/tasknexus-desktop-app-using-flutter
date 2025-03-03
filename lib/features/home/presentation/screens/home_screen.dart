import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/task_service.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/add_task_screen.dart';
import 'package:tasknexus/features/home/presentation/widgets/home_screen_widgets.dart';
import 'package:tasknexus/features/task_commencement/presentation/screens/task_commencement_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class ScreenHome extends StatefulWidget {
  final String userEmail;
  final String userName;

  const ScreenHome({
    super.key,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  // Current selected sidebar item
  String _currentSidebarItem = 'Scheduled Tasks';

  // Task service for data operations
  final TaskService _taskService = TaskService();

  // List to hold tasks
  List<TaskModel> _tasks = [];

  // Loading state
  bool _isLoading = true;

  // Add this property to store the search query
  String _searchQuery = '';

  // Add this property to store filtered tasks
  List<TaskModel> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks based on the current sidebar selection
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<TaskModel> tasks = [];

      // Load different tasks based on sidebar selection
      switch (_currentSidebarItem) {
        case 'Scheduled Tasks':
          // Get tasks with "Not Started" or "In Progress" status
          final notStartedTasks = await _taskService.getTasksByStatus(
            widget.userEmail,
            'Not Started',
          );
          final inProgressTasks = await _taskService.getTasksByStatus(
            widget.userEmail,
            'In Progress',
          );
          tasks = [...notStartedTasks, ...inProgressTasks];
          break;

        case 'Completed Tasks':
          tasks = await _taskService.getTasksByStatus(
            widget.userEmail,
            'Completed',
          );
          break;

        case 'With-held Tasks':
          tasks = await _taskService.getTasksByStatus(
            widget.userEmail,
            'With-held',
          );
          break;

        default:
          tasks = await _taskService.getTasks(widget.userEmail);
      }

      setState(() {
        _tasks = tasks;
        // Apply existing search filter to the new tasks
        _filterTasks();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ElegantSnackbar.show(
        context,
        message: 'Error loading tasks: $e',
        type: SnackBarType.error,
      );
    }
  }

  // Filter tasks based on search query
  void _filterTasks() {
    if (_searchQuery.isEmpty) {
      _filteredTasks = List.from(_tasks);
    } else {
      _filteredTasks =
          _tasks.where((task) {
            return task.name.toLowerCase().contains(_searchQuery) ||
                task.urn.toLowerCase().contains(_searchQuery) ||
                task.assignedBy.toLowerCase().contains(_searchQuery) ||
                task.assignedTo.toLowerCase().contains(_searchQuery) ||
                task.clientName.toLowerCase().contains(_searchQuery) ||
                task.status.toLowerCase().contains(_searchQuery);
          }).toList();
    }
  }

  // Update task status
  Future<void> _updateTaskStatus(TaskModel task, String newStatus) async {
    try {
      await _taskService.updateTaskStatus(
        task.urn,
        widget.userEmail,
        newStatus,
      );

      ElegantSnackbar.show(
        context,
        message: 'Task status updated to $newStatus',
        type: SnackBarType.success,
      );

      // Reload tasks to reflect the change
      _loadTasks();
    } catch (e) {
      ElegantSnackbar.show(
        context,
        message: 'Error updating task status: $e',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            //! L E F T - S I D E B A R
            FadeInLeft(
              child: HomeScreenWidgets.buildSidebar(
                screenHeight: screenHeight,
                currentSidebarItem: _currentSidebarItem,
                onSidebarItemTap: (String title, bool isLogout) async {
                  if (isLogout) {
                    // Handle logout
                    if (mounted) {
                      ElegantSnackbar.show(
                        actionLabel: 'LOGGED-OUT!',
                        duration: Duration(seconds: 1),
                        context,
                        message: 'Logout Success!!!',
                        type: SnackBarType.info,
                      );
                    }
                    // logout login here
                    context.read<AuthBloc>().add(LogoutEvent());
                    await Future.delayed(Duration(milliseconds: 1000), () {
                      if (mounted) {
                        NavigationHelper.navigateToWithReplacement(
                          context,
                          ScreenLogin(),
                        );
                      }
                    });
                  } else {
                    setState(() {
                      _currentSidebarItem = title;
                    });
                    // Reload tasks when sidebar item changes
                    _loadTasks();
                  }
                },
              ),
            ),

            //! M A I N - C O N T E N T   A R E A
            Expanded(
              child: Column(
                children: [
                  //! TOP BAR (CUSTOM APP BAR LIKE TOP BAR)
                  HomeScreenWidgets.buildTopBar(
                    context: context,
                    currentSidebarItem: _currentSidebarItem,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    onAddTaskPressed: () async {
                      final result =
                          await NavigationHelper.navigateToWithoutReplacement(
                            context,
                            ScreenAddTask(
                              userEmail: widget.userEmail,
                              userName: widget.userName,
                            ),
                          );
                      // Reload tasks after returning from add task screen
                      if (result) {
                        await _loadTasks();
                      }
                    },
                    onProfileItemSelected: (String title) async {
                      if (title == 'Home') {
                        NavigationHelper.navigateToWithReplacement(
                          context,
                          ScreenHome(
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                          ),
                        );
                      } else if (title == 'Logout') {
                        // Handle logout
                        if (mounted) {
                          ElegantSnackbar.show(
                            actionLabel: 'LOGGED-OUT!',
                            duration: Duration(seconds: 1),
                            context,
                            message: 'Logout Success!!!',
                            type: SnackBarType.info,
                          );
                        }
                        // logout login here
                        context.read<AuthBloc>().add(LogoutEvent());
                        await Future.delayed(Duration(milliseconds: 1000), () {
                          if (mounted) {
                            NavigationHelper.navigateToWithReplacement(
                              context,
                              ScreenLogin(),
                            );
                          }
                        });
                      }
                    },
                  ),

                  //! DASHBOARD
                  Expanded(
                    child: HomeScreenWidgets.buildDashboard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isLoading: _isLoading,
                      filteredTasks: _filteredTasks,
                      currentSidebarItem: _currentSidebarItem,
                      userEmail: widget.userEmail,
                      userName: widget.userName,
                      searchQuery: _searchQuery,
                      onSearchChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                          _filterTasks();
                        });
                      },
                      onClearSearch: () {
                        setState(() {
                          _searchQuery = '';
                          _filterTasks();
                        });
                      },
                      onAddNewTask: () async {
                        final result =
                            await NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddTask(
                                userEmail: widget.userEmail,
                                userName: widget.userName,
                              ),
                            );
                        // Reload tasks after returning from add task screen
                        if (result) {
                          await _loadTasks();
                        }
                      },
                      onStartTask: (TaskModel task) async {
                        // First update the status
                        await _updateTaskStatus(task, 'In Progress');

                        // Then navigate to the Task Commencement screen
                        if (mounted) {
                          final result =
                              await NavigationHelper.navigateToWithoutReplacement(
                                context,
                                ScreenTaskCommencement(
                                  taskUrn: task.urn,
                                  userEmail: widget.userEmail,
                                  userName: widget.userName,
                                ),
                              );

                          // Reload tasks after returning from the task commencement screen
                          if (result == true) {
                            await _loadTasks();
                          }
                        }
                      },
                      onCompleteTask:
                          (TaskModel task) =>
                              _updateTaskStatus(task, 'Completed'),
                      onWithheldTask:
                          (TaskModel task) =>
                              _updateTaskStatus(task, 'With-held'),
                      onEditTask: (TaskModel task) async {
                        await NavigationHelper.navigateToWithoutReplacement(
                          context,
                          ScreenAddTask(
                            userEmail: widget.userEmail,
                            userName: widget.userName,
                            taskUrn: task.urn,
                          ),
                        );

                        // Reload tasks after returning from add task screen
                        await _loadTasks();
                      },
                      onShowClientDetails: (
                        String clientName,
                        List<dynamic> clientContacts,
                      ) {
                        HomeScreenWidgets.showClientDetailsDialog(
                          context: context,
                          clientName: clientName,
                          clientContacts: clientContacts,
                        );
                      },
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
}
