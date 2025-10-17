import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / (totalQuestions * 10)) * 100;
    final bool isPassed = percentage >= 50;
    final String message = isPassed
        ? 'Congratulations! You passed.'
        : 'Keep practicing! You can do better.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20.0),
              Text(
                '$score / ${totalQuestions * 10}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
              ),
              const SizedBox(height: 20.0),
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20.0),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.replay),
                label: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
