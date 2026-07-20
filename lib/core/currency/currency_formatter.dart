import 'package:intl/intl.dart';

class CurrencyFormatter {
  static const Map<String, String> _symbols = {
    'NGN': '₦',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'CAD': 'CA\$',
    'GHS': 'GH₵',
    'KES': 'KSh',
    'ZAR': 'R',
  };

  static String format(double amount, String currencyCode) {
    final symbol = _symbols[currencyCode.toUpperCase()] ?? '$currencyCode ';
    final formatted = NumberFormat('#,##0.00').format(amount);
    return '$symbol$formatted';
  }

  static String symbolFor(String currencyCode) {
    return _symbols[currencyCode.toUpperCase()] ?? currencyCode.toUpperCase();
  }
}