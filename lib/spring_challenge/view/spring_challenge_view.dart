import 'package:animation_experiments/spring_challenge/spring_challenge.dart';
import 'package:flutter/material.dart';

class SpringChallengePage extends StatelessWidget {
  const SpringChallengePage({super.key});

  static Route<SpringChallengePage> route() {
    return MaterialPageRoute(
      builder: (context) => const SpringChallengePage(),
      settings: const RouteSettings(name: 'spring-challenge'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SpringChallengeView();
  }
}

class SpringChallengeView extends StatelessWidget {
  const SpringChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spring Challenge'),
        backgroundColor: Colors.grey[800],
      ),
      body: const SpringChallenge(),
    );
  }
}
