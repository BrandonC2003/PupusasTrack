import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:pupusas_track/core/data/services/session_service_impl.dart';
import 'package:pupusas_track/core/domain/services/session_service.dart';
import 'package:pupusas_track/features/catalogo_producto/data/repository/catalogo_producto_repository_impl.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/repository/catalogo_producto_repository.dart';
import 'package:pupusas_track/features/pupuseria/data/repositories/pupuseria_repository_impl.dart';
import 'package:pupusas_track/core/data/repositories/user_repository_impl.dart';
import 'package:pupusas_track/features/pupuseria/domain/repositories/pupuseria_repository.dart';
import 'package:pupusas_track/core/domain/repositories/user_repository.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/stream_auth_user_use_case.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'package:pupusas_track/features/pupuseria/domain/use_cases/create_pupuseria_use_case.dart';
import 'package:pupusas_track/features/pupuseria/domain/use_cases/delete_pupuseria_use_case.dart';
import 'package:pupusas_track/features/pupuseria/domain/use_cases/exists_pupuseria_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceFirebase(),
  );

  // Instances
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Services
  sl.registerLazySingleton<SessionService>(() => SessionServiceImpl(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(firestore: sl()),
  );

  sl.registerLazySingleton<PupuseriaRepository>(
    () => PupuseriaRepositoryImpl(),
  );

  sl.registerLazySingleton<CatalogoProductoRepository>(
    () => CatalogoProductoRepositoryImpl(firestore: sl(), sessionService: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignInUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(
    () => SignUpUseCase(authRepository: sl(), userRepository: sl()),
  );
  sl.registerLazySingleton(() => StreamAuthUserUseCase(authRepository: sl()));
  sl.registerLazySingleton(
    () => SignOutUseCase(authRepository: sl(), sessionService: sl()),
  );

  sl.registerLazySingleton(
    () => CreatePupuseriaUseCase(pupuseriaRepository: sl()),
  );
  sl.registerLazySingleton(
    () => DeletePupuseriaUseCase(pupuseriaRepository: sl()),
  );
  sl.registerLazySingleton(
    () => ExistsPupuseriaUseCase(pupuseriaRepository: sl()),
  );

  // Blocs
  sl.registerFactory(() => SignInBloc(signInUseCase: sl()));

  sl.registerFactory(
    () => SignUpBloc(
      signUpUseCase: sl(),
      createPupuseriaUseCase: sl(),
      existsPupuseriaUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(streamAuthUserUseCase: sl(), signOutUseCase: sl()),
  );
}
