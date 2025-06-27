import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/vocab_manager.dart';

class StudyView extends StatefulWidget {
  final String setId;

  const StudyView({Key? key, required this.setId}) : super(key: key);

  @override
  State<StudyView> createState() => StudyViewState();
}

class StudyViewState extends State<StudyView> with SingleTickerProviderStateMixin {
  bool _isFlashcardMode = true;
  int _currentIndex = 0;
  bool _showTranslation = false;
  List<String> _options = [];
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateOptions(String correctTranslation, List<String> allTranslations) {
    final random = Random();
    _options = [correctTranslation];
    while (_options.length < 4 && allTranslations.isNotEmpty) {
      final option = allTranslations[random.nextInt(allTranslations.length)];
      if (!_options.contains(option)) _options.add(option);
    }
    _options.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final vocabManager = Provider.of<VocabManager>(context);
    final set = vocabManager.sets.firstWhere((s) => s.id == widget.setId);
    final words = set.words;

    if (words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(set.name)),
        body: const Center(child: Text('No words in this set')),
      );
    }

    final currentWord = words[_currentIndex];
    if (_options.isEmpty && !_isFlashcardMode) {
      _generateOptions(currentWord.translation, words.map((w) => w.translation).toList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(set.name),
        actions: [
          IconButton(
            icon: Icon(_isFlashcardMode ? Icons.quiz : Icons.card_membership),
            onPressed: () {
              setState(() {
                _isFlashcardMode = !_isFlashcardMode;
                _showTranslation = false;
                _options = [];
                _controller.forward(from: 0);
              });
            },
          ),
        ],
      ),
      body: _isFlashcardMode
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _showTranslation = !_showTranslation;
                  _controller.forward(from: 0);
                });
              },
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Card(
                    child: Container(
                      width: 300,
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          _showTranslation ? currentWord.translation : currentWord.original,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        currentWord.original,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._options.map((option) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!mounted) return;
                          if (option == currentWord.translation) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Correct!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wrong!')),
                            );
                          }
                          setState(() {
                            _currentIndex = (_currentIndex + 1) % words.length;
                            _options = [];
                            _controller.forward(from: 0);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(option),
                      ),
                    )),
              ],
            ),
      floatingActionButton: _isFlashcardMode
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex + 1) % words.length;
                  _showTranslation = false;
                  _controller.forward(from: 0);
                });
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}