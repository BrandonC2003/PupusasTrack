
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_state.dart';
import 'package:pupusas_track/injection.dart';

class AgregarMaterialScreen extends StatefulWidget {
  const AgregarMaterialScreen({super.key});

  @override
  State<AgregarMaterialScreen> createState() => _AgregarMaterialScreenState();
}

class _AgregarMaterialScreenState extends State<AgregarMaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AgregarMaterialBloc>(),
      child: Scaffold(
        body: BlocListener<AgregarMaterialBloc, AgregarMaterialState>(
          listener: (context, state) {
            if (state.status == AgregarMaterialStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }

            if (state.status == AgregarMaterialStatus.success) {
              context.go(AppRoutes.catalogo);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}