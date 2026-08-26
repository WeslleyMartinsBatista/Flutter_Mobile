import 'package:flutter/material.dart';
import '../model/transaction_model.dart';
import '../theme/app_theme.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transações Recentes',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Ver todas'),
            ),
          ],
        ),
        Card(
          elevation: 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: colorScheme.outline,
            ),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final amountColor = tx.isIncome
                  ? AppTheme.incomeColor
                  : colorScheme.error;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx.iconColor.withOpacity(0.14),
                  child: Icon(tx.icon, color: tx.iconColor),
                ),
                title: Text(
                  tx.title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  tx.category,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
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
                        color: amountColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      tx.time,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
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
