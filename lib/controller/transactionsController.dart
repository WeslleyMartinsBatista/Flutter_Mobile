import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../database/mock_database.dart'; // Ou sua lista de mock

class TransactionsController extends ChangeNotifier {
  String searchQuery = '';
  String selectedCategory = 'Todas';

  final List<String> categories = [
    'Todas',
    'Receita',
    'Mercado',
    'Transporte',
    'Lazer',
  ];

  // Consome as transações (agora dinâmicas)
  List<TransactionModel> get _allTransactions => MockDatabase.transacoes;

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // Lógica de filtragem e agrupamento por data
  Map<String, List<TransactionModel>> get filteredAndGroupedTransactions {
    final filtered = _allTransactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
                            tx.category.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Todas' || tx.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final Map<String, List<TransactionModel>> grouped = {};
    for (var tx in filtered) {
      if (!grouped.containsKey(tx.dateGroup)) {
        grouped[tx.dateGroup] = [];
      }
      grouped[tx.dateGroup]!.add(tx);
    }
    return grouped;
  }
}