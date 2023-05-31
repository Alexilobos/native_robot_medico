import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HeartRateInterface extends StatefulWidget {
  const HeartRateInterface({Key? key}) : super(key: key);

  @override
  _HeartRateInterfaceState createState() => _HeartRateInterfaceState();
}

class _HeartRateInterfaceState extends State<HeartRateInterface> {
  int heartRate = 0;
  bool measuringHeartRate = false;

  void startHeartRateMeasurement() {
    setState(() {
      measuringHeartRate = true;
    });

    // Simulate heart rate measurement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        measuringHeartRate = false;
        final random = Random();
        const minHeartRate = 60;
        const maxHeartRate = 100;
        heartRate = minHeartRate + random.nextInt(maxHeartRate - minHeartRate);
      });
    });
  }

  Color getCircleColor() {
    if (hb >= 90) {
      return Colors.red;
    } else if (heartRate >= 60 && heartRate < 90) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  void generateRandomHeartRate() {
    final random = Random();
    const minHeartRate = 60;
    const maxHeartRate = 100;
    final newHeartRate =
        minHeartRate + random.nextInt(maxHeartRate - minHeartRate);

    updateHeartRate(newHeartRate);
  }

  void updateHeartRate(int newHeartRate) {
    setState(() {
      heartRate = newHeartRate;
    });
  }

  /* 
    TRIGGER QUE EJECUTA EL PYTHON DEL RASPBERRY 
  */

  int hb = 0;

  Future<void> Pulso() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.1.11:5000/pulso')); // Ethernet con Cable
      // http://192.168.1.111:5000/enviar_temperatura    // WIFI sin cable
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          hb = decoded['Pulso'];
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
        title: const Text('Mediciones de Ritmo Cardíaco'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Realizar la navegación hacia atrás
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ritmo Cardíaco Actual',
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
                    width: measuringHeartRate ? 180 : 0,
                    height: measuringHeartRate ? 180 : 0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '$hb',
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
              onPressed: Pulso,
              child: const Text('Actualizar Ritmo Cardíaco'),
            ),
          ],
        ),
      ),
    );
  }
}
