part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class ForgotPasswordLoadingState extends AuthState {}

final class ForgotPasswordSuccessState extends AuthState {
  final String email;
  const ForgotPasswordSuccessState({required this.email});

  @override
  List<Object> get props => [email];
}

final class ForgotPasswordErrorState extends AuthState {}
