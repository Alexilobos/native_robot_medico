//import 'dart:math';
import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RobotEyesApp(),
    );
  }
}

class RobotEyesApp extends StatelessWidget {
  const RobotEyesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 75, 72, 72),
      body: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GridCardApp()),
          );
        },
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Center(
              child: FractionallySizedBox(
                widthFactor: orientation == Orientation.portrait ? 0.6 : 0.3,
                heightFactor: 0.3,
                child: const RobotEyes(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RobotEyes extends StatefulWidget {
  const RobotEyes({Key? key}) : super(key: key);

  @override
  _RobotEyesState createState() => _RobotEyesState();
}

class _RobotEyesState extends State<RobotEyes>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.transparent, end: Colors.transparent),
        ),
        TweenSequenceItem(
          weight: 2.0,
          tween: ColorTween(begin: Colors.transparent, end: Colors.white),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.white, end: Colors.white),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.white, end: Colors.white),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.white, end: Colors.white),
        ),
        TweenSequenceItem(
          weight: 2.0,
          tween: ColorTween(begin: Colors.white, end: Colors.blue),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.blue, end: Colors.blue),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.blue, end: Colors.blue),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(begin: Colors.blue, end: Colors.blue),
        ),
        TweenSequenceItem(
          weight: 2.0,
          tween: ColorTween(begin: Colors.blue, end: Colors.transparent),
        ),
      ],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = constraints.maxWidth * 0.2;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Eye(
                    color: Colors.black,
                    borderColor: _colorAnimation.value,
                    borderWidth: containerSize * 0.05,
                    sizeFactor: containerSize,
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Eye(
                    color: Colors.black,
                    borderColor: _colorAnimation.value,
                    borderWidth: containerSize * 0.05,
                    sizeFactor: containerSize,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class Eye extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final double borderWidth;
  final double sizeFactor;

  const Eye({
    Key? key,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.sizeFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = sizeFactor * constraints.maxWidth;

        return Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth,
            ),
          ),
        );
      },
    );
  }
}