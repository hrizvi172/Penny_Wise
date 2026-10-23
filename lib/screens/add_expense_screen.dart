import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penny_wise/models/expense.dart';
import 'package:penny_wise/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() {
    return _AddExpenseScreen();
  }
}

class _AddExpenseScreen extends State<AddExpenseScreen> {
  //Global key for validation
  final _formKey = GlobalKey<FormState>();

  //Controllers for Title and amount
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category? _selectedCategory;
  DateTime? _selectedDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  //function to pick date
  void _selectDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      initialDate: now,
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  void _submitData() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    //start loading
    setState() => _isSaving = true;

    //dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      _formKey.currentState!.save();
      await provider.addExpense(
        _titleController.text.trim(),
        double.parse(_amountController.text),
        _selectedDate!,
        _selectedCategory!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add expense: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Failed to add expense: $e');
    } finally {
      if (mounted) {
        setState() => _isSaving = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(label: Text('Expense Title')),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the expense';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(label: Text('Amount Rs.')),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                initialValue: _selectedCategory,
                decoration: InputDecoration(label: Text('Select Category')),
                items: Category.values.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: category.color,
                          radius: 10,
                          child: Icon(
                            category.icon,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(category.label),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Category? newCategory) {
                  setState(() {
                    _selectedCategory = newCategory;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (_selectedDate != null)
                      ? Text(
                          DateFormat('E, MMM dd, yyyy').format(_selectedDate!),
                        )
                      : Text('Please Select a date'),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: Text('Select date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _submitData,
                icon: _isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
