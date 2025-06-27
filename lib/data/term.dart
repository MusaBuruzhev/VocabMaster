class Term {
  final String id;
  final String original;
  final String translation;

  Term({required this.id, required this.original, required this.translation});

  Term copyWith({String? id, String? original, String? translation}) {
    return Term(
      id: id ?? this.id,
      original: original ?? this.original,
      translation: translation ?? this.translation,
    );
  }
}