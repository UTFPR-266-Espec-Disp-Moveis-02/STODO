enum BookStatus {
  reading('Lendo'),
  read('Lido'),
  rereading('Relendo'),
  wantToRead('Quero Ler');

  final String label;
  const BookStatus(this.label);

  String toDbString() => name;

  static BookStatus fromDbString(String name) {
    return BookStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BookStatus.wantToRead,
    );
  }
}