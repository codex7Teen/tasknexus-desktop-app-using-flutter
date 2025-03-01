import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomBlackButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onTap;
  final bool isLoading;
  const CustomBlackButton({
    super.key,
    required this.buttonTitle,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.blackColor,
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                      strokeWidth: 3,
                    ),
                  )
                  : Text(
                    buttonTitle,
                    style: AppTextstyles.authFieldHeadings.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
        ),
      ),
    );
  }
}
