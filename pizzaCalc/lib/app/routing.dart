import 'package:flutter/material.dart' hide Route, Router;
import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:pizzaCalc/auth/module.dart';
import 'package:pizzaCalc/creation/module.dart';
import 'package:pizzaCalc/feed/module.dart';
import 'package:pizzaCalc/settings/module.dart';

import 'pages/main.dart';
import 'services.dart';
import 'utils.dart';

String appSchemeUrl(String path) =>
    'app://${services.packageInfo.packageName}/$path';

final _hostRegExp = RegExp('(?:www\.)?pizzaCalc\.app');

final router = Router(
  routes: [
    Route(
      matcher: Matcher.scheme('app'),
      routes: [
        Route(
          matcher: Matcher.path('main'),
          materialBuilder: (_, result) => LogConsoleOnShake(child: MainPage()),
        ),
      ],
    ),
    Route(
      matcher: Matcher.webHost(_hostRegExp, isOptional: true),
      routes: [authRoutes, creationRoutes, feedRoutes, settingsRoutes],
    ),
    Route(materialBuilder: (_, result) => NotFoundPage(result.uri)),
  ],
);

class NotFoundPage extends StatelessWidget {
  const NotFoundPage(this.uri) : assert(uri != null);

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.s.app_error_pageNotFound)),
    );
  }
}
