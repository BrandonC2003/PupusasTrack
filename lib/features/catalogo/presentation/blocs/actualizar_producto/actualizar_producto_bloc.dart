import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_producto/actualizar_producto_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_producto/actualizar_producto_state.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/use_cases/actualizar_producto_use_case.dart';

class ActualizarProductoBloc
    extends Bloc<ActualizarProductoEvent, ActualizarProductoState> {
  final ActualizarProductoUseCase actualizarProductoUseCase;

  ActualizarProductoBloc({required this.actualizarProductoUseCase})
    : super(const ActualizarProductoState()) {
    on<SetInitialValuesEvent>((event, emit) {
      final listaDescuentos = List<Descuento>.from(state.descuentos);

      for (var descuento in event.descuentos) {
        listaDescuentos.add(
          Descuento(
            id: DateTime.now().toIso8601String(),
            cantidad: descuento.cantidad,
            precio: descuento.precio,
          ),
        );
      }

      emit(
        state.copyWith(
          id: event.id,
          nombre: event.nombre,
          descripcion: event.descripcion,
          precio: event.precio,
          disponible: event.disponible,
          descuentos: listaDescuentos,
        ),
      );
    });

    on<ChangedNombreEvent>((event, emit) {
      final nombre = event.nombre.trim();
      if (nombre.isEmpty) {
        emit(
          state.copyWith(
            nombre: nombre,
            nombreStatus: NombreStatus.invalid,
            nombreMessage: 'El nombre es un campo obligatorio',
          ),
        );
      } else {
        emit(
          state.copyWith(
            nombre: nombre,
            nombreStatus: NombreStatus.valid,
            nombreMessage: '',
          ),
        );
      }
    });

    on<ChangedDescripcionEvent>((event, emit) {
      final descripcion = event.descripcion.trim();
      emit(state.copyWith(descripcion: descripcion));
    });

    on<ChangedPrecioEvent>((event, emit) {
      final precioStr = event.precio.trim();

      if (precioStr.isEmpty) {
        emit(
          state.copyWith(
            precio: 0.0,
            precioStatus: PrecioStatus.invalid,
            precioMessage: 'El precio es un campo obligatorio',
          ),
        );
        return;
      }

      final precio = double.tryParse(precioStr);
      if (precio == null || precio < 0) {
        emit(
          state.copyWith(
            precio: 0.0,
            precioStatus: PrecioStatus.invalid,
            precioMessage:
                'El precio debe ser un numero válido mayor o igual a 0',
          ),
        );
      } else {
        emit(
          state.copyWith(
            precio: precio,
            precioStatus: PrecioStatus.valid,
            precioMessage: '',
          ),
        );
      }
    });

    on<ChangedDisponibleEvent>((event, emit) {
      emit(state.copyWith(disponible: event.disponible));
    });

    on<AddedDescuentoEvent>((event, emit) {
      final nuevosDescuentos = List<Descuento>.from(state.descuentos);
      nuevosDescuentos.add(Descuento(id: DateTime.now().toIso8601String()));
      emit(state.copyWith(descuentos: nuevosDescuentos));
    });

    on<RemovedDescuentoEvent>((event, emit) {
      final nuevosDescuentos = state.descuentos
          .where((descuento) => descuento.id != event.descuentoId)
          .toList();
      emit(state.copyWith(descuentos: nuevosDescuentos));
    });

    on<ChangedDescuentoCantidadEvent>((event, emit) {
      final nuevosDescuentos = state.descuentos.map((descuento) {
        if (descuento.id == event.descuentoId) {
          final cantidad = int.tryParse(event.cantidad) ?? 0;
          return descuento.copyWith(cantidad: cantidad);
        }
        return descuento;
      }).toList();
      emit(state.copyWith(descuentos: nuevosDescuentos));
    });

    on<ChangedDescuentoPrecioEvent>((event, emit) {
      final nuevosDescuentos = state.descuentos.map((descuento) {
        if (descuento.id == event.descuentoId) {
          final precio = double.tryParse(event.precio) ?? 0.0;
          return descuento.copyWith(precio: precio);
        }
        return descuento;
      }).toList();
      emit(state.copyWith(descuentos: nuevosDescuentos));
    });

    on<SubmitProductoEvent>((event, emit) async {

      // Si los campos no han sido validados, forzar su validación
      // y esperar un ciclo de evento para que el estado se actualice
      if(state.nombreStatus == NombreStatus.initial){
        add(ChangedNombreEvent(nombre: state.nombre));
        await Future.delayed(Duration(milliseconds: 1));
      }

      if(state.precioStatus == PrecioStatus.initial) {
        add(ChangedPrecioEvent(precio: state.precio.toString()));
        await Future.delayed(Duration(milliseconds: 1));
      }

      bool validNombre = state.nombreStatus == NombreStatus.valid;
      bool validPrecio = state.precioStatus == PrecioStatus.valid;

      if (!validNombre || !validPrecio) {
        emit(
          state.copyWith(
            actualizarProductoStatus: ActualizarProductoStatus.failure,
            errorMessage: 'Complete el formulario correctamente',
          ),
        );

        emit(
          state.copyWith(
            actualizarProductoStatus: ActualizarProductoStatus.initial,
          ),
        );
        return;
      }

      try {
        await actualizarProductoUseCase(
          CatalogoProductoEntity(
            id: state.id,
            nombre: state.nombre,
            descripcion: state.descripcion,
            tipoProducto: TipoProducto.pupusa,
            precio: state.precio,
            descuentos: state.descuentos
                .map(
                  (d) =>
                      DescuentoEntity(cantidad: d.cantidad, precio: d.precio),
                )
                .toList(),
            disponible: state.disponible,
          ),
        );

        emit(
          state.copyWith(
            actualizarProductoStatus: ActualizarProductoStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            actualizarProductoStatus: ActualizarProductoStatus.failure,
            errorMessage:
                'Ocurrió un error al actualizar el producto. Intente nuevamente.',
          ),
        );
      }

      emit(
        state.copyWith(
          actualizarProductoStatus: ActualizarProductoStatus.initial,
        ),
      );
    });
  }
}
