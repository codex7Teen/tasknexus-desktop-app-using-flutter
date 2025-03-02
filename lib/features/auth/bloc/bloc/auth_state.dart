part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//! AUTH INITIAL STATE
class AuthInitial extends AuthState {}

//! AUTH LOADING STATE
class AuthLoading extends AuthState {}

// //! AUTH SUCCESS STATE
class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

//! AUTH FAILTURE STATE
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

//! FORGOT PASSWORD STATE
final class ForgotPasswordLoadingState extends AuthState {}

final class ForgotPasswordSuccessState extends AuthState {
  final String email;
  const ForgotPasswordSuccessState({required this.email});

  @override
  List<Object> get props => [email];
}

final class ForgotPasswordErrorState extends AuthState {}

//! CHECK USER LOGGED IN STATE
final class CheckUserLoggedInState extends AuthState {
  final bool isUserLoggedIn;

  const CheckUserLoggedInState({required this.isUserLoggedIn});

  @override
  List<Object> get props => [isUserLoggedIn];
}
