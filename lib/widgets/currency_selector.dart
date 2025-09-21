import 'package:flutter/material.dart';
import '../models/currency.dart';

class CurrencySelector extends StatefulWidget {
  final Currency selectedCurrency;
  final Function(Currency) onCurrencySelected;
  final String? labelText;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
    this.labelText,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = CurrencyData.currencies;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCurrencies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies() {
    setState(() {
      _filteredCurrencies = CurrencyData.searchCurrencies(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showCurrencyPicker,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText ?? 'العملة',
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Row(
          children: [
            Text(
              widget.selectedCurrency.symbol,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.selectedCurrency.name} (${widget.selectedCurrency.code})',
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اختر العملة'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'البحث عن العملة',
                    hintText: 'اكتب اسم العملة أو الرمز...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Currency list
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = _filteredCurrencies[index];
                      final isSelected = currency.code == widget.selectedCurrency.code;
                      
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              currency.symbol,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          currency.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(currency.code),
                        trailing: isSelected 
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          widget.onCurrencySelected(currency);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}

