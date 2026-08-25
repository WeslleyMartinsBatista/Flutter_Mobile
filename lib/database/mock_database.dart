import 'package:flutter/material.dart';
import '../model/userModel.dart'; 
import '../model/transaction_model.dart'; // Importe o modelo de transação[cite: 5]

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

  // Adicione a lista estática de transações abaixo[cite: 4]
  static List<TransactionModel> transacoes = [
    TransactionModel(
      id: '1',
      title: 'Compras da semana',
      category: 'Mercado',
      amount: -384.20,
      dateGroup: 'Hoje, Out 24',
      time: '20:15',
      icon: Icons.shopping_cart,
      iconColor: const Color(0xFFE55353),
    ),
    TransactionModel(
      id: '2',
      title: 'Salario',
      category: 'Receita',
      amount: 4250.00,
      dateGroup: 'Hoje, Out 24',
      time: '9:00',
      icon: Icons.money,
      iconColor: const Color(0xFF66BB6A),
    ),
    TransactionModel(
      id: '3',
      title: 'Café',
      category: 'Lazer',
      amount: -6.50,
      dateGroup: 'Hoje, Out 24',
      time: '8:30',
      icon: Icons.local_cafe,
      iconColor: const Color(0xFFE55353),
    ),
    TransactionModel(
      id: '4',
      title: 'Eletronicos',
      category: 'Lazer',
      amount: -1299.00,
      dateGroup: 'Ontem, Out 23',
      time: '16:45',
      icon: Icons.devices,
      iconColor: const Color(0xFFE55353),
    ),
    TransactionModel(
      id: '5',
      title: 'Rota 77',
      category: 'Transporte',
      amount: -16.75,
      dateGroup: 'Ontem, Out 23',
      time: '11:20',
      icon: Icons.directions_car,
      iconColor: const Color(0xFFE55353),
    ),
  ];
}