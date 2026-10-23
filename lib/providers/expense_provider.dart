import 'package:flutter/foundation.dart' hide Category;
import 'package:penny_wise/models/expense.dart';
import 'package:penny_wise/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider extends ChangeNotifier {
  //Get storage service instance
  final StorageService _storageService = StorageService.instance;

  //get expenses
  List<Expense> _expenses = [];

  //state is loading or not
  bool _isLoading = false;

  //for unique id
  final _uuid = const Uuid();

  //get loading state
  bool get isLoading => _isLoading;

  //get expenses list
  List<Expense> get expenses => _expenses;

  //get number of expenses
  int get expenseCount => _expenses.length;

  //get total sum of expenses
  double get totalExpense =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  //get total expense amount in the current month
  double get monthlyTotalExpense {
    final now = DateTime.now();

    final currentMonthExpenses = _expenses.where((expense) {
      final isCurrentMonth =
          expense.date.year == now.year && expense.date.month == now.month;

      return isCurrentMonth;
    });
    return currentMonthExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  //calculate spending of last 7 days
  Map<DateTime, double> get dailyExpenses {
    final now = DateTime.now();
    final List<DateTime> days = [];
    //list of 7 days
    for (int i = 6; i >= 0; i--) {
      days.add(DateTime(now.year, now.month, now.day - i));
    }
    final Map<DateTime, double> result = {};
    for (var day in days) {
      final total = _expenses
          .where(
            (expense) =>
                expense.date.year == day.year &&
                expense.date.month == day.month &&
                expense.date.day == day.day,
          )
          .fold(0.0, (sum, item) => sum + item.amount);
      result[day] = total;
    }
    return result;
  }

  //group weekly spendings
  Map<DateTime, double> get weeklyExpense {
    final now = DateTime.now();
    final Map<DateTime, double> result = {};

    //for last 12 weeks
    for (int i = 11; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
      final weekEnd = weekStart.add(Duration(days: 7));

      //calculate the expense in the week
      final total = _expenses
          .where(
            (expense) =>
                expense.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
                expense.date.isBefore(weekEnd),
          )
          .fold(0.0, (sum, item) => sum + item.amount);
      result[weekStart] = total;
    }
    return result;
  }

  //get to check if there are expenses in current month or not
  bool get hasMonthlyExpenses => monthlyTotalExpense > 0;

  double get monthlyAverageExpense {
    if (_expenses.isEmpty) return 0.0;
    //get all months with expense
    final monthWithExpenses = <String>{};
    for (var expense in _expenses) {
      final key = '${expense.date.year}-${expense.date.month}';
      monthWithExpenses.add(key);
    }
    return totalExpense / monthWithExpenses.length;
  }

  //get expenses categories
  Map<String, List<Expense>> get expenseCategory {
    final Map<String, List<Expense>> categoryMap = {};

    for (var expense in _expenses) {
      final String categoryName = expense.category.label;

      if (!categoryMap.containsKey(categoryName)) {
        categoryMap[categoryName] = [];
      }
      categoryMap[categoryName]!.add(expense);
    }
    return categoryMap;
  }

  int get categoryCount => expenseCategory.length;

  //get total expense amount based on categories
  Map<String, double> get categoryTotal {
    final Map<String, double> totals = {};

    for (var expense in _expenses) {
      totals[expense.category.label] =
          (totals[expense.category.label] ?? 0.0) + expense.amount;
    }
    return totals;
  }

  //sort newest first by date
  List<Expense> get recentExpenses =>
      List.from(_expenses)..sort((a, b) => b.date.compareTo(a.date));

  //get the top 3 most spend categories
  List<MapEntry<String, double>> get topCategories {
    final sorted = categoryTotal.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).toList();
  }

  //Methods for operations on Expenses

  //Method to load expenses
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _expenses = await _storageService.loadExpenses();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load expense data. Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Methods to save expenses in storage
  Future<void> saveExpenses() async {
    try {
      await _storageService.saveExpenses(_expenses);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save expenses in storage. Error: $e');
      }
    }
  }

  //Method to add new expense
  Future<void> addExpense(
    String title,
    double amount,
    DateTime date,
    Category category,
  ) async {
    final newExpense = Expense(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    _expenses.add(newExpense);
    notifyListeners();
    try {
      await saveExpenses();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add the expense. Error: $e');
      }
    }
  }

  //Method to delete the expense
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expenses) => expenses.id == id);
    notifyListeners();
    try {
      await saveExpenses();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delte the expense. Error: $e');
      }
    }
  }
}
