import 'package:flutter/material.dart';

class TransactionActionButtons extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onSave;
  final VoidCallback onSchedule;

  const TransactionActionButtons({
    super.key,
    required this.accentColor,
    required this.onSave,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onSave,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text(
              'Salvar Transação',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: accentColor, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onSchedule,
            icon: Icon(Icons.schedule, color: accentColor),
            label: Text(
              'Agendar Transação',
              style: TextStyle(color: accentColor, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}