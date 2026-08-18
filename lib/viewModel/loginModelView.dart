// Definição do modelo de dados
class UserModel {
  final String email;
  final String password;

  UserModel({
    required this.email,
    required this.password,
  });
}

// Classe que controla a lógica da tela de login
class LoginViewModel {
  // Função que valida e processa o login
  void fazerLogin(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      print('Erro: E-mail ou senha não podem estar vazios.');
      return;
    }

    final usuario = UserModel(email: email, password: password);
    
    // Simulação de sucesso no login
    print('Login realizado com sucesso para: ${usuario.email}');
  }
}
