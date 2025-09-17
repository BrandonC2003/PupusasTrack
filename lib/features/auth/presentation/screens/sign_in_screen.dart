import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_event.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/sign_in/sign_in_state.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../blocs/email_status.dart';
import '../blocs/form_status.dart';
import '../blocs/password_status.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        signInUseCase: SignInUseCase(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {

  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.submissionSuccess) {
            // Navegar a home cuando el login es exitoso
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.formMessage ?? 'Inicio de sesión exitoso')),
            );
          }
          
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.formMessage ?? 'Error al iniciar sesión')),
            );
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
              _buildLoginButton(context),
              
              const SizedBox(height: 32),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('o', style: TextStyle(color: Colors.grey.shade600)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              
              const SizedBox(height: 32),
              
              OutlinedButton(
                onPressed: () => context.go('/sign-up'),
                child: const Text('Crear nueva cuenta'),
              ),
            ],
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
          'Control de Pupusería',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '"Sabor auténtico, control moderno"',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Column(
          children: [
            TextFormField(
              key: const Key('emailField'),
              onChanged: (value) => context.read<SignInBloc>().add(EmailChanged(value)),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                errorText: state.emailStatus == EmailStatus.invalid ? state.emailMessage : null,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('passwordField'),
              onChanged: (value) => context.read<SignInBloc>().add(PasswordChanged(value)),
              obscureText: state.obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                errorText: state.passwordStatus == PasswordStatus.invalid ? state.passwordMessage : null,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(state.obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => context.read<SignInBloc>().add(ToggleObscurePassword()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state.formStatus == FormStatus.submissionInProgress) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () => context.read<SignInBloc>().add(SignInSubmitted()),
          child: const Text('Iniciar Sesión'),
        );
      },
    );
  }
}