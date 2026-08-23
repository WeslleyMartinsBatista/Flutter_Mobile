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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categoria (Opcional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            if (selectedCategory != null)
              TextButton(
                onPressed: () => onCategoryChanged(null),
                child: const Text('Limpar seleção', style: TextStyle(fontSize: 12)),
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
                  color: isSelected ? Colors.white : const Color(0xFF4B5563),
                ),
                label: Text(cat.name),
                selected: isSelected,
                selectedColor: accentColor,
                backgroundColor: const Color(0xFFF3F4F6),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                onSelected: (selected) {
                  onCategoryChanged(selected ? cat.name : null);
                },
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18, color: Colors.blue),
              label: const Text('Editar', style: TextStyle(color: Colors.blue)),
              backgroundColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade100),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}