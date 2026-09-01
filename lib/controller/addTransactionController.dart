import 'package:flutter/material.dart';

import '../model/transaction_type.dart';
import '../model/category_item.dart';
import '../service/supabase_service.dart';

class AddTransactionController extends ChangeNotifier {
  TransactionType selectedType = TransactionType.despesa;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedCategory;

  List<CategoryItem> _categories = [];
  List<CategoryItem> get categories => _categories;

  AddTransactionController() {
    loadCategories();
  }

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

  Future<void> loadCategories() async {
    try {
      final userId = await SupabaseService.currentProfileId();
      _categories = await SupabaseService.categoriesForUser(userId);
      if (selectedCategory != null &&
          !_categories.any((category) => category.name == selectedCategory)) {
        selectedCategory = null;
      }
      notifyListeners();
    } catch (_) {
      // A tela permanece utilizável mesmo se as categorias falharem ao carregar.
    }
  }

  void refreshCategories() {
    loadCategories();
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

  Future<bool> saveTransaction() async {
    final amountText = amountController.text.replaceAll(',', '.').trim();
    final parsedAmount = double.tryParse(amountText);

    if (parsedAmount == null ||
        parsedAmount <= 0 ||
        descriptionController.text.trim().isEmpty) {
      return false;
    }

    final userId = await SupabaseService.currentProfileId();
    final categoryId = await SupabaseService.categoryIdByName(
      userId,
      selectedCategory,
    );
    final occurredAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final type = selectedType.name;

    await SupabaseService.client.from('transacoes').insert({
      'user_id': userId,
      'category_id': categoryId,
      'title': descriptionController.text.trim(),
      'type': type,
      'amount': parsedAmount.abs(),
      'occurred_at': occurredAt.toIso8601String(),
      'icon_name': SupabaseService.iconNameForTransaction(type),
      'icon_color': SupabaseService.colorToHex(accentColor),
    });

    return true;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
