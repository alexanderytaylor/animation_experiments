import 'package:flutter/material.dart';

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
