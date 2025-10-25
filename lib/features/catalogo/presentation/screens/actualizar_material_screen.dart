import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_material/actualizar_material_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_material/actualizar_material_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_material/actualizar_material_state.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/injection.dart';

class ActualizarMaterialScreen extends StatefulWidget {
  final MaterialEntity material;
  const ActualizarMaterialScreen({super.key, required this.material});

  @override
  State<ActualizarMaterialScreen> createState() =>
      _ActualizarMaterialScreenState();
}

class _ActualizarMaterialScreenState extends State<ActualizarMaterialScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActualizarMaterialBloc>()
        ..add(SetIdMaterial(widget.material.id ?? ''))
        ..add(NombreChanged(widget.material.nombre))
        ..add(DescripcionChanged(widget.material.descripcion)),
      child: Scaffold(
        appBar: _buildAppBar(context, 'Actualizar Material'),
        body: BlocListener<ActualizarMaterialBloc, ActualizarMaterialState>(
          listener: (context, state) {
            if (state.actualizarMaterialStatus ==
                ActualizarMaterialStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }

            if (state.actualizarMaterialStatus ==
                ActualizarMaterialStatus.success) {
              context.pop(true);
            }
          },
          child: BlocBuilder<ActualizarMaterialBloc, ActualizarMaterialState>(
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
                            initialValue: widget.material.nombre,
                            onChanged: (value) => context
                                .read<ActualizarMaterialBloc>()
                                .add(NombreChanged(value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Nombre del material',
                              errorText:
                                  state.nombreStatus == NombreStatus.invalid
                                  ? state.nombreMessage
                                  : null,
                              prefixIcon: const Icon(Icons.grain_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            key: const Key('descripcionField'),
                            initialValue: widget.material.descripcion,
                            onChanged: (value) => context
                                .read<ActualizarMaterialBloc>()
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
                            child: _buildActualizarMaterialButton(context),
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

  Widget _buildActualizarMaterialButton(BuildContext context) {
    return BlocBuilder<ActualizarMaterialBloc, ActualizarMaterialState>(
      builder: (context, state) {
        if (state.actualizarMaterialStatus ==
            ActualizarMaterialStatus.loading) {
          return Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ElevatedButton(
          onPressed: () => context.read<ActualizarMaterialBloc>().add(
            (SubmitActualizarMaterial()),
          ),
          child: const Text('Actualizar Material'),
        );
      },
    );
  }
}
