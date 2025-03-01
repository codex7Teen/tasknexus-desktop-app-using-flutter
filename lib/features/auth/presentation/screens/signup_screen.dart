import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/features/auth/presentation/widgets/login_screen_widgets.dart';
import 'package:tasknexus/features/auth/presentation/widgets/signup_screen_widgets.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool createPasswordObscureText = true;
  bool confirmPasswordObscureText = true;

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    log(screenHeight.round().toString());
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
                  SignupScreenWidgets.buildFormSection(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    context: context,
                    nameController: nameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    confirmPasswordObscureText: confirmPasswordObscureText,
                    createPasswordObscureText: createPasswordObscureText,
                    toggleCreatePasswordVisibility: () => setState(() {
                      createPasswordObscureText = !createPasswordObscureText;
                    }),
                    toggleConfirmPasswordVisibility: () => setState(() {
                      confirmPasswordObscureText = !confirmPasswordObscureText;
                    }),
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
