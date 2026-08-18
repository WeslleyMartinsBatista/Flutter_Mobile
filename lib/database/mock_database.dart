import '../models/user.dart';

class MockDatabase{
    static List<User> usuarios = [
        User(
            nome: "weslley Martins Batista",
            email: "weslley@gmail.com"
            senha: "123",
        ),
        User(
            nome: "juliano Grass",
            email: "juliano@gmail.com"
            senha: "123",
        ),
        User(
            nome: "Gabriel Cortes",
            email: "gabriel@gmail.com"
            senha: "123",
        ),
    ];
} 