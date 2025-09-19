import 'package:get_it/get_it.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceFirebase());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => SignInBloc(
      signInUseCase: sl(),
    )
  );

  sl.registerFactory(
    () => SignUpBloc(
      signUpUseCase: sl(),
    )
  );
}
