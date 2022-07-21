import 'package:animation_experiments/spring_simulation/spring_simulation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/physics.dart';

// From https://www.youtube.com/watch?v=O8Z5Ebx6xSY&t=242s

class SpringSimulaitonPage extends StatelessWidget {
  const SpringSimulaitonPage({super.key});

  static Route<SpringSimulaitonPage> route() {
    return MaterialPageRoute(
      builder: (context) => const SpringSimulaitonPage(),
      settings: const RouteSettings(name: 'spring-simulation'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SpringSimulationView();
  }
}

class SpringSimulationView extends StatelessWidget {
  const SpringSimulationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spring Simulation'),
      ),
      backgroundColor: Colors.amber,
      body: const SpringingBlockExample(),
    );
  }
}

class SpringingBlockExample extends StatefulWidget {
  const SpringingBlockExample({super.key});

  @override
  State<SpringingBlockExample> createState() => _SpringingBlockExampleState();
}

class _SpringingBlockExampleState extends State<SpringingBlockExample>
    with TickerProviderStateMixin {
  late AnimationController blockAnimationController;
  double mass = 5;
  double stiffness = 50;
  double damping = 1;

  late SpringSimulation displayedSpringSimulation;
  bool isSpringing = false;

  @override
  void initState() {
    super.initState();

    blockAnimationController = AnimationController.unbounded(vsync: this);

    _recalculateDisplayedSpringSimulation();
  }

  void _nudgeBlock() {
    final nudgeSimulation = FrictionSimulation(
      0.2,
      0,
      320,
    );
    blockAnimationController.animateWith(nudgeSimulation);
    isSpringing = false;
  }

  void _resetBlock() {
    final nonMovingSimulation = FrictionSimulation(0, 0, 0);
    blockAnimationController.animateWith(nonMovingSimulation);
    isSpringing = false;
  }

  void _springBack() {
    final springDesc =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);
    final springSim =
        SpringSimulation(springDesc, blockAnimationController.value, 0, 0);
    blockAnimationController.animateWith(springSim);
    isSpringing = true;
  }

  void _recalculateDisplayedSpringSimulation() {
    final desc =
        SpringDescription(mass: mass, stiffness: stiffness, damping: damping);

    setState(() {
      displayedSpringSimulation = SpringSimulation(desc, 200, 0, 0);
    });
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
              Row(
                children: [
                  const Text('Mass'),
                  Slider(
                    max: 10,
                    value: mass,
                    onChanged: (val) {
                      setState(() {
                        mass = val;
                        _recalculateDisplayedSpringSimulation();
                      });
                    },
                  ),
                  Text(mass.toStringAsFixed(2))
                ],
              ),
              Row(
                children: [
                  const Text('Stiffness'),
                  Slider(
                    max: 100,
                    value: stiffness,
                    onChanged: (val) {
                      setState(() {
                        stiffness = val;
                        _recalculateDisplayedSpringSimulation();
                      });
                    },
                  ),
                  Text(stiffness.toStringAsFixed(2))
                ],
              ),
              Row(
                children: [
                  const Text('Damping'),
                  Slider(
                    max: 2,
                    value: damping,
                    onChanged: (val) {
                      setState(() {
                        damping = val;
                        _recalculateDisplayedSpringSimulation();
                      });
                    },
                  ),
                  Text(damping.toStringAsFixed(2))
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                width: 200,
                child: AnimatedBuilder(
                  animation: blockAnimationController,
                  builder: (context, snapshot) {
                    return SpringSimulationChart(
                      simulation: displayedSpringSimulation,
                      elapsedTime: blockAnimationController.isAnimating
                          ? blockAnimationController.lastElapsedDuration!
                          : Duration.zero,
                      isSpringing: isSpringing,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height / 3,
          child: const ColoredBox(color: Colors.blue),
        ),
        AnimatedBuilder(
          animation: blockAnimationController,
          builder: (context, snapshot) {
            return Positioned(
              height: 50,
              width: 50,
              bottom: screenSize.height / 3,
              left: screenSize.width / 4 - 25 + blockAnimationController.value,
              child: const ColoredBox(color: Colors.red),
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
                    child: const Text('NUDGE'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetBlock,
                    child: const Text('RESET'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _springBack,
                    child: const Text('SPRING BACK'),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
