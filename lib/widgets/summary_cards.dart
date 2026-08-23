import 'package:flutter/material.dart';

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
    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            title: 'Entradas',
            amount: totalIncome,
            icon: Icons.arrow_downward,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryItem(
            title: 'Saídas',
            amount: totalExpense,
            icon: Icons.arrow_upward,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({required String title, required double amount, required IconData icon, required Color color}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  hideBalance ? 'R\$ •••' : 'R\$ ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}