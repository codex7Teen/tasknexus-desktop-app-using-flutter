import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/shared/custom_auth_textfields.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class SignupScreenWidgets {
  static buildFormSection({
    required double screenWidth,
    required double screenHeight,
    required BuildContext context,
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
              CustomAuthTextfield(hintText: 'Enter your full name'),
              SizedBox(height: 10),

              //! EMAIL SECTION
              Text("Email", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // EMAIL INPUT FIELD
              CustomAuthTextfield(hintText: 'Enter your email'),
              SizedBox(height: 10),

              //! CREATE PASSWORD SECTION
              Text("Create Password", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // PASSWORD INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Enter your password',
                passwordField: true,
              ),
              SizedBox(height: 10),

              //! CONFIRM PASSWORD SECTION
              Text("Confirm Password", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // PASSWORD INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Confirm your password',
                passwordField: true,
              ),

              SizedBox(
                height:
                    screenHeight > 782
                        ? screenHeight * 0.040
                        : screenHeight * 0.010,
              ),
              //! SIGN UP BUTTON
              CustomBlackButton(buttonTitle: 'Sign Up'),

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
