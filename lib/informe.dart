import 'package:flutter/material.dart';

import 'home.dart';

class MedicalReportInterface extends StatefulWidget {
  const MedicalReportInterface({Key? key}) : super(key: key);

  @override
  _MedicalReportInterfaceState createState() => _MedicalReportInterfaceState();
}

class _MedicalReportInterfaceState extends State<MedicalReportInterface> {
  String medicalReport = "Aquí se generará tu informe médico.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe Médico'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Realizar la navegación hacia atrás
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(medicalReport, style: const TextStyle(fontSize: 20.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GridCardApp(),
                        ),
                      );
                    },
              child: const Text('Generar Informe Médico'),
            ),
          ),
        ],
      ),
    );
  }
}
