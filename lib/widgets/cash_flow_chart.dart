import 'package:flutter/material.dart';
import '../model/chart_data_model.dart';
import '../theme/app_theme.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fluxo de Caixa',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                children: chartData
                    .map((data) => _buildBar(context, data))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context, ChartDataModel data) {
    final colorScheme = Theme.of(context).colorScheme;
    final barColor = data.isExpense ? colorScheme.error : AppTheme.incomeColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 18,
          height: 120 * data.height,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.label,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}