import 'package:flutter/material.dart';

import '../model/userModel.dart';

class HomeView extends StatelessWidget {
  final UserModel usuario;

  const HomeView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página Inicial')),
      body: Center(child: Text('Bem-vindo, ${usuario.nome}!')),
    );
  }
}
