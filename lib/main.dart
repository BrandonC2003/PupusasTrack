import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'app_router.dart';
import 'app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInBloc>(create: (_) => sl<SignInBloc>()),
        BlocProvider<SignUpBloc>(create: (_) => sl<SignUpBloc>()),
      ],
      child: MaterialApp.router(
        title: 'PupusasTrack',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
