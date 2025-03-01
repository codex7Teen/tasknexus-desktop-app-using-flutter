import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/core/utils/app_constants.dart';
import 'package:tasknexus/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tasknexus/features/auth/presentation/screens/signup_screen.dart';
import 'package:tasknexus/shared/custom_auth_textfields.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/custom_google_signin_button.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class LoginScreenWidgets {

  static buildBackgroundImage() {
    return Column(
      children: [
        // BACKGROUND IMAGE
        Expanded(
          child: Image.asset(
            'assets/images/login_background_image.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  static buildPromoSection() {
    return Expanded(
      child: Stack(
        children: [
          // BACKGROUND IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              'assets/images/login_background_image_2.jpg',
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blackColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // PROMOTION TEXTS
                Text(
                  'ALIGN. ACCOMPLISH. ASCEND.',
                  style: AppTextstyles.loginMiniQuoteText,
                ),
                Spacer(),
                Text(
                  'Focus\nProductivity\nAchieve More',
                  style: AppTextstyles.loginSuperHeading.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "You can achieve great things by planning ahead and staying focused.\nStay organized, work smart, and keep moving forward.",
                  style: AppTextstyles.loginQuoteText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildFormSection({
    required double screenWidth,
    required double screenHeight,
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool obscureText,
    required Function()? toggleVisibility,
    required GlobalKey<FormState> formKey,
  }) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APP NAME
                Center(
                  child: Text('TASKNEXUS', style: AppTextstyles.apptitileText),
                ),
                SizedBox(
                  height:
                      screenHeight > 670
                          ? screenHeight * 0.09
                          : screenHeight * 0.01,
                ),
                // WELCOME TEXT
                Center(
                  child: Text(
                    'Welcome Back',
                    style: AppTextstyles.loginSuperHeading,
                  ),
                ),
                SizedBox(height: 8),
                // ENTER EMAIL AND PASS TEXT
                Center(
                  child: Text(
                    "Enter your email and password to access your account",
                    style: AppTextstyles.enterNameAndPasswordText,
                  ),
                ),
                SizedBox(height: screenHeight * 0.038),
                //! EMAIL SECTION
                Text("Email", style: AppTextstyles.authFieldHeadings),
                SizedBox(height: 5),
                // EMAIL INPUT FIELD
                CustomAuthTextfield(
                  hintText: 'Enter your email',
                  controller: emailController,
                ),

                SizedBox(height: 10),
                //! PASSWORD SECTION
                Text("Password", style: AppTextstyles.authFieldHeadings),
                SizedBox(height: 5),
                // PASSWORD INPUT FIELD
                CustomAuthTextfield(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: obscureText,
                  toggleVisibility: toggleVisibility,
                  isPasswordVisible: !obscureText,
                ),
                SizedBox(height: 5),

                //! FORGOT PASSWORD BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    GestureDetector(
                      onTap:
                          () => NavigationHelper.navigateToWithReplacement(
                            context,
                            ScreenForgotPassword(),
                          ),
                      child: Text(
                        "Forgot password ?",
                        style: AppTextstyles.authFieldHeadings,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.045),
                //! SIGN IN BUTTON
                CustomBlackButton(
                  buttonTitle: 'Sign In',
                  onTap: () {
                    //! TEXT FELD VALIDATIONS
                    if (passwordController.text.trim().isEmpty &&
                        emailController.text.trim().isEmpty) {
                      return ElegantSnackbar.show(
                        context,
                        message: 'Please enter your email & password.',
                        type: SnackBarType.warning,
                      );
                    } else if (passwordController.text.trim().isEmpty) {
                      return ElegantSnackbar.show(
                        context,
                        message: 'Please enter your password.',
                        type: SnackBarType.warning,
                      );
                    } else if (passwordController.text.trim().isNotEmpty &&
                        passwordController.text.trim().length < 8) {
                      return ElegantSnackbar.show(
                        context,
                        message: 'Password should be atleast 8 characters.',
                        type: SnackBarType.warning,
                      );
                    } else if (emailController.text.trim().isEmpty) {
                      return ElegantSnackbar.show(
                        context,
                        message: 'Please enter your email.',
                        type: SnackBarType.warning,
                      );
                    } else if (emailController.text.trim().isNotEmpty &&
                        !AppConstants().emailRegex.hasMatch(
                          emailController.text,
                        )) {
                      return ElegantSnackbar.show(
                        context,
                        message: 'Please enter a valid email.',
                        type: SnackBarType.warning,
                      );
                    }
                  },
                ),
                SizedBox(height: 10),

                //! GOOGLE SIGN IN BUTTON
                CustomGoogleSigninButton(
                  onTap:
                      () => ElegantSnackbar.show(
                        context,
                        message: 'This feature will be available soon.',
                        type: SnackBarType.info,
                        actionLabel: 'COMING SOON!!!',
                        duration: Duration(seconds: 2),
                      ),
                ),

                SizedBox(
                  height:
                      screenHeight > 670
                          ? screenHeight * 0.09
                          : screenHeight * 0.01,
                ),

                //! SIGN UP BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTextstyles.dontHaveAccountText,
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap:
                          () => NavigationHelper.navigateToWithReplacement(
                            context,
                            ScreenSignUp(),
                          ),
                      child: Text(
                        'Sign Up',
                        style: AppTextstyles.authFieldHeadings,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
