import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/category_progress.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  DateTime _selectedDate = DateTime(2026, 8); // Mês/Ano padrão

  // Banco de dados simulado por mês
  final Map<String, List<Map<String, dynamic>>> _monthlyRawExpenses = {
    '2026-08': [
      {'title': 'Aluguel', 'category': 'Casa', 'amount': 1500.00, 'color': const Color(0xFF2C2C2C)},
      {'title': 'Feira semanal', 'category': 'Mercado', 'amount': 850.00, 'color': const Color(0xFF7A9BB0)},
      {'title': 'Combustível', 'category': 'Transporte', 'amount': 420.00, 'color': const Color(0xFFC08A75)},
      {'title': 'Lanche rápido', 'category': null, 'amount': 200.00, 'color': const Color(0xFF9E9E9E)}, // Sem categoria -> "Outros"
      {'title': 'Cinema', 'category': '', 'amount': 110.00, 'color': const Color(0xFF9E9E9E)}, // Vazio -> "Outros"
    ],
    '2026-07': [
      {'title': 'Supermercado', 'category': 'Mercado', 'amount': 1100.00, 'color': const Color(0xFF7A9BB0)},
      {'title': 'Luz e Água', 'category': 'Casa', 'amount': 450.00, 'color': const Color(0xFF2C2C2C)},
      {'title': 'Uber', 'category': 'Transporte', 'amount': 180.00, 'color': const Color(0xFFC08A75)},
      {'title': 'Presente', 'category': null, 'amount': 150.00, 'color': const Color(0xFF9E9E9E)},
    ],
  };

  // Processa as despesas: Agrupa por categoria e aplica o fallback "Outros"
  List<Map<String, dynamic>> _getProcessedCategories() {
    final key = DateFormat('yyyy-MM').format(_selectedDate);
    final rawList = _monthlyRawExpenses[key] ?? [];

    final Map<String, Map<String, dynamic>> aggregated = {};

    for (var item in rawList) {
      String catName = (item['category'] == null || (item['category'] as String).trim().isEmpty)
          ? 'Outros'
          : item['category'];

      Color color = catName == 'Outros' ? Colors.grey : (item['color'] as Color);

      if (aggregated.containsKey(catName)) {
        aggregated[catName]!['amount'] += (item['amount'] as double);
      } else {
        aggregated[catName] = {
          'name': catName,
          'amount': item['amount'] as double,
          'color': color,
        };
      }
    }

    // Retorna ordenado do maior para o menor gasto
    final result = aggregated.values.toList();
    result.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    return result;
  }

  // Calcula o total geral do mês
  double _calculateTotal(List<Map<String, dynamic>> categories) {
    return categories.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  // Abre o seletor de mês
  void _selectMonth() async {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    ).then((picked) {
      if (picked != null) {
        setState(() {
          _selectedDate = DateTime(picked.year, picked.month);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getProcessedCategories();
    final totalSpent = _calculateTotal(categories);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Relatórios de gastos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: _selectMonth,
            tooltip: 'Selecionar Mês',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibição do Mês Atual
            Center(
              child: Text(
                DateFormat('MMMM yyyy', 'pt_BR').format(_selectedDate),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Card Principal com Gráfico em Rosca
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Total gasto', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${totalSpent.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: categories.isEmpty
                          ? const Center(child: Text('Nenhum gasto neste mês'))
                          : PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: categories.map((cat) {
                                  return PieChartSectionData(
                                    color: cat['color'] as Color,
                                    value: cat['amount'] as double,
                                    title: '',
                                    radius: 40,
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Gastos mensais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lista das Categorias Mais Gastas
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: categories.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('Sem categorias gravadas')),
                      )
                    : Column(
                        children: categories.map((cat) {
                          return CategoryProgress(
                            categoryName: cat['name'],
                            amount: cat['amount'],
                            totalAmount: totalSpent,
                            color: cat['color'],
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}