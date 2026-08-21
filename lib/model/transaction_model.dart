import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String dateGroup; // Ex: "Hoje, Out 24"
  final String time;
  final IconData icon;
  final Color iconColor;

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dateGroup,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  bool get isIncome => amount >= 0;
}