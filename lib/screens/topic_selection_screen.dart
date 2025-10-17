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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildTopicCard(context, 'English Words', Icons.book, Colors.blue),
            _buildTopicCard(
                context, 'Science Facts', Icons.science, Colors.green),
            _buildTopicCard(
                context, 'Math Formulas', Icons.calculate, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
      BuildContext context, String topic, IconData icon, Color color) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: color.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(topic: topic),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            const SizedBox(height: 16.0),
            Text(
              topic,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
