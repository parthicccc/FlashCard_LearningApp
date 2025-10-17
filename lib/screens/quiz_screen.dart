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
  List<String> _shuffledAnswers = [];

  @override
  void initState() {
    super.initState();
    final questionList = questions[widget.topic];
    if (questionList == null || questionList.isEmpty) {
      // If there are no questions, we can't shuffle answers.
      // The build method will handle showing an appropriate message.
      return;
    }
    _shuffleAnswers();
  }

  void _shuffleAnswers() {
    final questionList = questions[widget.topic];
    if (questionList == null || questionList.isEmpty) return;

    final currentQuestion = questionList[_questionIndex] as Map<String, Object>;
    final answers = List<String>.from(currentQuestion['answers'] as List<String>);
    answers.shuffle();
    _shuffledAnswers = answers;
  }

  void _nextQuestion() {
    final questionList = questions[widget.topic];
    if (questionList == null) return;

    if (_questionIndex < questionList.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedAnswer = null;
        _shuffleAnswers();
      });
    } else {
      // Quiz finished
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: questionList.length,
          ),
        ),
      );
    }
  }

  void _selectAnswer(String answer) {
    final questionList = questions[widget.topic];
    if (questionList == null) return;

    final currentQuestion = questionList[_questionIndex] as Map<String, Object>;
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] as int;
    final correctAnswer =
        (currentQuestion['answers'] as List<String>)[correctAnswerIndex];

    setState(() {
      _selectedAnswer = answer;
      if (answer == correctAnswer) {
        _score += currentQuestion['points'] as int;
        _showFloatingText('+10', Colors.green);
      } else {
        _score -= 10;
        _showFloatingText('-10', Colors.red);
      }
    });
  }

  void _showFloatingText(String text, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 50,
        left: MediaQuery.of(context).size.width / 2 - 50,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 1 - value,
              child: Transform.translate(
                offset: Offset(0, -value * 100),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionList = questions[widget.topic];

    if (questionList == null || questionList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic),
        ),
        body: const Center(
          child: Text('No questions available for this topic.'),
        ),
      );
    }

    final currentQuestion = questionList[_questionIndex] as Map<String, Object>;
    final correctAnswerIndex = currentQuestion['correctAnswerIndex'] as int;
    final correctAnswer =
        (currentQuestion['answers'] as List<String>)[correctAnswerIndex];
    final progress = (_questionIndex + 1) / questionList.length;

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
            Text('Score: $_score',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text(
                  currentQuestion['question'] as String,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._shuffledAnswers.map((answer) {
              final isSelected = _selectedAnswer == answer;
              final isCorrect = answer == correctAnswer;
              Color? buttonColor;
              if (isSelected) {
                buttonColor = isCorrect ? Colors.green : Colors.red;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap:
                      _selectedAnswer == null ? () => _selectAnswer(answer) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: buttonColor ??
                          Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      answer,
                      style: TextStyle(
                        color: buttonColor != null ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
