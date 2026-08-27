import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';

class RegisterController {
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  UserModel? criarConta({
    required String nome,
    required String email,
    required String senha,
    required String confirmacaoSenha,
  }) {
    errorMessage.value = null;

    final nomeNormalizado = nome.trim();
    final emailNormalizado = email.trim().toLowerCase();

    if (nomeNormalizado.length < 2) {
      errorMessage.value = 'Informe seu nome completo.';
      return null;
    }

    final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(emailNormalizado);
    if (!emailValido) {
      errorMessage.value = 'Informe um e-mail válido.';
      return null;
    }

    if (senha.length < 6) {
      errorMessage.value = 'A senha deve ter pelo menos 6 caracteres.';
      return null;
    }

    if (senha != confirmacaoSenha) {
      errorMessage.value = 'As senhas não coincidem.';
      return null;
    }

    final emailJaCadastrado = MockDatabase.usuarios.any(
      (usuario) => usuario.email.toLowerCase() == emailNormalizado,
    );
    if (emailJaCadastrado) {
      errorMessage.value = 'Este e-mail já possui uma conta.';
      return null;
    }

    final novoUsuario = UserModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nome: nomeNormalizado,
      email: emailNormalizado,
      senha: senha,
      saldo: 0.0,
    );

    MockDatabase.usuarios.add(novoUsuario);
    return novoUsuario;
  }

  void dispose() {
    errorMessage.dispose();
  }
}
