import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc_notifier.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:pupusas_track/features/auth/presentation/screens/sign_out_screen.dart';
import 'package:pupusas_track/features/main_layout/presentation/screens/home_screen.dart';
import 'package:pupusas_track/features/main_layout/presentation/screens/main_layout_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';

class AppRouter {
  final AuthBloc authBloc;
  late final GoRouter router;

  AppRouter(this.authBloc) {
    final refreshNotifier = AuthBlocNotifier(authBloc);

    router = GoRouter(
      initialLocation: AppRoutes.signIn,
      refreshListenable: refreshNotifier, // escucha cambios del Bloc
      redirect: (context, state) {
        final authState = authBloc.state;
        final loggingIn = state.matchedLocation == AppRoutes.signIn;
        final signUpIn = state.matchedLocation == AppRoutes.signUp;

        if (authState is Unauthenticated && !loggingIn && !signUpIn) {
          return AppRoutes.signIn;
        }

        if (authState is Authenticated && loggingIn) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.signOut,
          builder: (context, state) => const SignOutScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainLayoutScreen(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
