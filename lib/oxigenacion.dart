import 'package:flutter/material.dart';

class OxigenacionInterface extends StatelessWidget {
  const OxigenacionInterface({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medición de Oxigenación'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oxigenación de la Sangre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 0.8, // Aquí puedes ajustar el valor de la oxigenación
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    strokeWidth: 10,
                  ),
                  const Text(
                    '80%', // Aquí puedes mostrar el valor de la oxigenación
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Continuar'),
              onPressed: () {
                // Acción al presionar el botón Continuar
              },
            ),
          ],
        ),
      ),
    );
  }
}