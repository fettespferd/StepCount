import 'package:flutter/material.dart' hide Route, Router;
import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:stepCalc/auth/module.dart';
import 'package:stepCalc/calc/module.dart';
import 'package:stepCalc/settings/module.dart';

import 'pages/main.dart';
import 'services.dart';
import 'utils.dart';

String appSchemeUrl(String path) =>
    'app://${services.packageInfo.packageName}/$path';

final _hostRegExp = RegExp('(?:www\.)?stepCalc\.app');

final router = Router(
  routes: [
    Route(
      matcher: Matcher.scheme('app'),
      routes: [
        Route(
          matcher: Matcher.path('main'),
          materialBuilder: (_, result) => MainPage(),
        ),
      ],
    ),
    Route(
      matcher: Matcher.webHost(_hostRegExp, isOptional: true),
      routes: [authRoutes, calcRoutes, settingsRoutes],
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
