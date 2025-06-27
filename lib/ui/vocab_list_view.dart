import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_manager.dart';
import '../state/theme_manager.dart';
import '../state/vocab_manager.dart';
import 'term_editor_view.dart';
import 'study_view.dart';

class VocabListView extends StatefulWidget {
  const VocabListView({super.key});

  @override
  _VocabListViewState createState() => _VocabListViewState();
}

class _VocabListViewState extends State<VocabListView> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VocabManager>(context, listen: false).loadSets();
    });
  }

  void _addSet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Vocabulary Set'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Set Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                Provider.of<VocabManager>(context, listen: false)
                    .addSet(_nameController.text);
                _nameController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Set name cannot be empty')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabManager = Provider.of<VocabManager>(context);
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Sets'),
        actions: [
          IconButton(
            icon: Icon(themeManager.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeManager.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthManager>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: vocabManager.sets.isEmpty
          ? const Center(child: Text('No sets yet. Add one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: vocabManager.sets.length,
              itemBuilder: (context, index) {
                final set = vocabManager.sets[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      set.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermEditorView(setId: set.id),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudyView(setId: set.id),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSet,
        child: const Icon(Icons.add),
      ),
    );
  }
}