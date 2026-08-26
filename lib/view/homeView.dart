import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controller/homeController.dart';
import '../widgets/balance_card.dart';
import '../widgets/summary_cards.dart';
import '../widgets/recent_transactions_section.dart';
import 'addTransactionView.dart';
import 'settingsView.dart';
import 'expense_report_screen.dart';
import 'transactionsView.dart';
import '../model/userModel.dart';

class HomeView extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final UserModel usuario;

  const HomeView({
    super.key,
    required this.themeNotifier,
    required this.usuario,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(usuario: widget.usuario);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddTransactionModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTransactionView(),
      ),
    );

    if (result == true) {
      _controller.refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final categoriasPizza = _controller.getPieChartData();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsView(
                          themeNotifier: widget.themeNotifier,
                          usuario: _controller.usuario,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    child: Icon(Icons.person, color: colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${_controller.usuario.nome.split(' ').first}',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bem-vindo de volta',
                      style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _controller.hideBalance
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: colorScheme.onSurface,
                ),
                onPressed: _controller.toggleHideBalance,
                tooltip: 'Ocultar Saldo',
              ),
              IconButton(
                icon: Icon(Icons.notifications_none, color: colorScheme.onSurface),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: colorScheme.onSurface),
                color: colorScheme.surface,
                onSelected: (value) {
                  if (value == 'relatorios') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpenseReportScreen(),
                      ),
                    );
                  }
                  if (value == 'transacoes') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionsView(),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'relatorios',
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart, color: colorScheme.onSurface),
                        const SizedBox(width: 12),
                        Text('Relatórios de gastos', style: TextStyle(color: colorScheme.onSurface)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'transacoes',
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, color: colorScheme.onSurface),
                        const SizedBox(width: 12),
                        Text('Transações', style: TextStyle(color: colorScheme.onSurface)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  BalanceCard(
                    totalBalance: _controller.totalBalance,
                    hideBalance: _controller.hideBalance,
                  ),
                  const SizedBox(height: 20),
                  SummaryCards(
                    totalIncome: _controller.totalIncome,
                    totalExpense: _controller.totalExpense,
                    hideBalance: _controller.hideBalance,
                  ),
                  const SizedBox(height: 24),
                  
                  // Transações Recentes agora vem antes do gráfico
                  RecentTransactionsSection(
                    transactions: _controller.recentTransactions,
                    hideBalance: _controller.hideBalance,
                  ),
                  const SizedBox(height: 24),

                  // Gráfico de Pizza movido para baixo e com Nomes
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(
                            theme.brightness == Brightness.dark ? 0.45 : 0.12,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Despesas por Categoria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 220, // Aumentei um pouco a altura para caber os textos
                          child: categoriasPizza.isEmpty
                              ? Center(
                                  child: Text(
                                    'Sem gastos registrados',
                                    style: TextStyle(color: colorScheme.onSurface),
                                  ),
                                )
                              : PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: categoriasPizza.map((cat) {
                                      return PieChartSectionData(
                                        color: cat['color'] as Color,
                                        value: cat['amount'] as double,
                                        title: cat['name'] as String, // Aqui exibe o nome da categoria!
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Letra branca dentro da fatia do gráfico
                                        ),
                                        radius: 60, // Aumentei o raio da fatia para o texto caber melhor
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddTransactionModal,
            backgroundColor: colorScheme.primary,
            icon: Icon(Icons.add, color: colorScheme.onPrimary),
            label: Text(
              'Nova Transação',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        );
      },
    );
  }
}