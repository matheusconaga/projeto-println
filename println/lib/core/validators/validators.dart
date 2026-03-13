
class Validators {
  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail obrigatório';
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validarUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username é obrigatório';
    }
    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? validarConfirmacaoSenha(String? senha, String? confirmacao) {
    if (confirmacao == null || confirmacao.isEmpty) {
      return 'Confirmação de senha obrigatória';
    }
    if (senha != confirmacao) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}