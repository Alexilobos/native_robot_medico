import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Stack(
          children: [
            Center(child: Face()),
          ],
        ),
      ),
    );
  }
}

class Face extends StatefulWidget {
  const Face({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FaceState createState() => _FaceState();
}

class _FaceState extends State<Face> with SingleTickerProviderStateMixin {
  bool _isSwitched = true; // Set to true to start in the off state
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (!_isSwitched) {
        _controller.forward().then((value) => _controller.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!_isSwitched) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GridCardApp()),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 800, // Increase the height of the face
              width: 1400, // Increase the width of the face
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              margin: EdgeInsets.only(top: _isSwitched ? 60 : 90),
            ),
            Visibility(
              visible: !_isSwitched,
              child: Transform.translate(
                offset: const Offset(-100, 0),
                child: Eye(controller: _controller),
              ),
            ),
            Visibility(
              visible: !_isSwitched,
              child: Transform.translate(
                offset: const Offset(100, 0),
                child: Eye(controller: _controller),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _isSwitched = !_isSwitched;
                    });
                  },
                  child: Icon(
                    _isSwitched ? Icons.power_off : Icons.power_settings_new,
                    color: _isSwitched ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Eye extends StatelessWidget {
  const Eye({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: (1 - controller.value) * 60 + 20, // Changethe height calculation
          width: 80, // Increase the width of the eyes
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Color(0xFF002966),
                Colors.blue,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        );
      },
    );
  }
}