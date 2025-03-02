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
    //! SIGN UP BLOC
    on<SignUpEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        // Save credentials in secure storage
        await _authService.saveCredentials(event.email, event.password);

        // Create user model
        final user = UserModel(name: event.name, email: event.email);

        // Save user data to Hive
        await _authService.saveUserData(user);

        emit(AuthSuccess(user: user));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    //! LOGIN BLOC
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        // Validate credentials
        final isValid = await _authService.validateCredentials(
          event.email,
          event.password,
        );
        log("EVENT EMAIL: ${event.email}");
        log("EVENT PASSWORD: ${event.password}");

        if (isValid) {
          // Get user data from Hive
          final user = await _authService.getUserData(event.email);

          if (user != null) {
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

    //! CHECK USER LOGGED IN
    on<CheckUserLoggedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final isUserLoggedIn = await _authService.isUserLoggedIn();
        emit(CheckUserLoggedInState(isUserLoggedIn: isUserLoggedIn));
      } catch (e) {
        emit(AuthFailure(error: 'User is not logged In'));
      }
    });
  }
}
