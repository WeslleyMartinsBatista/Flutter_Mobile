import 'package:flutter/material.dart';

import '../model/transaction_model.dart';
import '../service/supabase_service.dart';

class ExpenseReportController extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<TransactionModel> _transactions = [];
  bool isLoading = true;
  String? errorMessage;

  ExpenseReportController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    try {
      final userId = await SupabaseService.currentProfileId();
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
      errorMessage = null;
    } catch (_) {
      errorMessage = 'Não foi possível carregar o relatório.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    loadData();
    notifyListeners();
  }

  List<Map<String, dynamic>> getProcessedCategories() {
    final Map<String, Map<String, dynamic>> aggregated = {};
    final categoryColors = <String, Color>{
      'Casa': const Color(0xFF2C2C2C),
      'Mercado': const Color(0xFF7A9BB0),
      'Transporte': const Color(0xFFC08A75),
      'Saúde': const Color(0xFFE57373),
      'Lazer': const Color(0xFF81C784),
    };

    for (final tx in _transactions) {
      if (!tx.isIncome &&
          tx.date.year == _selectedDate.year &&
          tx.date.month == _selectedDate.month) {
        final category = tx.category.trim().isEmpty ? 'Outros' : tx.category;
        final amount = tx.amount.abs();
        if (aggregated.containsKey(category)) {
          aggregated[category]!['amount'] += amount;
        } else {
          aggregated[category] = {
            'name': category,
            'amount': amount,
            'color': categoryColors[category] ?? Colors.grey,
          };
        }
      }
    }

    final result = aggregated.values.toList();
    result.sort(
      (a, b) => (b['amount'] as double).compareTo(a['amount'] as double),
    );
    return result;
  }

  double get totalSpent {
    return getProcessedCategories().fold(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );
  }
}
