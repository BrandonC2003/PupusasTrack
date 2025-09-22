import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies();

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});
  final authBloc = sl<AuthBloc>();
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(authBloc);
    return BlocProvider(
      create: (_) => authBloc,
      child: MaterialApp.router(
        title: 'PupusasTrack',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.router,
      ),
    );
  }
}
