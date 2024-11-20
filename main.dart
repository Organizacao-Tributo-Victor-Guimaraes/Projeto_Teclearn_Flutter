import 'package:flutter/material.dart';
import 'dart:math';

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
  bool isAnswerCorrect = false;

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

  late List<Map<String, Object>> questionQueue;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void shuffleOptions() {
    final currentOptions = questionQueue[currentQuestionIndex]['options'] as List<String>;
    currentOptions.shuffle(Random());
  }

  void handleAnswer(String selectedAnswer) {
    final correctAnswer = questionQueue[currentQuestionIndex]['correctAnswer'] as String;

    setState(() {
      isOptionSelected = true;
      isAnswerCorrect = (selectedAnswer == correctAnswer);

      if (!isAnswerCorrect) {
        lives--;
        if (lives == 0) {
          _showGameOverDialog();
        }
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (!isAnswerCorrect) {
        // Move a pergunta errada para o final da fila
        final incorrectQuestion = questionQueue.removeAt(currentQuestionIndex);
        questionQueue.add(incorrectQuestion);
      } else {
        // Se a resposta estiver correta, remover a pergunta da fila
        questionQueue.removeAt(currentQuestionIndex);
      }

      if (questionQueue.isEmpty) {
        // Se todas as perguntas foram respondidas corretamente
        _showWinDialog();
      } else {
        // Caso contrário, avançar para a próxima pergunta
        if (currentQuestionIndex >= questionQueue.length) {
          currentQuestionIndex = 0;
        }
        isOptionSelected = false;
        isAnswerCorrect = false;
        shuffleOptions();
      }
    });
  }

  void resetGame() {
    setState(() {
      currentQuestionIndex = 0;
      lives = 5;
      isOptionSelected = false;
      isAnswerCorrect = false;
      questionQueue = List.from(questions);
      shuffleOptions();
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
        content: Text('Você completou o quiz com sucesso.'),
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

  @override
  Widget build(BuildContext context) {
    if (questionQueue.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz com Vidas'),
        ),
        body: Center(
          child: Text(
            'Carregando...',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    final question = questionQueue[currentQuestionIndex];

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOptionSelected && option == question['correctAnswer']
                      ? Colors.green
                      : isOptionSelected && option != question['correctAnswer']
                      ? Colors.red
                      : null,
                ),
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
