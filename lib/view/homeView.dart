import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página Inicial')),
      body: const Center(child: Text('Bem-vindo a Home! Login efetuado com sucesso.')),
    );
  }
}
