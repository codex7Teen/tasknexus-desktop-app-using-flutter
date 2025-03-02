import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/widgets/login_screen_widgets.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      //! B O D Y
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Show success snackbar
            ElegantSnackbar.show(
              context,
              message: 'Logged-In as ${state.user.name.toString()}. 🎉🎉🎉 ',
              type: SnackBarType.success,
            );
            // Navigate to home
            Future.delayed(const Duration(milliseconds: 500), () {
              NavigationHelper.navigateToWithReplacement(context, ScreenHome());
            });
          } else if (state is AuthFailure) {
            // Show error snackbar
            ElegantSnackbar.show(
              context,
              message: 'Log-In Failed: ${state.error}.',
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
                    LoginScreenWidgets.buildFormSection(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      context: context,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscureText: obscureText,
                      toggleVisibility:
                          () => setState(() {
                            obscureText = !obscureText;
                          }),
                      formKey: _formKey,
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
