//import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_robot/oxi_sangre.dart';
import 'package:native_robot/ritmocardiaco.dart';
import 'personalizado.dart';
import 'temperatura.dart';

class GridCardApp extends StatelessWidget {
  const GridCardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text('CareTest'),        
      ), 
      body: Column(
        children: [
          const Image(
            image: AssetImage("../asset/logo.jpeg"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  CardWidget(
                    svgPath: "../asset/icons/oxigenacion_sangre.svg",
                    text: 'Ritmo cardiaco',
                    color: Colors.blue.shade400,
                    onTap: const HeartRateInterface(),
                  ),
                  const CardWidget(
                    svgPath: "../asset/icons/pulso_cardiaco.svg",
                    text: 'Temperatura corporal',
                    color: Colors.purple,
                    onTap: TemperatureInterface(),
                  ),
                  const CardWidget(
                    svgPath: "../asset/icons/pulso_cardiaco.svg",
                    text: 'Oxigenacion de sangre',
                    color: Colors.yellow,
                    onTap: OxygenSaturationInterface(),
                  ),
                  const CardWidget(
                    svgPath: "../asset/icons/pulso_cardiaco.svg",
                    text: 'Personalizado',
                    color: Colors.black,
                    onTap: PersonalizadoInterface(),
                  ),
                ],
              ),
            ),
          ),
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
    return GestureDetector(
      onTap: onTap != null
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => onTap!))
          : null,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final iconSize = constraints.maxWidth * 0.4;
            final textSize = constraints.maxHeight * 0.1;

            return Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: SvgPicture.asset(
                      svgPath,
                      color: color,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}