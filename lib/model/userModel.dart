class UserModel {
  final String id;
  String nome;
  String email;
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