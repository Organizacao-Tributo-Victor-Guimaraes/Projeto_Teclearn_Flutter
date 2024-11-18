import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int lives = 5;
  bool isOptionSelected = false;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Qual é a extensão padrão de arquivos JavaScript?',
      'options': ['html', 'json', 'js', 'css'],
      'correctAnswer': 'js',
    },
    {
      'question': 'Qual é o maior planeta do sistema solar?',
      'options': ['Terra', 'Marte', 'Júpiter', 'Saturno'],
      'correctAnswer': 'Júpiter',
    },
    {
      'question': 'Qual a variável para inteiros?',
      'options': ['float', 'int', 'double', 'char'],
      'correctAnswer': 'int',
    },
    {
      'question': 'Em Python, como você imprime algo na tela?',
      'options': ['echo()', 'System.out.println()', 'console.log()', 'print()'],
      'correctAnswer': 'print()',
    },
  ];

  void handleAnswer(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];

    setState(() {
      isOptionSelected = true;
      if (selectedAnswer != correctAnswer) {
        lives--;
        if (lives == 0) {
          _showGameOverDialog();
        }
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        isOptionSelected = false;
      } else {
        _showWinDialog();
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Você perdeu todas as vidas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Parabéns!'),
        content: Text('Você completou o quiz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              resetGame();
            },
            child: Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      currentQuestionIndex = 0;
      lives = 3;
      isOptionSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz com Vidas'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Vidas: $lives',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            question['question'] as String,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ...(question['options'] as List<String>).map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: ElevatedButton(
                onPressed: isOptionSelected
                    ? null
                    : () {
                  handleAnswer(option);
                },
                child: Text(option),
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isOptionSelected ? nextQuestion : null,
            child: Text('Próxima Pergunta'),
          ),
        ],
      ),
    );
  }
}
