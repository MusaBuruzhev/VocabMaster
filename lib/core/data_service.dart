import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/term.dart';
import '../data/vocab_set.dart';

class DataService {
  static const String _setsKey = 'vocab_sets';

  Future<void> saveSets(List<VocabSet> sets) async {
    final prefs = await SharedPreferences.getInstance();
    final setsJson = sets
        .map((set) => {
              'id': set.id,
              'name': set.name,
              'words': set.words
                  .map((word) => {
                        'id': word.id,
                        'original': word.original,
                        'translation': word.translation,
                      })
                  .toList(),
            })
        .toList();
    await prefs.setString(_setsKey, jsonEncode(setsJson));
  }

  Future<List<VocabSet>> loadSets() async {
    final prefs = await SharedPreferences.getInstance();
    final setsJson = prefs.getString(_setsKey);
    if (setsJson == null) return [];
    final List<dynamic> decoded = jsonDecode(setsJson);
    return decoded
        .map((set) => VocabSet(
              id: set['id'],
              name: set['name'],
              words: (set['words'] as List)
                  .map((word) => Term(
                        id: word['id'],
                        original: word['original'],
                        translation: word['translation'],
                      ))
                  .toList(),
            ))
        .toList();
  }
}