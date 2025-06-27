import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/term.dart';
import '../data/vocab_set.dart';
import '../core/data_service.dart';

class VocabManager with ChangeNotifier {
  final DataService _dataService = DataService();
  List<VocabSet> _sets = [];

  List<VocabSet> get sets => _sets;

  Future<void> loadSets() async {
    _sets = await _dataService.loadSets();
    notifyListeners();
  }

  Future<void> addSet(String name) async {
    if (name.isEmpty) return;
    final newSet = VocabSet(id: const Uuid().v4(), name: name);
    _sets = [..._sets, newSet];
    await _dataService.saveSets(_sets);
    notifyListeners();
  }

  Future<void> addWord(String setId, String original, String translation) async {
    if (original.isEmpty || translation.isEmpty) return;
    final setIndex = _sets.indexWhere((set) => set.id == setId);
    if (setIndex == -1) return;
    final newWord = Term(
      id: const Uuid().v4(),
      original: original,
      translation: translation,
    );
    final updatedSet = _sets[setIndex].copyWith(
      words: [..._sets[setIndex].words, newWord],
    );
    _sets = [..._sets]..[setIndex] = updatedSet;
    await _dataService.saveSets(_sets);
    notifyListeners();
  }
}