import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/currency.dart';
import '../services/database_helper.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  List<Transaction> _transactions = [];
  DateTime _currentDate = DateTime.now();
  Map<String, double> _openingBalances = {};
  Map<String, Map<String, double>> _dayTotals = {};

  List<Transaction> get transactions => _transactions;
  DateTime get currentDate => _currentDate;
  Map<String, double> get openingBalances => _openingBalances;
  Map<String, Map<String, double>> get dayTotals => _dayTotals;

  List<Transaction> get expenseTransactions =>
      _transactions.where((t) => t.type == 'Expense').toList();

  List<Transaction> get incomeTransactions =>
      _transactions.where((t) => t.type == 'Income').toList();

  Map<String, double> get closingBalances {
    Map<String, double> closing = {};
    
    for (String currencyCode in _openingBalances.keys) {
      final opening = _openingBalances[currencyCode] ?? 0.0;
      final dayTotal = _dayTotals[currencyCode];
      final net = dayTotal?['net'] ?? 0.0;
      closing[currencyCode] = opening + net;
    }
    
    // Add currencies that have day totals but no opening balance
    for (String currencyCode in _dayTotals.keys) {
      if (!closing.containsKey(currencyCode)) {
        final net = _dayTotals[currencyCode]?['net'] ?? 0.0;
        closing[currencyCode] = net;
      }
    }
    
    return closing;
  }

  List<String> get activeCurrencies {
    Set<String> currencies = {};
    currencies.addAll(_openingBalances.keys);
    currencies.addAll(_dayTotals.keys);
    currencies.addAll(_transactions.map((t) => t.currency.code));
    return currencies.toList()..sort();
  }

  void setCurrentDate(DateTime date) {
    _currentDate = date;
    loadTransactionsForDate(date);
  }

  void goToPreviousDay() {
    setCurrentDate(_currentDate.subtract(const Duration(days: 1)));
  }

  void goToNextDay() {
    setCurrentDate(_currentDate.add(const Duration(days: 1)));
  }

  void goToToday() {
    setCurrentDate(DateTime.now());
  }

  Future<void> loadTransactionsForDate(DateTime date) async {
    try {
      _transactions = await _databaseHelper.getTransactionsForDate(date);
      _dayTotals = await _databaseHelper.getDayTotals(date);
      
      // Load opening balances for all currencies used in transactions
      _openingBalances = {};
      Set<String> currencyCodes = {};
      currencyCodes.addAll(_transactions.map((t) => t.currency.code));
      currencyCodes.addAll(_dayTotals.keys);
      
      for (String currencyCode in currencyCodes) {
        final balance = await _databaseHelper.getBalanceAtDateStart(date, currencyCode);
        _openingBalances.addAll(balance);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      // Calculate new balance
      final currencyCode = transaction.currency.code;
      final openingBalance = await _databaseHelper.getBalanceAtDateStart(_currentDate, currencyCode);
      final dayTotals = await _databaseHelper.getDayTotals(_currentDate);
      
      final currentBalance = openingBalance[currencyCode] ?? 0.0;
      final dayNet = dayTotals[currencyCode]?['net'] ?? 0.0;
      final newBalance = currentBalance + dayNet + transaction.amount;
      
      final transactionWithBalance = transaction.copyWith(
        currentBalance: newBalance,
      );
      
      await _databaseHelper.insertTransaction(transactionWithBalance);
      await loadTransactionsForDate(_currentDate);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _databaseHelper.updateTransaction(transaction);
      await _recalculateBalances(transaction.date);
      await loadTransactionsForDate(_currentDate);
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final transaction = await _databaseHelper.getTransaction(id);
      if (transaction != null) {
        await _databaseHelper.deleteTransaction(id);
        await _recalculateBalances(transaction.date);
        await loadTransactionsForDate(_currentDate);
      }
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  Future<void> _recalculateBalances(DateTime fromDate) async {
    // This is a simplified version. In a real app, you might want to
    // recalculate all balances from the affected date onwards
    // For now, we'll just reload the current date's data
    await loadTransactionsForDate(_currentDate);
  }

  String formatAmount(double amount, String currencyCode) {
    final currency = CurrencyData.findByCode(currencyCode);
    final symbol = currency?.symbol ?? currencyCode;
    return '$symbol ${amount.abs().toStringAsFixed(2)}';
  }

  Map<String, double> getTotalsByType(String type) {
    Map<String, double> totals = {};
    
    for (final transaction in _transactions) {
      if (transaction.type == type) {
        final currencyCode = transaction.currency.code;
        totals[currencyCode] = (totals[currencyCode] ?? 0.0) + transaction.amount.abs();
      }
    }
    
    return totals;
  }
}

