import 'package:flutter/material.dart';
import 'package:penny_wise/providers/expense_provider.dart';
import 'package:penny_wise/screens/add_expense_screen.dart';
import 'package:penny_wise/screens/stats_screen.dart';
import 'package:penny_wise/widgets/expense_list.dart';
import 'package:penny_wise/widgets/expense_summary_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Penny Wise',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        elevation: 16,
        child: Icon(Icons.add, size: 36),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.expenses.isEmpty) {
            return const Center(child: Text('No expenses recorded yet'));
          }
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ExpenseSummaryCard(),
                SizedBox(height: 16),
                Text(
                  'Expenses List',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 16),
                Expanded(child: ExpenseList()),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home_outlined, size: 36),
            ),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatsScreen()),
                );
              },
              icon: Icon(Icons.bar_chart, size: 36),
            ),
          ],
        ),
      ),
    );
  }
}
