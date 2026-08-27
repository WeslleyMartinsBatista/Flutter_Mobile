import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/userModel.dart';
import '../model/category_item.dart';

class SettingsController extends ChangeNotifier {
  final UserModel usuario;

  SettingsController({required this.usuario});

  String get userName => usuario.nome;
  String get userEmail => usuario.email;

  List<CategoryItem> get categories => MockDatabase.categorias;

  void addCategory(String name) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) return;

    final alreadyExists = categories.any(
      (category) => category.name.toLowerCase() == normalizedName.toLowerCase(),
    );
    if (alreadyExists) return;

    categories.add(
      CategoryItem(
        name: normalizedName,
        icon: Icons.label_outline,
      ),
    );
    notifyListeners();
  }

  void removeCategory(CategoryItem category) {
    categories.remove(category);
    notifyListeners();
  }

  void clearAllData() {
    MockDatabase.clearAllData();
    notifyListeners();
  }

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