
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:id_anywhere/data/ida_firebase.dart';
import 'package:id_anywhere/service/local_authentication_service.dart';

GetIt resolver = GetIt();

Future setupDependencies() async {
  resolver.registerLazySingleton(() => LocalAuthenticationService());
  resolver.registerLazySingleton(() => FirebaseConnection());
  resolver.registerLazySingleton(() => FlutterSecureStorage());
}