import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/category_item.dart';
import '../model/transaction_model.dart';
import '../model/userModel.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static User get authenticatedUser {
    final user = client.auth.currentUser;
    if (user == null) {
      throw AuthException('Usuário não autenticado.');
    }
    return user;
  }

  static Future<Map<String, dynamic>> currentProfileRow() async {
    final authId = authenticatedUser.id;
    return await client
        .from('usuario')
        .select()
        .eq('auth_id', authId)
        .single();
  }

  static Future<int> currentProfileId() async {
    final row = await currentProfileRow();
    return (row['id'] as num).toInt();
  }

  static UserModel userFromRow(Map<String, dynamic> row) {
    return UserModel(
      id: row['id'].toString(),
      nome: (row['nome'] ?? 'Usuário').toString(),
      email: (row['email'] ?? '').toString(),
      senha: '',
      saldo: (row['saldo'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Future<UserModel> currentProfile() async {
    return userFromRow(await currentProfileRow());
  }

  static IconData iconFromName(String? name) {
    switch (name) {
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'sports_esports':
        return Icons.sports_esports_outlined;
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.label_outline;
    }
  }

  static Color colorFromHex(String? value) {
    if (value == null || value.isEmpty) return Colors.grey;
    final normalized = value.replaceFirst('#', '');
    final hex = normalized.length == 6 ? 'FF$normalized' : normalized;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? Colors.grey : Color(parsed);
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static String iconNameForTransaction(String type) {
    switch (type) {
      case 'receita':
        return 'arrow_upward';
      case 'investimento':
        return 'trending_up';
      default:
        return 'shopping_bag';
    }
  }

  static IconData transactionIcon(String? name, String type) {
    switch (name) {
      case 'arrow_upward':
        return Icons.arrow_upward_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      default:
        return iconFromName(name);
    }
  }

  static String dateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return 'Hoje';
    if (difference == 1) return 'Ontem';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  static String timeLabel(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static TransactionModel transactionFromRow(Map<String, dynamic> row) {
    final type = (row['type'] ?? 'despesa').toString();
    final databaseAmount = (row['amount'] as num?)?.toDouble() ?? 0.0;
    final amount = type == 'despesa' ? -databaseAmount.abs() : databaseAmount.abs();
    final date = DateTime.tryParse((row['occurred_at'] ?? '').toString()) ?? DateTime.now();
    final categoryRelation = row['categorias'];
    final category = categoryRelation is Map<String, dynamic>
        ? (categoryRelation['name'] ?? '').toString()
        : (row['category_name'] ?? '').toString();
    final color = colorFromHex(row['icon_color']?.toString());

    return TransactionModel(
      id: row['id'].toString(),
      title: (row['title'] ?? '').toString(),
      category: category.isEmpty ? 'Geral' : category,
      amount: amount,
      dateGroup: dateGroup(date),
      time: timeLabel(date),
      icon: transactionIcon(row['icon_name']?.toString(), type),
      iconColor: color,
      date: date,
    );
  }

  static Future<List<CategoryItem>> categoriesForUser(int userId) async {
    final rows = await client
        .from('categorias')
        .select()
        .eq('user_id', userId)
        .order('name');

    return (rows as List)
        .map((row) => CategoryItem(
              name: (row['name'] ?? '').toString(),
              icon: iconFromName(row['icon_name']?.toString()),
            ))
        .toList();
  }

  static Future<int?> categoryIdByName(int userId, String? name) async {
    if (name == null || name.trim().isEmpty || name == 'Geral') return null;
    final rows = await client
        .from('categorias')
        .select('id')
        .eq('user_id', userId)
        .eq('name', name)
        .limit(1);
    if (rows.isEmpty) return null;
    return (rows.first['id'] as num).toInt();
  }
}
