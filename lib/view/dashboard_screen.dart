import 'package:flutter/material.dart';

import '../model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../widgets/balance_card.dart';
import '../widgets/summary_cards.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/cash_flow_chart.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';
import 'expense_report_screen.dart';
import 'transactions_screen.dart';
import '../model/userModel.dart';

class DashboardScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final UserModel usuario;

  const DashboardScreen({
    super.key,
    required this.themeNotifier,
    required this.usuario,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _hideBalance = false;
  String _chartPeriod = 'Mês';

  // Dados Mockados
  final double totalBalance = 3859.30;
  final double totalIncome = 4250.00;
  final double totalExpense = 390.70;

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

  List<ChartDataModel> _getChartData() {
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

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Essencial para formulários grandes e para o teclado não cobrir os campos
      backgroundColor: Colors.transparent, // Permite que o arredondamento e as sombras do seu AddTransactionScreen apareçam perfeitamente
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Empurra o modal para cima quando o teclado abre
        ),
        child: const AddTransactionScreen(), // Aqui você chama a sua classe!
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        title: Row(
          // O 'const' que estava aqui foi removido
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SettingsScreen(themeNotifier: widget.themeNotifier),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12), // const adicionado aqui
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${widget.usuario.nome.split(' ').first}',
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
              _hideBalance ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _hideBalance = !_hideBalance),
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
                totalBalance: totalBalance,
                hideBalance: _hideBalance,
              ),
              const SizedBox(height: 20),
              SummaryCards(
                totalIncome: totalIncome,
                totalExpense: totalExpense,
                hideBalance: _hideBalance,
              ),
              const SizedBox(height: 24),
              RecentTransactionsSection(
                transactions: recentTransactions,
                hideBalance: _hideBalance,
              ),
              const SizedBox(height: 24),
              CashFlowChart(
                chartPeriod: _chartPeriod,
                chartData: _getChartData(),
                onPeriodChanged: (newPeriod) =>
                    setState(() => _chartPeriod = newPeriod),
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
  }
}
