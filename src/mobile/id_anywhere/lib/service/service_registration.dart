
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/service/code_service.dart';
import 'package:id_anywhere/service/local_authentication_service.dart';
import 'package:id_anywhere/service/verify_license.dart';
import 'package:id_anywhere/service/verify_passport.dart';
import 'package:id_anywhere/state/session.dart';

GetIt resolver = GetIt();

Future setupDependencies() async {
  resolver.registerLazySingleton(() => LocalAuthenticationService());
  resolver.registerLazySingleton(() => FirebaseConnection());
  resolver.registerLazySingleton(() => FlutterSecureStorage());
  resolver.registerLazySingleton(() => Session());
  resolver.registerLazySingleton(() => VerifyLicenseService());
  resolver.registerLazySingleton(() => VerifyPassportService());
  resolver.registerLazySingleton(() => CodeService());
}