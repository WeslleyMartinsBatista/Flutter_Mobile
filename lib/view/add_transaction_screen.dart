import 'package:flutter/material.dart';
import '../model/transaction_type.dart';
import '../model/category_item.dart';
import '../widgets/transaction_type_selector.dart';
import '../widgets/amount_input.dart';
import '../widgets/date_time_selector.dart';
import '../widgets/category_selector.dart';
import '../widgets/transaction_action_buttons.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.despesa;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedCategory;

  final List<CategoryItem> _categories = [
    CategoryItem(name: 'Mercado', icon: Icons.shopping_cart_outlined),
    CategoryItem(name: 'Transporte', icon: Icons.directions_bus_outlined),
    CategoryItem(name: 'Refeição', icon: Icons.restaurant),
    CategoryItem(name: 'Casa', icon: Icons.home_outlined),
    CategoryItem(name: 'Saúde', icon: Icons.medical_services_outlined),
    CategoryItem(name: 'Lazer', icon: Icons.sports_esports_outlined),
    CategoryItem(name: 'Educação', icon: Icons.school_outlined),
  ];

  Color get _accentColor {
    switch (_selectedType) {
      case TransactionType.despesa:
        return const Color(0xFFE53935);
      case TransactionType.receita:
        return const Color(0xFF43A047);
      case TransactionType.investimento:
        return const Color(0xFF1E88E5);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 550),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8)),
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
                _buildHeader(),
                const SizedBox(height: 20),
                TransactionTypeSelector(
                  selectedType: _selectedType,
                  accentColor: _accentColor,
                  onChanged: (type) => setState(() => _selectedType = type),
                ),
                const SizedBox(height: 24),
                AmountInput(
                  controller: _amountController,
                  typeName: _selectedType.name,
                  accentColor: _accentColor,
                ),
                const SizedBox(height: 20),
                _buildDescriptionInput(),
                const SizedBox(height: 16),
                DateTimeSelector(
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onDateChanged: (date) => setState(() => _selectedDate = date),
                  onTimeChanged: (time) => setState(() => _selectedTime = time),
                ),
                const SizedBox(height: 24),
                CategorySelector(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  accentColor: _accentColor,
                  onCategoryChanged: (category) => setState(() => _selectedCategory = category),
                ),
                const SizedBox(height: 32),
                TransactionActionButtons(
                  accentColor: _accentColor,
                  onSave: () {
                    // Lógica para salvar transação
                  },
                  onSchedule: () {
                    // Lógica para agendar transação
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
  return Row(
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
        // Altere esta linha para fechar a tela:
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: Colors.grey),
        tooltip: 'Fechar',
      ),
    ],
  );
}

  Widget _buildDescriptionInput() {
    return TextField(
      controller: _descriptionController,
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
    );
  }
}