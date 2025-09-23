// lib/features/main_layout/presentation/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).matchedLocation;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header simple
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0047AB)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('🫓', style: TextStyle(fontSize: 40)),
                SizedBox(height: 8),
                Text(
                  'PupasTrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Items del menú
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: currentRoute == AppRoutes.home,
            onTap: () {
              context.pop();
              context.go(AppRoutes.home);
            },
          ),

          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Catálogo de productos'),
            selected: currentRoute == AppRoutes.catalogo,
            onTap: () {
              context.pop();
              context.go(AppRoutes.catalogo);
            },
          ),

          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Pedidos'),
            selected: currentRoute == AppRoutes.pedidos,
            onTap: () {
              context.pop();
              context.go(AppRoutes.pedidos);
            },
          ),

          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Registro diario'),
            selected: currentRoute == AppRoutes.registroDiario,
            onTap: () {
              context.pop();
              context.go(AppRoutes.registroDiario);
            },
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Informes'),
            selected: currentRoute == AppRoutes.informes,
            onTap: () {
              context.pop();
              context.go(AppRoutes.informes);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              context.pop();
              context.go('/settings');
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade400),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red.shade400),
            ),
            onTap: () {
              context.pop();
              context.go(AppRoutes.signOut);
            },
          ),
        ],
      ),
    );
  }
}
