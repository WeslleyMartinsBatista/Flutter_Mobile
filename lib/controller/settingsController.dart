import 'package:flutter/material.dart';

import '../model/category_item.dart';
import '../model/userModel.dart';
import '../service/supabase_service.dart';

class SettingsController extends ChangeNotifier {
  final UserModel usuario;
  List<CategoryItem> _categories = [];
  bool isLoading = true;
  String? errorMessage;

  SettingsController({required this.usuario}) {
    loadCategories();
  }

  String get userName => usuario.nome;
  String get userEmail => usuario.email;
  List<CategoryItem> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _categories = await SupabaseService.categoriesForUser(
        int.parse(usuario.id),
      );
      notifyListeners();
    } catch (_) {
      errorMessage = 'Não foi possível carregar suas categorias.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCategory(String name) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty ||
        _categories.any(
          (category) =>
              category.name.toLowerCase() == normalizedName.toLowerCase(),
        )) {
      return false;
    }

    try {
      await SupabaseService.client.from('categorias').insert({
        'user_id': int.parse(usuario.id),
        'name': normalizedName,
        'icon_name': 'label_outline',
      });
      await loadCategories();
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível adicionar a categoria.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCategory(CategoryItem category) async {
    try {
      await SupabaseService.client
          .from('categorias')
          .delete()
          .eq('user_id', int.parse(usuario.id))
          .eq('name', category.name);
      await loadCategories();
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível excluir a categoria.';
      notifyListeners();
      return false;
    }
  }

  Future<void> clearAllData() async {
    final userId = int.parse(usuario.id);
    await SupabaseService.client.from('transacoes').delete().eq('user_id', userId);
    await SupabaseService.client.from('categorias').delete().eq('user_id', userId);
    await SupabaseService.client
        .from('usuario')
        .update({'saldo': 0.00})
        .eq('id', userId);
    usuario.saldo = 0.0;
    _categories = [];
    notifyListeners();
  }

  String get initials {
    final names = usuario.nome.trim().split(' ');
    if (names.isEmpty || names.first.isEmpty) return '';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names.last[0]}'.toUpperCase();
  }

  Future<bool> updateProfile(String newName, String newEmail) async {
    final name = newName.trim();
    final email = newEmail.trim().toLowerCase();
    if (name.isEmpty || email.isEmpty) return false;

    try {
      await SupabaseService.client
          .from('usuario')
          .update({'nome': name, 'email': email})
          .eq('id', int.parse(usuario.id));
      usuario.nome = name;
      usuario.email = email;
      notifyListeners();
      return true;
    } catch (_) {
      errorMessage = 'Não foi possível atualizar o perfil.';
      notifyListeners();
      return false;
    }
  }
}
