import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomBlackButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onTap;
  const CustomBlackButton({super.key, required this.buttonTitle, this.onTap});

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
          child: Text(
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
