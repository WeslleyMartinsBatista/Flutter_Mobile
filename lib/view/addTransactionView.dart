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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha um valor e uma descrição válidos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 550),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
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
                        const Text(
                          'Nova Transação',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.grey),
                          tooltip: 'Fechar',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TransactionTypeSelector(
                      selectedType: _controller.selectedType,
                      accentColor: _controller.accentColor,
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
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex: Compras no supermercado',
                        prefixIcon: const Icon(Icons.edit_note_outlined),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DateTimeSelector(
                      selectedDate: _controller.selectedDate,
                      selectedTime: _controller.selectedTime,
                      onDateChanged: _controller.setDate,
                      onTimeChanged: _controller.setTime,
                    ),
                    const SizedBox(height: 24),
                    CategorySelector(
                      categories: _controller.categories,
                      selectedCategory: _controller.selectedCategory,
                      accentColor: _controller.accentColor,
                      onCategoryChanged: _controller.setCategory,
                    ),
                    const SizedBox(height: 32),
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