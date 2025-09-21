import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../models/currency.dart';
import '../widgets/transaction_dialog.dart';

class CashFlowScreen extends StatefulWidget {
  const CashFlowScreen({super.key});

  @override
  State<CashFlowScreen> createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends State<CashFlowScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .loadTransactionsForDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // App Bar with gradient
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF6a11cb), Color(0xFF2575fc)],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '💰 سجل الصادر والوارد اليومي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDateNavigation(provider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Date info
                SliverToBoxAdapter(
                  child: _buildDateInfo(provider),
                ),

                // Currency summaries
                SliverToBoxAdapter(
                  child: _buildCurrencySummaries(provider),
                ),

                // Add new transaction button
                SliverToBoxAdapter(
                  child: _buildAddTransactionButton(),
                ),

                // Expenses section
                SliverToBoxAdapter(
                  child: _buildExpensesSection(provider),
                ),

                // Income section
                SliverToBoxAdapter(
                  child: _buildIncomeSection(provider),
                ),

                // Balance summary
                SliverToBoxAdapter(
                  child: _buildBalanceSummary(provider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateNavigation(TransactionProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton('◀️ السابق', provider.goToPreviousDay),
          _buildNavButton('التالي ▶️', provider.goToNextDay),
          _buildNavButton('📅 اليوم', provider.goToToday),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(70, 30),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDateInfo(TransactionProvider provider) {
    final arabicDays = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    final dayName = arabicDays[provider.currentDate.weekday - 1];
    final dateStr = DateFormat('yyyy-MM-dd').format(provider.currentDate);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFe9ecef),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'اليوم: $dayName',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF495057),
            ),
          ),
          Text(
            'التاريخ: $dateStr',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF495057),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySummaries(TransactionProvider provider) {
    final activeCurrencies = provider.activeCurrencies;
    
    if (activeCurrencies.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'لا توجد حركات لهذا اليوم',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: activeCurrencies.map((currencyCode) {
          final currency = CurrencyData.findByCode(currencyCode);
          final dayTotals = provider.dayTotals[currencyCode];
          final expenseTotal = dayTotals?['expense'] ?? 0.0;
          final incomeTotal = dayTotals?['income'] ?? 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffe0b2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'إجمالي الصادر',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFe65100),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currency?.symbol ?? currencyCode} ${_formatNumber(expenseTotal)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFe65100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFc8e6c9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'إجمالي الوارد',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2e7d32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currency?.symbol ?? currencyCode} ${_formatNumber(incomeTotal)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2e7d32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddTransactionButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _showAddTransactionDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFff5722),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        child: const Text(
          '➕ إضافة حركة جديدة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesSection(TransactionProvider provider) {
    return _buildTransactionSection(
      title: 'الصادر',
      transactions: provider.expenseTransactions,
      titleColor: const Color(0xFF721c24),
      backgroundColor: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
      ),
    );
  }

  Widget _buildIncomeSection(TransactionProvider provider) {
    return _buildTransactionSection(
      title: 'الوارد',
      transactions: provider.incomeTransactions,
      titleColor: const Color(0xFF155724),
      backgroundColor: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF84fab0), Color(0xFF8fd3f4)],
      ),
    );
  }

  Widget _buildTransactionSection({
    required String title,
    required List<Transaction> transactions,
    required Color titleColor,
    required LinearGradient backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFdee2e6)),
      ),
      child: Column(
        children: [
          // Section title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),

          // Table headers
          Container(
            color: const Color(0xFFf8f9fa),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: const Row(
              children: [
                Expanded(flex: 4, child: Text('التفاصيل', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('العملة', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('العملية', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // Transactions list
          if (transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'لا توجد حركات',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ...transactions.map((transaction) => _buildTransactionRow(transaction)),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Transaction transaction) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFdee2e6), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              transaction.description,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(transaction.amount.abs()),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.currency.symbol,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showEditTransactionDialog(transaction),
                  icon: const Icon(Icons.edit, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFf6c23e),
                    foregroundColor: const Color(0xFF343a40),
                    minimumSize: const Size(30, 30),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _deleteTransaction(transaction),
                  icon: const Icon(Icons.delete, size: 16),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFdc3545),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(30, 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummary(TransactionProvider provider) {
    final activeCurrencies = provider.activeCurrencies;
    
    if (activeCurrencies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: activeCurrencies.map((currencyCode) {
          final currency = CurrencyData.findByCode(currencyCode);
          final openingBalance = provider.openingBalances[currencyCode] ?? 0.0;
          final closingBalance = provider.closingBalances[currencyCode] ?? 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFffd166), Color(0xFFffb347)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🔄 مدور بداية اليوم',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF343a40),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currency?.symbol ?? currencyCode} ${_formatNumber(openingBalance)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF343a40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF00b09b), Color(0xFF96c93d)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '💰 باقي نهاية اليوم',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currency?.symbol ?? currencyCode} ${_formatNumber(closingBalance)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatNumber(double number) {
    return NumberFormat('#,##0.00').format(number);
  }

  void _showAddTransactionDialog() async {
    final result = await showDialog<Transaction>(
      context: context,
      builder: (context) => const TransactionDialog(),
    );

    if (result != null && mounted) {
      try {
        await Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تمت إضافة الحركة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في إضافة الحركة: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showEditTransactionDialog(Transaction transaction) async {
    final result = await showDialog<Transaction>(
      context: context,
      builder: (context) => TransactionDialog(
        transaction: transaction,
        isEdit: true,
      ),
    );

    if (result != null && mounted) {
      try {
        await Provider.of<TransactionProvider>(context, listen: false)
            .updateTransaction(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تعديل الحركة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في تعديل الحركة: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _deleteTransaction(Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف الحركة "${transaction.description}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await Provider.of<TransactionProvider>(context, listen: false)
            .deleteTransaction(transaction.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف الحركة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في حذف الحركة: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

