import 'package:flutter/material.dart';

import '../controller/homeController.dart';
import '../widgets/balance_card.dart';
import '../widgets/summary_cards.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/cash_flow_chart.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';
import 'expense_report_screen.dart';
import 'transactions_screen.dart';
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
    // Instancia o Controller passando o usuário do Widget
    _controller = HomeController(usuario: widget.usuario);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddTransactionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D47A1),
            elevation: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          themeNotifier: widget.themeNotifier,
                        ),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${_controller.usuario.nome.split(' ').first}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Bem-vindo de volta',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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
                  color: Colors.white,
                ),
                onPressed: _controller.toggleHideBalance,
                tooltip: 'Ocultar Saldo',
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.white),
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
                        builder: (context) => const TransactionsScreen(),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'relatorios',
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart),
                        SizedBox(width: 12),
                        Text('Relatórios de gastos'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'transacoes',
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long),
                        SizedBox(width: 12),
                        Text('Transações'),
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
                  RecentTransactionsSection(
                    transactions: _controller.recentTransactions,
                    hideBalance: _controller.hideBalance,
                  ),
                  const SizedBox(height: 24),
                  CashFlowChart(
                    chartPeriod: _controller.chartPeriod,
                    chartData: _controller.getChartData(),
                    onPeriodChanged: _controller.setChartPeriod,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddTransactionModal,
            backgroundColor: const Color(0xFF0D47A1),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Nova Transação',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}