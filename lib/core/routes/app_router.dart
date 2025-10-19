import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc_notifier.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:pupusas_track/features/auth/presentation/screens/sign_out_screen.dart';
import 'package:pupusas_track/features/catalogo/presentation/screens/agregar_material_screen.dart';
import 'package:pupusas_track/features/catalogo/presentation/screens/agregar_producto_screen.dart';
import 'package:pupusas_track/features/catalogo/presentation/screens/catalogo_screen.dart';
import 'package:pupusas_track/features/informes/presentation/screens/informes_screen.dart';
import 'package:pupusas_track/features/main_layout/presentation/screens/home_screen.dart';
import 'package:pupusas_track/features/main_layout/presentation/screens/main_layout_screen.dart';
import 'package:pupusas_track/features/pedidos/presentation/screens/pedidos_screen.dart';
import 'package:pupusas_track/features/profile/presentation/screens/profile_screen.dart';
import 'package:pupusas_track/features/registro_diario/presentation/screens/registro_diario_screen.dart';
import 'package:pupusas_track/features/settings/presentation/screens/settings_screen.dart';
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
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainLayoutScreen(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.catalogo,
              builder: (context, state) => const CatalogoScreen(),
            ),
            GoRoute(
              path: AppRoutes.agregarProducto,
              builder: (context, state) => const AgregarProductoScreen(),
            ),
            GoRoute(
              path: AppRoutes.agregarMaterial,
              builder: (context, state) => const AgregarMaterialScreen(),
            ),
            GoRoute(
              path: AppRoutes.pedidos,
              builder: (context, state) => const PedidosScreen(),
            ),
            GoRoute(
              path: AppRoutes.informes,
              builder: (context, state) => const InformesScreen(),
            ),
            GoRoute(
              path: AppRoutes.registroDiario,
              builder: (context, state) => const RegistroDiarioScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
