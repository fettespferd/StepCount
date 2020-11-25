import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stepCalc/generated/l10n.dart';

import 'logger.dart';

extension ContextWithLocalization on BuildContext {
  S get s => S.of(this);
}

typedef L10nStringGetter = String Function(S);

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Tries launching a url.
Future<bool> tryLaunchingUrl(String url) async {
  logger.i("Trying to launch url '$url'…");

  if (await canLaunch(url)) {
    await launch(url);
    return true;
  }
  return false;
}

extension ScaffoldKeyShowSnackBar on GlobalKey<ScaffoldState> {
  void showSimpleSnackBar(String message) =>
      currentState.showSnackBar(SnackBar(content: Text(message)));
}

extension TimestampToInstant on Timestamp {
  Instant get asInstant =>
      Instant.epochTime(Time(seconds: seconds, nanoseconds: nanoseconds));
}

extension InstantToTimestamp on Instant {
  Timestamp get asTimestamp =>
      Timestamp(epochSeconds, timeSinceEpoch.nanosecondOfSecond);
}
