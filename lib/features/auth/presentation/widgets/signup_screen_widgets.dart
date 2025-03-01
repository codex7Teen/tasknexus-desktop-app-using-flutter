import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/core/utils/app_constants.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/shared/custom_auth_textfields.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class SignupScreenWidgets {
  static buildFormSection({
    required double screenWidth,
    required double screenHeight,
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required bool createPasswordObscureText,
    required bool confirmPasswordObscureText,
    required void Function()? toggleCreatePasswordVisibility,
    required void Function()? toggleConfirmPasswordVisibility,
  }) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
                    screenHeight > 782
                        ? screenHeight * 0.07
                        : screenHeight * 0.01,
              ),
              // WELCOME TEXT
              Center(
                child: Text(
                  "Let's Get Started",
                  style: AppTextstyles.loginSuperHeading,
                ),
              ),
              SizedBox(height: 8),
              // ENTER EMAIL AND PASS TEXT
              Center(
                child: Text(
                  "Sign up with your name, email and password to get started",
                  style: AppTextstyles.enterNameAndPasswordText,
                ),
              ),
              SizedBox(
                height:
                    screenHeight > 782
                        ? screenHeight * 0.038
                        : screenHeight * 0.018,
              ),

              //! NAME SECTION
              Text("Full Name", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // NAME INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Enter your full name',
                controller: nameController,
              ),
              SizedBox(height: 10),

              //! EMAIL SECTION
              Text("Email", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // EMAIL INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              SizedBox(height: 10),

              //! CREATE PASSWORD SECTION
              Text("Create Password", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // PASSWORD INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Enter your password',
                controller: passwordController,
                isPasswordVisible: !createPasswordObscureText,
                obscureText: createPasswordObscureText,
                toggleVisibility: toggleCreatePasswordVisibility,
              ),
              SizedBox(height: 10),

              //! CONFIRM PASSWORD SECTION
              Text("Confirm Password", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // PASSWORD INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Confirm your password',
                controller: confirmPasswordController,
                isPasswordVisible: !confirmPasswordObscureText,
                obscureText: confirmPasswordObscureText,
                toggleVisibility: toggleConfirmPasswordVisibility,
              ),

              SizedBox(
                height:
                    screenHeight > 782
                        ? screenHeight * 0.040
                        : screenHeight * 0.010,
              ),
              //! SIGN UP BUTTON
              CustomBlackButton(
                buttonTitle: 'Sign Up',
                onTap: () {
                  //! TEXT FELD VALIDATIONS
                  if (passwordController.text.trim().isEmpty &&
                      emailController.text.trim().isEmpty &&
                      confirmPasswordController.text.trim().isEmpty &&
                      nameController.text.trim().isEmpty) {
                    return ElegantSnackbar.show(
                      context,
                      message: 'Please fill the fields above to sign-up.',
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
                  } else if (nameController.text.trim().isEmpty) {
                    return ElegantSnackbar.show(
                      context,
                      message: 'Please enter a your name.',
                      type: SnackBarType.warning,
                    );
                  } else if (confirmPasswordController.text.trim().isEmpty) {
                    return ElegantSnackbar.show(
                      context,
                      message: 'Please confirm your password.',
                      type: SnackBarType.warning,
                    );
                  } else if (confirmPasswordController.text.trim().isNotEmpty &&
                      confirmPasswordController.text.trim().length < 8) {
                    return ElegantSnackbar.show(
                      context,
                      message: 'Password should be atleast 8 characters.',
                      type: SnackBarType.warning,
                    );
                  } else if (passwordController.text.trim().isNotEmpty &&
                      confirmPasswordController.text.trim().isNotEmpty &&
                      passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                    return ElegantSnackbar.show(
                      context,
                      message: "Entered passwords doesn't match",
                      type: SnackBarType.warning,
                    );
                  }
                },
              ),

              SizedBox(
                height:
                    screenHeight > 782
                        ? screenHeight * 0.07
                        : screenHeight * 0.01,
              ),

              //! SIGN IN BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already Signed Up?",
                    style: AppTextstyles.dontHaveAccountText,
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap:
                        () => NavigationHelper.navigateToWithReplacement(
                          context,
                          ScreenLogin(),
                        ),
                    child: Text(
                      'Sign In',
                      style: AppTextstyles.authFieldHeadings,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
