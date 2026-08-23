import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String typeName;
  final Color accentColor;

  const AmountInput({
    super.key,
    required this.controller,
    required this.typeName,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Valor da $typeName',
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        IntrinsicWidth(
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
            decoration: InputDecoration(
              prefixText: 'R\$ ',
              prefixStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: accentColor.withOpacity(0.7),
              ),
              hintText: '0,00',
              hintStyle: TextStyle(color: Colors.grey.shade300),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}