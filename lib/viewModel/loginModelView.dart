import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';

class LoginViewModel {
  
  bool fazerLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      print('Erro: E-mail ou senha não podem estar vazios.');
      return false;
    }

    try {
      // O <UserModel> garante que o Dart reconheça 'email' e 'senha'
      final usuarioEncontrado = MockDatabase.usuarios.firstWhere(
        (user) => user.email == email && user.senha == password
      );

      print('Login realizado com sucesso para: ${usuarioEncontrado.nome}');
      return true;

    } catch (e) {
      print('Erro: E-mail ou senha incorretos.');
      return false;
    }
  }
}
