import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';

class SettingsController extends ChangeNotifier {
  final UserModel usuario;

  SettingsController({required this.usuario});

  String get userName => usuario.nome;
  String get userEmail => usuario.email;

  // Retorna as iniciais do nome (ex: "JS")
  String get initials {
    List<String> names = usuario.nome.trim().split(' ');
    if (names.isEmpty) return "";
    if (names.length == 1) return names[0][0].toUpperCase();
    return "${names[0][0]}${names.last[0]}".toUpperCase();
  }

  // Atualiza os dados no objeto local e sincroniza no MockDatabase
  void updateProfile(String newName, String newEmail) {
    if (newName.trim().isEmpty || newEmail.trim().isEmpty) return;

    // Procura o usuário no MockDatabase e atualiza
    final index = MockDatabase.usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      final updatedUser = UserModel(
        id: usuario.id,
        nome: newName.trim(),
        email: newEmail.trim(),
        senha: usuario.senha,
        saldo: usuario.saldo,
      );

      MockDatabase.usuarios[index] = updatedUser;
      
      // Atualiza a instância do controlador
      usuario.nome = updatedUser.nome;
      usuario.email = updatedUser.email;

      notifyListeners();
    }
  }
}