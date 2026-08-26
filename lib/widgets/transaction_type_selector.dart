import 'package:flutter/material.dart';
import '../model/transaction_type.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onChanged;
  final Color accentColor;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: TransactionType.values.map((type) {
          final isSelected = selectedType == type;
          String label;
          switch (type) {
            case TransactionType.despesa:
              label = 'Despesa';
              break;
            case TransactionType.receita:
              label = 'Receita';
              break;
            case TransactionType.investimento:
              label = 'Investimento';
              break;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: themeShadow(context),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : const [],
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? accentColor
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color themeShadow(BuildContext context) {
    final theme = Theme.of(context);
    return theme.shadowColor.withOpacity(
      theme.brightness == Brightness.dark ? 0.55 : 0.25,
    );
  }
}
