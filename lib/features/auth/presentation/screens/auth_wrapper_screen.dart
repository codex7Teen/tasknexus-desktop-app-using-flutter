import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CheckUserLoggedInState) {
          return state.isUserLoggedIn ? ScreenHome() : ScreenLogin();
        } else {
          return ScreenLogin(); // Default to login if error occurs
        }
      },
    );
  }
}
