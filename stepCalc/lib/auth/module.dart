import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:stepCalc/app/module.dart';
import '../profile/pages/profil.dart';
import 'pages/password_reset/page.dart';
import 'pages/sign_in/page.dart';
import 'pages/sign_up/page.dart';
import 'service.dart';

export 'service.dart';

void initAuth() {
  services.registerSingleton(AuthService());
}

final authRoutes = Route(
  routes: [
    Route(
      matcher: Matcher.path('login'),
      materialBuilder: (_, result) => SignInPage(),
    ),
    Route(
      matcher: Matcher.path('passwordReset'),
      materialBuilder: (_, result) => PasswordResetPage(),
    ),
    Route(
      matcher: Matcher.path('signUp'),
      materialBuilder: (_, result) => SignUpPage(),
    ),
    Route(
      matcher: Matcher.path('profil'),
      materialBuilder: (_, result) => ProfilPage(),
    )
  ],
);
