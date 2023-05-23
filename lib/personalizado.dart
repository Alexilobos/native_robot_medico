import 'package:flutter/material.dart';

class PersonalizadoInterface extends StatelessWidget {
  const PersonalizadoInterface({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center Text Interface'),
      ),
      body: const Center(
        child: Text(
          '¡Hola, mundo!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}