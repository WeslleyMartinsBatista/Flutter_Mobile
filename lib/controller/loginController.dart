import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';

class LoginController {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final ValueNotifier<UserModel?> currentUser = ValueNotifier(null);

  Future<bool> fazerLogin(String email, String password) async {
    errorMessage.value = null;

    final emailTrimmed = email.trim().toLowerCase();

    if (emailTrimmed.isEmpty || password.isEmpty) {
      errorMessage.value = 'E-mail e senha são obrigatórios!';
      return false;
    }

    isLoading.value = true;

    // Simulando requisição
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final usuarioEncontrado = MockDatabase.usuarios.firstWhere(
        (user) =>
            user.email.toLowerCase() == emailTrimmed && user.senha == password,
      );

      currentUser.value = usuarioEncontrado;
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'E-mail ou senha incorretos!';
      isLoading.value = false;
      return false;
    }
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    currentUser.dispose();
  }
}