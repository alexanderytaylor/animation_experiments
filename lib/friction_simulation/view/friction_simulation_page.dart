import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// From https://www.youtube.com/watch?v=ABqgbKQTZBE

class FrictionSimulationPage extends StatelessWidget {
  const FrictionSimulationPage({super.key});

  static Route<FrictionSimulationPage> route() {
    return MaterialPageRoute(
      builder: (context) => const FrictionSimulationPage(),
      settings: const RouteSettings(name: 'friciton-simulation'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const FricitonSimulationView();
  }
}

class FricitonSimulationView extends StatelessWidget {
  const FricitonSimulationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friction Simulator'),
      ),
      backgroundColor: Colors.amber,
      body: const SlidingBlockExample(),
    );
  }
}

class SlidingBlockExample extends StatefulWidget {
  const SlidingBlockExample({super.key});

  @override
  State<SlidingBlockExample> createState() => _SlidingBlockExampleState();
}

class _SlidingBlockExampleState extends State<SlidingBlockExample>
    with TickerProviderStateMixin {
  late AnimationController blockAnimationController;
  double drag = 1;
  double position = 1;
  double velocity = 1;

  @override
  void initState() {
    super.initState();

    blockAnimationController = AnimationController.unbounded(vsync: this);
  }

  void _nudgeBlock() {
    final movingSimulation = FrictionSimulation(drag, position, velocity);
    blockAnimationController.animateWith(movingSimulation);
  }

  void _resetBlock() {
    final nonMovingSimulation = FrictionSimulation(0, 0, 0);
    blockAnimationController.animateWith(nonMovingSimulation);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: Column(
            children: [
              Slider(
                max: 10,
                value: drag,
                onChanged: (value) => setState(() => drag = value),
                label: 'Drag Coefficient: ${drag.toStringAsFixed(2)}',
                divisions: 1000,
              ),
              Slider(
                max: 10,
                value: position,
                onChanged: (value) => setState(() => position = value),
                label: 'Position: ${position.toStringAsFixed(2)}',
                divisions: 1000,
              ),
              Slider(
                max: 100,
                value: velocity,
                onChanged: (value) => setState(() => velocity = value),
                label: 'Velocity: ${velocity.toStringAsFixed(2)}',
                divisions: 1000,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height / 3,
          child: const ColoredBox(
            color: Colors.blue,
          ),
        ),
        AnimatedBuilder(
          animation: blockAnimationController,
          builder: (context, child) {
            return Positioned(
              height: 50,
              width: 50,
              bottom: screenSize.height / 3,
              left: screenSize.width / 4 - 25 + blockAnimationController.value,
              child: const ColoredBox(
                color: Colors.red,
              ),
            );
          },
        ),
        Positioned(
          bottom: screenSize.height / 6,
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _nudgeBlock,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[200],
                      onPrimary: Colors.black,
                    ),
                    child: const Text(
                      'NUDGE',
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetBlock,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[200],
                      onPrimary: Colors.black,
                    ),
                    child: const Text('RESET'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
