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
  // Modify the _loadTasks method to initialize filtered tasks
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
            FadeInLeft(child: _buildSidebar(screenHeight)),

            //! M A I N - C O N T E N T   A R E A
            Expanded(
              child: Column(
                children: [
                  //! TOP BAR (CUSTOM APP BAR LIKE TOP BAR)
                  _buildTopBar(context),

                  //! DASHBOARD
                  Expanded(child: _buildDashboard(screenWidth, screenHeight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(double screenHeight) {
    return Container(
      width: 250,
      height: screenHeight,
      color: AppColors.blackColor,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App logo
          Text(
            'TASKNEXUS',
            style: AppTextstyles.apptitileText.copyWith(
              color: AppColors.whiteColor,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 50),

          // Sidebar menu items
          _buildSidebarItem('Scheduled Tasks', Icons.calendar_today),
          _buildSidebarItem('Completed Tasks', Icons.check_circle),
          _buildSidebarItem('With-held Tasks', Icons.pause_circle),

          const Spacer(),

          // Logout option at bottom
          _buildSidebarItem('Logout', Icons.logout, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    String title,
    IconData icon, {
    bool isLogout = false,
  }) {
    final isSelected = _currentSidebarItem == title;

    return GestureDetector(
      onTap: () async {
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.whiteColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? AppColors.whiteColor
                      : AppColors.whiteColor.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: AppTextstyles.enterNameAndPasswordText.copyWith(
                color:
                    isSelected
                        ? AppColors.whiteColor
                        : AppColors.whiteColor.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! TOP BAR (APP BAR LIKE ONE)
  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //! Page title
          Text(
            _currentSidebarItem,
            style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 22),
          ),

          //! Right side controls
          Row(
            children: [
              // Add Task button
              ElevatedButton.icon(
                onPressed: () async {
                  final result =
                      await NavigationHelper.navigateToWithoutReplacement(
                        context,
                        ScreenAddTask(
                          userEmail: widget.userEmail,
                          userName: widget.userName,
                        ),
                      );
                  // Reload tasks after returning from add task screen\
                  if (result) {
                    await _loadTasks();
                  }
                },
                icon: const Icon(Icons.add, color: AppColors.whiteColor),
                label: Text(
                  'Add Task',
                  style: AppTextstyles.enterNameAndPasswordText.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blackColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // User profile dropdown
              _buildUserProfileButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileButton(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder:
          (context) => [
            _buildPopupMenuItem('Home', Icons.home),
            _buildPopupMenuItem('Settings', Icons.settings),
            _buildPopupMenuItem('Logout', Icons.logout),
          ],
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
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData icon) {
    return PopupMenuItem(
      onTap: () async {
        if (title == 'Home') {
          NavigationHelper.navigateToWithReplacement(
            context,
            ScreenHome(userEmail: widget.userEmail, userName: widget.userName),
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
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.blackColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppTextstyles.enterNameAndPasswordText.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(double screenWidth, double screenHeight) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! SEARCH AREA
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      hintStyle: AppTextstyles.enterNameAndPasswordText
                          .copyWith(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                        _filterTasks();
                      });
                    },
                  ),
                ),
                // Clear search button
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _filterTasks();
                      });
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tasks table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredTasks.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              Colors.grey[100],
                            ),
                            dataRowMaxHeight: 60,
                            headingRowHeight: 50,
                            columnSpacing: 30,
                            columns: const [
                              DataColumn(label: Text('URN')),
                              DataColumn(label: Text('Task')),
                              DataColumn(label: Text('Assigned By')),
                              DataColumn(label: Text('Assigned To')),
                              DataColumn(label: Text('Start Date')),
                              DataColumn(label: Text('Due Date')),
                              DataColumn(label: Text('Client')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows:
                                _filteredTasks.map((task) {
                                  // Rest of the DataRow code remains the same
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(task.urn)),
                                      DataCell(Text(task.name)),
                                      DataCell(Text(task.assignedBy)),
                                      DataCell(Text(task.assignedTo)),
                                      DataCell(Text(task.commencementDate)),
                                      DataCell(Text(task.dueDate)),
                                      DataCell(
                                        GestureDetector(
                                          onTap:
                                              () => _showClientDetailsDialog(
                                                context,
                                                task.clientName,
                                                task.clientContacts,
                                              ),
                                          child: Row(
                                            children: [
                                              Text(
                                                task.clientName,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              const Icon(
                                                Icons.info_outline,
                                                size: 16,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _getStatusColor(task.status)[0],
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            task.status,
                                            style: TextStyle(
                                              color:
                                                  _getStatusColor(
                                                    task.status,
                                                  )[1],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            // Only show Start button for Not Started tasks
                                            if (task.status == 'Not Started')
                                              _buildActionButton(
                                                'Start',
                                                Icons.play_arrow,
                                                Colors.green,
                                                () async {
                                                  // First update the status
                                                  await _updateTaskStatus(
                                                    task,
                                                    'In Progress',
                                                  );

                                                  // Then navigate to the Task Commencement screen
                                                  if (mounted) {
                                                    final result =
                                                        await NavigationHelper.navigateToWithoutReplacement(
                                                          context,
                                                          ScreenTaskCommencement(
                                                            taskUrn: task.urn,
                                                            userEmail:
                                                                widget
                                                                    .userEmail,
                                                            userName:
                                                                widget.userName,
                                                          ),
                                                        );

                                                    // Reload tasks after returning from the task commencement screen
                                                    if (result == true) {
                                                      await _loadTasks();
                                                    }
                                                  }
                                                },
                                              ),

                                            // Only show Complete button for In Progress tasks
                                            if (task.status == 'In Progress')
                                              _buildActionButton(
                                                'Complete',
                                                Icons.check,
                                                Colors.blue,
                                                () => _updateTaskStatus(
                                                  task,
                                                  'Completed',
                                                ),
                                              ),

                                            const SizedBox(width: 5),

                                            _buildActionButton(
                                              'Edit',
                                              Icons.edit,
                                              Colors.blue,
                                              () async {
                                                NavigationHelper.navigateToWithoutReplacement(
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
                                            ),

                                            const SizedBox(width: 5),

                                            _buildActionButton(
                                              'With-held',
                                              Icons.delete,
                                              Colors.red,
                                              () => _updateTaskStatus(
                                                task,
                                                'With-held',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to filter tasks based on search query
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

  // Helper method to get status colors
  List<Color> _getStatusColor(String status) {
    switch (status) {
      case 'Not Started':
        return [Colors.orange[50]!, Colors.orange[700]!];
      case 'In Progress':
        return [Colors.blue[50]!, Colors.blue[700]!];
      case 'Completed':
        return [Colors.green[50]!, Colors.green[700]!];
      case 'With-held':
        return [Colors.red[50]!, Colors.red[700]!];
      default:
        return [Colors.grey[50]!, Colors.grey[700]!];
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

  // Widget to display when no tasks are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No ${_currentSidebarItem.toLowerCase()} found',
            style: AppTextstyles.loginSuperHeading.copyWith(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new task to get started',
            style: AppTextstyles.enterNameAndPasswordText.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result =
                  await NavigationHelper.navigateToWithoutReplacement(
                    context,
                    ScreenAddTask(
                      userEmail: widget.userEmail,
                      userName: widget.userName,
                    ),
                  );
              // Reload tasks after returning from add task screen\
              if (result) {
                await _loadTasks();
              }
            },
            icon: const Icon(Icons.add, color: AppColors.whiteColor),
            label: Text(
              'Add New Task',
              style: AppTextstyles.enterNameAndPasswordText.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blackColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String tooltip,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  void _showClientDetailsDialog(
    BuildContext context,
    String clientName,
    List<dynamic> clientContacts,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Client Details: $clientName',
              style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 18),
            ),
            content: SizedBox(
              width: 500,
              height: 300,
              child: Column(
                children: [
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Name',
                            style: AppTextstyles.enterNameAndPasswordText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Designation',
                            style: AppTextstyles.enterNameAndPasswordText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Email',
                            style: AppTextstyles.enterNameAndPasswordText
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Client contacts list
                  Expanded(
                    child:
                        clientContacts.isEmpty
                            ? Center(
                              child: Text(
                                'No contacts available',
                                style: AppTextstyles.enterNameAndPasswordText
                                    .copyWith(color: Colors.grey),
                              ),
                            )
                            : ListView.builder(
                              itemCount: clientContacts.length,
                              itemBuilder: (context, index) {
                                final contact = clientContacts[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          contact.name,
                                          style:
                                              AppTextstyles
                                                  .enterNameAndPasswordText,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          contact.designation,
                                          style:
                                              AppTextstyles
                                                  .enterNameAndPasswordText,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          contact.email,
                                          style:
                                              AppTextstyles
                                                  .enterNameAndPasswordText,
                                        ),
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
