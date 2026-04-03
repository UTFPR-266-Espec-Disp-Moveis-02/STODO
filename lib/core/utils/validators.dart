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

  /// Valida que o texto não ultrapassa [max] caracteres.
  static String? Function(String?) maxLength(int max, {String? message}) {
    return (value) {
      if (value != null && value.length > max) {
        return message ?? 'Máximo de $max caracteres';
      }
      return null;
    };
  }

  /// Encadeia múltiplos validators — retorna o primeiro erro encontrado.
  static String? Function(T?) compose<T>(List<String? Function(T?)> validators) {
    return (value) {
      for (final v in validators) {
        final error = v(value);
        if (error != null) return error;
      }
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
