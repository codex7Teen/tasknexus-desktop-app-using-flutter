import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';
import 'package:tasknexus/shared/custom_elegant_snackbar.dart';
import 'package:tasknexus/shared/navigation_helper_widget.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Show success snackbar
          ElegantSnackbar.show(
            context,
            message: 'Logged-In as ${state.user.name}. 🎉🎉🎉 ',
            type: SnackBarType.success,
          );

          // Add a slight delay to ensure the snackbar is visible before navigation
          Future.delayed(const Duration(milliseconds: 500), () {
            NavigationHelper.navigateToWithReplacement(
              context,
              ScreenHome(
                userEmail: state.user.email,
                userName: state.user.name,
              ),
              milliseconds: 400,
            );
          });
        }
      },
      builder: (context, state) {
        // Show loading indicator while checking auth state
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If already authenticated but waiting for navigation delay
        if (state is AuthSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Default to login screen for all other states
        return const ScreenLogin();
      },
    );
  }
}
