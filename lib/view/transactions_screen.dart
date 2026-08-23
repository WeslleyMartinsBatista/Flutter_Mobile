import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../widgets/transaction_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todas';

  final List<String> _categories = ['Todas', 'Receita', 'Mercado', 'Transporte', 'Lazer'];

  // Dados simulados baseados no design
  final List<TransactionModel> _allTransactions = [
    TransactionModel(id: '1', title: 'Compras da semana', category: 'Mercado', amount: -384.20, dateGroup: 'Hoje, Out 24', time: '20:15', icon: Icons.shopping_cart, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '2', title: 'Salario', category: 'Receita', amount: 4250.00, dateGroup: 'Hoje, Out 24', time: '9:00', icon: Icons.money, iconColor: const Color(0xFF66BB6A)),
    TransactionModel(id: '3', title: 'Café', category: '', amount: -6.50, dateGroup: 'Hoje, Out 24', time: '8:30', icon: Icons.local_cafe, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '4', title: 'Eletronicos', category: 'Lazer', amount: -1299.00, dateGroup: 'Ontem, Out 23', time: '16:45', icon: Icons.devices, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '5', title: 'Rota 77', category: 'Transporte', amount: -16.75, dateGroup: 'Ontem, Out 23', time: '11:20', icon: Icons.directions_car, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '6', title: 'Assinatura netflix', category: 'Lazer', amount: -35.99, dateGroup: 'Ontem, Out 23', time: '02:00', icon: Icons.play_circle_fill, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '7', title: 'Posto de gasolina', category: 'Transporte', amount: -55.00, dateGroup: 'Out 22, 2026', time: '18:30', icon: Icons.local_gas_station, iconColor: const Color(0xFFE55353)),
    TransactionModel(id: '8', title: 'Venda de um site', category: 'Receita', amount: 850.00, dateGroup: 'Out 22, 2026', time: '17:40', icon: Icons.account_balance_wallet, iconColor: const Color(0xFF66BB6A)),
  ];

  // Lógica de filtragem e agrupamento
  Map<String, List<TransactionModel>> get _filteredAndGroupedTransactions {
    final filtered = _allTransactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            tx.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todas' || tx.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    final Map<String, List<TransactionModel>> grouped = {};
    for (var tx in filtered) {
      if (!grouped.containsKey(tx.dateGroup)) {
        grouped[tx.dateGroup] = [];
      }
      grouped[tx.dateGroup]!.add(tx);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _filteredAndGroupedTransactions;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Transações', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {}, // Abrir filtros avançados
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Procure transações ou categorias',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          // Filtro de Categorias (Horizontal Scroll)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.grey.shade100,
                    checkmarkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? Colors.black26 : Colors.grey.shade300),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),

          // Lista de Transações Agrupadas
          Expanded(
            child: groupedData.isEmpty
                ? const Center(child: Text('Nenhuma transação encontrada.'))
                : ListView.builder(
                    itemCount: groupedData.length,
                    itemBuilder: (context, index) {
                      final dateGroup = groupedData.keys.elementAt(index);
                      final transactions = groupedData[dateGroup]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho da Data
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: const Color(0xFFF9F9F9),
                            child: Text(
                              dateGroup,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          // Itens da Data
                          ...transactions.map((tx) => TransactionItem(transaction: tx)),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A1A1A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}