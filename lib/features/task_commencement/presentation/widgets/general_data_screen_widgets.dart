import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';

class GeneralDataScreenWidgets {
  static Widget buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General Data',
          style: AppTextstyles.loginSuperHeading.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Please enter the general information for this task.',
          style: AppTextstyles.enterNameAndPasswordText.copyWith(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  static Widget buildFormCard({
    required TextEditingController areaNameController,
    required TextEditingController totalSchoolsController,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area name field
            _buildFormLabel('Name of the Area'),
            const SizedBox(height: 8),
            _buildAreaNameField(areaNameController),
            const SizedBox(height: 24),

            // Total number of schools field
            _buildFormLabel('Total No. of Schools (Max 5)'),
            const SizedBox(height: 8),
            _buildTotalSchoolsField(totalSchoolsController, context),
            const SizedBox(height: 24),

            // Information panel
            _buildInfoPanel(),
          ],
        ),
      ),
    );
  }

  static Widget _buildAreaNameField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter area name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.location_on_outlined),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the area name';
        }
        return null;
      },
    );
  }

  static Widget _buildTotalSchoolsField(
    TextEditingController controller,
    BuildContext context,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter number of schools (1-5)',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.school_outlined),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the number of schools';
        }

        final number = int.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }

        if (number < 1 || number > 5) {
          return 'Number of schools must be between 1 and 5';
        }

        return null;
      },
      onChanged: (value) {
        final number = int.tryParse(value);
        if (number != null && (number < 1 || number > 5)) {
          ElegantSnackbar.show(
            context,
            message: 'Total schools must be between 1 and 5',
            type: SnackBarType.warning,
          );
        }
      },
    );
  }

  static Widget _buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Note:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'For each school entered, a separate button will be created in the sidebar. '
            'You can navigate to each school to enter specific details.',
            style: TextStyle(color: Colors.blue[700], fontSize: 14),
          ),
        ],
      ),
    );
  }

  static Widget buildSubmitButton({
    required BuildContext context,
    required bool isSubmitting,
    required bool isUpdate,
    required VoidCallback onSubmit,
  }) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child:
              isSubmitting
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    isUpdate ? 'Update General Data' : 'Save General Data',
                    style: AppTextstyles.enterNameAndPasswordText.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 16,
                    ),
                  ),
        ),
      ),
    );
  }

  static Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: AppTextstyles.enterNameAndPasswordText.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
