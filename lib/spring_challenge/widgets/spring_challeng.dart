import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

class SpringChallenge extends StatefulWidget {
  const SpringChallenge({super.key});

  @override
  State<SpringChallenge> createState() => _SpringChallengeState();
}

class _SpringChallengeState extends State<SpringChallenge>
    with SingleTickerProviderStateMixin {
  final _springDescription = const SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 15,
  );

  late Spring _spring;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _spring = Spring(
      tickerProvider: this,
      springDescription: _springDescription,
    )..addListener(() {
        setState(() {});
      });
  }

  void _onTapUp(TapUpDetails details) {
    _spring
      ..anchorPosition = details.localPosition
      ..startSpring();
  }

  void _onPanDown(DragDownDetails details) {
    //TODO: make ball pulse;
  }

  void _onPanStart(DragStartDetails details) {
    _spring.endSpring();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _spring.springPosition += details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    _spring.startSpring();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          setState(() {
            _isInitialized = true;
            _spring
              ..anchorPosition = box.size.center(Offset.zero)
              ..springPosition = _spring.anchorPosition;
          });
        }
      });
      return const SizedBox.expand();
    }

    return GestureDetector(
      onTapUp: _onTapUp,
      onPanDown: _onPanDown,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          _buildBackground(),
          CustomPaint(
            painter: WebPainter(
              anchorPosition: _spring.anchorPosition,
              springPosition: _spring.springPosition,
            ),
            size: Size.infinite,
          ),
          Transform.translate(
            offset: _spring.springPosition,
            child: FractionalTranslation(
              translation: const Offset(-.5, -.5),
              child: _buildBall(),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildBackground() => const SizedBox.expand(
        child: ColoredBox(
          color: Color.fromARGB(255, 11, 14, 55),
        ),
      );

  Container _buildBall() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.redAccent[400],
        shape: BoxShape.circle,
      ),
    );
  }
}

class Spring with ChangeNotifier {
  Spring({
    required TickerProvider tickerProvider,
    required SpringDescription springDescription,
  })  : _tickerProvider = tickerProvider,
        _springDescription = springDescription;

  final TickerProvider _tickerProvider;
  final SpringDescription _springDescription;
  late SpringSimulation _springSimX;
  late SpringSimulation _springSimY;
  Offset _previousVelocity = Offset.zero;

  late final Ticker _ticker = _tickerProvider.createTicker(_onTick);

  Offset get anchorPosition => _anchorPosition;
  Offset _anchorPosition = Offset.zero;
  set anchorPosition(Offset newAnchorPosition) {
    endSpring();
    _anchorPosition = newAnchorPosition;

    notifyListeners();
  }

  Offset get springPosition => _springPosition;
  Offset _springPosition = Offset.zero;
  set springPosition(Offset newSpringPosition) {
    endSpring();
    _springPosition = newSpringPosition;

    notifyListeners();
  }

  void startSpring() {
    _springSimX = SpringSimulation(
      _springDescription,
      springPosition.dx,
      _anchorPosition.dx,
      _previousVelocity.dx,
    );
    _springSimY = SpringSimulation(
      _springDescription,
      springPosition.dy,
      _anchorPosition.dy,
      _previousVelocity.dy,
    );

    _ticker.start();
  }

  void _onTick(Duration elapsedTime) {
    final _elapsedSecondsFraction = elapsedTime.inMilliseconds / 1000;

    _springPosition = Offset(
      _springSimX.x(_elapsedSecondsFraction),
      _springSimY.x(_elapsedSecondsFraction),
    );

    _previousVelocity = Offset(
      _springSimX.dx(_elapsedSecondsFraction),
      _springSimY.dx(_elapsedSecondsFraction),
    );

    if (_springSimX.isDone(_elapsedSecondsFraction) &&
        _springSimY.isDone(_elapsedSecondsFraction)) endSpring();

    notifyListeners();
  }

  void endSpring() {
    _ticker.stop();
  }
}

class WebPainter extends CustomPainter {
  WebPainter({
    required this.anchorPosition,
    required this.springPosition,
  });

  final Offset anchorPosition;
  final Offset springPosition;

  final springPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      anchorPosition,
      springPosition,
      springPaint,
    );
  }

  @override
  bool shouldRepaint(covariant WebPainter oldDelegate) {
    return anchorPosition != oldDelegate.anchorPosition ||
        springPosition != oldDelegate.springPosition;
  }
}
