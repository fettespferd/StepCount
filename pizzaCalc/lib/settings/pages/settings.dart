import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.s.settings,
        ),
        backgroundColor: Colors.black12,
      ),
      body: ListView(
        children: [
          SingleSelectPreferenceTile<ThemeMode>(
            preference: services.preferences.themeMode,
            values: ThemeMode.values,
            title: 'Design',
            stringifier: (themeMode) => {
              ThemeMode.system: 'Systemeinstellung',
              ThemeMode.light: 'Hell',
              ThemeMode.dark: 'Dunkel',
            }[themeMode],
            dialogTitle: 'Design auswählen',
          ),
        ],
      ),
    );
  }
}

typedef Stringifier<T> = String Function(T value);

class SingleSelectPreferenceTile<T> extends StatelessWidget {
  const SingleSelectPreferenceTile({
    Key key,
    @required this.preference,
    @required this.values,
    @required this.title,
    @required this.stringifier,
    @required this.dialogTitle,
  })  : assert(preference != null),
        assert(values != null),
        assert(title != null),
        assert(stringifier != null),
        assert(dialogTitle != null),
        super(key: key);

  final Preference<T> preference;
  final List<T> values;
  final String title;
  final Stringifier<T> stringifier;
  final String dialogTitle;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<T>(
      preference: preference,
      builder: (context, value) {
        return ListTile(
          onTap: () => _showDialog(context),
          leading: Icon(OMIcons.settingsBrightness),
          title: Text(title),
          subtitle: Text(stringifier(value)),
        );
      },
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    final value = await showDialog<T>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(dialogTitle),
          children: [
            for (final value in values)
              SimpleDialogOption(
                onPressed: () => context.navigator.pop(value),
                child: Text(stringifier(value)),
              ),
          ],
        );
      },
    );
    await preference.setValue(value);
  }
}
