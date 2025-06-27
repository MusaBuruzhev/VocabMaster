import 'term.dart';

class VocabSet {
  final String id;
  final String name;
  final List<Term> words;

  VocabSet({required this.id, required this.name, this.words = const []});

  VocabSet copyWith({String? id, String? name, List<Term>? words}) {
    return VocabSet(
      id: id ?? this.id,
      name: name ?? this.name,
      words: words ?? this.words,
    );
  }
}