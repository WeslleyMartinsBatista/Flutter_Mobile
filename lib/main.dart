import 'package:flutter/material.dart';
import 'view/loginView.dart'; // Importa a tela de login

void main() {
  runApp(const MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Chamada da tela de Login
    );
  }
}
