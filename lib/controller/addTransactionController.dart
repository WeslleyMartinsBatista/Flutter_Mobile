import 'package:flutter/material.dart';
import '../model/transaction_type.dart';
import '../model/category_item.dart';
import '../model/transaction_model.dart';
import '../database/mock_database.dart';

class AddTransactionController extends ChangeNotifier {
  TransactionType selectedType = TransactionType.despesa;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedCategory;

  final List<CategoryItem> categories = [
    CategoryItem(name: 'Mercado', icon: Icons.shopping_cart_outlined),
    CategoryItem(name: 'Transporte', icon: Icons.directions_bus_outlined),
    CategoryItem(name: 'Refeição', icon: Icons.restaurant),
    CategoryItem(name: 'Casa', icon: Icons.home_outlined),
    CategoryItem(name: 'Saúde', icon: Icons.medical_services_outlined),
    CategoryItem(name: 'Lazer', icon: Icons.sports_esports_outlined),
    CategoryItem(name: 'Educação', icon: Icons.school_outlined),
  ];

  Color get accentColor {
    switch (selectedType) {
      case TransactionType.despesa:
        return const Color(0xFFE53935);
      case TransactionType.receita:
        return const Color(0xFF43A047);
      case TransactionType.investimento:
        return const Color(0xFF1E88E5);
    }
  }

  void setType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  bool saveTransaction() {
    final amountText = amountController.text.replaceAll(',', '.');
    final double? parsedAmount = double.tryParse(amountText);

    if (parsedAmount == null || descriptionController.text.trim().isEmpty) {
      return false;
    }

    final isExpense = selectedType == TransactionType.despesa;
    final finalAmount = isExpense ? -parsedAmount.abs() : parsedAmount.abs();

    final newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: descriptionController.text.trim(),
      category: selectedCategory ?? 'Geral',
      amount: finalAmount,
      dateGroup: 'Hoje',
      time: '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
      icon: isExpense ? Icons.shopping_bag_outlined : Icons.arrow_upward_rounded,
      iconColor: accentColor,
    );

    MockDatabase.transacoes.insert(0, newTransaction);
    return true;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}