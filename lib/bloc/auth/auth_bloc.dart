import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthStateLogout()) {
    on<AuthEventLogin>(_authEventLogin);

    on<AuthEventLogout>(_authEventLogout);
  }

  void _authEventLogin(AuthEventLogin event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStateLoading());

      await auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(AuthStateLogin());
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        message = 'Kata sandi salah';
      } else {
        message = 'Sign In Failed';
      }

      emit(AuthStateError(message));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  void _authEventLogout(AuthEventLogout event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStateLoading());

      await auth.signOut();

      emit(AuthStateLogout());
    } on FirebaseAuthException catch (e) {
      emit(AuthStateError(e.message.toString()));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }
}
