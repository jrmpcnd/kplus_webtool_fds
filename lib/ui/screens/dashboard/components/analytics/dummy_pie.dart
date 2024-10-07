import 'dart:math';

import 'package:flutter/material.dart';

class NeumorphicPie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Outer white circle
    return Container(
      height: 290.0,
      width: 290.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: Center(
        // Container of the pie chart
        child: Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 20,
                blurRadius: 45,
                offset: const Offset(0, 7), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              const Center(child: MiddleRing(width: 300.0)),
              Transform.rotate(
                angle: pi * 1.6,
                child: CustomPaint(
                  painter: ProgressRings(
                    completedPercentage: 0.65,
                    circleWidth: 50.0,
                    gradient: greenGradient,
                    gradientStartAngle: 0.0,
                    gradientEndAngle: pi / 3,
                    progressStartAngle: 1.85,
                    lengthToRemove: 3,
                  ),
                  child: const Center(),
                ),
              ),
              Transform.rotate(
                angle: pi / 1.8,
                child: CustomPaint(
                  painter: ProgressRings(
                    completedPercentage: 0.20,
                    circleWidth: 50.0,
                    gradient: turqoiseGradient,
                  ),
                  child: const Center(),
                ),
              ),
              Transform.rotate(
                angle: pi / 2.6,
                child: CustomPaint(
                  painter: ProgressRings(
                    completedPercentage: 0.35,
                    circleWidth: 50.0,
                    gradient: redGradient,
                    gradientStartAngle: 0.0,
                    gradientEndAngle: pi / 2,
                    progressStartAngle: 1.85,
                  ),
                  child: const Center(),
                ),
              ),
              Transform.rotate(
                angle: pi * 1.1,
                child: CustomPaint(
                  painter: ProgressRings(
                    completedPercentage: 0.24,
                    circleWidth: 50.0,
                    gradient: orangeGradient,
                    gradientStartAngle: 0.0,
                    gradientEndAngle: pi / 2,
                    progressStartAngle: 1.85,
                  ),
                  child: const Center(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const innerColor = Color.fromRGBO(233, 242, 249, 1);
const shadowColor = Color.fromRGBO(220, 227, 234, 1);

const greenGradient = [Color.fromRGBO(223, 250, 92, 1), Color.fromRGBO(129, 250, 112, 1)];
const turqoiseGradient = [Color.fromRGBO(91, 253, 199, 1), Color.fromRGBO(129, 182, 205, 1)];

const redGradient = [
  Color.fromRGBO(255, 93, 91, 1),
  Color.fromRGBO(254, 154, 92, 1),
];
const orangeGradient = [
  Color.fromRGBO(251, 173, 86, 1),
  Color.fromRGBO(253, 255, 93, 1),
];

class MiddleRing extends StatelessWidget {
  final double width;
  const MiddleRing({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          height: width * 0.3,
          width: width * 0.3,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            // Edge shadow
            BoxShadow(
              offset: const Offset(-1.5, -1.5),
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 2.0,
            ),

            // Circular shadow
            const BoxShadow(
              offset: Offset(1.5, 1.5),
              color: Colors.white,
              spreadRadius: 2.0,
              blurRadius: 4,
            )
          ]),
        ),
      ),
    );
  }
}

class ProgressRings extends CustomPainter {
  /// From 0.0 to 1.0
  final double completedPercentage;
  final double circleWidth;
  final List<Color> gradient;
  final double gradientStartAngle;
  final double gradientEndAngle;
  final double progressStartAngle;
  final double lengthToRemove;

  ProgressRings({
    required this.completedPercentage,
    required this.circleWidth,
    required this.gradient,
    this.gradientStartAngle = 3 * pi / 2,
    this.gradientEndAngle = 4 * pi / 2,
    this.progressStartAngle = 0,
    this.lengthToRemove = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    double arcAngle = 2 * pi * (completedPercentage);

    Rect boundingSquare = Rect.fromCircle(center: center, radius: radius);

    paint(List<Color> colors, {double startAngle = 0.0, double endAngle = pi * 2}) {
      final Gradient gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: endAngle,
        colors: colors,
      );

      return Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = circleWidth
        ..shader = gradient.createShader(boundingSquare);
    }

    canvas.drawArc(
      boundingSquare,
      -pi / 2 + progressStartAngle,
      arcAngle - lengthToRemove,
      false,
      paint(
        gradient,
        startAngle: gradientStartAngle,
        endAngle: gradientEndAngle,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter painter) => true;
}
