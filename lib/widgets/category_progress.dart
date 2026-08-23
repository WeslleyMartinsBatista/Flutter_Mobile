import 'package:flutter/material.dart';

class CategoryProgress extends StatelessWidget {
  final String categoryName;
  final double amount;
  final double totalAmount;
  final Color color;

  const CategoryProgress({
    super.key,
    required this.categoryName,
    required this.amount,
    required this.totalAmount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula o percentual do gasto para a barra de progresso (evita divisão por zero)
    final double percentage = totalAmount > 0 ? (amount / totalAmount) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                'R\$ ${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}