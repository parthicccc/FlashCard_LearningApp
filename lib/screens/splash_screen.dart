import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flashcard_app/screens/topic_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SplashScreen({super.key, required this.toggleTheme});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TopicSelectionScreen(toggleTheme: widget.toggleTheme),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: const Icon(
                Icons.school,
                size: 100.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Welcome to Flashcard App!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your journey to knowledge begins now.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
