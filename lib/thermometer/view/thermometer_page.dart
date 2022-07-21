import 'package:flutter/material.dart';

// From https://www.youtube.com/watch?v=NPmFoz56G3g
class ThermometerPage extends StatelessWidget {
  const ThermometerPage({super.key});

  static Route<ThermometerPage> route() {
    return MaterialPageRoute(
      builder: (context) => const ThermometerPage(),
      settings: const RouteSettings(name: 'thermometer'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ThermometerView();
  }
}

class ThermometerView extends StatefulWidget {
  const ThermometerView({super.key});

  @override
  State<ThermometerView> createState() => _ThermometerViewState();
}

class _ThermometerViewState extends State<ThermometerView> {
  double fullness = .5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text('Thermometer'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 400,
                  width: 150,
                  child: Thermometer(fullness: fullness),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: 700,
              child: Slider(
                value: fullness,
                onChanged: (newVal) => setState(() => fullness = newVal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Thermometer extends StatelessWidget {
  const Thermometer({super.key, required this.fullness});

  final double fullness;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ThermometerPainter(fullness),
    );
  }
}

class _ThermometerPainter extends CustomPainter {
  _ThermometerPainter(this.fullness);

  final double fullness;
  @override
  void paint(Canvas canvas, Size size) {
    final bulbRadius = size.width / 2;
    final stemHeight = size.height - bulbRadius;
    final stemWidth = bulbRadius;
    const inset = 10.0;
    final bulbCenter = Offset(size.width / 2, size.height - bulbRadius);

    final glassContainer = Paint()
      ..color = const Color(0xffcfe2f3)
      ..style = PaintingStyle.fill;
    final mercury = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final glassStem = Rect.fromCenter(
      center: Offset(size.width / 2, stemHeight / 2),
      width: stemWidth,
      height: stemHeight,
    );

    final fullContents = glassStem.deflate(inset);
    final emptyContents = Rect.fromCenter(
      center: bulbCenter,
      width: stemWidth - (inset * 2),
      height: bulbRadius,
    );

    final mercuryTop = Rect.lerp(emptyContents, fullContents, fullness);

    canvas
      ..drawRect(glassStem, glassContainer)
      ..drawCircle(bulbCenter, bulbRadius, glassContainer)
      ..drawRect(mercuryTop!, mercury)
      ..drawCircle(bulbCenter, bulbRadius - inset, mercury);
  }

  @override
  bool shouldRepaint(covariant _ThermometerPainter oldDelegate) =>
      oldDelegate.fullness != fullness;
}
