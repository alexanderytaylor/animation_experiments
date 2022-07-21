import 'dart:math';
import 'package:flutter/material.dart';

// From https://www.youtube.com/watch?v=oqIyVDuOvuI

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
  // Default starting values for skew, ratio and fullness
  double skew = 0.2;
  double ratio = 0.7;
  double fullness = 0.5;

// Slider label  textStyle
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
                      fullness: fullness,
                    ),
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

  // The ratio between the width of the top of the glass and the bottom of the
  // glass.
  final double ratio;

  // How skewed the glass is.
  final double skew;

  // How full of liquid the glass is.
  final double fullness;

// This method tells a CustomPainter what to paint.
  @override
  void paint(Canvas canvas, Size size) {
    // Glass paint object with an off white color and filled interior
    final glass = Paint()
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.fill;

    // Top of Milk paint object with a white color and filled interior
    final milkTop = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Milk body paint object with an almost white color and filled interior
    final milkColor = Paint()
      ..color = const Color.fromARGB(255, 235, 235, 235)
      ..style = PaintingStyle.fill;

    // Outline paint object with a stroke width that applies to the edge of a
    // shape.
    final black = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // size refers to the canvas size which in this case is dictated by the
    // bounding height and width of the SizedBox higher in the widget tree.

    // Rectangle to layout the top oval of the glass using its left, top, right
    // and bottom edges.
    final top = Rect.fromLTRB(0, 0, size.width, size.width * skew);

    // Rectangle to layout the bottom oval of the glass constructed from a
    // center coordinate (Offset), width and height.
    final bottom = Rect.fromCenter(
      center: Offset(size.width * .5, size.height - size.width * .5 * skew),
      width: size.width * ratio,
      height: size.width * skew * ratio,
    );

    // Rectangle to layout the top of the liquid. Constructed by linearly
    // interpolating between the 2 rectangles, top and bottom based on the
    // fullness  value.
    final liquidTop = Rect.lerp(bottom, top, fullness);

    // Defines the Path "outline" of the cup.
    final cupPath = Path()
      // Start at x coord: leftmost point of the top rectangle.
      //          y coord: middle of the top rectangle.
      ..moveTo(top.left, top.top + top.height * 0.5)
      // Using top rectangle bounds, arc from starting radian pi (left side of a
      // cirlce), sweeping by angle pi (to right side of circle) for top curve
      // of the cup.
      ..arcTo(top, pi, pi, true)
      // Straight line from last coordinate (middle right edge of top rectangle)
      // to x coord: rightmost point of bottom rectangle.
      //    y coord: middle of the bottom rect.
      // forming right edge of cup.
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      // Using bottom rectangle bounds, arc from right middle edge (0 radians)
      // to left most edge (pi) forming bottom curved edge of cup.
      ..arcTo(bottom, 0, pi, true)
      // Straight line from last coordinate (middle left edge of bottom
      // rectangle to x coord: leftmost point of top rectangle
      //              y coord: middle of top rectangle.
      // forming left edge of cup.
      ..lineTo(top.left, top.top + top.height * 0.5);

    // Defines the Path "outline" of the liquid.
    // Almost the same as the cup path except instead of using the top rectangle
    // the liquidTop rectangle is used instead.
    final liquidPath = Path()
      ..moveTo(liquidTop!.left, liquidTop.top + liquidTop.height * 0.5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * .5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * 0.5);

    // Draw the following onto the canvas:
    canvas
      // Using the cupPath outline and the glass filled paint object draw the
      // cup.
      ..drawPath(cupPath, glass)
      // Using the liquidPath outline and the milkColor filled paint object draw
      // the liquid inside the cup.
      ..drawPath(liquidPath, milkColor)
      // Using the liquidTop rectangle and the milkTop filled paint object draw
      // an oval for the top of the liquid.
      ..drawOval(liquidTop, milkTop)
      // Using the cupPath outline and the black stroke paint object draw the
      // edge of the cup.
      ..drawPath(cupPath, black)
      // Using the top rectangle and black stroked paitn object draw oval to
      // complete the front facing top rim of the cup.
      ..drawOval(top, black);
  }

  // This method tells a CustomPainter if it should rebuild.
  // You can set this to true but that is very expensive and inefficient making
  // it constantly rebuild.
  // Far more efficient to compare the old objects non fixed values (fullness,
  // skew and ratio) to the new values and repaint if they are differe.
  @override
  bool shouldRepaint(covariant GlassOfLiquid oldDelegate) {
    return oldDelegate.fullness != fullness ||
        oldDelegate.skew != skew ||
        oldDelegate.ratio != ratio;
  }
}
