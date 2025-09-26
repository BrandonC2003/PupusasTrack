import 'package:flutter/material.dart';

class InformesScreen extends StatefulWidget{
  const InformesScreen({super.key});

  @override
  State<InformesScreen> createState() => _InformesScreenState();
}

class _InformesScreenState extends State<InformesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("Pantalla de informes"),);
  }
}