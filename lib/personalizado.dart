import 'package:flutter/material.dart';

import 'oxigenacion.dart';

class PersonalizadoInterface extends StatelessWidget {
  const PersonalizadoInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Formulario'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Motivo de la consulta',
                      icon: Icon(Icons.chat_bubble),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Duración de los síntomas',
                      icon: const Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_view_day),
                        onPressed: () {
                          // Aquí se puede mostrar un calendario para seleccionar la fecha
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Antecedentes médicos relevantes',
                      icon: Icon(Icons.history),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Medicación actual',
                      icon: Icon(Icons.medical_services),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Acciones tomadas previamente',
                      icon: Icon(Icons.playlist_add_check),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Continuar con las mediciones de signos vitales'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OxygenPulseTemperatureInterface()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
