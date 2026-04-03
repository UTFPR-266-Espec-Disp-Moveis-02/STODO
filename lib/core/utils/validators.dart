class AppValidators {
  /// Campo de texto obrigatório.
  static String? Function(String?) required({String message = 'Campo obrigatório'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  /// Seleção obrigatória (dropdown, icon selector, color selector).
  static String? Function(T?) requiredSelection<T>({String message = 'Selecione uma opção'}) {
    return (value) {
      if (value == null) return message;
      return null;
    };
  }

  /// Upload de arquivo obrigatório (imagem, documento, etc).
  static String? Function(String?) requiredFile({String message = 'Selecione uma imagem'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  /// Valida que o valor é um número inteiro entre 0 e [max].
  static String? Function(String?) pageNumber({required int max}) {
    return (value) {
      if (value == null || value.isEmpty) return 'Informe a página atual';
      final n = int.tryParse(value);
      if (n == null) return 'Apenas números são permitidos';
      if (n < 0) return 'Valor mínimo: 0';
      if (n > max) return 'Valor máximo: $max';
      return null;
    };
  }
}
