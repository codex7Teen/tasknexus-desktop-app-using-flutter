import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class AddTaskScreenWidgets {
  static buildAppbar({
    required bool isEditMode,
    required BuildContext context,
  }) {
    return AppBar(
      title: Text(
        isEditMode ? 'Edit Task' : 'Add New Task',
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
    );
  }

  // Helper widget to build form fields
  static Widget buildFormField({
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

  static // Helper widget to build date fields
  Widget
  buildDateField({
    required BuildContext context,
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

  static // Helper widget to build cards for sections
  Widget
  buildCard({required String title, required Widget content}) {
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

  static Widget buildClientDetailstableHeader() {
    return // Client details table header
    Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          SizedBox(width: 40), // Space for action button
        ],
      ),
    );
  }

  static buildCliendDetailsRow({
    required List<List<TextEditingController>> clientDetailsControllers,
    required void Function(int) removeClientDetailRow,
  }) {
    return Container(
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
        itemCount: clientDetailsControllers.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              children: [
                // Name field
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: clientDetailsControllers[index][0],
                    validator: (value) {
                      // Only validate if any of the fields in this row has text
                      if (clientDetailsControllers[index][0].text.isNotEmpty ||
                          clientDetailsControllers[index][1].text.isNotEmpty ||
                          clientDetailsControllers[index][2].text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Contact name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Designation field
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: clientDetailsControllers[index][1],
                    validator: (value) {
                      // Only validate if any of the fields in this row has text
                      if (clientDetailsControllers[index][0].text.isNotEmpty ||
                          clientDetailsControllers[index][1].text.isNotEmpty ||
                          clientDetailsControllers[index][2].text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Role/Position',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Email field
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: clientDetailsControllers[index][2],
                    validator: (value) {
                      // Only validate if any of the fields in this row has text
                      if (clientDetailsControllers[index][0].text.isNotEmpty ||
                          clientDetailsControllers[index][1].text.isNotEmpty ||
                          clientDetailsControllers[index][2].text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                // Remove button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                  onPressed: () => removeClientDetailRow(index),
                  tooltip: 'Remove contact',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static buildCancelButton({required BuildContext context}) {
    return Expanded(
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
    );
  }
}
