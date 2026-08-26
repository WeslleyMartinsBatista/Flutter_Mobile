import 'package:flutter/material.dart';
import '../controller/addTransactionController.dart';
import '../widgets/transaction_type_selector.dart';
import '../widgets/amount_input.dart';
import '../widgets/date_time_selector.dart';
import '../widgets/category_selector.dart';
import '../widgets/transaction_action_buttons.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  late final AddTransactionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AddTransactionController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final success = _controller.saveTransaction();
    if (success) {
      Navigator.pop(context, true);
    } else {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Preencha um valor e uma descrição válidos.'),
          backgroundColor: colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 550),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: colorScheme.surface, // Acompanha o tema (claro ou escuro)
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(
                  theme.brightness == Brightness.dark ? 0.65 : 0.18,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nova Transação',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                          tooltip: 'Fechar',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Seletor de Tipo — usa a cor primária do tema
                    TransactionTypeSelector(
                      selectedType: _controller.selectedType,
                      accentColor: colorScheme.primary,
                      onChanged: _controller.setType,
                    ),
                    const SizedBox(height: 24),
                    AmountInput(
                      controller: _controller.amountController,
                      typeName: _controller.selectedType.name,
                      accentColor: _controller.accentColor,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller.descriptionController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex: Compras no supermercado',
                        prefixIcon: Icon(Icons.edit_note_outlined, color: colorScheme.onSurfaceVariant),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Seletor de Data e Hora
                    DateTimeSelector(
                      selectedDate: _controller.selectedDate,
                      selectedTime: _controller.selectedTime,
                      onDateChanged: _controller.setDate,
                      onTimeChanged: _controller.setTime,
                    ),
                    const SizedBox(height: 24),
                    // Seletor de Categorias — usa a cor primária do tema
                    CategorySelector(
                      categories: _controller.categories,
                      selectedCategory: _controller.selectedCategory,
                      accentColor: colorScheme.primary,
                      onCategoryChanged: _controller.setCategory,
                    ),
                    const SizedBox(height: 32),
                    // Botões de Ação (mantêm as cores específicas por tipo: vermelho, verde, azul)
                    TransactionActionButtons(
                      accentColor: _controller.accentColor,
                      onSave: _onSave,
                      onSchedule: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}