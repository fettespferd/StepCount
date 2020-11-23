import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:time_machine/time_machine.dart';

final services = GetIt.instance;

Future<void> initServices() async {
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  await firebaseAuth.setLanguageCode('de-DE');

  final cloudFunctions = CloudFunctions(region: 'europe-west3');

  final firebaseStorage = FirebaseStorage.instance;
  await firebaseStorage
      .setMaxUploadRetryTimeMillis(30 * TimeConstants.millisecondsPerSecond);

  services
    ..registerSingleton(firebaseAuth)
    ..registerSingleton(cloudFunctions)
    ..registerSingleton(FirebaseFirestore.instance)
    ..registerSingleton(firebaseStorage)
    ..registerSingletonAsync(PackageInfo.fromPlatform);
}

extension Services on GetIt {
  // Firebase:
  FirebaseAuth get firebaseAuth => get<FirebaseAuth>();
  FirebaseFirestore get firebaseFirestore => get<FirebaseFirestore>();
  CloudFunctions get cloudFunctions => get<CloudFunctions>();
  FirebaseStorage get firebaseStorage => get<FirebaseStorage>();

  // Others:
  PackageInfo get packageInfo => get<PackageInfo>();
}
