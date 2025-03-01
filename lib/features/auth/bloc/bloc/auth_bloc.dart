import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    //! SEND PASSWORD LINK BLOC
    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      await Future.delayed(
        Duration(milliseconds: 1500),
        () => emit(ForgotPasswordSuccessState(email: event.email)),
      );
    });
  }
}
