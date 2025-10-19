import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/core/themes/app_theme.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_producto/agregar_producto_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_producto/agregar_producto_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_producto/agregar_producto_state.dart';
import 'package:pupusas_track/injection.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AgregarProductoBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(context, 'Agregar Pupusa'),
        body: BlocListener<AgregarProductoBloc, AgregarProductoState>(
          listener: (context, state) {
            if (state.status == AgregarProductoStatus.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }

            if (state.status == AgregarProductoStatus.success) {
              context.pop(true);
            }
          },
          child: BlocBuilder<AgregarProductoBloc, AgregarProductoState>(
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
                                .read<AgregarProductoBloc>()
                                .add(ChangedNombreEvent(nombre: value)),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Nombre de la pupusa',
                              errorText:
                                  state.nombreStatus == NombreStatus.invalid
                                  ? state.nombreMessage
                                  : null,
                              prefixIcon: const Icon(Icons.restaurant),
                            ),
                          ),

                          const SizedBox(height: 24),

                          TextFormField(
                            key: const Key('descripcionField'),
                            onChanged: (value) =>
                                context.read<AgregarProductoBloc>().add(
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
                                .read<AgregarProductoBloc>()
                                .add(ChangedPrecioEvent(precio: value)),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Precio',
                              prefixText: '\$ ',
                              errorText:
                                  state.nombreStatus == NombreStatus.invalid
                                  ? state.nombreMessage
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
                                          .read<AgregarProductoBloc>()
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

                          const SizedBox(height: 24),
                          // Header for descuentos with add button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Descuentos',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => context.read<AgregarProductoBloc>().add(AddedDescuentoEvent()),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Agregar'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  minimumSize: const Size(0, 36),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.descuentos.length,
                            itemBuilder: (context, i) {
                              final d = state.descuentos[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0.8,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      key: Key('descuento_row_${d.id}'),
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                      initialValue: d.cantidad == 0
                                          ? ''
                                          : d.cantidad.toString(),
                                      decoration: InputDecoration(
                                        labelText: 'Cantidad',
                                        errorText: d.valid
                                            ? null
                                            : d.errorMessage,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) => context
                                          .read<AgregarProductoBloc>()
                                          .add(
                                            ChangedDescuentoCantidadEvent(
                                              descuentoId: d.id,
                                              cantidad: v,
                                            ),
                                          ),
                                    ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextFormField(
                                      initialValue: d.precio == 0.0
                                          ? ''
                                          : d.precio.toStringAsFixed(2),
                                      decoration: const InputDecoration(
                                        labelText: 'Precio',
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      onChanged: (v) => context
                                          .read<AgregarProductoBloc>()
                                          .add(
                                            ChangedDescuentoPrecioEvent(
                                              descuentoId: d.id,
                                              precio: v,
                                            ),
                                          ),
                                    ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => context.read<AgregarProductoBloc>().add(
                                            RemovedDescuentoEvent(
                                              descuentoId: d.id,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
                          Expanded(child: _buildAgregarMaterialButton(context)),
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
    return BlocBuilder<AgregarProductoBloc, AgregarProductoState>(
      builder: (context, state) {
        if (state.status == AgregarProductoStatus.loading) {
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
              context.read<AgregarProductoBloc>().add((SubmitProductoEvent())),
          child: const Text('Agregar Pupusa'),
        );
      },
    );
  }
}
