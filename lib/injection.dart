import 'package:get_it/get_it.dart';
import 'package:pupusas_track/core/data/repositories/pupuseria_repository_impl.dart';
import 'package:pupusas_track/core/data/repositories/user_repository_impl.dart';
import 'package:pupusas_track/core/domain/repositories/pupuseria_repository.dart';
import 'package:pupusas_track/core/domain/repositories/user_repository.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/stream_auth_user_use_case.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceFirebase());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl()
  );

  sl.registerLazySingleton<PupuseriaRepository>(
    () => PupuseriaRepositoryImpl()
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  
  sl.registerLazySingleton(
    () => SignUpUseCase(
      authRepository: sl(),
      userRepository: sl(),
      pupuseriaRepository: sl()
      )
  );

  sl.registerLazySingleton(() => StreamAuthUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(authRepository: sl()));

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

  sl.registerFactory(
    () => AuthBloc(
      streamAuthUserUseCase: sl(),
      signOutUseCase: sl()
      )
  );
}
