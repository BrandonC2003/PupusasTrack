import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/auth/auth_event.dart';

class SignOutScreen extends StatefulWidget{
  const SignOutScreen({super.key});

  @override
  State<SignOutScreen> createState() => _SignOutScreenState();
}

class _SignOutScreenState extends State<SignOutScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    return Center(
      child: Text("Cerrando sesion"),
    );
  }
}