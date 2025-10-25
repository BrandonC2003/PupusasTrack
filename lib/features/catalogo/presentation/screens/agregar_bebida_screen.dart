import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_bebida/agregar_bebida_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_bebida/agregar_bebida_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_bebida/agregar_bebida_state.dart';
import 'package:pupusas_track/injection.dart';

class AgregarBebidaScreen extends StatefulWidget {
  const AgregarBebidaScreen({super.key});

  @override
  State<AgregarBebidaScreen> createState() => _AgregarBebidaScreenState();
}

class _AgregarBebidaScreenState extends State<AgregarBebidaScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AgregarBebidaBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(context, 'Agregar Bebida'),
        body: BlocListener<AgregarBebidaBloc, AgregarBebidaState>(
          listener: (context, state) {
            if (state.agregarBebidaStatus == AgregarBebidaStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }

            if (state.agregarBebidaStatus == AgregarBebidaStatus.success) {
              context.pop(true);
            }
          },
          child: BlocBuilder<AgregarBebidaBloc, AgregarBebidaState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextFormField(
                            key: const Key('nombreField'),
                            onChanged: (value) => context
                                .read<AgregarBebidaBloc>()
                                .add(ChangedNombreEvent(nombre: value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Nombre de la bebida',
                              errorText:
                                  state.nombreStatus == NombreStatus.invalid
                                  ? state.nombreMessage
                                  : null,
                              prefixIcon: const Icon(Icons.local_drink),
                            ),
                          ),

                          const SizedBox(height: 24),

                          TextFormField(
                            key: const Key('descripcionField'),
                            onChanged: (value) =>
                                context.read<AgregarBebidaBloc>().add(
                                  ChangedDescripcionEvent(descripcion: value),
                                ),
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 6,
                            maxLength: 500,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              prefixIcon: const Icon(Icons.comment_outlined),
                            ),
                          ),

                          const SizedBox(height: 24),

                          TextFormField(
                            key: const Key('PrecioField'),
                            onChanged: (value) => context
                                .read<AgregarBebidaBloc>()
                                .add(ChangedPrecioEvent(precio: value)),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Precio',
                              prefixText: '\$ ',
                              errorText:
                                  state.precioStatus == PrecioStatus.invalid
                                  ? state.precioMessage
                                  : null,
                              prefixIcon: const Icon(Icons.money_outlined),
                            ),
                            inputFormatters: [
                              // Permite números y punto; limita a 2 decimales con un TextInputFormatter simple
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          TextFormField(
                            key: const Key('sizeField'),
                            onChanged: (value) => context
                                .read<AgregarBebidaBloc>()
                                .add(ChangedSizeEvent(size: value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Tamaño',
                              prefixIcon: const Icon(Icons.tune_outlined),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Disponibilidad: caja con borde para que se vea claramente
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Disponibilidad',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Marcar si el producto está disponible para la venta',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Switch(
                                      value: state.disponible,
                                      onChanged: (value) => context
                                          .read<AgregarBebidaBloc>()
                                          .add(ChangedDisponibleEvent(disponible: value)),
                                    ),
                                    const SizedBox(height: 4),
                                    Chip(
                                      label: Text(
                                        state.disponible ? 'Disponible' : 'No disponible',
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                      backgroundColor: state.disponible
                                          ? AppTheme.verdeComal
                                          : Colors.grey.shade500,
                                    ),
                                  ],
                                ),
                              ],
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
                          Expanded(child: _buildAgregarBebidaButton(context)),
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

  Widget _buildAgregarBebidaButton(BuildContext context) {
    return BlocBuilder<AgregarBebidaBloc, AgregarBebidaState>(
      builder: (context, state) {
        if (state.agregarBebidaStatus == AgregarBebidaStatus.loading) {
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
              context.read<AgregarBebidaBloc>().add((SubmitBebidaEvent())),
          child: const Text('Agregar Bebida'),
        );
      },
    );
  }
}
