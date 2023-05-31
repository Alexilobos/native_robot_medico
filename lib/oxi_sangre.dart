import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OxygenSaturationInterface extends StatefulWidget {
  const OxygenSaturationInterface({Key? key}) : super(key: key);

  @override
  _OxygenSaturationInterfaceState createState() =>
      _OxygenSaturationInterfaceState();
}

class _OxygenSaturationInterfaceState extends State<OxygenSaturationInterface> {
  double oxygenSaturation = 0.0;
  bool measuringOxygenSaturation = false;

  void startOxygenSaturationMeasurement() {
    setState(() {
      measuringOxygenSaturation = true;
    });

    // Simulate oxygen saturation measurement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        measuringOxygenSaturation = false;
        final random = Random();
        const minOxygenSaturation = 90.0;
        const maxOxygenSaturation = 100.0;
        oxygenSaturation = minOxygenSaturation +
            random.nextDouble() * (maxOxygenSaturation - minOxygenSaturation);
      });
    });
  }

  Color getCircleColor() {
    if (o2 >= 95.0) {
      return Colors.green;
    } else if (oxygenSaturation >= 90.0 && oxygenSaturation < 95.0) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  void generateRandomOxygenSaturation() {
    final random = Random();
    const minOxygenSaturation = 90.0;
    const maxOxygenSaturation = 100.0;
    final newOxygenSaturation = minOxygenSaturation +
        random.nextDouble() * (maxOxygenSaturation - minOxygenSaturation);

    updateOxygenSaturation(newOxygenSaturation);
  }

  void updateOxygenSaturation(double newOxygenSaturation) {
    setState(() {
      oxygenSaturation = newOxygenSaturation;
    });
  }

  /* 
    TRIGGER QUE EJECUTA EL PYTHON DEL RASPBERRY 
  */

  int o2 = 0;

  Future<void> Oxigeno() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.104:5000/oxigeno')); // Ethernet con Cable
      // http://192.168.1.111:5000/enviar_temperatura    // WIFI sin cable
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          o2 = decoded['Oxigenación'];
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
        title: const Text('Mediciones de Oxigenación'),
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
            image: AssetImage("../asset/giroscopio.gif"),
            fit: BoxFit.fill
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nivel de Oxigenación Actual',
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
                    width: measuringOxygenSaturation ? 180 : 0,
                    height: measuringOxygenSaturation ? 180 : 0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '$o2 SpO2',
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
              onPressed: Oxigeno,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.white),
                )
              ),
              child: const Text(
                'Actualizar Oxigenación',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
