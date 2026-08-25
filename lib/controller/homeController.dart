import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../model/userModel.dart';

class HomeController extends ChangeNotifier {
  final UserModel usuario;

  HomeController({required this.usuario});

  // Estados da Tela
  bool _hideBalance = false;
  bool get hideBalance => _hideBalance;

  String _chartPeriod = 'Mês';
  String get chartPeriod => _chartPeriod;

  // Lê as transações atualizadas do MockDatabase
  // Retorna apenas as 3 últimas transações da lista
  List<TransactionModel> get recentTransactions {
    return MockDatabase.transacoes.take(3).toList();
  }

  // Cálculo dinâmico das receitas
  double get totalIncome {
    return MockDatabase.transacoes
        .where((t) => t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Cálculo dinâmico das despesas
  double get totalExpense {
    return MockDatabase.transacoes
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount.abs());
  }

  // Calcula o saldo total somando e subtraindo as movimentações do saldo base do usuário
  double get totalBalance => usuario.saldo + totalIncome - totalExpense;

  // Métodos / Ações
  void toggleHideBalance() {
    _hideBalance = !_hideBalance;
    notifyListeners();
  }

  void setChartPeriod(String newPeriod) {
    _chartPeriod = newPeriod;
    notifyListeners();
  }

  // Notifica a HomeView para reconstruir os cards e a lista
  void refreshData() {
    notifyListeners();
  }

  List<ChartDataModel> getChartData() {
    if (_chartPeriod == 'Dia') {
      return [
        ChartDataModel(label: '08:00', height: 0.3, isExpense: true),
        ChartDataModel(label: '12:00', height: 0.8, isExpense: false),
        ChartDataModel(label: '16:00', height: 0.2, isExpense: true),
        ChartDataModel(label: '20:00', height: 0.5, isExpense: true),
      ];
    } else if (_chartPeriod == 'Mês') {
      return [
        ChartDataModel(label: 'Sem 1', height: 0.4, isExpense: true),
        ChartDataModel(label: 'Sem 2', height: 0.9, isExpense: false),
        ChartDataModel(label: 'Sem 3', height: 0.3, isExpense: true),
        ChartDataModel(label: 'Sem 4', height: 0.6, isExpense: false),
      ];
    } else {
      return [
        ChartDataModel(label: 'Jan-Mar', height: 0.7, isExpense: false),
        ChartDataModel(label: 'Abr-Jun', height: 0.5, isExpense: true),
        ChartDataModel(label: 'Jul-Set', height: 0.8, isExpense: false),
        ChartDataModel(label: 'Out-Dez', height: 0.4, isExpense: true),
      ];
    }
  }
}