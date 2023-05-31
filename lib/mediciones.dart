import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicionesInterface extends StatefulWidget {
  final String datosFormulario;
  const MedicionesInterface({required this.datosFormulario, Key? key})
      : super(key: key);

  @override
  _MedicionesInterfaceState createState() =>
      _MedicionesInterfaceState();
}

class _MedicionesInterfaceState
    extends State<MedicionesInterface>
    with SingleTickerProviderStateMixin {
  double oxygenation = 0.0;
  int pulse = 0;
  double temperature = 0.0;
  bool measuringOxygenation = false;
  bool measuringPulse = false;
  bool measuringTemperature = false;

  TextEditingController datosFormularioController = TextEditingController();
  String prompt = '';

  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  String temp = "0.0";
  Future<void> triggerTemperatura() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.104:5000/temp_no_queue'));
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

  int oxigeno = 0;
  Future<void> triggerOxigeno() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.104:5000/oxi_no_queue'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          oxigeno = decoded['Oxigenación'];
        });
      } else {
        print('Failed to trigger Python script');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int pulso = 0;
  Future<void> triggerPulso() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.104:5000/pulso_no_queue'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          pulso = decoded['Pulso'];
        });
      } else {
        print('Failed to trigger Python script');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String respuestaGpt = '';
  Future<void> consultaGpt(String data) async {
    var url = Uri.parse('http://192.168.1.104:5000/consultagpt');
    var response = await http.post(url, body: {'data': data});
    setState(() {
      respuestaGpt = response.body;
    });
  }

  String respuestaVoz = '';
  Future<void> recomendacionGpt(String data) async {
    var url = Uri.parse('http://192.168.1.104:5000/recomendacion-gpt');
    var response = await http.post(url, body: {'data': data});
    setState(() {
      respuestaVoz = response.body;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

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

  void sendData() {
    // Code to send the measured data
    // Add your logic here
    print('Sending data...');
    // Add any animation or further logic you need when sending data
  }

  @override
  Widget build(BuildContext context) {
    bool allDataAvailable = temperature != 0 && pulse != 0 && oxygenation != 0;

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
                        triggerOxigeno
                        //startOxygenationMeasurement,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMeasurementCard(
                        'Pulsaciones',
                        measuringPulse,
                        measuringPulse ? 'Medición en curso...' : '$pulse bpm',
                        Colors.blue,
                        triggerPulso
                        //startPulseMeasurement,
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
                        triggerTemperatura
                        //startTemperatureMeasurement,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              /*allDataAvailable && measuringTemperature ?*/ sendData /*: true*/;
                              setState(() {
                                prompt =
                                    '${datosFormularioController.text}\nMis signos vitales son: \nTemperatura: $temp, %Oxigenacion: $oxigeno, Pulso: $pulso';
                              });
                              consultaGpt(prompt);
                              recomendacionGpt(prompt);
                            },//allDataAvailable && !measuringTemperature ? sendData : null,
                            
                            
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: const CircleBorder(),
                              primary: /*allDataAvailable ?*/ const Color.fromARGB(255, 90, 152, 251)/* : Colors.grey[200]*/,
                              elevation: 3.0,
                            ),
                            child: AnimatedBuilder(
                              animation: _buttonAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _buttonAnimation.value,
                                  child: child,
                                );
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.send),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enviar Datos',
                            style: TextStyle(
                              fontSize: 12,
                              color: allDataAvailable ? Colors.black : Colors.grey,
                            ),
                          ),
                          Text(
                            respuestaGpt,
                            style: TextStyle(
                              fontSize: 12,
                              color: allDataAvailable ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildMeasurementCard(
    String title,
    bool measuring,
    String measurementValue,
    Color color,
    VoidCallback onPressed,
  ) {
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}