import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/features/auth/presentation/widgets/forgot_password_screen_widgets.dart';
import 'package:tasknexus/features/auth/presentation/widgets/login_screen_widgets.dart';

class ScreenForgotPassword extends StatelessWidget {
   final TextEditingController emailController = TextEditingController();
   ScreenForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      //! B O D Y
      body: Stack(
        children: [
          LoginScreenWidgets.buildBackgroundImage(),
          //! CONTENT AREA
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.03,
              // assuring screen responsiveness
              horizontal:
                  screenWidth > 1050 ? screenWidth * 0.1 : screenWidth * 0.01,
            ),
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //! APP PROMO SECTION (LEFT SECTION)
                  LoginScreenWidgets.buildPromoSection(),

                  //! FORM SECTION (RIGHT SECTION)
                  ForgotPasswordScreenWidgets.buildFormSection(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    context: context,
                    emailController: emailController
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
