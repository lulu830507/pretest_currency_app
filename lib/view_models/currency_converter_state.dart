import '../models/currency_model.dart';

class CurrencyConverterState {
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final double amount;
  final double result;
  final bool showError;
  final List<Currency> currencies;

  CurrencyConverterState({
    this.fromCurrency,
    this.toCurrency,
    required this.amount,
    required this.result,
    required this.showError,
    this.currencies = const [],
  });

  CurrencyConverterState copyWith({
    Currency? fromCurrency,
    Currency? toCurrency,
    double? amount,
    double? result,
    bool? showError,
    List<Currency>? currencies,
  }) {
    return CurrencyConverterState(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      showError: showError ?? this.showError,
      currencies: currencies ?? this.currencies,
    );
  }
}