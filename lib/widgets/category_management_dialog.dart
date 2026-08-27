import 'package:flutter/material.dart';
import '../database/mock_database.dart';
import '../model/category_item.dart';

Future<void> showCategoryManagementDialog(
  BuildContext context, {
  VoidCallback? onCategoriesChanged,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => CategoryManagementDialog(
      onCategoriesChanged: onCategoriesChanged,
    ),
  );
}

class CategoryManagementDialog extends StatefulWidget {
  final VoidCallback? onCategoriesChanged;

  const CategoryManagementDialog({
    super.key,
    this.onCategoriesChanged,
  });

  @override
  State<CategoryManagementDialog> createState() =>
      _CategoryManagementDialogState();
}

class _CategoryManagementDialogState extends State<CategoryManagementDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  List<CategoryItem> get _categories => MockDatabase.categorias;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Digite um nome para a categoria.');
      return;
    }

    final alreadyExists = _categories.any(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
    );
    if (alreadyExists) {
      setState(() => _errorMessage = 'Essa categoria já existe.');
      return;
    }

    _categories.add(
      CategoryItem(
        name: name,
        icon: Icons.label_outline,
      ),
    );
    _nameController.clear();
    widget.onCategoriesChanged?.call();
    setState(() => _errorMessage = null);
  }

  void _removeCategory(CategoryItem category) {
    _categories.remove(category);
    widget.onCategoriesChanged?.call();
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Categorias'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addCategory(),
                    decoration: const InputDecoration(
                      labelText: 'Nova categoria',
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addCategory,
                  tooltip: 'Adicionar categoria',
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Categorias cadastradas',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 260,
              child: _categories.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma categoria cadastrada.',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            category.icon,
                            color: colorScheme.primary,
                          ),
                          title: Text(category.name),
                          trailing: IconButton(
                            onPressed: () => _removeCategory(category),
                            tooltip: 'Excluir categoria',
                            icon: Icon(
                              Icons.delete_outline,
                              color: colorScheme.error,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
