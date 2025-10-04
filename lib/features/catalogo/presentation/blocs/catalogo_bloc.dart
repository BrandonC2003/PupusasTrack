import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/catalogo_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/catalogo_state.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/use_cases/obtener_productos_use_case.dart';
import 'package:pupusas_track/features/material/domain/use_cases/obtener_materiales_use_case.dart';

class CatalogoBloc extends Bloc<CatalogoEvent, CatalogoState> {
  final ObtenerProductosUseCase obtenerProductosUseCase;
  final ObtenerMaterialesUseCase obtenerMaterialesUseCase;

  CatalogoBloc({
    required this.obtenerProductosUseCase,
    required this.obtenerMaterialesUseCase,
  }) : super(CatalogoInitial()) {
    on<CargarProductos>((event, emit) async{
      emit(CatalogoLoading());

      try{
        final catalogoProductos = await obtenerProductosUseCase();
        final materiales = await obtenerMaterialesUseCase();

        final pupusas = catalogoProductos.where((producto) => producto.tipoProducto == TipoProducto.pupusa).toList();
        final bebidas = catalogoProductos.where((producto) => producto.tipoProducto == TipoProducto.bebida).toList();

        emit(CatalogoLoaded(pupusas: pupusas, bebidas: bebidas, materiales: materiales));
      }catch(error){
        emit(CatalogoError(errorMessage: 'Ocurrio un error al obtener el catalogo de productos'));
      }
    });
  }
}
