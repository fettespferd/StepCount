import 'package:firebase_auth/firebase_auth.dart';
import 'package:stepCalc/app/module.dart';

part 'cubit.freezed.dart';

class EmailSignUpCubit extends Cubit<EmailSignUpState> {
  EmailSignUpCubit() : super(EmailSignUpState.initial());

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    logger.i('Signing Up with $email...');
    emit(EmailSignUpState.isSigningUp());

    UserCredential userCredential;
    try {
      userCredential = await services.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emit(EmailSignUpState.error(SignUpError.emailInUse));
          return;
        case 'invalid-email':
          emit(EmailSignUpState.error(SignUpError.invalidEmail));
          return;
        case 'operation-not-allowed':
          emit(EmailSignUpState.error(SignUpError.operationNotAllowed));
          return;
        case 'weak-password':
          emit(EmailSignUpState.error(SignUpError.weakPassword));
          return;
      }
      rethrow;
    }
    await userCredential.user.sendEmailVerification();
    logger.i('Signed up with UID ${userCredential.user.uid}.');
    emit(EmailSignUpState.success());
  }
}

@freezed
abstract class EmailSignUpState with _$EmailSignUpState {
  const factory EmailSignUpState.initial() = _InitialState;
  const factory EmailSignUpState.isSigningUp() = _SigningUpState;
  const factory EmailSignUpState.error(SignUpError error) = _ErrorState;
  const factory EmailSignUpState.success() = _SuccessState;
}

enum SignUpError {
  emailInUse,
  invalidEmail,
  operationNotAllowed,
  weakPassword,
}
