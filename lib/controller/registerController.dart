import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/supabase_service.dart';
import '../model/userModel.dart';

class RegisterController {
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<UserModel?> criarConta({
    required String nome,
    required String email,
    required String senha,
    required String confirmacaoSenha,
  }) async {
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

    try {
      final response = await SupabaseService.client.auth.signUp(
        email: emailNormalizado,
        password: senha,
        data: {'nome': nomeNormalizado},
      );

      if (response.user == null) {
        errorMessage.value = 'Não foi possível criar sua conta.';
        return null;
      }

      // Se a confirmação de e-mail estiver ativa, o perfil pode ser carregado
      // somente depois que o usuário confirmar a conta e entrar.
      if (response.session == null) {
        errorMessage.value =
            'Conta criada. Confirme seu e-mail antes de fazer login.';
        return null;
      }

      return await SupabaseService.currentProfile();
    } on AuthException catch (error) {
      errorMessage.value = _friendlyAuthError(error.message);
      return null;
    } catch (error) {
      errorMessage.value = 'Erro ao carregar o perfil: $error';
      return null;
    }
  }

  String _friendlyAuthError(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('already registered') ||
        normalized.contains('already exists')) {
      return 'Este e-mail já possui uma conta.';
    }
    return message;
  }

  void dispose() {
    errorMessage.dispose();
  }
}
