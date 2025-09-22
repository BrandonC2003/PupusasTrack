// lib/features/main_layout/presentation/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            selected: true,
            onTap: () {
              context.pop();
              context.go(AppRoutes.home);
            },
          ),

          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Catálogo de productos'),
            onTap: () {
              context.pop();
              context.go('/catalog');
            },
          ),

          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Pedidos'),
            onTap: () {
              context.pop();
              context.go('/pedidos');
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
