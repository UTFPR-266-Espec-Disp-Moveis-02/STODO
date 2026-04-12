import 'package:flutter/material.dart';
import 'package:stodo/core/themes/colors.dart';

enum BookStatus {
  wantToRead('Quero Ler', AppColors.gray200, Icons.bookmark_outline),
  reading('Lendo', AppColors.primary, Icons.menu_book),
  read('Lido', AppColors.topicColor3, Icons.check_circle_outline),
  rereading('Relendo', AppColors.topicColor5, Icons.replay);

  final String label;
  final Color color;
  final IconData icon;

  const BookStatus(this.label, this.color, this.icon);

  String toDbString() => name;

  static BookStatus fromDbString(String name) {
    return BookStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BookStatus.wantToRead,
    );
  }

  /// Regras de negócio aplicadas ao mudar o status:
  /// - [read]      → página atual = total de páginas (terminou)
  /// - [wantToRead]→ página atual = 0 (não iniciou)
  /// - [rereading] → página atual = 0 (recomeça do início)
  /// - [reading]   → mantém a página atual
  int applyPageRule(int currentPage, int totalPages) {
    switch (this) {
      case BookStatus.read:
        return totalPages;
      case BookStatus.wantToRead:
        return 0;
      case BookStatus.rereading:
        return 0;
      case BookStatus.reading:
        return currentPage;
    }
  }
}