import 'package:flutter/material.dart';
import 'dart:math';

import 'oxigenacion.dart';

class TemperatureInterface extends StatelessWidget {
  const TemperatureInterface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double temperature = 0.0;

  void updateTemperature(double newTemperature) {
    setState(() {
      temperature = newTemperature;
    });
  }

  Color getCircleColor() {
    if (temperature >= 37.5) {
      return Colors.red;
    } else if (temperature >= 36.0 && temperature < 37.5) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  void generateRandomTemperature() {
    final random = Random();
    const minTemperature = 35.5;
    const maxTemperature = 41.0;
    final newTemperature = minTemperature + random.nextDouble() * (maxTemperature - minTemperature);

    updateTemperature(newTemperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mediciones de Temperatura'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Temperatura Actual',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getCircleColor(),
              ),
              child: Center(
                child: Text(
                  '${temperature.toStringAsFixed(1)} °C',
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: generateRandomTemperature,
              child: const Text('Actualizar Temperatura'),
            ),
          ],
        ),
      ),
    );
  }
}
