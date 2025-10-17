import 'package:flashcard_app/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/data/questions.dart';

class QuizScreen extends StatefulWidget {
  final String topic;

  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;

  void _nextQuestion() {
    if (_questionIndex < questions[widget.topic]!.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedAnswer = null;
      });
    } else {
      // Quiz finished
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: questions[widget.topic]!.length,
          ),
        ),
      );
    }
  }

  void _selectAnswer(String answer) {
    final currentQuestion = questions[widget.topic]![_questionIndex] as Map<String, Object>;
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] as int;
    final correctAnswer = (currentQuestion['answers'] as List<String>)[correctAnswerIndex];

    setState(() {
      _selectedAnswer = answer;
      if (answer == correctAnswer) {
        _score += currentQuestion['points'] as int;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[widget.topic]![_questionIndex] as Map<String, Object>;
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] as int;
    final correctAnswer = (currentQuestion['answers'] as List<String>)[correctAnswerIndex];
    final progress = (_questionIndex + 1) / questions[widget.topic]!.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Score: $_score', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              currentQuestion['question'] as String,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...(currentQuestion['answers'] as List<String>).map((answer) {
              final isSelected = _selectedAnswer == answer;
              final isCorrect = answer == correctAnswer;
              Color? buttonColor;
              if (isSelected) {
                buttonColor = isCorrect ? Colors.green : Colors.red;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: _selectedAnswer == null ? () => _selectAnswer(answer) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: buttonColor ?? Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      answer,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? _nextQuestion : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
