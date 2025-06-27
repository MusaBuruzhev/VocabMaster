import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/vocab_manager.dart';

class TermEditorView extends StatefulWidget {
  final String setId;

  const TermEditorView({Key? key, required this.setId}) : super(key: key);

  @override
  State<TermEditorView> createState() => TermEditorViewState();
}

class TermEditorViewState extends State<TermEditorView> {
  final _originalController = TextEditingController();
  final _translationController = TextEditingController();

  void _addWord() {
    if (_originalController.text.isEmpty || _translationController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in both fields')),
        );
      }
      return;
    }
    Provider.of<VocabManager>(context, listen: false).addWord(
      widget.setId,
      _originalController.text,
      _translationController.text,
    );
    _originalController.clear();
    _translationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vocabManager = Provider.of<VocabManager>(context);
    final set = vocabManager.sets.firstWhere((s) => s.id == widget.setId);

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${set.name}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _originalController,
                        decoration: InputDecoration(
                          labelText: 'Original',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _translationController,
                        decoration: InputDecoration(
                          labelText: 'Translation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.teal),
                      onPressed: _addWord,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: set.words.isEmpty
                ? const Center(child: Text('No words yet. Add one!'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: set.words.length,
                    itemBuilder: (context, index) {
                      final word = set.words[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            word.original,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(word.translation),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}