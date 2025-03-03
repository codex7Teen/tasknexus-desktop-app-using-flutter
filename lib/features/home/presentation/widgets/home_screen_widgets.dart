import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/data/models/task_model.dart';

class HomeScreenWidgets {
  //! SIDEBAR
  static Widget buildSidebar({
    required double screenHeight,
    required String currentSidebarItem,
    required Function(String, bool) onSidebarItemTap,
  }) {
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
          buildSidebarItem(
            title: 'Scheduled Tasks',
            icon: Icons.calendar_today,
            isSelected: currentSidebarItem == 'Scheduled Tasks',
            onTap: () => onSidebarItemTap('Scheduled Tasks', false),
          ),
          buildSidebarItem(
            title: 'Completed Tasks',
            icon: Icons.check_circle,
            isSelected: currentSidebarItem == 'Completed Tasks',
            onTap: () => onSidebarItemTap('Completed Tasks', false),
          ),
          buildSidebarItem(
            title: 'With-held Tasks',
            icon: Icons.pause_circle,
            isSelected: currentSidebarItem == 'With-held Tasks',
            onTap: () => onSidebarItemTap('With-held Tasks', false),
          ),

          const Spacer(),

          // Logout option at bottom
          buildSidebarItem(
            title: 'Logout',
            icon: Icons.logout,
            isSelected: false,
            onTap: () => onSidebarItemTap('Logout', true),
          ),
        ],
      ),
    );
  }

  //! SIDEBAR ITEM
  static Widget buildSidebarItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
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

  //! TOP BAR
  static Widget buildTopBar({
    required BuildContext context,
    required String currentSidebarItem,
    required String userEmail,
    required String userName,
    required VoidCallback onAddTaskPressed,
    required Function(String) onProfileItemSelected,
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
          //! Page title
          Text(
            currentSidebarItem,
            style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 22),
          ),

          //! Right side controls
          Row(
            children: [
              // Add Task button
              ElevatedButton.icon(
                onPressed: onAddTaskPressed,
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
              buildUserProfileButton(
                context: context,
                onSelected: onProfileItemSelected,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //! USER PROFILE BUTTON
  static Widget buildUserProfileButton({
    required BuildContext context,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder:
          (context) => [
            buildPopupMenuItem(title: 'Home', icon: Icons.home),
            buildPopupMenuItem(title: 'Settings', icon: Icons.settings),
            buildPopupMenuItem(title: 'Logout', icon: Icons.logout),
          ],
      onSelected: (String value) => onSelected(value),
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

  //! POPUP MENU ITEM
  static PopupMenuItem<String> buildPopupMenuItem({
    required String title,
    required IconData icon,
  }) {
    return PopupMenuItem<String>(
      value: title,
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

  //! DASHBOARD
  static Widget buildDashboard({
    required double screenWidth,
    required double screenHeight,
    required bool isLoading,
    required List<TaskModel> filteredTasks,
    required String currentSidebarItem,
    required String userEmail,
    required String userName,
    required String searchQuery,
    required Function(String) onSearchChanged,
    required VoidCallback onClearSearch,
    required VoidCallback onAddNewTask,
    required Function(TaskModel) onStartTask,
    required Function(TaskModel) onCompleteTask,
    required Function(TaskModel) onWithheldTask,
    required Function(TaskModel) onEditTask,
    required Function(String, List<dynamic>) onShowClientDetails,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! SEARCH AREA
          buildSearchBar(
            searchQuery: searchQuery,
            onSearchChanged: onSearchChanged,
            onClearSearch: onClearSearch,
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
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredTasks.isEmpty
                      ? buildEmptyState(
                        currentSidebarItem: currentSidebarItem,
                        onAddNewTask: onAddNewTask,
                      )
                      : buildTasksTable(
                        filteredTasks: filteredTasks,
                        onStartTask: onStartTask,
                        onCompleteTask: onCompleteTask,
                        onWithheldTask: onWithheldTask,
                        onEditTask: onEditTask,
                        onShowClientDetails: onShowClientDetails,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  //! SEARCH BAR
  static Widget buildSearchBar({
    required String searchQuery,
    required Function(String) onSearchChanged,
    required VoidCallback onClearSearch,
  }) {
    return Container(
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
                hintStyle: AppTextstyles.enterNameAndPasswordText.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            ),
          ),
          // Clear search button
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: onClearSearch,
            ),
        ],
      ),
    );
  }

  //! EMPTY STATE
  static Widget buildEmptyState({
    required String currentSidebarItem,
    required VoidCallback onAddNewTask,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No ${currentSidebarItem.toLowerCase()} found',
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
            onPressed: onAddNewTask,
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

  //! TASKS TABLE
  static Widget buildTasksTable({
    required List<TaskModel> filteredTasks,
    required Function(TaskModel) onStartTask,
    required Function(TaskModel) onCompleteTask,
    required Function(TaskModel) onWithheldTask,
    required Function(TaskModel) onEditTask,
    required Function(String, List<dynamic>) onShowClientDetails,
  }) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
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
              filteredTasks.map((task) {
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
                            () => onShowClientDetails(
                              task.clientName,
                              task.clientContacts,
                            ),
                        child: Row(
                          children: [
                            Text(
                              task.clientName,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
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
                              HomeScreenWidgets().getStatusColor(
                                task.status,
                              )[0],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.status,
                          style: TextStyle(
                            color:
                                HomeScreenWidgets().getStatusColor(
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
                            buildActionButton(
                              tooltip: 'Start',
                              icon: Icons.play_arrow,
                              color: Colors.green,
                              onPressed: () => onStartTask(task),
                            ),

                          // Only show Complete button for In Progress tasks
                          if (task.status == 'In Progress')
                            buildActionButton(
                              tooltip: 'Complete',
                              icon: Icons.check,
                              color: Colors.blue,
                              onPressed: () => onCompleteTask(task),
                            ),

                          const SizedBox(width: 5),

                          buildActionButton(
                            tooltip: 'Edit',
                            icon: Icons.edit,
                            color: Colors.blue,
                            onPressed: () => onEditTask(task),
                          ),

                          const SizedBox(width: 5),

                          buildActionButton(
                            tooltip: 'With-held',
                            icon: Icons.delete,
                            color: Colors.red,
                            onPressed: () => onWithheldTask(task),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  //! ACTION BUTTON
  static Widget buildActionButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
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

  //! CLIENT DETAILS DIALOG
  static void showClientDetailsDialog({
    required BuildContext context,
    required String clientName,
    required List<dynamic> clientContacts,
  }) {
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

  // Helper method to get status colors
  List<Color> getStatusColor(String status) {
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
}
