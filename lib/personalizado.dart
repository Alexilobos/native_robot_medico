import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'oxigenacion.dart';

class PersonalizadoInterface extends StatefulWidget {
  const PersonalizadoInterface({Key? key}) : super(key: key);

  @override
  _PersonalizadoInterfaceState createState() => _PersonalizadoInterfaceState();
}

class _PersonalizadoInterfaceState extends State<PersonalizadoInterface> {
  bool isVoiceResponseEnabled = false;

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
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Motivo de la consulta',
                      icon: Icon(Icons.chat_bubble),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
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
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Antecedentes médicos relevantes',
                      icon: Icon(Icons.history),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Medicación actual',
                      icon: Icon(Icons.medical_services),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Acciones tomadas previamente',
                      icon: Icon(Icons.playlist_add_check),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  isVoiceResponseEnabled
                      ? Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isVoiceResponseEnabled = false;
                                });
                              },
                              child: const Text('Desactivar respuesta por voz'),
                            ),
                            const SizedBox(height: 16.0),
                            const RecordingButton(),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isVoiceResponseEnabled = true;
                            });
                          },
                          child: const Text('Prefiero responder por voz'),
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

class RecordingButton extends StatefulWidget {
  const RecordingButton({super.key});

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isRecording = false;

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });

    if (isRecording) {
      print('Iniciando grabación');
      GrabartriggerPythonScript();
    } else {
      print('Deteniendo grabación');
      ParartriggerPythonScript();
    }
  }

  void GrabartriggerPythonScript() async {
    try {
      await http.get(Uri.parse('http://127.0.0.1:5000/grabar'));
    } catch (e) {
      print('Error: $e');
    }
  }

  void ParartriggerPythonScript() async {
    try {
      await http.get(Uri.parse('http://127.0.0.1:5000/parar'));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: FloatingActionButton(
        onPressed: toggleRecording,
        backgroundColor: isRecording ? Colors.red : Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.fiber_manual_record,
              size: 40.0,
              color: isRecording ? Colors.white : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
