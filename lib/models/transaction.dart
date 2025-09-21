import 'currency.dart';

class Transaction {
  final int? id;
  final DateTime date;
  final String type; // 'Income' or 'Expense'
  final String description;
  final double amount;
  final Currency currency;
  final double? currentBalance;

  Transaction({
    this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.amount,
    required this.currency,
    this.currentBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'description': description,
      'amount': amount,
      'currency_code': currency.code,
      'current_balance': currentBalance,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    final currencyCode = map['currency_code'] ?? 'USD';
    final currency = CurrencyData.findByCode(currencyCode) ?? 
                    const Currency(code: 'USD', name: 'الدولار الأمريكي', symbol: '\$');
    
    return Transaction(
      id: map['id']?.toInt(),
      date: DateTime.parse(map['date']),
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      currency: currency,
      currentBalance: map['current_balance']?.toDouble(),
    );
  }

  Transaction copyWith({
    int? id,
    DateTime? date,
    String? type,
    String? description,
    double? amount,
    Currency? currency,
    double? currentBalance,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }
}

