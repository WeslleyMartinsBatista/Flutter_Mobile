import 'package:flutter/material.dart';
import '../controller/transactionsController.dart';
import '../widgets/transaction_item.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late final TransactionsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransactionsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final groupedData = _controller.filteredAndGroupedTransactions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              'Transações',
              style: TextStyle(
                color: colorScheme.onSurface, // Adapta para branco no dark e preto no light
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.tune, color: colorScheme.onSurface),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Barra de Pesquisa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  onChanged: _controller.setSearchQuery,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Procure transações ou categorias',
                    hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest, // Fundo dinâmico
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ),
              ),
              
              // Filtro de Categorias
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = _controller.categories[index];
                    final isSelected = _controller.selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _controller.setSelectedCategory(category),
                        backgroundColor: colorScheme.surface,
                        selectedColor: colorScheme.primary, // Cor de destaque do tema
                        checkmarkColor: colorScheme.onPrimary,
                        labelStyle: TextStyle(
                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : theme.dividerColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 8),

              // Lista Agrupada
              Expanded(
                child: groupedData.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma transação encontrada.',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedData.length,
                        itemBuilder: (context, index) {
                          final dateGroup = groupedData.keys.elementAt(index);
                          final transactions = groupedData[dateGroup]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                color: colorScheme.surfaceContainerHighest, // Adapta ao Dark Mode
                                child: Text(
                                  dateGroup,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
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
            backgroundColor: colorScheme.primary,
            child: Icon(Icons.add, color: colorScheme.onPrimary),
          ),
        );
      },
    );
  }
}