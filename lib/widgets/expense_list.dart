import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penny_wise/models/expense.dart';
import 'package:penny_wise/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.expenses.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final expense = provider.expenses;
            return Dismissible(
              key: Key(expense[index].id),
              onDismissed: (direction) {
                provider.deleteExpense(expense[index].id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${expense[index].title}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: ListTile(
                key: Key(expense[index].id),
                leading: CircleAvatar(
                  backgroundColor: expense[index].category.color,
                  child: Icon(expense[index].category.icon),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(expense[index].title),
                    Text(
                      'Rs. ${expense[index].amount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Text(
                  DateFormat('EEEE, MMMM d').format(expense[index].date),
                ),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }
}
