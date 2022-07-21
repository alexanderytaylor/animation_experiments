import 'package:animation_experiments/experiments/experiments.dart';
import 'package:animation_experiments/friction_simulation/friction_simulation.dart';
import 'package:animation_experiments/glass_of_liquid/glass_of_liquid.dart';
import 'package:animation_experiments/spring_challenge/spring_challenge.dart';
import 'package:animation_experiments/spring_simulation/spring_simulation.dart';
import 'package:animation_experiments/thermometer/thermometer.dart';
import 'package:flutter/material.dart';

class ExperimentsPage extends StatelessWidget {
  const ExperimentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExperimentsView();
  }
}

class ExperimentsView extends StatelessWidget {
  const ExperimentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiments List'),
      ),
      body: ListView(
        children: [
          ExperimentButton(
            onPressed: () =>
                Navigator.of(context).push(ThermometerPage.route()),
            name: 'Thermometer',
          ),
          ExperimentButton(
            onPressed: () =>
                Navigator.of(context).push(GlassOfLiquidPage.route()),
            name: 'Glass of Liquid',
          ),
          ExperimentButton(
            onPressed: () =>
                Navigator.of(context).push(FrictionSimulationPage.route()),
            name: 'Friciton Simulation',
          ),
          ExperimentButton(
            onPressed: () =>
                Navigator.of(context).push(SpringSimulaitonPage.route()),
            name: 'Spring Simulation',
          ),
          ExperimentButton(
            onPressed: () =>
                Navigator.of(context).push(SpringChallengePage.route()),
            name: 'Spring Challenge',
          )
        ],
      ),
    );
  }
}
