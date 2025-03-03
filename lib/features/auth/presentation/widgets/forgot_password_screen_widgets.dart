import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';
import 'package:tasknexus/core/utils/app_constants.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/shared/custom_auth_textfields.dart';
import 'package:tasknexus/shared/custom_black_button.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/custom_white_button.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class ForgotPasswordScreenWidgets {
  static buildFormSection({
    required double screenWidth,
    required double screenHeight,
    required BuildContext context,
    required TextEditingController emailController,
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
              FadeInDown(
                child: Center(
                  child: Text('TASKNEXUS', style: AppTextstyles.apptitileText),
                ),
              ),
              SizedBox(
                height:
                    screenHeight > 670
                        ? screenHeight * 0.09
                        : screenHeight * 0.01,
              ),
              // RECOVER ACCOUNT TEXT
              FadeInRight(
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Recover Your Account',
                    style: AppTextstyles.loginSuperHeading,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // ENTER EMAIL TO SEND RESET LINK TEXT
              Center(
                child: Text(
                  "Enter your email, and we'll send you a password reset link.",
                  style: AppTextstyles.enterNameAndPasswordText,
                ),
              ),
              SizedBox(height: screenHeight * 0.038),
              //! EMAIL SECTION
              Text("Registered Email", style: AppTextstyles.authFieldHeadings),
              SizedBox(height: 5),
              // EMAIL INPUT FIELD
              CustomAuthTextfield(
                hintText: 'Enter your email',
                controller: emailController,
              ),

              SizedBox(height: screenHeight * 0.045),
              //! RESET BUTTON
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccessState) {
                    return ElegantSnackbar.show(
                      context,
                      message:
                          'Password reset link has been sent to ${state.email}. Please check your inbox.',
                      type: SnackBarType.success,
                    );
                  }
                },
                builder: (context, state) {
                  return CustomBlackButton(
                    isLoading: state is ForgotPasswordLoadingState,
                    buttonTitle: 'Send Reset Link',
                    onTap: () {
                      if (emailController.text.trim().isEmpty) {
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
                      } else {
                        context.read<AuthBloc>().add(
                          ForgotPasswordEvent(
                            email: emailController.text.trim(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              //! GO BACK BUTTON
              CustomWhiteButton(
                buttonTitle: 'Go back to Login',
                onTap:
                    () => NavigationHelper.navigateToWithReplacement(
                      context,
                      ScreenLogin(),
                    ),
              ),

              SizedBox(
                height:
                    screenHeight > 670
                        ? screenHeight * 0.09
                        : screenHeight * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
