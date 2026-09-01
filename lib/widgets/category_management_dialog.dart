import 'package:flutter/material.dart';

import '../service/supabase_service.dart';
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
  List<CategoryItem> _categories = [];
  int? _userId;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final userId = await SupabaseService.currentProfileId();
      final categories = await SupabaseService.categoriesForUser(userId);
      if (!mounted) return;
      setState(() {
        _userId = userId;
        _categories = categories;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Não foi possível carregar as categorias.';
      });
    }
  }

  Future<void> _addCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Digite um nome para a categoria.');
      return;
    }
    if (_userId == null) {
      setState(() => _errorMessage = 'Usuário não autenticado.');
      return;
    }
    if (_categories.any(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
    )) {
      setState(() => _errorMessage = 'Essa categoria já existe.');
      return;
    }

    try {
      await SupabaseService.client.from('categorias').insert({
        'user_id': _userId,
        'name': name,
        'icon_name': 'label_outline',
      });
      _nameController.clear();
      widget.onCategoriesChanged?.call();
      await _loadCategories();
      if (mounted) setState(() => _errorMessage = null);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Não foi possível adicionar a categoria.');
      }
    }
  }

  Future<void> _removeCategory(CategoryItem category) async {
    if (_userId == null) return;
    try {
      await SupabaseService.client
          .from('categorias')
          .delete()
          .eq('user_id', _userId!)
          .eq('name', category.name);
      widget.onCategoriesChanged?.call();
      await _loadCategories();
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Não foi possível excluir a categoria.');
      }
    }
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
                  onPressed: _isLoading ? null : _addCategory,
                  tooltip: 'Adicionar categoria',
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                style: TextStyle(color: colorScheme.error, fontSize: 12),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _categories.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhuma categoria cadastrada.',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
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
