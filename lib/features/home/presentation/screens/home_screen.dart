import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/features/home/presentation/screens/add_task_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  // Current selected sidebar item
  String _currentSidebarItem = 'Scheduled Tasks';

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
            _buildSidebar(screenHeight),

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
      onTap: () {
        if (isLogout) {
          // Handle logout
          ElegantSnackbar.show(
            context,
            message: 'Logging out...',
            type: SnackBarType.info,
          );
          // Add actual logout logic here
        } else {
          setState(() {
            _currentSidebarItem = title;
          });
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
                onPressed: () {
                  NavigationHelper.navigateToWithoutReplacement(
                    context,
                    const ScreenAddTask(
                      userEmail: 'djdennis@gmail.com',
                      userName: 'dennis',
                    ),
                  );
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
      onTap: () {
        ElegantSnackbar.show(
          context,
          message: 'Navigating to $title',
          type: SnackBarType.info,
        );
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
    // Mock data for the dashboard
    final tasks = [
      {
        'urn': 'TN-2023-001',
        'name': 'Website Redesign',
        'assignedBy': 'John Smith',
        'assignedTo': 'Sarah Johnson',
        'commencementDate': '01/03/2023',
        'dueDate': '15/03/2023',
        'clientName': 'Acme Corp',
        'status': 'In Progress',
      },
      {
        'urn': 'TN-2023-002',
        'name': 'Mobile App Development',
        'assignedBy': 'Michael Brown',
        'assignedTo': 'David Wilson',
        'commencementDate': '05/03/2023',
        'dueDate': '20/03/2023',
        'clientName': 'XYZ Industries',
        'status': 'Not Started',
      },
      {
        'urn': 'TN-2023-003',
        'name': 'Database Migration',
        'assignedBy': 'Emma Davis',
        'assignedTo': 'James Miller',
        'commencementDate': '08/03/2023',
        'dueDate': '22/03/2023',
        'clientName': 'Tech Solutions',
        'status': 'In Progress',
      },
    ];

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
                  ),
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
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
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
                        tasks.map((task) {
                          return DataRow(
                            cells: [
                              DataCell(Text(task['urn'] ?? '')),
                              DataCell(Text(task['name'] ?? '')),
                              DataCell(Text(task['assignedBy'] ?? '')),
                              DataCell(Text(task['assignedTo'] ?? '')),
                              DataCell(Text(task['commencementDate'] ?? '')),
                              DataCell(Text(task['dueDate'] ?? '')),
                              DataCell(
                                GestureDetector(
                                  onTap:
                                      () => _showClientDetailsDialog(
                                        context,
                                        task['clientName'] ?? '',
                                      ),
                                  child: Row(
                                    children: [
                                      Text(
                                        task['clientName'] ?? '',
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
                                        task['status'] == 'In Progress'
                                            ? Colors.blue[50]
                                            : Colors.orange[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    task['status'] ?? '',
                                    style: TextStyle(
                                      color:
                                          task['status'] == 'In Progress'
                                              ? Colors.blue[700]
                                              : Colors.orange[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    _buildActionButton(
                                      'Start',
                                      Icons.play_arrow,
                                      Colors.green,
                                      () {
                                        ElegantSnackbar.show(
                                          context,
                                          message:
                                              'Starting task: ${task['name']}',
                                          type: SnackBarType.info,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    _buildActionButton(
                                      'Edit',
                                      Icons.edit,
                                      Colors.blue,
                                      () {
                                        NavigationHelper.navigateToWithoutReplacement(
                                          context,
                                          ScreenAddTask(
                                            userEmail: 'djdennis@gmail.com',
                                            userName: 'DENNII',
                                            taskUrn: 'TN-2025-6974',
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    _buildActionButton(
                                      'Delete',
                                      Icons.delete,
                                      Colors.red,
                                      () {
                                        ElegantSnackbar.show(
                                          context,
                                          message:
                                              'Moving task to With-held Tasks',
                                          type: SnackBarType.warning,
                                        );
                                      },
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

  void _showClientDetailsDialog(BuildContext context, String clientName) {
    // Mock client details
    final clientDetails = [
      {
        'name': 'John Smith',
        'designation': 'CEO',
        'email': 'john.smith@example.com',
      },
      {
        'name': 'Emily Johnson',
        'designation': 'Project Manager',
        'email': 'emily.j@example.com',
      },
      {
        'name': 'Michael Brown',
        'designation': 'Technical Lead',
        'email': 'michael.b@example.com',
      },
    ];

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

                  // Table content
                  Expanded(
                    child: ListView.builder(
                      itemCount: clientDetails.length,
                      itemBuilder: (context, index) {
                        final detail = clientDetails[index];
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
                                  detail['name'] ?? '',
                                  style: AppTextstyles.enterNameAndPasswordText,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  detail['designation'] ?? '',
                                  style: AppTextstyles.enterNameAndPasswordText,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  detail['email'] ?? '',
                                  style: AppTextstyles.enterNameAndPasswordText,
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
