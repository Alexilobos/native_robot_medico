import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'personalizado.dart';

class GridCardApp extends StatelessWidget {
  const GridCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Card Interface'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 1 / 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: const [
          CardWidget(svgPath: "../asset/icons/oxigenacion_sangre.svg", text: 'oxigenacion de sangre', color: Colors.red, onTap: null),
          CardWidget(svgPath: "../asset/icons/pulso_cardiaco.svg", text: 'pulso cardiaco', color: Colors.purple, onTap: null),
          CardWidget(svgPath: "../asset/icons/pulso_cardiaco.svg", text: 'pulso cardiaco', color: Colors.yellow, onTap: null),
          CardWidget(svgPath: "../asset/icons/pulso_cardiaco.svg", text: 'pulso cardiaco', color: null, onTap: null),
          CardWidget(svgPath: "../asset/icons/pulso_cardiaco.svg", text: 'personalizado', color: Colors.blue, onTap: PersonalizadoInterface()),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String svgPath;
  final String text;
  final Color? color;
  final Widget? onTap;

  const CardWidget({
    Key? key,
    required this.svgPath,
    required this.text,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: GestureDetector(
        onTap: onTap != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => onTap!)) : null,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 55.0,
                height: 55.0,
                child: SvgPicture.asset(
                  svgPath,
                  color: color,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
