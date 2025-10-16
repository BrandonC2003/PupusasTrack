import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/core/domain/services/session_service.dart';
import 'package:pupusas_track/core/errors/validation_error.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/confirmar_password_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/nombre_status.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/use_cases/agregar_productos_iniciales_use_case.dart';
import 'package:pupusas_track/features/material/domain/use_cases/crear_material_inicial_use_case.dart';
import 'package:pupusas_track/features/pupuseria/domain/use_cases/create_pupuseria_use_case.dart';
import 'package:pupusas_track/features/pupuseria/domain/use_cases/exists_pupuseria_use_case.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;
  final CreatePupuseriaUseCase createPupuseriaUseCase;
  final ExistsPupuseriaUseCase existsPupuseriaUseCase;
  final AgregarProductosInicialesUseCase agregarProductosInicialesUseCase;
  final CrearMaterialInicialUseCase crearMaterialInicialUseCase;
  final SessionService sessionService;
  SignUpBloc({
    required this.signUpUseCase,
    required this.createPupuseriaUseCase,
    required this.existsPupuseriaUseCase,
    required this.agregarProductosInicialesUseCase,
    required this.crearMaterialInicialUseCase,
    required this.sessionService,
  }) : super(SignUpState()) {
    on<PasswordChanged>((event, emit) {
      if (event.password.isEmpty) {
        emit(
          state.copyWith(
            passwordStatus: InvalidPasswordStatus(
              message: "Ingrese la contraseña",
            ),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          password: event.password,
          passwordStatus: ValidPasswordStatus(),
        ),
      );
    });

    on<ConfirmPasswordChanged>((event, emit) {
      if (event.confirmPassword != state.password) {
        emit(
          state.copyWith(
            confirmarPasswordStatus: InvalidConfirmarPasswordStatus(
              message: "Las contraseñas no coinciden",
            ),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          confirmPassword: event.confirmPassword,
          confirmarPasswordStatus: ValidConfirmarPasswordStatus(),
        ),
      );
    });

    on<ToggleObscurePassword>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

    on<ToggleObscureConfirmPassword>((event, emit) {
      emit(
        state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword),
      );
    });

    on<EmailChanged>((event, emit) {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      );

      if (!emailRegExp.hasMatch(event.email)) {
        emit(
          state.copyWith(
            emailStatus: InvalidEmailStatus(
              message: "Dirección de correo inválida",
            ),
          ),
        );
        return;
      }

      emit(state.copyWith(email: event.email, emailStatus: ValidEmailStatus()));
    });

    on<NombreChanged>((event, emit) {
      if (event.nombre.isEmpty) {
        emit(
          state.copyWith(
            nombreStatus: InvalidNombreStatus(message: "Ingrese el nombre"),
          ),
        );
        return;
      }
      emit(
        state.copyWith(nombre: event.nombre, nombreStatus: ValidNombreStatus()),
      );
    });

    on<PupuseriaIdChanged>((event, emit) {
      emit(state.copyWith(idPupuseria: event.pupuseriaId));
    });

    on<SignUpSubmitted>((event, emit) async {
      if (state.emailStatus is! ValidEmailStatus ||
          state.confirmarPasswordStatus is! ValidConfirmarPasswordStatus ||
          state.nombreStatus is! ValidNombreStatus ||
          state.passwordStatus is! ValidPasswordStatus) {
        emit(
          state.copyWith(
            formStatus: InvalidFormStatus(
              message: "Completa los campos correctamente",
            ),
          ),
        );
        emit(state.copyWith(formStatus: InitialFormStatus()));
        return;
      }

      emit(state.copyWith(formStatus: SubmissionInProgress()));
      try {

        if (state.idPupuseria != '') {
          var existsPupuseria = await existsPupuseriaUseCase(state.idPupuseria);
          if (!existsPupuseria) {
            emit(
              state.copyWith(
                formStatus: InvalidFormStatus(
                  message: 'El id de pupuseria ingresado no ha sido encontrado',
                ),
              ),
            );

            emit(state.copyWith(formStatus: InitialFormStatus()));

            return;
          }
        }

        var idPupuseria = state.idPupuseria == '' ?  await createPupuseriaUseCase() : state.idPupuseria;

        await signUpUseCase(
          SignUpParams(
            email: state.email!,
            password: state.password!,
            nombre: state.nombre!,
            idPupuseria: idPupuseria,
          ),
        );

        await sessionService.setIdPupuseria(idPupuseria);
        //Si es la primera vez que se crea una pupuseria, se agregan los productos y materiales iniciales
        if(state.idPupuseria == ''){
          await agregarProductosInicialesUseCase();
          await crearMaterialInicialUseCase();
        }
        
        emit(
          state.copyWith(
            formStatus: SubmissionSuccess(
              message: "Usuario registrado exitosamente",
            ),
          ),
        );
      } on ValidationError catch (error) {
        emit(
          state.copyWith(formStatus: SubmissionFailure(message: error.message)),
        );
      } catch (err) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailure(message: err.toString()),
          ),
        );
      }
      emit(state.copyWith(formStatus: InitialFormStatus()));
    });
  }
}
