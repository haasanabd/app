import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as model;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cash_flow.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cash_transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        currency_code TEXT NOT NULL,
        current_balance REAL
      )
    ''');
  }

  Future<int> insertTransaction(model.Transaction transaction) async {
    final db = await database;
    return await db.insert('cash_transactions', transaction.toMap());
  }

  Future<List<model.Transaction>> getTransactionsForDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'cash_transactions',
      where: 'date BETWEEN ? AND ? AND type IN (?, ?)',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
        'Income',
        'Expense'
      ],
      orderBy: 'date ASC, id ASC',
    );

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<Map<String, double>> getBalanceAtDateStart(DateTime date, String currencyCode) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    final List<Map<String, dynamic>> result = await db.query(
      'cash_transactions',
      columns: ['current_balance'],
      where: 'date < ? AND currency_code = ?',
      whereArgs: [startOfDay.toIso8601String(), currencyCode],
      orderBy: 'date DESC, id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return {
        currencyCode: result.first['current_balance']?.toDouble() ?? 0.0,
      };
    }

    return {currencyCode: 0.0};
  }

  Future<Map<String, Map<String, double>>> getDayTotals(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        currency_code,
        SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN type = 'Expense' THEN ABS(amount) ELSE 0 END) as total_expense,
        SUM(amount) as net_amount
      FROM cash_transactions 
      WHERE date BETWEEN ? AND ?
      GROUP BY currency_code
    ''', [startOfDay.toIso8601String(), endOfDay.toIso8601String()]);

    Map<String, Map<String, double>> totals = {};
    
    for (final row in result) {
      final currencyCode = row['currency_code'] as String;
      totals[currencyCode] = {
        'income': row['total_income']?.toDouble() ?? 0.0,
        'expense': row['total_expense']?.toDouble() ?? 0.0,
        'net': row['net_amount']?.toDouble() ?? 0.0,
      };
    }

    return totals;
  }

  Future<int> updateTransaction(model.Transaction transaction) async {
    final db = await database;
    return await db.update(
      'cash_transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'cash_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<model.Transaction?> getTransaction(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cash_transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return model.Transaction.fromMap(maps.first);
    }
    return null;
  }
}

