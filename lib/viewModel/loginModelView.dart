import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';

class LoginViewModel {

  UserModel? fazerLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      print('Erro: E-mail ou senha não podem estar vazios.');
      return null;
    }

    try {
      final usuarioEncontrado = MockDatabase.usuarios.firstWhere(
        (user) =>
            user.email == email &&
            user.senha == password,
      );

      print(
        'Login realizado com sucesso para: ${usuarioEncontrado.nome}',
      );

      return usuarioEncontrado;

    } catch (e) {
      print('Erro: E-mail ou senha incorretos.');
      return null;
    }
  }
}
