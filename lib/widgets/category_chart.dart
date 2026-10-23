import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:penny_wise/models/expense.dart';

class CategoryChart extends StatelessWidget {
  const CategoryChart({
    super.key,
    required this.categoryTotal,
    required this.totalExpenses,
  });

  final Map<String, double> categoryTotal;
  final double totalExpenses;

  //Helper to get Category from label
  Category? _getCategory(String label) {
    try {
      return Category.values.firstWhere((cat) => cat.label == label);
    } catch (_) {
      return null;
    }
  }

  //List of pie chart section data
  List<PieChartSectionData> _buildPieChartSectionData() {
    return categoryTotal.entries.map((entry) {
      final label = entry.key;
      final amount = entry.value;
      final category = _getCategory(label);
      final color = category?.color;
      final value = (amount / totalExpenses) * 100;
      return PieChartSectionData(
        value: value,
        color: color,
        title: value.toStringAsFixed(1),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (categoryTotal.isEmpty || totalExpenses <= 0) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Center(child: Text('No data added yet')),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pie_chart_outline, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Category Spending Summary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: _buildPieChartSectionData(),
                centerSpaceRadius: 75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
