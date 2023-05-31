import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mediciones.dart';

class PersonalizadoInterface extends StatefulWidget {
  const PersonalizadoInterface({Key? key}) : super(key: key);

  @override
  State<PersonalizadoInterface> createState() => _PersonalizadoInterfaceState();
}

class _PersonalizadoInterfaceState extends State<PersonalizadoInterface> {
  String datosFormulario = ''; // Variable para almacenar los datos del formulario
  String motivo = '';
  String duracionSintomas = '';
  String antecedentes = '';
  String medicacionActual = '';
  String accionesTomadas = '';

  bool isVoiceResponseEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage("../asset/logo.jpeg"),
                  ),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Motivo de la consulta',
                      icon: Icon(Icons.chat_bubble),
                    ),
                    onChanged: (value) {
                      setState(() {
                        motivo = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Duración de los síntomas',
                      icon: Icon(Icons.calendar_today),
                    ),
                    onChanged: (value) {
                      setState(() {
                        duracionSintomas = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Antecedentes médicos relevantes',
                      icon: Icon(Icons.history),
                    ),
                    onChanged: (value) {
                      setState(() {
                        antecedentes = value;
                      });
                    },
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: !isVoiceResponseEnabled,
                    decoration: const InputDecoration(
                      labelText: 'Medicación actual',
                      icon: Icon(Icons.medical_services),
                    ),
                    onChanged: (value) {
                      setState(() {
                        medicacionActual = value;
                      });
                    },
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
                              child: const Text('Desactivar Respuesta Por Voz'),
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
                          child: const Text('Prefiero Responder Por Voz'),
                        ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: const Text('Continuar con las mediciones de signos vitales'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicionesInterface(
                            datosFormulario:
                                'Motivo: $motivo\nDuracion de sintomas: $duracionSintomas\nAntecedentes medicos: $antecedentes\nMedicacion actual: $medicacionActual\nAcciones tomadas previamente: $accionesTomadas',
                          ),
                        ),
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
  const RecordingButton({Key? key}) : super(key: key);

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton>
    with SingleTickerProviderStateMixin {
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
      startRecordingPythonScript();
    } else {
      print('Deteniendo grabación');
      stopRecordingPythonScript();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Grabación'),
            content: const Text('Grabación Guardada'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void startRecordingPythonScript() async {
    try {
      await http.get(Uri.parse('http://127.0.0.1:5000/grabar'));
    } catch (e) {
      print('Error: $e');
    }
  }

  void stopRecordingPythonScript() async {
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
