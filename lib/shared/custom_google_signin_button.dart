import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomGoogleSigninButton extends StatelessWidget {
  const CustomGoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'assets/images/google_logo_nobg.png',
              fit: BoxFit.contain,
              width: 22,
            ),
            SizedBox(width: 8),
            Text('Sign In With Google', style: AppTextstyles.authFieldHeadings),
          ],
        ),
      ),
    );
  }
}
