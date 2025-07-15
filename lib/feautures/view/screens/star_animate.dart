import 'dart:math';
import 'package:flutter/material.dart';

class StarAnimate extends StatefulWidget {
  const StarAnimate({super.key});

  @override
  State<StarAnimate> createState() => _StarAnimateState();
}

class _StarAnimateState extends State<StarAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int starCount = 33;
  final Random random = Random();

  late List<Offset> positions;
  late List<double> opacities;
  late List<bool> fadingOut;

void generateInitialStars(Size screenSize) {
    positions = List.generate(starCount, (_) => getRandomOffset(screenSize));
    opacities = List.generate(starCount, (_) => 1.0);
    fadingOut = List.generate(starCount, (_) => true);
  }

  Offset getRandomOffset(Size screenSize) {
    return Offset(
      random.nextDouble() * screenSize.width,
      random.nextDouble() * screenSize.height,
    );
  }


  void updateStars(Size screenSize) {
    for (int i = 0; i < starCount; i++) {
      if (fadingOut[i]) {
        opacities[i] -= 0.03;
        if (opacities[i] <= 0) {
          opacities[i] = 1.0;
          positions[i] = getRandomOffset(screenSize); // YANGI random joy
        }
      }
    }
  }


 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;
    generateInitialStars(screenSize);

    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 60),
          )
          ..addListener(() {
            updateStars(screenSize);
            setState(() {});
          })
          ..repeat();
  }


  Path drawStar(Offset center, double radius) {
    const int points = 5;
    final Path path = Path();
    final angle = (2 * pi) / points;
    final halfAngle = angle / 2;

    for (int i = 0; i < points; i++) {
      final outerX = center.dx + radius * cos(i * angle);
      final outerY = center.dy + radius * sin(i * angle);
      final innerX = center.dx + (radius / 2) * cos(i * angle + halfAngle);
      final innerY = center.dy + (radius / 2) * sin(i * angle + halfAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(innerX, innerY);
        path.lineTo(outerX, outerY);
      }
    }

    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        size: Size.infinite,
        painter: BlinkingStarPainter(positions, opacities, drawStar),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BlinkingStarPainter extends CustomPainter {
  final List<Offset> positions;
  final List<double> opacities;
  final Path Function(Offset, double) starFunc;

  BlinkingStarPainter(this.positions, this.opacities, this.starFunc);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < positions.length; i++) {
      if (opacities[i] <= 0) continue;
      paint.color = Colors.yellow.withOpacity(opacities[i]);
      final path = starFunc(positions[i], 10);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
