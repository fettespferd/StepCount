import 'package:pizzaCalc/app/module.dart';

String get appVersion {
  final packageInfo = services.packageInfo;
  return '${packageInfo.version}+${packageInfo.buildNumber}';
}
