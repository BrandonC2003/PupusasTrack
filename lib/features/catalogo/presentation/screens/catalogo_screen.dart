import 'package:flutter/material.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Pantalla de catalogo"),);
  }
}