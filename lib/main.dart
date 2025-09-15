import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/entities/auth_user.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();

  final authRepository = sl<AuthRepository>();
  final authUser = await authRepository.authUser.first;

  runApp(App(authRepository: authRepository, authUser: authUser));
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
    this.authUser,
  });

  final AuthRepository authRepository;
  final AuthUser? authUser;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
      ],
      child: MaterialApp(
        title: 'PupusasTrack',
        theme: ThemeData.light(useMaterial3: true),
        home: const SignInScreen(),
      ),
    );
  }
}
