import 'package:flutter/material.dart';
import '../model/category_item.dart';

class CategorySelector extends StatelessWidget {
  final List<CategoryItem> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final Color accentColor;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.accentColor,
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
              'Categoria (Opcional)',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (selectedCategory != null)
              TextButton(
                onPressed: () => onCategoryChanged(null),
                child: const Text(
                  'Limpar seleção',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: [
            ...categories.map((cat) {
              final isSelected = selectedCategory == cat.name;
              return ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  cat.icon,
                  size: 18,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
                label: Text(cat.name),
                selected: isSelected,
                selectedColor: accentColor,
                backgroundColor: colorScheme.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : colorScheme.outline,
                  ),
                ),
                onSelected: (selected) {
                  onCategoryChanged(selected ? cat.name : null);
                },
              );
            }),
            ActionChip(
              avatar: Icon(
                Icons.add,
                size: 18,
                color: colorScheme.primary,
              ),
              label: Text(
                'Editar',
                style: TextStyle(color: colorScheme.primary),
              ),
              backgroundColor: colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.primary.withOpacity(0.35)),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
