import 'package:flutter/material.dart';

import '../model/category_item.dart';
import '../model/transaction_model.dart';
import '../service/supabase_service.dart';

class TransactionsController extends ChangeNotifier {
  String searchQuery = '';
  String selectedCategory = 'Todas';
  List<CategoryItem> _categoryItems = [];
  List<TransactionModel> _transactions = [];
  bool isLoading = true;
  String? errorMessage;

  TransactionsController() {
    loadData();
  }

  List<String> get categories => [
        'Todas',
        ..._categoryItems.map((category) => category.name),
      ];

  List<TransactionModel> get _allTransactions => _transactions;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userId = await SupabaseService.currentProfileId();
      _categoryItems = await SupabaseService.categoriesForUser(userId);
      final rows = await SupabaseService.client
          .from('transacoes')
          .select('*, categorias(name)')
          .eq('user_id', userId)
          .order('occurred_at', ascending: false);
      _transactions = (rows as List)
          .map((row) => SupabaseService.transactionFromRow(
                Map<String, dynamic>.from(row),
              ))
          .toList();
      if (!categories.contains(selectedCategory)) {
        selectedCategory = 'Todas';
      }
    } catch (_) {
      errorMessage = 'Não foi possível carregar suas transações.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void refreshData() {
    loadData();
  }

  Map<String, List<TransactionModel>> get filteredAndGroupedTransactions {
    final filtered = _allTransactions.where((tx) {
      final query = searchQuery.toLowerCase();
      final matchesSearch = tx.title.toLowerCase().contains(query) ||
          tx.category.toLowerCase().contains(query);
      final matchesCategory = selectedCategory == 'Todas' ||
          tx.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final Map<String, List<TransactionModel>> grouped = {};
    for (final tx in filtered) {
      grouped.putIfAbsent(tx.dateGroup, () => []).add(tx);
    }
    return grouped;
  }
}
