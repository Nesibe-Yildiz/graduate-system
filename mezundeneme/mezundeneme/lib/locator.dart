import 'package:get_it/get_it.dart';

import 'mesaj/repository/user_repository.dart';
import 'mesaj/services/firebase_auth_service.dart';
import 'mesaj/services/firebase_storage_service.dart';
import 'mesaj/services/firestore_db_service.dart';

GetIt locator = GetIt.I; // GetIt.I -  GetIt.instance - nin kisaltmasidir

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  // locator.registerLazySingleton(() => BildirimGondermeServis());
}
