import 'package:flutter/material.dart';
import '../controller/settingsController.dart';
import '../model/userModel.dart';
import '../widgets/setting_row.dart';
import 'loginView.dart';

class SettingsView extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final UserModel usuario;

  const SettingsView({
    super.key,
    required this.themeNotifier,
    required this.usuario,
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
        final isDarkMode = widget.themeNotifier.value == ThemeMode.dark;

        return Scaffold(
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
                const Divider(height: 1),

                // Perfil
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC08A75),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _controller.initials,
                          style: const TextStyle(
                            color: Colors.white,
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _controller.userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _showEditProfileDialog,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Editar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Configurações Gerais
                SettingRow(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Carteira',
                  subtitle: 'BRL (R\$)',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),
                SettingRow(
                  icon: Icons.label_outline,
                  title: 'Categorias',
                  subtitle: 'Modifique as categorias',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),
                SettingRow(
                  icon: Icons.notifications_none,
                  title: 'Notificações',
                  subtitle: 'Alertas e lembretes diários',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),

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

                const Divider(height: 1),

                // Seção de Segurança
                const Padding(
                  padding: EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
                  child: Text(
                    'SEGURANÇA & DADOS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SettingRow(
                  icon: Icons.help_outline,
                  title: 'Privacidade & Segurança',
                  subtitle: 'Biometria & PIN',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),
                SettingRow(
                  icon: Icons.download_outlined,
                  title: 'Exportar dados',
                  subtitle: 'Baixar CSV ou JSON',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),
                SettingRow(
                  icon: Icons.delete_outline,
                  title: 'Limpar os dados',
                  subtitle: 'Resetar todas as transações',
                  onTap: () {},
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
                        backgroundColor: const Color(0xFFB35C5C),
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