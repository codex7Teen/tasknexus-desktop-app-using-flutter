import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';
import 'package:tasknexus/features/task_commencement/bloc/bloc/task_commencement_bloc.dart';
import 'package:tasknexus/features/task_commencement/presentation/screens/general_data_screen.dart';
import 'package:tasknexus/features/task_commencement/presentation/screens/school_data_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class TaskCommencementScreenWidgets {
  static Widget buildTopBar({
    required BuildContext context,
    required TaskModel taskModel,
    required String userEmail,
    required String userName,
  }) {
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
                'Task: ${taskModel.name} (${taskModel.urn})',
                style: AppTextstyles.enterNameAndPasswordText.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // User profile button
          _buildUserProfileButton(
            context: context,
            userEmail: userEmail,
            userName: userName,
          ),
        ],
      ),
    );
  }

  static Widget _buildUserProfileButton({
    required BuildContext context,
    required String userEmail,
    required String userName,
  }) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder:
          (context) => [
            _buildPopupMenuItem(
              context: context,
              title: 'Home',
              icon: Icons.home,
              userEmail: userEmail,
              userName: userName,
            ),
            _buildPopupMenuItem(
              context: context,
              title: 'Settings',
              icon: Icons.settings,
              userEmail: userEmail,
              userName: userName,
            ),
            _buildPopupMenuItem(
              context: context,
              title: 'Sign Out',
              icon: Icons.logout,
              userEmail: userEmail,
              userName: userName,
            ),
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

  static PopupMenuItem _buildPopupMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String userEmail,
    required String userName,
  }) {
    return PopupMenuItem(
      onTap: () async {
        if (title == 'Home') {
          NavigationHelper.navigateToWithReplacement(
            context,
            ScreenHome(userEmail: userEmail, userName: userName),
          );
        } else if (title == 'Sign Out') {
          // Handle logout
          if (context.mounted) {
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
            if (context.mounted) {
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

  static Widget buildSidebar({
    required BuildContext context,
    required TaskCommencementState state,
    required VoidCallback onGeneralDataTap,
    required Function(int) onSchoolTap,
    required VoidCallback onBackToHomeTap,
  }) {
    // Default sidebar items
    List<Widget> sidebarItems = [
      _buildSidebarItem(
        context: context,
        title: 'General Data',
        icon: Icons.dashboard_customize,
        isSelected:
            state is TaskCommencementInitial ||
            (state is TaskCommencementLoaded &&
                state.selectedSchoolIndex == -1),
        onTap: onGeneralDataTap,
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
            context: context,
            title: schoolName,
            icon: Icons.school,
            isSelected: state.selectedSchoolIndex == i,
            onTap: () => onSchoolTap(i),
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
            context: context,
            title: 'Back to Home',
            icon: Icons.arrow_back,
            onTap: onBackToHomeTap,
          ),
        ],
      ),
    );
  }

  static Widget _buildSidebarItem({
    required BuildContext context,
    required String title,
    required IconData icon,
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

  static Widget buildContent({
    required BuildContext context,
    required TaskCommencementState state,
    required String taskUrn,
    required String userEmail,
  }) {
    if (state is TaskCommencementLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TaskCommencementLoaded) {
      // If selected index is -1 or not set, show general data
      if (state.selectedSchoolIndex == -1) {
        return GeneralDataScreen(
          taskUrn: taskUrn,
          userEmail: userEmail,
          generalData: state.generalData,
        );
      } else {
        // Show school data for the selected index
        return SchoolDataScreen(
          taskUrn: taskUrn,
          userEmail: userEmail,
          schoolIndex: state.selectedSchoolIndex,
          generalData: state.generalData,
        );
      }
    }

    // Initial state - show general data form
    return GeneralDataScreen(taskUrn: taskUrn, userEmail: userEmail);
  }
}
