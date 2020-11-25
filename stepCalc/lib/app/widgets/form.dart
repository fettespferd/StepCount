import 'package:flutter/material.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

extension FormDialogs on BuildContext {
  Future<bool> showDiscardChangesDialog() async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text('Änderungen verwerfen?'),
          content: Text('Deine Änderungen wurden noch nicht gespeichert.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => context.navigator.pop(false),
              child: Text('Weiter bearbeiten'),
            ),
            FlatButton(
              onPressed: () => context.navigator.pop(true),
              child: Text('Verwerfen'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
