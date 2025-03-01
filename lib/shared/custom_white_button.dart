import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomWhiteButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onTap;
  const CustomWhiteButton({super.key, this.onTap, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightGreyColor4),
          color: AppColors.whiteColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/back_icon_black.png',
                fit: BoxFit.contain,
                width: 22,
              ),
              SizedBox(width: 8),
              Text(buttonTitle, style: AppTextstyles.authFieldHeadings),
            ],
          ),
        ),
      ),
    );
  }
}
