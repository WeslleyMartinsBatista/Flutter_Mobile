import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final bool hideBalance;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.hideBalance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final foregroundColor = isDark ? const Color(0xFFF4F6F8) : Colors.white;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0B2E52), Color(0xFF175C94)]
                : const [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Total',
              style: TextStyle(
                color: foregroundColor.withOpacity(0.78),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hideBalance ? 'R\$ ••••••' : 'R\$ ${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(
                color: foregroundColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}