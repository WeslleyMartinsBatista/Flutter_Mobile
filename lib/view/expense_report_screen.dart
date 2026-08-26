import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/category_progress.dart';
import '../controller/expenseReportController.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  late final ExpenseReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseReportController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Abre o seletor de mês
  void _selectMonth() async {
    showDatePicker(
      context: context,
      initialDate: _controller.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    ).then((picked) {
      if (picked != null) {
        _controller.setSelectedDate(DateTime(picked.year, picked.month));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pegamos as cores dinâmicas do tema
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final categories = _controller.getProcessedCategories();
        final totalSpent = _controller.totalSpent;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor, // Fundo dinâmico
          appBar: AppBar(
            backgroundColor: colorScheme.surface, // AppBar adaptável
            title: Text(
              'Relatórios de gastos', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: false,
            iconTheme: IconThemeData(color: colorScheme.onSurface), // Corrigido botão de voltar
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: colorScheme.onSurface),
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
                    DateFormat('MMMM yyyy', 'pt_BR').format(_controller.selectedDate).toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant, // Cinza dinâmico
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Principal com Gráfico em Rosca
                Card(
                  elevation: 0,
                  color: colorScheme.surface, // Fundo dinâmico
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Total gasto', 
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R\$ ${totalSpent.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28, 
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 180,
                          child: categories.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum gasto neste mês',
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                )
                              : PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: categories.map((cat) {
                                      return PieChartSectionData(
                                        color: cat['color'] as Color,
                                        value: cat['amount'] as double,
                                        title: cat['name'], // Adicionado o nome da categoria no gráfico
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
                Text(
                  'Gastos mensais',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                // Lista das Categorias Mais Gastas
                Card(
                  elevation: 0,
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: categories.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Sem categorias gravadas',
                                style: TextStyle(color: colorScheme.onSurface),
                              ),
                            ),
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
      },
    );
  }
}