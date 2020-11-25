import 'package:flutter/material.dart';
import 'package:stepCalc/app/module.dart';

import '../utils.dart';

class LegalBar extends StatelessWidget {
  const LegalBar();

  @override
  Widget build(BuildContext context) {
    return SeparatedButtons(
      children: <Widget>[
        TextButton(
          onPressed: () {},
          child: Text(context.s.settings_legal_disclosure),
        ),
        TextButton(
          onPressed: () {},
          child: Text(context.s.settings_legal_privacyPolicy),
        ),
        TextButton(
          onPressed: () {
            showLicensePage(
              context: context,
              applicationName: services.packageInfo.appName,
              applicationVersion: 'v$appVersion',
              applicationIcon: Image.asset('assets/logo/logo-white.png'),
            );
          },
          child: Text(context.s.settings_legal_licenses),
        ),
      ],
    );
  }
}
