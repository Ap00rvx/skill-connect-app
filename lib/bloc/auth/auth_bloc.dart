import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shatter_vcs/config/app_exception.dart';
import 'package:shatter_vcs/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final email = event.email;
      final password = event.password;
      final name = event.name;
      print(name);
      final response = await AuthService().signUp(email, password, name);

      response.fold((user) => emit(AuthSignUpSuccess(user)),
          (exception) => emit(AuthFailure(exception)));
    });
    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      final email = event.email;
      final password = event.password;
      final response = await AuthService().login(email, password);
      response.fold((user) => emit(AuthSuccess(user)),
          (exception) => emit(AuthFailure(exception)));
    });
    on<AuthGoogleSignIn>((event, emit) async {
      emit(AuthLoading());
      final response = await AuthService().signInWithGoogle();
      response.fold((user) => emit(AuthSuccess(user)),
          (exception) => emit(AuthFailure(exception)));
    });
  }
}
