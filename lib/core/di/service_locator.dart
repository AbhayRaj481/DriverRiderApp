import 'package:driving_mobile_app/repositories/repo_lib.dart';
import 'package:get_it/get_it.dart';
import 'package:driving_mobile_app/blocs/bloc_lib.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repos
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // BLoC factories
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl<AuthRepository>()),
  );
}
