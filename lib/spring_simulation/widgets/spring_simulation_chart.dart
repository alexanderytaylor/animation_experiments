import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const _durationsSecs = 4;
const _chartMax = 200;

class SpringSimulationChart extends StatelessWidget {
  const SpringSimulationChart({
    super.key,
    required this.simulation,
    required this.elapsedTime,
    required this.isSpringing,
  });

  final SpringSimulation simulation;
  final Duration elapsedTime;
  final bool isSpringing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpringSimulationChartPainter(
        simulation: simulation,
        elapsedTime: elapsedTime,
        isSpringing: isSpringing,
      ),
    );
  }
}

class _SpringSimulationChartPainter extends CustomPainter {
  _SpringSimulationChartPainter({
    required this.simulation,
    required this.elapsedTime,
    required this.isSpringing,
  });

  final SpringSimulation simulation;
  final Duration elapsedTime;
  final bool isSpringing;

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final red = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas
      ..drawRect(Rect.fromLTWH(0, 0, size.width, size.height), white)
      ..drawLine(Offset.zero, Offset(0, size.height), black)
      ..drawLine(
        Offset(0, size.height),
        Offset(size.width, size.height),
        black,
      );

    final springLine = Path()
      ..moveTo(0, size.height - (simulation.x(0) / _chartMax) * size.height);

    final pixelTimeStep = _durationsSecs / size.width;
    var simulatedElapsedTime = pixelTimeStep;
    for (var i = 1; i < size.width.round(); i++) {
      springLine.lineTo(
        i.toDouble(),
        size.height -
            (simulation.x(simulatedElapsedTime) / _chartMax) * size.height,
      );
      simulatedElapsedTime += pixelTimeStep;
    }

    canvas.drawPath(springLine, black);
    if (isSpringing && elapsedTime.inMilliseconds / 1000 < _durationsSecs) {
      final elapsedTimePixel =
          elapsedTime.inMilliseconds / 1000 / _durationsSecs * size.width;
      canvas.drawLine(
        Offset(elapsedTimePixel, 0),
        Offset(elapsedTimePixel, size.height),
        red,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpringSimulationChartPainter oldDelegate) {
    return elapsedTime != oldDelegate.elapsedTime &&
            (oldDelegate.elapsedTime.inMilliseconds / 1000 < _durationsSecs ||
                elapsedTime.inMilliseconds / 1000 < _durationsSecs) ||
        simulation != oldDelegate.simulation;
  }
}
