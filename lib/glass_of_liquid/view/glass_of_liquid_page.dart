import 'dart:math';

import 'package:flutter/material.dart';

class GlassOfLiquidPage extends StatelessWidget {
  const GlassOfLiquidPage({super.key});

  static Route<GlassOfLiquidPage> route() {
    return MaterialPageRoute(
      builder: (context) => const GlassOfLiquidPage(),
      settings: const RouteSettings(name: 'glass-of-liquid'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const GlassOfLiquidView();
  }
}

class GlassOfLiquidView extends StatefulWidget {
  const GlassOfLiquidView({super.key});

  @override
  State<GlassOfLiquidView> createState() => _GlassOfLiquidViewState();
}

class _GlassOfLiquidViewState extends State<GlassOfLiquidView> {
  double skew = 0.2;
  double ratio = 0.7;
  double fullness = 0.5;
  static const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glass of Liquid'),
        backgroundColor: Colors.orange[700],
      ),
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 300,
                  child: CustomPaint(
                    painter: GlassOfLiquid(
                        skew: .01 + skew * .4,
                        ratio: ratio,
                        fullness: fullness),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: 700,
              child: Column(
                children: [
                  const Text(
                    'Tilt',
                    style: textStyle,
                  ),
                  Slider(
                    value: skew,
                    onChanged: (newVal) {
                      setState(() => skew = newVal);
                    },
                  ),
                  const Text(
                    'Base Width',
                    style: textStyle,
                  ),
                  Slider(
                    value: ratio,
                    onChanged: (newVal) {
                      setState(() => ratio = newVal);
                    },
                  ),
                  const Text(
                    'Fullness',
                    style: textStyle,
                  ),
                  Slider(
                    value: fullness,
                    onChanged: (newVal) {
                      setState(() => fullness = newVal);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlassOfLiquid extends CustomPainter {
  GlassOfLiquid({
    required this.ratio,
    required this.skew,
    required this.fullness,
  });

  final double ratio;
  final double skew;
  final double fullness;

  @override
  void paint(Canvas canvas, Size size) {
    final glass = Paint()
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.fill;
    final milkTop = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final milkColor = Paint()
      ..color = const Color.fromARGB(255, 235, 235, 235)
      ..style = PaintingStyle.fill;
    final black = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final top = Rect.fromLTRB(0, 0, size.width, size.width * skew);
    final bottom = Rect.fromCenter(
      center: Offset(size.width * .5, size.height - size.width * .5 * skew),
      width: size.width * ratio,
      height: size.width * skew * ratio,
    );

    final liquidTop = Rect.lerp(bottom, top, fullness);

    final cupPath = Path()
      ..moveTo(top.left, top.top + top.height * 0.5)
      ..arcTo(top, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(top.left, top.top + top.height * 0.5);

    final liquidPath = Path()
      ..moveTo(liquidTop!.left, liquidTop.top + liquidTop.height * 0.5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * 0.5);

    canvas
      ..drawPath(cupPath, glass)
      ..drawPath(liquidPath, milkColor)
      ..drawOval(liquidTop, milkTop)
      ..drawPath(cupPath, black)
      ..drawOval(top, black);
  }

  @override
  bool shouldRepaint(covariant GlassOfLiquid oldDelegate) {
    return oldDelegate.fullness != fullness ||
        oldDelegate.skew != skew ||
        oldDelegate.ratio != ratio;
  }
}
