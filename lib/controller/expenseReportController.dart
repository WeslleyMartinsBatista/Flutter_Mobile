import 'package:flutter/material.dart';
import '../database/mock_database.dart';

class ExpenseReportController extends ChangeNotifier {
  // Inicializa com o mês e ano atuais
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Busca no MockDatabase, filtra pelo mês selecionado e agrupa as categorias
  List<Map<String, dynamic>> getProcessedCategories() {
    final Map<String, Map<String, dynamic>> aggregated = {};

    // Tabela de cores para manter o padrão
    final Map<String, Color> categoryColors = {
      'Casa': const Color(0xFF2C2C2C),
      'Mercado': const Color(0xFF7A9BB0),
      'Transporte': const Color(0xFFC08A75),
      'Saúde': const Color(0xFFE57373),
      'Lazer': const Color(0xFF81C784),
    };

    // Percorre as transações reais do sistema
    for (var tx in MockDatabase.transacoes) {
      // Filtra apenas despesas E que sejam do mês/ano selecionado
      if (!tx.isIncome &&
          tx.date.year == _selectedDate.year &&
          tx.date.month == _selectedDate.month) {
        
        String catName = tx.category.trim().isEmpty ? 'Outros' : tx.category;
        Color color = categoryColors[catName] ?? Colors.grey;
        double amount = tx.amount.abs();

        if (aggregated.containsKey(catName)) {
          aggregated[catName]!['amount'] += amount;
        } else {
          aggregated[catName] = {
            'name': catName,
            'amount': amount,
            'color': color,
          };
        }
      }
    }

    // Retorna ordenado do maior para o menor gasto
    final result = aggregated.values.toList();
    result.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    return result;
  }

  // Calcula o total geral do mês baseado nos dados processados
  double get totalSpent {
    final categories = getProcessedCategories();
    return categories.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }
}