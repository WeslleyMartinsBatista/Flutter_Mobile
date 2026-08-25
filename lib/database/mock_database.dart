import '../model/userModel.dart'; 

class MockDatabase {
  static List<UserModel> usuarios = [
    UserModel(
      id: "1",
      nome: "Weslley Martins Batista",
      email: "weslley@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
    UserModel(
      id: "2",
      nome: "Juliano Grass",
      email: "juliano@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
    UserModel(
      id: "3",
      nome: "Gabriel Cortes",
      email: "gabriel@gmail.com",
      senha: "123",
      saldo: 1000.0,
    ),
  ];
}