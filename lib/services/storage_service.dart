import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class StorageService {
  StorageService._privateConstructor();

  static final StorageService _instance = StorageService._privateConstructor();

  static StorageService get instance => _instance;
  static final String _storageKey = 'my_expense';

  //function to save the data in share preferences
  Future<void> saveExpenses(List<Expense> expenses) async {
    try {
      //get the storage
      final prefs = await SharedPreferences.getInstance();
      //convert expenses to map
      final List<Map<String, dynamic>> expensesMap = expenses
          .map((expense) => expense.toJson())
          .toList();

      //convert the map to json
      final String jsonString = jsonEncode(expensesMap);
      //store in the phone's storeage
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving the data $e');
      rethrow;
    }
  }

  //function to load the data from shared preferences
  Future<List<Expense>> loadExpenses() async {
    try {
      //get to phone storage
      final prefs = await SharedPreferences.getInstance();
      //get the data using storage key
      final String? jsonString = prefs.getString(_storageKey);
      //if there is nothing to return
      if (jsonString == null) {
        return [];
      }
      //convert jsonSting to map
      final List<dynamic> expensesMap = jsonDecode(jsonString);
      //convert the map to expense
      final List<Expense> expenses = expensesMap
          .map((map) => Expense.fromJson(map as Map<String, dynamic>))
          .toList();

      return expenses;
    } catch (e) {
      print('Error loading the data $e');
      return [];
    }
  }
}
