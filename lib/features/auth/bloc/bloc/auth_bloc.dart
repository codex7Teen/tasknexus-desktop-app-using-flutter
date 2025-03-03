import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/user_model.dart';
import 'package:tasknexus/data/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    //! LOGIN BLOC
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        log("EVENT EMAIL: ${event.email}");
        log("EVENT PASSWORD: ${event.password}");

        // Validate credentials
        final isValid = await _authService.validateCredentials(
          event.email,
          event.password,
        );

        if (isValid) {
          // Get user data from Hive
          final user = await _authService.getUserData(event.email);

          if (user != null) {
            // Store credentials in secure storage after successful login
            await _authService.saveCredentials(event.email, event.password);

            // Remove the artificial delay - this might be causing the blink
            // await Future.delayed(const Duration(milliseconds: 100));

            emit(AuthSuccess(user: user));
          } else {
            emit(AuthFailure(error: 'User data not found'));
          }
        } else {
          emit(AuthFailure(error: 'Invalid credentials'));
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    //! SIGN UP BLOC
    on<SignUpEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        // Save credentials in secure storage
        await _authService.saveCredentials(event.email, event.password);

        // Create user model
        final user = UserModel(
          name: event.name,
          email: event.email,
          password: event.password,
        );

        // Save user data to Hive
        await _authService.saveUserData(user);

        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    //! LOG OUT BLOC
    on<LogoutEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        // Clear credentials but keep user data in Hive
        await _authService.clearCredentials();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    //! CHECK USER LOGGED IN
    on<CheckUserLoggedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final isUserLoggedIn = await _authService.isUserLoggedIn();

        if (isUserLoggedIn) {
          // If user is logged in, get the email from secure storage
          final credentials = await _authService.getCredentials();
          final email = credentials['email'] ?? '';

          // Get user data from Hive
          final user = await _authService.getUserData(email);

          if (user != null) {
            emit(AuthSuccess(user: user));
            return;
          }
        }

        emit(CheckUserLoggedInState(isUserLoggedIn: isUserLoggedIn));
      } catch (e) {
        emit(
          AuthFailure(error: 'Error checking login status: ${e.toString()}'),
        );
      }
    });

    //! FORGOT PASSWORD LINK BLOC
    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        await Future.delayed(
          Duration(milliseconds: 1500),
          () => emit(ForgotPasswordSuccessState(email: event.email)),
        );
      } catch (e) {
        emit(ForgotPasswordErrorState());
      }
    });
  }
}
