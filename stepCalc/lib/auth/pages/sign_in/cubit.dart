import 'package:firebase_auth/firebase_auth.dart';
import 'package:stepCalc/app/module.dart';

part 'cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInState.initial());

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    logger.i('Signing in as $email…');
    emit(SignInState.isSigningIn());

    UserCredential userCredential;
    try {
      userCredential = await services.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          emit(SignInState.error(SignInError.credentialsInvalid));
          return;
        case 'user-disabled':
          emit(SignInState.error(SignInError.userDisabled));
          return;
        case 'unknown':
          if (e.message
              .startsWith('com.google.firebase.FirebaseNetworkException')) {
            emit(SignInState.error(SignInError.offline));
            return;
          }
      }
      rethrow;
    }

    if (!userCredential.user.emailVerified) {
      await services.firebaseAuth.signOut();
      emit(SignInState.error(SignInError.emailNotVerified));
      return;
    }

    logger.i('Signed in with UID ${userCredential.user.uid}.');
    emit(SignInState.success());
  }
}

@freezed
abstract class SignInState with _$SignInState {
  const factory SignInState.initial() = _InitialState;
  const factory SignInState.isSigningIn() = _SigningInState;
  const factory SignInState.error(SignInError error) = _ErrorState;
  const factory SignInState.success() = _SuccessState;
}

enum SignInError { offline, credentialsInvalid, emailNotVerified, userDisabled }
