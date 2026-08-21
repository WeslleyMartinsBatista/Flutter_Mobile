import 'package:flutter/material.dart';
import '../model/transaction_model.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool hideBalance;

  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    required this.hideBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transações Recentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text('Ver todas'),
            ),
          ],
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx.iconColor.withOpacity(0.1),
                  child: Icon(tx.icon, color: tx.iconColor),
                ),
                title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(tx.category),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      hideBalance
                          ? 'R\$ •••'
                          : '${tx.isIncome ? '+' : ''}${tx.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tx.isIncome ? Colors.green : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                    Text(tx.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}