// task_commencement_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/add_task_service.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/features/task_commencement/presentation/screens/general_data_screen.dart';
import 'package:tasknexus/features/task_commencement/presentation/screens/school_data_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

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
                  _buildSidebar(context, state),

                  // Main content area
                  Expanded(
                    child: Column(
                      children: [
                        // Custom app bar
                        _buildTopBar(context),

                        // Content based on state
                        Expanded(child: _buildContent(context, state)),
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
          // Task info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Task Commencement',
                style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                'Task: ${_taskModel?.name} (${_taskModel?.urn})',
                style: AppTextstyles.enterNameAndPasswordText.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // User profile button
          _buildUserProfileButton(context),
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
            _buildPopupMenuItem('Sign Out', Icons.logout),
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

  Widget _buildSidebar(BuildContext context, TaskCommencementState state) {
    // Default sidebar items
    List<Widget> sidebarItems = [
      _buildSidebarItem(
        context,
        'General Data',
        Icons.dashboard_customize,
        isSelected:
            state is TaskCommencementInitial ||
            (state is TaskCommencementLoaded &&
                state.selectedSchoolIndex == -1),
        onTap: () {
          if (state is TaskCommencementLoaded) {
            context.read<TaskCommencementBloc>().add(
              const ChangeSelectedSchool(-1),
            );
          }
        },
      ),
    ];

    // Add school items if data is loaded
    if (state is TaskCommencementLoaded) {
      for (int i = 0; i < state.generalData.totalSchools; i++) {
        final schoolName =
            state.generalData.schools[i].name.isNotEmpty
                ? state.generalData.schools[i].name
                : 'School-${i + 1}';

        sidebarItems.add(
          _buildSidebarItem(
            context,
            schoolName,
            Icons.school,
            isSelected: state.selectedSchoolIndex == i,
            onTap: () {
              context.read<TaskCommencementBloc>().add(ChangeSelectedSchool(i));
            },
          ),
        );
      }
    }

    return Container(
      width: 250,
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
          const SizedBox(height: 50),

          // Dynamic sidebar items
          ...sidebarItems,

          const Spacer(),

          // Back to home button
          _buildSidebarItem(
            context,
            'Back to Home',
            Icons.arrow_back,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    String title,
    IconData icon, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Expanded(
              child: Text(
                title,
                style: AppTextstyles.enterNameAndPasswordText.copyWith(
                  color:
                      isSelected
                          ? AppColors.whiteColor
                          : AppColors.whiteColor.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskCommencementState state) {
    if (state is TaskCommencementLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TaskCommencementLoaded) {
      // If selected index is -1 or not set, show general data
      if (state.selectedSchoolIndex == -1) {
        return GeneralDataScreen(
          taskUrn: widget.taskUrn,
          userEmail: widget.userEmail,
          generalData: state.generalData,
        );
      } else {
        // Show school data for the selected index
        return SchoolDataScreen(
          taskUrn: widget.taskUrn,
          userEmail: widget.userEmail,
          schoolIndex: state.selectedSchoolIndex,
          generalData: state.generalData,
        );
      }
    }

    // Initial state - show general data form
    return GeneralDataScreen(
      taskUrn: widget.taskUrn,
      userEmail: widget.userEmail,
    );
  }
}
