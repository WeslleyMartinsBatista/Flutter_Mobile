import 'package:flutter/material.dart';
import '../model/chart_data_model.dart';

class CashFlowChart extends StatelessWidget {
  final String chartPeriod;
  final ValueChanged<String> onPeriodChanged;
  final List<ChartDataModel> chartData;

  const CashFlowChart({
    super.key,
    required this.chartPeriod,
    required this.onPeriodChanged,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fluxo de Caixa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Dia', label: Text('Dia')),
                    ButtonSegment(value: 'Mês', label: Text('Mês')),
                    ButtonSegment(value: 'Ano', label: Text('Ano')),
                  ],
                  selected: {chartPeriod},
                  onSelectionChanged: (newSelection) => onPeriodChanged(newSelection.first),
                  style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chartData.map((data) => _buildBar(data)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(ChartDataModel data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 120 * data.height,
          decoration: BoxDecoration(
            color: data.isExpense ? Colors.redAccent.shade100 : const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(data.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}