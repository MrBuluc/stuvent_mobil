import 'package:stuventmobil/repository/user_repository.dart';
import 'package:stuventmobil/services/bildirim_gonderme_servis.dart';
import 'package:stuventmobil/services/firebase_auth_service.dart';
import 'package:stuventmobil/services/firebase_storage_service.dart';
import 'package:stuventmobil/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}