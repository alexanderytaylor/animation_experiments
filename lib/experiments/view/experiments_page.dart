import 'package:animation_experiments/glass_of_liquid/glass_of_liquid.dart';
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
                Navigator.of(context).push(GlassOfLiquidPage.route()),
            name: 'Glass of Liquid',
          ),
        ],
      ),
    );
  }
}

class ExperimentButton extends StatelessWidget {
  const ExperimentButton({
    super.key,
    required this.onPressed,
    required this.name,
  });

  final VoidCallback onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(20),
      ),
      onPressed: onPressed,
      child: Text(
        name,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
