import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../model/userModel.dart';

class HomeController extends ChangeNotifier {
  final UserModel usuario;

  HomeController({required this.usuario});

  bool _hideBalance = false;
  bool get hideBalance => _hideBalance;

  String _chartPeriod = 'Mês';
  String get chartPeriod => _chartPeriod;

  List<TransactionModel> get recentTransactions {
    return MockDatabase.transacoes.take(3).toList();
  }

  double get totalIncome {
    return MockDatabase.transacoes
        .where((t) => t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return MockDatabase.transacoes
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount.abs());
  }

  double get totalBalance => usuario.saldo + totalIncome - totalExpense;

  void toggleHideBalance() {
    _hideBalance = !_hideBalance;
    notifyListeners();
  }

  void setChartPeriod(String newPeriod) {
    _chartPeriod = newPeriod;
    notifyListeners();
  }

  void refreshData() {
    notifyListeners();
  }

  // NOVO: Geração dinâmica de dados para o Gráfico de Pizza (Agrupado por categoria)
  List<Map<String, dynamic>> getPieChartData() {
    final Map<String, double> aggregated = {};
    
    for (var tx in MockDatabase.transacoes) {
      if (!tx.isIncome) { // Considera apenas despesas para a pizza
        String catName = tx.category.trim().isEmpty ? 'Outros' : tx.category;
        aggregated[catName] = (aggregated[catName] ?? 0) + tx.amount.abs();
      }
    }

    // Define cores predefinidas para categorias
    final Map<String, Color> categoryColors = {
      'Casa': const Color(0xFF2C2C2C),
      'Mercado': const Color(0xFF7A9BB0),
      'Transporte': const Color(0xFFC08A75),
      'Saúde': const Color(0xFFE57373),
      'Lazer': const Color(0xFF81C784),
    };

    return aggregated.entries.map((entry) {
      return {
        'name': entry.key,
        'amount': entry.value,
        'color': categoryColors[entry.key] ?? Colors.grey,
      };
    }).toList();
  }

  // ATUALIZADO: Gráfico de Barras totalmente dinâmico
  List<ChartDataModel> getChartData() {
    // Para simplificar a lógica dinâmica: comparamos as receitas vs despesas agrupadas
    double income = totalIncome;
    double expense = totalExpense;
    double maxAmount = income > expense ? income : expense;
    
    // Evita divisão por zero
    if (maxAmount == 0) maxAmount = 1;

    // Normaliza os valores (de 0.0 a 1.0) para desenhar a altura das barras
    if (_chartPeriod == 'Dia') {
      return [
        ChartDataModel(label: 'Manhã', height: (expense * 0.3) / maxAmount, isExpense: true),
        ChartDataModel(label: 'Tarde', height: (expense * 0.5) / maxAmount, isExpense: true),
        ChartDataModel(label: 'Noite', height: (expense * 0.2) / maxAmount, isExpense: true),
      ];
    } else if (_chartPeriod == 'Mês') {
      return [
        ChartDataModel(label: 'Receitas', height: income / maxAmount, isExpense: false),
        ChartDataModel(label: 'Despesas', height: expense / maxAmount, isExpense: true),
      ];
    } else {
      return [
        ChartDataModel(label: 'Total', height: income / maxAmount, isExpense: false),
        ChartDataModel(label: 'Gasto', height: expense / maxAmount, isExpense: true),
      ];
    }
  }
}