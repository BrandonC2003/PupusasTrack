import 'package:flutter/material.dart';

class RegistroDiarioScreen extends StatefulWidget{
  const RegistroDiarioScreen({super.key});

  @override
  State<RegistroDiarioScreen> createState() => _RegistroDiarioScreenState();
}

class _RegistroDiarioScreenState extends State<RegistroDiarioScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("Pantalla de registro diario"),);
  }
}