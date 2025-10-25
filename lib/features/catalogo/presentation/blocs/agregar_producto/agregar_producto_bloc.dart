import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_producto/agregar_producto_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_producto/agregar_producto_state.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/use_cases/agregar_producto_use_case.dart';

class AgregarProductoBloc extends Bloc<AgregarProductoEvent, AgregarProductoState>{

  final AgregarProductoUseCase agregarProductoUseCase;

  AgregarProductoBloc({required this.agregarProductoUseCase}) 
  : super(const AgregarProductoState()) {
    on<ChangedNombreEvent>((event, emit) {
      final nombre = event.nombre.trim();
      if (nombre.isEmpty) {
        emit(state.copyWith(
          nombre: nombre,
          nombreStatus: NombreStatus.invalid,
          nombreMessage: 'El nombre es un campo obligatorio',
        ));
      } else {
        emit(state.copyWith(
          nombre: nombre,
          nombreStatus: NombreStatus.valid,
          nombreMessage: '',
        ));
      }
    });

    on<ChangedDescripcionEvent>((event, emit) {
      final descripcion = event.descripcion.trim();
      emit(state.copyWith(descripcion: descripcion));
    });

    on<ChangedPrecioEvent>((event, emit) {
      final precioStr = event.precio.trim();

      if(precioStr.isEmpty){
        emit(state.copyWith(
          precio: 0.0,
          precioStatus: PrecioStatus.invalid,
          precioMessage: 'El precio es un campo obligatorio',
        ));
        return;
      }
      
      
      final precio = double.tryParse(precioStr);
      if (precio == null || precio < 0) {
        emit(state.copyWith(
          precio: 0.0,
          precioStatus: PrecioStatus.invalid,
          precioMessage: 'El precio debe ser un numero válido mayor o igual a 0',
        ));
      } else {
        emit(state.copyWith(
          precio: precio,
          precioStatus: PrecioStatus.valid,
          precioMessage: '',
        ));
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
      final nuevosDescuentos = state.descuentos.where((descuento) => descuento.id != event.descuentoId).toList();
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
      bool validNombre = state.nombreStatus == NombreStatus.valid;
      bool validPrecio = state.precioStatus == PrecioStatus.valid;
      String nombreMessage = state.nombreMessage.isEmpty ? 'El nombre es un campo obligatorio' : state.nombreMessage;
      String precioMessage = state.precioMessage.isEmpty ? 'El precio es un campo obligatorio' : state.precioMessage;

      if(!validNombre || !validPrecio){
        emit(state.copyWith(
          nombreStatus: !validNombre ? NombreStatus.invalid : state.nombreStatus,
          nombreMessage: !validNombre ? nombreMessage : state.nombreMessage,
          precioStatus: !validPrecio ? PrecioStatus.invalid : state.precioStatus,
          precioMessage: !validPrecio ? precioMessage : state.precioMessage,
          status: AgregarProductoStatus.failure,
          errorMessage: 'Complete el formulario correctamente',
        ));

        emit(state.copyWith(
        status: AgregarProductoStatus.initial,
      ));
        return;
      } 

      await agregarProductoUseCase(CatalogoProductoEntity(
        id: '', 
        nombre: state.nombre, 
        descripcion: state.descripcion,
        tipoProducto: TipoProducto.pupusa, 
        precio: state.precio, 
        descuentos: state.descuentos.map((d) => DescuentoEntity(cantidad: d.cantidad, precio: d.precio)).toList(),
        disponible: state.disponible
        )
      );

      emit(state.copyWith(
        status: AgregarProductoStatus.success,
      ));
    });
  }
}