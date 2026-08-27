import 'package:flutter/material.dart';
import '../model/userModel.dart'; 
import '../model/transaction_model.dart';
import '../model/category_item.dart';

class MockDatabase {
  static List<UserModel> usuarios = [
    UserModel(
      id: "1",
      nome: "Weslley Martins Batista",
      email: "weslley@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
    UserModel(
      id: "2",
      nome: "Juliano Grass",
      email: "juliano@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
    UserModel(
      id: "3",
      nome: "Gabriel Cortes",
      email: "gabriel@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
  ];

    static List<TransactionModel> transacoes = [];

  static List<CategoryItem> _defaultCategories() => [
        CategoryItem(name: 'Mercado', icon: Icons.shopping_cart_outlined),
        CategoryItem(name: 'Transporte', icon: Icons.directions_bus_outlined),
        CategoryItem(name: 'Refeição', icon: Icons.restaurant),
        CategoryItem(name: 'Casa', icon: Icons.home_outlined),
        CategoryItem(name: 'Saúde', icon: Icons.medical_services_outlined),
        CategoryItem(name: 'Lazer', icon: Icons.sports_esports_outlined),
        CategoryItem(name: 'Educação', icon: Icons.school_outlined),
      ];

  static final List<CategoryItem> categorias = _defaultCategories();

  static void clearAllData() {
    transacoes.clear();
    categorias
      ..clear()
      ..addAll(_defaultCategories());

    for (final usuario in usuarios) {
      usuario.saldo = 0.0;
    }
  }

}