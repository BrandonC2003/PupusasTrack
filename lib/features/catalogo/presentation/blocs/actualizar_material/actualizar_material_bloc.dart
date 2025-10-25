import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_material/actualizar_material_event.dart';
import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_material/actualizar_material_state.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/use_cases/actualizar_material_use_case.dart';

class ActualizarMaterialBloc
    extends Bloc<ActualizarMaterialEvent, ActualizarMaterialState> {
  final ActualizarMaterialUseCase actualizarMaterialUseCase;

  ActualizarMaterialBloc({required this.actualizarMaterialUseCase})
    : super(const ActualizarMaterialState()) {
    on<SetIdMaterial>(_onSetIdMaterial);
    on<NombreChanged>(_onNombreChanged);
    on<DescripcionChanged>(_onDescripcionChanged);
    on<SubmitActualizarMaterial>(_onSubmitActualizarMaterial);
  }

  void _onSetIdMaterial(
    SetIdMaterial event,
    Emitter<ActualizarMaterialState> emit,
  ) {
    emit(state.copyWith(idMaterial: event.idMaterial));
  }

  void _onNombreChanged(
    NombreChanged event,
    Emitter<ActualizarMaterialState> emit,
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
    Emitter<ActualizarMaterialState> emit,
  ) {
    emit(state.copyWith(descripcion: event.descripcion));
  }

  void _onSubmitActualizarMaterial(
    SubmitActualizarMaterial event,
    Emitter<ActualizarMaterialState> emit,
  ) async {
    emit(
      state.copyWith(
        actualizarMaterialStatus: ActualizarMaterialStatus.loading,
      ),
    );
    try {
      if (state.nombreStatus != NombreStatus.valid) {
        emit(
          state.copyWith(
            actualizarMaterialStatus: ActualizarMaterialStatus.failure,
            errorMessage: 'Complete los campos correctamente',
            nombreStatus: NombreStatus.invalid,
            nombreMessage: 'El nombre es un campo requerido',
          ),
        );
        emit(
          state.copyWith(
            actualizarMaterialStatus: ActualizarMaterialStatus.initial,
            errorMessage: '',
          ),
        );
        return;
      }

      var materialEntity = MaterialEntity(
        id: state.idMaterial,
        nombre: state.nombre,
        descripcion: state.descripcion,
      );
      await actualizarMaterialUseCase(materialEntity);

      emit(
        state.copyWith(
          actualizarMaterialStatus: ActualizarMaterialStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actualizarMaterialStatus: ActualizarMaterialStatus.failure,
          errorMessage: "Ocurrió un error al actualizar el material",
        ),
      );
    }
  }
}
