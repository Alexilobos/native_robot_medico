import 'package:flutter/material.dart';

class OxygenPulseTemperatureInterface extends StatefulWidget {
  const OxygenPulseTemperatureInterface({Key? key}) : super(key: key);

  @override
  _OxygenPulseTemperatureInterfaceState createState() =>
      _OxygenPulseTemperatureInterfaceState();
}

class _OxygenPulseTemperatureInterfaceState
    extends State<OxygenPulseTemperatureInterface> {
  double oxygenation = 0.0;
  int pulse = 0;
  double temperature = 0.0;
  bool measuringOxygenation = false;
  bool measuringPulse = false;
  bool measuringTemperature = false;

  void startOxygenationMeasurement() {
    setState(() {
      measuringOxygenation = true;
    });

    // Simulate oxygenation measurement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        measuringOxygenation = false;
        oxygenation = 98.5; // Set the measured oxygenation value
      });
    });
  }

  void startPulseMeasurement() {
    setState(() {
      measuringPulse = true;
    });

    // Simulate pulse measurement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        measuringPulse = false;
        pulse = 72; // Set the measured pulse value
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mediciones de Salud'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildMeasurementCard(
                        'Oxigenación',
                        measuringOxygenation,
                        measuringOxygenation ? 'Medición en curso...' : '$oxygenation%',
                        Colors.red,
                        startOxygenationMeasurement,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMeasurementCard(
                        'Pulsaciones',
                        measuringPulse,
                        measuringPulse ? 'Medición en curso...' : '$pulse bpm',
                        Colors.blue,
                        startPulseMeasurement,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildMeasurementCard(
                        'Temperatura',
                        measuringTemperature,
                        measuringTemperature ? 'Medición en curso...' : '$temperature °C',
                        Colors.green,
                        startTemperatureMeasurement,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(), // Coloca aquí otro elemento si lo deseas
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementCard(String title, bool measuring, String measurementValue, Color color, VoidCallback onPressed) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  width: measuring ? 180 : 0,
                  height: measuring ? 180 : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                Text(
                  measurementValue,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: measuring ? null : onPressed,
              child: const Text('Iniciar Medición'),
            ),
          ],
        ),
      ),
    );
  }
}
