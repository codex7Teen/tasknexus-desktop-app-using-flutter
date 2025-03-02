import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/user_model.dart';
import 'package:tasknexus/data/services/auth_services.dart';
import 'package:tasknexus/features/auth/bloc/bloc/auth_bloc.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';
import 'package:tasknexus/features/home/presentation/screens/home_screen.dart';

class AuthWrapperScreen extends StatelessWidget {
  const AuthWrapperScreen({super.key});

  // In auth_wrapper_screen.dart
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CheckUserLoggedInState) {
          if (state.isUserLoggedIn) {
            // Retrieve user info from secure storage
            return FutureBuilder<Map<String, String>>(
              future: AuthService().getCredentials(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final email = snapshot.data!['email'] ?? '';

                  // Use email to get user model from Hive
                  return FutureBuilder<UserModel?>(
                    future: AuthService().getUserData(email),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (userSnapshot.hasData && userSnapshot.data != null) {
                        return ScreenHome(
                          userName: userSnapshot.data!.name,
                          userEmail: userSnapshot.data!.email,
                        );
                      }

                      // Fallback if user data is not found
                      return ScreenLogin();
                    },
                  );
                }

                return ScreenLogin();
              },
            );
          } else {
            return ScreenLogin();
          }
        } else {
          return ScreenLogin(); // Default to login if error occurs
        }
      },
    );
  }
}
