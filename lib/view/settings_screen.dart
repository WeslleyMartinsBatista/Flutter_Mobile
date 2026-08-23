import 'package:flutter/material.dart';
import '../widgets/setting_row.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const SettingsScreen({super.key, required this.themeNotifier});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Estado inicial do usuário
  String _userName = "Juliano Silva";
  String _userEmail = "juliano.silva@email.com";

  // Retorna as iniciais para o Avatar (ex: "JS")
  String get _initials {
    List<String> names = _userName.trim().split(' ');
    if (names.isEmpty) return "";
    if (names.length == 1) return names[0][0].toUpperCase();
    return "${names[0][0]}${names.last[0]}".toUpperCase();
  }

  // Função para abrir o modal de edição
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

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
                decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
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
                setState(() {
                  _userName = nameController.text;
                  _userEmail = emailController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função de Logout simulada
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MockLoginScreen()),
      (route) => false, // Remove todas as telas anteriores da pilha
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
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
            // Seção de Perfil
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC08A75), // Cor do avatar do print
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_userEmail, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Editar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            
            // Dark Mode Toggle
            SettingRow(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Alterar tema do aplicativo',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            
            const Divider(height: 1),
            
            // Seção de Segurança
            const Padding(
              padding: EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
              child: Text(
                'SEGURANÇA & DADOS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
              title: 'Exportar data',
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
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Sair', style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB35C5C), // Vermelho do botão do print
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Tela de Login Falsa para testar o redirecionamento do Logout
class MockLoginScreen extends StatelessWidget {
  const MockLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tela de Login', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Voltar para a aplicação principal
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Placeholder()), 
                );
              },
              child: const Text('Entrar'),
            )
          ],
        ),
      ),
    );
  }
}