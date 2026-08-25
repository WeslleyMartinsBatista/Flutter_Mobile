import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../model/userModel.dart';

class HomeController extends ChangeNotifier {
  final UserModel usuario;
  late double totalBalance;

  HomeController({required this.usuario}) {
    totalBalance = usuario.saldo;
  }

  // Estados da Tela
  bool _hideBalance = false;
  bool get hideBalance => _hideBalance;

  String _chartPeriod = 'Mês';
  String get chartPeriod => _chartPeriod;

  final double totalIncome = 4250.00;
  final double totalExpense = 390.70;

  // Métodos / Ações
  void toggleHideBalance() {
    _hideBalance = !_hideBalance;
    notifyListeners();
  }

  void setChartPeriod(String newPeriod) {
    _chartPeriod = newPeriod;
    notifyListeners();
  }

  // Dados Mockados
  final List<TransactionModel> recentTransactions = [
    TransactionModel(
      id: '1',
      title: 'Compras da semana',
      category: 'Mercado',
      amount: -384.20,
      dateGroup: 'Hoje',
      time: '20:15',
      icon: Icons.shopping_cart,
      iconColor: Colors.redAccent,
    ),
    TransactionModel(
      id: '2',
      title: 'Salário',
      category: 'Receita',
      amount: 4250.00,
      dateGroup: 'Hoje',
      time: '09:00',
      icon: Icons.attach_money,
      iconColor: Colors.green,
    ),
    TransactionModel(
      id: '3',
      title: 'Café',
      category: 'Alimentação',
      amount: -6.50,
      dateGroup: 'Hoje',
      time: '08:30',
      icon: Icons.local_cafe,
      iconColor: Colors.redAccent,
    ),
  ];

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