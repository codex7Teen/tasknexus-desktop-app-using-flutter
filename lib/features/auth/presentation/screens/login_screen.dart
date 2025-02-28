import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/shared/custom_auth_textfields.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/custom_google_signin_button.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      //! B O D Y
      body: Stack(
        children: [
          Column(
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
          ),
          //! CONTENT AREA
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 35,
              horizontal: screenWidth * 0.1,
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
                  //! APP PROMO SECTION
                  Expanded(
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
                              color: AppColors.blackColor.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 35,
                            horizontal: 30,
                          ),
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
                                style: AppTextstyles.loginSuperHeading,
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
                  ),

                  //! FORM SECTION
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // APP NAME
                            Center(
                              child: Text(
                                'TASKNEXUS',
                                style: AppTextstyles.apptitileText,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.09),
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
                            Text(
                              "Email",
                              style: AppTextstyles.authFieldHeadings,
                            ),
                            SizedBox(height: 8),
                            // EMAIL INPUT FIELD
                            CustomAuthTextfield(hintText: 'Enter your email'),

                            SizedBox(height: 20),
                            //! PASSWORD SECTION
                            Text(
                              "Password",
                              style: AppTextstyles.authFieldHeadings,
                            ),
                            SizedBox(height: 8),
                            // PASSWORD INPUT FIELD
                            CustomAuthTextfield(
                              hintText: 'Enter your password',
                              passwordField: true,
                            ),
                            SizedBox(height: 8),

                            //! FORGOT PASSWORD BUTTON
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text(
                                  "Forgot password ?",
                                  style: AppTextstyles.authFieldHeadings,
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.045),
                            //! SIGN IN BUTTON
                            CustomBlackButton(buttonTitle: 'Sign In'),
                            SizedBox(height: 10),

                            //! GOOGLE SIGN IN BUTTON
                            CustomGoogleSigninButton(),

                            SizedBox(height: screenHeight * 0.09),

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
                                Text(
                                  'Sign Up',
                                  style: AppTextstyles.authFieldHeadings,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
