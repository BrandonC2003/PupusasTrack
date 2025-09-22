import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/core/routes/app_routes.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/confirmar_password_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/nombre_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/pupuseria_id_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_event.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_up/sign_up_state.dart';
import 'package:pupusas_track/injection.dart';

import '../blocs/email_status.dart';
import '../blocs/form_status.dart';
import '../blocs/password_status.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignUpBloc>(),
      child: Scaffold(
        body: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.formStatus is SubmissionSuccess) {
              // Navegar a signIn cuando el signUp es exitoso
              context.go(AppRoutes.signIn);
            }

            if (state.formStatus is SubmissionFailure ||
                state.formStatus is InvalidFormStatus) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.formStatus.message)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Logo y título
                _buildHeader(context),

                const SizedBox(height: 48),

                // Formulario
                _buildLoginForm(context),

                const SizedBox(height: 24),

                // Botón de login
                _buildSignUpButton(context),

                const SizedBox(height: 32),

                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withAlpha(0x7F),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text('🫓', style: TextStyle(fontSize: 56)),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'PupasTrack',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Únete a PupusasTrack',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          '"Tradición y tecnología en armonía"',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            TextFormField(
              key: const Key('nombreField'),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(NombreChanged(value)),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                errorText: state.nombreStatus is InvalidNombreStatus
                    ? state.nombreStatus.message
                    : null,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('emailField'),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(EmailChanged(value)),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                errorText: state.emailStatus is InvalidEmailStatus
                    ? state.emailStatus.message
                    : null,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('passwordField'),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(PasswordChanged(value)),
              obscureText: state.obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: state.passwordStatus is InvalidPasswordStatus
                    ? state.passwordStatus.message
                    : null,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      context.read<SignUpBloc>().add(ToggleObscurePassword()),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('confirmPasswordField'),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(ConfirmPasswordChanged(value)),
              obscureText: state.obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                errorText:
                    state.confirmarPasswordStatus
                        is InvalidConfirmarPasswordStatus
                    ? state.confirmarPasswordStatus.message
                    : null,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => context.read<SignUpBloc>().add(
                    ToggleObscureConfirmPassword(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('idPupuseriaField'),
              onChanged: (value) =>
                  context.read<SignUpBloc>().add(PupuseriaIdChanged(value)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'ID Pupusería',
                helperText: "Si no tienes un ID, puedes dejar este campo vacío",
                errorText: state.idPupuseriaStatus is InvalidPupuseriaIdStatus
                    ? state.idPupuseriaStatus.message
                    : null,
                prefixIcon: const Icon(Icons.tag_sharp),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.formStatus is SubmissionInProgress) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () => context.read<SignUpBloc>().add(SignUpSubmitted()),
          child: const Text('Crear Cuenta'),
        );
      },
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes cuenta? ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
        ),
        GestureDetector(
          onTap: () {
            context.go(AppRoutes.signIn);
          },
          child: Text(
            'Iniciar sesión',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
