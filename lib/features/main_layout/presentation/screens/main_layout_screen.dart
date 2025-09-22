import 'package:flutter/material.dart';
import 'package:pupusas_track/features/main_layout/presentation/widgets/app_drawer.dart';
import 'package:pupusas_track/features/main_layout/presentation/widgets/app_header.dart';

class MainLayoutScreen extends StatelessWidget {

  final Widget child;
  
  const MainLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      
      // App Bar personalizada
      appBar: AppHeader(),
      
      // Drawer simple
      drawer: AppDrawer(),
      
      // Contenido
      body: child,
    );
  }
}