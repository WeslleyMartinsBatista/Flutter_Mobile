import 'package:flutter/material.dart';
import '../controller/settingsController.dart';
import '../model/userModel.dart';
import '../widgets/setting_row.dart';
import '../widgets/category_management_dialog.dart';
import 'loginView.dart';

class SettingsView extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final UserModel usuario;
  final VoidCallback? onDataChanged;

  const SettingsView({
    super.key,
    required this.themeNotifier,
    required this.usuario,
    this.onDataChanged,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController(usuario: widget.usuario);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _controller.userName);
    final emailController = TextEditingController(text: _controller.userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.updateProfile(
                  nameController.text,
                  emailController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoriesDialog() {
    showCategoryManagementDialog(context);
  }

  Future<void> _confirmClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          title: const Text('Limpar todos os dados?'),
          content: const Text(
            'Essa ação apagará todas as transações, zerará os saldos e removerá as categorias adicionadas. Os gráficos também ficarão vazios. Essa ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Limpar tudo'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    _controller.clearAllData();
    widget.onDataChanged?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todos os dados foram removidos.')),
    );
  }

  void _logout() {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(themeNotifier: widget.themeNotifier),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDarkMode = widget.themeNotifier.value == ThemeMode.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Configurações',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, color: colorScheme.outline),

                // Perfil
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _controller.initials,
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller.userName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _controller.userEmail,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _showEditProfileDialog,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Editar'),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colorScheme.outline),

                // Configurações Gerais
                SettingRow(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Carteira',
                  subtitle: 'BRL (R\$)',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 64, color: colorScheme.outline),
                SettingRow(
                  icon: Icons.label_outline,
                  title: 'Categorias',
                  subtitle: 'Adicione ou exclua categorias',
                  onTap: _showCategoriesDialog,
                ),
                Divider(height: 1, indent: 64, color: colorScheme.outline),
                SettingRow(
                  icon: Icons.notifications_none,
                  title: 'Notificações',
                  subtitle: 'Alertas e lembretes diários',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 64, color: colorScheme.outline),

                // Dark Mode
                SettingRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Alterar tema do aplicativo',
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      widget.themeNotifier.value =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ),

                Divider(height: 1, color: colorScheme.outline),

                // Seção de Segurança
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
                  child: Text(
                    'SEGURANÇA & DADOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SettingRow(
                  icon: Icons.help_outline,
                  title: 'Privacidade & Segurança',
                  subtitle: 'Biometria & PIN',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 64, color: colorScheme.outline),
                SettingRow(
                  icon: Icons.download_outlined,
                  title: 'Exportar dados',
                  subtitle: 'Baixar CSV ou JSON',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 64, color: colorScheme.outline),
                SettingRow(
                  icon: Icons.delete_outline,
                  title: 'Limpar os dados',
                  subtitle: 'Apagar saldo, transações e gráficos',
                  onTap: _confirmClearData,
                ),

                const SizedBox(height: 32),

                // Botão Sair
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
