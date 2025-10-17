import 'package:flutter/material.dart';
import 'package:flashcard_app/screens/quiz_screen.dart';

class TopicSelectionScreen extends StatelessWidget {
  final VoidCallback toggleTheme;

  const TopicSelectionScreen({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Topic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English Words'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizScreen(topic: 'English Words'),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Science Facts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizScreen(topic: 'Science Facts'),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Math Formulas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizScreen(topic: 'Math Formulas'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
