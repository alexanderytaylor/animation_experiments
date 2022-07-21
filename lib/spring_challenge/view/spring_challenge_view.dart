import 'package:animation_experiments/spring_challenge/spring_challenge.dart';
import 'package:flutter/material.dart';

// From: https://www.youtube.com/watch?v=_4qyESnzRq8

class SpringChallengePage extends StatelessWidget {
  const SpringChallengePage({super.key});

  static Route<SpringChallengePage> route() {
    return MaterialPageRoute(
      builder: (context) => const SpringChallengePage(),
      settings: const RouteSettings(name: 'spidey-spring-challenge'),
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
        title: const Text('Spidey Spring Challenge'),
        backgroundColor: const Color.fromRGBO(177, 19, 19, 1),
      ),
      body: const SpideySpring(),
    );
  }
}
