import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingTrendChart extends StatelessWidget {
  final Map<DateTime, double> spendingData;
  final bool isWeekly;

  const SpendingTrendChart({
    super.key,
    required this.spendingData,
    this.isWeekly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (spendingData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('No spending data available')),
        ),
      );
    }

    final entries = spendingData.entries.toList();
    final maxAmount = spendingData.values.fold(
      0.0,
      (max, v) => v > max ? v : max,
    );

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              // Y-Axis setup
              maxY: maxAmount == 0 ? 100 : maxAmount * 1.2,

              // Grid setup
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: maxAmount == 0 ? 25 : maxAmount / 4,
              ),

              // Hide borders top/right/left
              borderData: FlBorderData(show: true),

              // Tooltips on tap
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '\$${rod.toY.toStringAsFixed(2)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),

              // Axes Titles
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) => Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 18,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= entries.length) {
                        return const SizedBox.shrink();
                      }

                      final date = entries[index].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _getLabel(date),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bar Generation
              barGroups: List.generate(entries.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entries[index].value,
                      color: Theme.of(context).colorScheme.primary,
                      width: isWeekly ? 10 : 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String _getLabel(DateTime date) {
    if (isWeekly) {
      return '${date.month}/${date.day}'; // e.g., "8/3"
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1]; // e.g., "Mon"
  }
}

// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// //
// // class SpendingTrendChart extends StatelessWidget {
// //   final Map<DateTime, double> spendingData;
// //   final bool isWeekly;
// //
// //   const SpendingTrendChart({
// //     super.key,
// //     required this.spendingData,
// //     this.isWeekly = false,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (spendingData.isEmpty) {
// //       return const Card(
// //         child: Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Center(child: Text('No spending data available')),
// //         ),
// //       );
// //     }
// //
// //     final entries = spendingData.entries.toList();
// //     final maxAmount = spendingData.values.fold(
// //       0.0,
// //       (max, v) => v > max ? v : max,
// //     );
// //
// //     return Card(
// //       elevation: 1,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: AspectRatio(
// //           aspectRatio: 1.5,
// //           child: BarChart(
// //             BarChartData(
// //               // Y-Axis setup
// //               maxY: maxAmount == 0 ? 100 : maxAmount * 1.2,
// //
// //               // Grid setup
// //               gridData: FlGridData(
// //                 show: true,
// //                 drawVerticalLine: false,
// //                 horizontalInterval: maxAmount == 0 ? 25 : maxAmount / 4,
// //               ),
// //
// //               // Hide borders top/right/left
// //               borderData: FlBorderData(show: false),
// //
// //               // Tooltips on tap
// //               barTouchData: BarTouchData(
// //                 touchTooltipData: BarTouchTooltipData(
// //                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
// //                     return BarTooltipItem(
// //                       '\$${rod.toY.toStringAsFixed(2)}',
// //                       const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //
// //               // Axes Titles
// //               titlesData: FlTitlesData(
// //                 topTitles: const AxisTitles(
// //                   sideTitles: SideTitles(showTitles: false),
// //                 ),
// //                 rightTitles: const AxisTitles(
// //                   sideTitles: SideTitles(showTitles: false),
// //                 ),
// //                 leftTitles: AxisTitles(
// //                   sideTitles: SideTitles(
// //                     showTitles: true,
// //                     reservedSize: 42,
// //                     getTitlesWidget: (value, meta) => Text(
// //                       '\$${value.toInt()}',
// //                       style: const TextStyle(fontSize: 10, color: Colors.grey),
// //                     ),
// //                   ),
// //                 ),
// //                 bottomTitles: AxisTitles(
// //                   sideTitles: SideTitles(
// //                     showTitles: true,
// //                     reservedSize: 28,
// //                     getTitlesWidget: (value, meta) {
// //                       final index = value.toInt();
// //                       if (index < 0 || index >= entries.length)
// //                         return const SizedBox.shrink();
// //
// //                       final date = entries[index].key;
// //                       return Padding(
// //                         padding: const EdgeInsets.only(top: 8.0),
// //                         child: Text(
// //                           _getLabel(date),
// //                           style: const TextStyle(
// //                             fontSize: 11,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ),
// //
// //               // Bar Generation
// //               barGroups: List.generate(entries.length, (index) {
// //                 return BarChartGroupData(
// //                   x: index,
// //                   barRods: [
// //                     BarChartRodData(
// //                       toY: entries[index].value,
// //                       color: Theme.of(context).colorScheme.primary,
// //                       width: isWeekly ? 10 : 16,
// //                       borderRadius: const BorderRadius.vertical(
// //                         top: Radius.circular(4),
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               }),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String _getLabel(DateTime date) {
// //     if (isWeekly) {
// //       return '${date.month}/${date.day}'; // e.g., "8/3"
// //     }
// //     const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
// //     return days[date.weekday - 1]; // e.g., "Mon"
// //   }
// // }
//
// import 'package:flutter/material.dart';
//
// class SpendingTrendChart extends StatelessWidget {
//   const SpendingTrendChart({
//     super.key,
//     required this.spendingData,
//     this.isWeekly = false,
//   });
//
//   final Map<DateTime, double> spendingData;
//   final bool isWeekly;
//
//   @override
//   Widget build(BuildContext context) {
//     if (spendingData.isEmpty) {
//       return Card(
//         elevation: 1,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('No data available'),
//         ),
//       );
//     }
//
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.bar_chart_outlined, size: 24),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Spending Trends',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
