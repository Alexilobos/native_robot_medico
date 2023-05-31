import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class TemperatureInterface extends StatefulWidget {
  const TemperatureInterface({Key? key}) : super(key: key);

  @override
  _TemperatureInterfaceState createState() => _TemperatureInterfaceState();
}

class _TemperatureInterfaceState extends State<TemperatureInterface> {
  double temperature = 0.0;
  bool measuringTemperature = false;

  void startTemperatureMeasurement() {
    setState(() {
      measuringTemperature = true;
    });

    // Simulate temperature measurement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        measuringTemperature = false;
        temperature = 36.5; // Set the measured temperature value
      });
    });
  }

  Color getCircleColor() {
    if (temp >= 37.5) {
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
    final newTemperature = minTemperature +
        random.nextDouble() * (maxTemperature - minTemperature);

    updateTemperature(newTemperature);
  }

  void updateTemperature(double newTemperature) {
    setState(() {
      temperature = newTemperature;
    });
  }

  /* 
    TRIGGER QUE EJECUTA EL PYTHON DEL RASPBERRY 
  */

  double temp = 0.00;

  Future<void> triggerPythonScript() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104:5000/enviar_temperatura')); // Ethernet con Cable
      // http://192.168.1.111:5000/enviar_temperatura    // WIFI sin cable
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          temp = decoded['Temperatura Corporal'];
        });
      } else {
        print('Failed to trigger Python script');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mediciones de Temperatura'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Realizar la navegación hacia atrás
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../asset/temperaturafondo.gif"),
            fit: BoxFit.fill
          )
        ),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 3),
                    width: measuringTemperature ? 180 : 0,
                    height: measuringTemperature ? 180 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getCircleColor(), //Colors.green.shade100.withOpacity(0.1), // Establece la opacidad del color verde a 0.5
                    ),
                  ),
                  Text(
                    '$temp °C',
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: triggerPythonScript,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Establece el color de fondo como transparente
                elevation: 0, // Elimina la sombra del botón
                shape: RoundedRectangleBorder( // Establece el borde del botón
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.white), // Establece un borde blanco alrededor del botón
                ),
              ),
              child: const Text(
                'Actualizar Temperatura',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )/*.frosted(
                blur: 1,
                borderRadius: BorderRadius.circular(15),
                padding: const EdgeInsets.all(8),
              ),*/
            ),
          ],
        ),
      ),
    );
  }
}
