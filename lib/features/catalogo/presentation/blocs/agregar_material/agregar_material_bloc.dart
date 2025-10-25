import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/agregar_material/agregar_material_state.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/use_cases/crear_material_use_case.dart';

class AgregarMaterialBloc
    extends Bloc<AgregarMaterialEvent, AgregarMaterialState> {
  final CrearMaterialUseCase agregarMaterialUseCase;

  AgregarMaterialBloc({required this.agregarMaterialUseCase})
    : super(const AgregarMaterialState()) {
    on<NombreChanged>(_onNombreChanged);
    on<DescripcionChanged>(_onDescripcionChanged);
    on<AgregarMaterial>(_onAgregarMaterial);
  }

  void _onNombreChanged(
    NombreChanged event,
    Emitter<AgregarMaterialState> emit,
  ) {
    var isValid = true;
    var message = '';

    if (event.name.isEmpty) {
      isValid = false;
      message = 'El nombre es un campo requerido';
    }

    if (event.name.length > 50) {
      isValid = false;
      message = 'El nombre no puede tener más de 50 caracteres';
    }

    emit(
      state.copyWith(
        nombre: event.name,
        nombreStatus: isValid ? NombreStatus.valid : NombreStatus.invalid,
        nombreMessage: message,
      ),
    );
  }

  void _onDescripcionChanged(
    DescripcionChanged event,
    Emitter<AgregarMaterialState> emit,
  ) {
    emit(state.copyWith(descripcion: event.descripcion));
  }

  void _onAgregarMaterial(
    AgregarMaterial event,
    Emitter<AgregarMaterialState> emit,
  ) async {
    emit(state.copyWith(status: AgregarMaterialStatus.loading));
    try {
      if (state.nombreStatus != NombreStatus.valid) {
        emit(
          state.copyWith(
            status: AgregarMaterialStatus.failure,
            errorMessage: 'Complete los campos correctamente',
            nombreStatus: NombreStatus.invalid,
            nombreMessage: 'El nombre es un campo requerido',
          ),
        );
        emit(
          state.copyWith(
            status: AgregarMaterialStatus.initial,
            errorMessage: '',
          ),
        );
        return;
      }

      var materialEntity = MaterialEntity(
        nombre: state.nombre,
        descripcion: state.descripcion,
      );
      await agregarMaterialUseCase(materialEntity);

      emit(state.copyWith(status: AgregarMaterialStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: AgregarMaterialStatus.failure,
          errorMessage: "Ocurrió un error al guardar el material",
        ),
      );
    }
  }
}
