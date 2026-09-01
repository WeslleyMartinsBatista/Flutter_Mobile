import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../service/supabase_service.dart';
import '../model/userModel.dart';

class LoginController {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);
  final ValueNotifier<UserModel?> currentUser = ValueNotifier(null);

  Future<bool> fazerLogin(String email, String password) async {
    errorMessage.value = null;
    final emailNormalizado = email.trim().toLowerCase();

    if (emailNormalizado.isEmpty || password.isEmpty) {
      errorMessage.value = 'E-mail e senha são obrigatórios!';
      return false;
    }

    isLoading.value = true;

    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: emailNormalizado,
        password: password,
      );

      currentUser.value = await SupabaseService.currentProfile();
      return true;
    } on AuthException catch (error) {
      errorMessage.value = _friendlyAuthError(error.message);
      return false;
    } catch (error, stackTrace) {
      debugPrint('Erro completo no login: $error');
      debugPrintStack(stackTrace: stackTrace);
      errorMessage.value = 'Erro do Supabase: $error';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyAuthError(String message) {
    final normalized = message.toLowerCase();
    if (normalized.contains('invalid login credentials')) {
      return 'E-mail ou senha incorretos!';
    }
    if (normalized.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar.';
    }
    return message;
  }

  Future<void> sair() async {
    await SupabaseService.client.auth.signOut();
    currentUser.value = null;
  }

  void dispose() {
    isLoading.dispose();
    errorMessage.dispose();
    currentUser.dispose();
  }
}
