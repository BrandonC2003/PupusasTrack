import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_event.dart';
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
        appBar: _buildAppBar(context, 'Agregar Material'),
        body: BlocListener<AgregarMaterialBloc, AgregarMaterialState>(
          listener: (context, state) {
            if (state.status == AgregarMaterialStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }

            if (state.status == AgregarMaterialStatus.success) {
              context.pop(true);
            }
          },
          child: BlocBuilder<AgregarMaterialBloc, AgregarMaterialState>(
            builder: (context, state) {
              return Column(
                children: [
                  // form area: expand to take available space and allow internal scrolling
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextFormField(
                            key: const Key('nombreField'),
                            onChanged: (value) => context
                                .read<AgregarMaterialBloc>()
                                .add(NombreChanged(value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Nombre del material',
                              errorText: state.nombreStatus == NombreStatus.invalid
                                  ? state.nombreMessage
                                  : null,
                              prefixIcon: const Icon(Icons.grain_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            key: const Key('descripcionField'),
                            onChanged: (value) => context
                                .read<AgregarMaterialBloc>()
                                .add(DescripcionChanged(value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: const Icon(Icons.comment_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          // Botón Guardar
                          Expanded(
                            child: _buildAgregarMaterialButton(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
        onPressed: () => context.go(AppRoutes.catalogo),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAgregarMaterialButton(BuildContext context) {
    return BlocBuilder<AgregarMaterialBloc, AgregarMaterialState>(
      builder: (context, state) {
        if (state.status == AgregarMaterialStatus.loading) {
          return Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          ),
        );
        }

        return ElevatedButton(
          onPressed: () =>
              context.read<AgregarMaterialBloc>().add((AgregarMaterial())),
          child: const Text('Agregar Material'),
        );
      },
    );
  }
}
