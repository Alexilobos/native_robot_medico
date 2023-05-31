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
        title: const Text('CareTest'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: GridView(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
          ),
          children: const [
            CardWidget(
              svgPath: "asset/icons/oxigenacion_sangre.svg",
              text: 'ritmo cardiaco',
              color: Colors.red,
              onTap: HeartRateInterface(),
              width: 100.0,
              height: 100.0,
              backgroundColor: Colors.white,
            ),
            CardWidget(
              svgPath: "asset/icons/pulso_cardiaco.svg",
              text: 'temperatura corporal',
              color: Colors.purple,
              onTap: TemperatureInterface(),
              width: 100.0,
              height: 100.0,
              backgroundColor: Colors.white,
            ),
            CardWidget(
              svgPath: "asset/icons/pulso_cardiaco.svg",
              text: 'oxigenacion de sangre',
              color: Colors.yellow,
              onTap: OxygenSaturationInterface(),
              width: 100.0,
              height: 100.0,
              backgroundColor: Colors.white,
            ),
            CardWidget(
              svgPath: "asset/icons/pulso_cardiaco.svg",
              text: 'personalizado',
              color: Colors.blue,
              onTap: PersonalizadoInterface(),
              width: 100.0,
              height: 100.0,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String svgPath;
  final String text;
  final Color? color;
  final Widget? onTap;
  final double width;
  final double height;
  final Color? backgroundColor;

  const CardWidget({
    Key? key,
    required this.svgPath,
    required this.text,
    this.color,
    this.onTap,
    required this.width,
    required this.height,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => onTap!))
          : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: backgroundColor,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
