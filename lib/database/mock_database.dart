import '../model/userModel.dart'; 

class MockDatabase {
    static List<UserModel> usuarios = [
        UserModel(
            nome: "Weslley Martins Batista",
            email: "weslley@gmail.com",
            senha: "123",
        ),
        UserModel(
            nome: "juliano Grass",
            email: "juliano@gmail.com",
            senha: "123",
        ),
        UserModel(
            nome: "Gabriel Cortes",
            email: "gabriel@gmail.com",
            senha: "123",
        ),
    ];
}
