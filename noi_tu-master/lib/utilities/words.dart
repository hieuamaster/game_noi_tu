class Word {
  final String text;
  final String chuan;
  final String head;
  final String tail;

  Word({this.text, this.chuan, this.head, this.tail});

  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'text': text,
      'chuan': chuan.toLowerCase(),
      'head': head.toLowerCase(),
      'tail': tail.toLowerCase(),
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.

  @override
  String toString() {
    return '$text';
  }
}
