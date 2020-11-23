import 'package:get_it/get_it.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/content/module.dart';

class AuthService {
  bool get isSignedIn => services.firebaseAuth.currentUser != null;
  Id<User> get userId {
    assert(isSignedIn);
    return Id<User>(services.firebaseAuth.currentUser.uid);
  }
}

extension AuthServiceGetIt on GetIt {
  AuthService get auth => get<AuthService>();
}
