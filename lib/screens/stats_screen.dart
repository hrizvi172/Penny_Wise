import 'package:flutter/material.dart';
import 'package:penny_wise/providers/expense_provider.dart';
import 'package:penny_wise/widgets/category_chart.dart';
import 'package:penny_wise/widgets/spending_overview_card.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreen();
}

class _StatsScreen extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SpendingOverviewCard(),
              CategoryChart(
                categoryTotal: provider.categoryTotal,
                totalExpenses: provider.totalExpense,
              ),
              // SpendingTrendChart(spendingData: provider.dailyExpenses),
              // SpendingTrendChart(
              //   spendingData: provider.weeklyExpense,
              //   isWeekly: true,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
