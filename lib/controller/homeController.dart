import 'package:flutter/material.dart';

import '../model/chart_data_model.dart';
import '../model/transaction_model.dart';
import '../model/userModel.dart';
import '../service/supabase_service.dart';

class HomeController extends ChangeNotifier {
  final UserModel usuario;
  List<TransactionModel> _transactions = [];
  bool isLoading = true;
  String? errorMessage;

  HomeController({required this.usuario}) {
    loadData();
  }

  bool _hideBalance = false;
  bool get hideBalance => _hideBalance;

  String _chartPeriod = 'Mês';
  String get chartPeriod => _chartPeriod;

  List<TransactionModel> get recentTransactions => _transactions.take(3).toList();

  double get totalIncome => _transactions
      .where((transaction) => transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  double get totalExpense => _transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());

  double get totalBalance => usuario.saldo + totalIncome - totalExpense;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final profileRow = await SupabaseService.currentProfileRow();
      usuario.nome = (profileRow['nome'] ?? usuario.nome).toString();
      usuario.email = (profileRow['email'] ?? usuario.email).toString();
      usuario.saldo = (profileRow['saldo'] as num?)?.toDouble() ?? 0.0;

      final rows = await SupabaseService.client
          .from('transacoes')
          .select('*, categorias(name)')
          .eq('user_id', int.parse(usuario.id))
          .order('occurred_at', ascending: false);

      _transactions = (rows as List)
          .map((row) => SupabaseService.transactionFromRow(
                Map<String, dynamic>.from(row),
              ))
          .toList();
    } catch (_) {
      errorMessage = 'Não foi possível carregar seus dados.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshData() {
    loadData();
  }

  void toggleHideBalance() {
    _hideBalance = !_hideBalance;
    notifyListeners();
  }

  void setChartPeriod(String newPeriod) {
    _chartPeriod = newPeriod;
    notifyListeners();
  }

  List<Map<String, dynamic>> getPieChartData() {
    final Map<String, double> aggregated = {};
    for (final tx in _transactions) {
      if (!tx.isIncome) {
        final category = tx.category.trim().isEmpty ? 'Outros' : tx.category;
        aggregated[category] = (aggregated[category] ?? 0) + tx.amount.abs();
      }
    }

    final colors = <String, Color>{
      'Casa': const Color(0xFF2C2C2C),
      'Mercado': const Color(0xFF7A9BB0),
      'Transporte': const Color(0xFFC08A75),
      'Saúde': const Color(0xFFE57373),
      'Lazer': const Color(0xFF81C784),
    };

    return aggregated.entries
        .map((entry) => {
              'name': entry.key,
              'amount': entry.value,
              'color': colors[entry.key] ?? Colors.grey,
            })
        .toList();
  }

  List<ChartDataModel> getChartData() {
    double income = totalIncome;
    double expense = totalExpense;
    double maxAmount = income > expense ? income : expense;
    if (maxAmount == 0) maxAmount = 1;

    if (_chartPeriod == 'Dia') {
      return [
        ChartDataModel(label: 'Manhã', height: (expense * 0.3) / maxAmount, isExpense: true),
        ChartDataModel(label: 'Tarde', height: (expense * 0.5) / maxAmount, isExpense: true),
        ChartDataModel(label: 'Noite', height: (expense * 0.2) / maxAmount, isExpense: true),
      ];
    }

    if (_chartPeriod == 'Mês') {
      return [
        ChartDataModel(label: 'Receitas', height: income / maxAmount, isExpense: false),
        ChartDataModel(label: 'Despesas', height: expense / maxAmount, isExpense: true),
      ];
    }

    return [
      ChartDataModel(label: 'Total', height: income / maxAmount, isExpense: false),
      ChartDataModel(label: 'Gasto', height: expense / maxAmount, isExpense: true),
    ];
  }
}
