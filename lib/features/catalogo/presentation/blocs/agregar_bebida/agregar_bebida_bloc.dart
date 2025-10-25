import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_bebida/agregar_bebida_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_bebida/agregar_bebida_state.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/use_cases/agregar_producto_use_case.dart';

class AgregarBebidaBloc extends Bloc<AgregarBebidaEvent, AgregarBebidaState>{

  final AgregarProductoUseCase agregarProductoUseCase;

  AgregarBebidaBloc({required this.agregarProductoUseCase}) 
  : super(const AgregarBebidaState()) {
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

    on<ChangedSizeEvent>((event, emit) {
      emit(state.copyWith(size: event.size));
    });

    on<SubmitBebidaEvent>((event, emit) async {
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
          agregarBebidaStatus: AgregarBebidaStatus.failure,
          errorMessage: 'Complete el formulario correctamente',
        ));

        emit(state.copyWith(
        agregarBebidaStatus: AgregarBebidaStatus.initial,
      ));
        return;
      } 

      await agregarProductoUseCase(CatalogoProductoEntity(
        id: '', 
        nombre: state.nombre, 
        descripcion: state.descripcion,
        tipoProducto: TipoProducto.bebida, 
        precio: state.precio, 
        size: state.size,
        disponible: state.disponible
        )
      );

      emit(state.copyWith(
        agregarBebidaStatus: AgregarBebidaStatus.success,
      ));
    });
  }
}