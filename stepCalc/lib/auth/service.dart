import 'package:get_it/get_it.dart';
import 'package:stepCalc/app/module.dart';

class AuthService {
  bool get isSignedIn => services.firebaseAuth.currentUser != null;
}

extension AuthServiceGetIt on GetIt {
  AuthService get auth => get<AuthService>();
}
