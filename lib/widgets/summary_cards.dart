import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SummaryCards extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final bool hideBalance;

  const SummaryCards({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.hideBalance,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            colorScheme: colorScheme,
            title: 'Entradas',
            amount: totalIncome,
            icon: Icons.arrow_downward,
            color: AppTheme.incomeColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryItem(
            colorScheme: colorScheme,
            title: 'Saídas',
            amount: totalExpense,
            icon: Icons.arrow_upward,
            color: colorScheme.error,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required ColorScheme colorScheme,
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.14),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hideBalance ? 'R\$ •••' : 'R\$ ${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
