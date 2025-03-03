import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/widgets/login_screen_widgets.dart';
import 'package:tasknexus/features/auth/presentation/widgets/signup_screen_widgets.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool createPasswordObscureText = true;
  bool confirmPasswordObscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    log(screenHeight.round().toString());
    return Scaffold(
      //! B O D Y
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Show success snackbar
            ElegantSnackbar.show(
              context,
              message: 'Signed up as ${state.user.name.toString()}. 🎉🎉🎉 ',
              type: SnackBarType.success,
            );
            // Navigate to home
            Future.delayed(const Duration(milliseconds: 500), () {
              NavigationHelper.navigateToWithReplacement(
                context,
                ScreenHome(
                  userEmail: state.user.email,
                  userName: state.user.name,
                ),
              );
            });
          } else if (state is AuthFailure) {
            // Show error snackbar
            ElegantSnackbar.show(
              context,
              message: 'Signup failed: ${state.error}.',
              type: SnackBarType.error,
            );
          }
        },
        child: Stack(
          children: [
            LoginScreenWidgets.buildBackgroundImage(),
            //! CONTENT AREA
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                // Assuring screen responsiveness
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
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      confirmPasswordObscureText: confirmPasswordObscureText,
                      createPasswordObscureText: createPasswordObscureText,
                      toggleCreatePasswordVisibility:
                          () => setState(() {
                            createPasswordObscureText =
                                !createPasswordObscureText;
                          }),
                      toggleConfirmPasswordVisibility:
                          () => setState(() {
                            confirmPasswordObscureText =
                                !confirmPasswordObscureText;
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
