import 'package:flutter/material.dart';

enum Category {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  other,

  // final String label;
  //
  // const Category({required this.label});
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  //Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  //Deserialization
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      category: Category.values.firstWhere((e) => e.name == json['category']),
    );
  }
}

extension CategoryExtension on Category {
  //Display the category name
  String get label {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.bills:
        return 'Bills';
      case Category.entertainment:
        return 'Entertainment';
      case Category.other:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.restaurant;
      case Category.transport:
        return Icons.directions_car;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.bills:
        return Icons.receipt;
      case Category.entertainment:
        return Icons.movie;
      case Category.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case Category.food:
        return Colors.orange;
      case Category.transport:
        return Colors.blue;
      case Category.shopping:
        return Colors.purple;
      case Category.bills:
        return Colors.red;
      case Category.entertainment:
        return Colors.green;
      case Category.other:
        return Colors.grey;
    }
  }
}
