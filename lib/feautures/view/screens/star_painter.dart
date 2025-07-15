import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class StarPainter extends CustomPainter {
  final Offset position;
  final double size;
  final double opacity;

  StarPainter(this.position, this.size, this.opacity);

  @override
  void paint(Canvas canvas, ui.Size canvasSize) {
    if (opacity == 0) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(position.dx, position.dy - size / 2)
      ..lineTo(position.dx - size * 0.35, position.dy + size / 2)
      ..lineTo(position.dx + size / 2, position.dy - size * 0.1)
      ..lineTo(position.dx - size / 2, position.dy - size * 0.1)
      ..lineTo(position.dx + size * 0.35, position.dy + size / 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
class AnimatedStarsLayer extends StatefulWidget {
  const AnimatedStarsLayer({super.key});

  @override
  State<AnimatedStarsLayer> createState() => _AnimatedStarsLayerState();
}

class _AnimatedStarsLayerState extends State<AnimatedStarsLayer>
    with SingleTickerProviderStateMixin {
  final int starCount = 17;
  final Random _random = Random();
  late AnimationController _controller;
  late List<Offset> positions;
  late List<double> opacities;

  @override
  void initState() {
    super.initState();
    positions = List.generate(
      starCount,
      (index) => Offset(
        _random.nextDouble() * 400, // placeholder width
        _random.nextDouble() * 800, // placeholder height
      ),
    );
    opacities = List.generate(starCount, (_) => _random.nextDouble());

    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
          )
          ..addListener(() {
            updateOpacities();
            setState(() {});
          })
          ..repeat(reverse: true);
  }

  void updateOpacities() {
    opacities = opacities.map((e) {
      double change = _random.nextDouble() * 0.1;
      double newVal = e + (_random.nextBool() ? change : -change);
      return newVal.clamp(0.0, 1.0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return CustomPaint(
      size: screenSize,
      painter: _MultipleStarsPainter(
        positions: positions,
        opacities: opacities,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
class _MultipleStarsPainter extends CustomPainter {
  final List<Offset> positions;
  final List<double> opacities;

  _MultipleStarsPainter({required this.positions, required this.opacities});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < positions.length; i++) {
      final painter = StarPainter(positions[i], 10.0, opacities[i]);
      painter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
