class UserModel {
  final String id;
  final String nome;
  final String email;
  final String senha;
  double saldo;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.saldo,
  });
}