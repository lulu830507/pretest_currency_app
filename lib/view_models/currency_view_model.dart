import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_model.dart';
import '../repositories/currency_repositories.dart';
import 'currency_converter_state.dart';

final currencyViewModelProvider = StateNotifierProvider.autoDispose<
  CurrencyConverterViewModel,
  CurrencyConverterState
>((ref) {
  final currencies = ref.watch(currencyProvider).value ?? [];
  return CurrencyConverterViewModel(currencies: currencies);
});

class CurrencyConverterViewModel extends StateNotifier<CurrencyConverterState> {
  final TextEditingController amountController = TextEditingController();

  CurrencyConverterViewModel({required List<Currency> currencies})
    : super(
        CurrencyConverterState(
          amount: 0,
          result: 0.0,
          showError: false,
          fromCurrency: null,
          toCurrency: null,
          currencies: currencies, // 直接拿到 currencies
        ),
      );

  // 設置貨幣
  void setFromCurrency(Currency? currency) {
    // 更新 fromCurrency 時，保留其他狀態
    state = state.copyWith(
      fromCurrency: currency,
      toCurrency: state.toCurrency,
      // 保留現有 toCurrency
      amount: state.amount,
      result: state.result,
      showError: state.showError,
      currencies: state.currencies,
    );
    convert();
  }

  void setToCurrency(Currency? currency) {
    // 更新 toCurrency 時，保留其他狀態
    state = state.copyWith(
      fromCurrency: state.fromCurrency,
      // 保留現有 fromCurrency
      toCurrency: currency,
      amount: state.amount,
      result: state.result,
      showError: state.showError,
      currencies: state.currencies,
    );
    convert();
  }

  void setAmount(String value) {
    final amount = double.tryParse(value) ?? 1.0;
    // 更新 amount 時，保留其他狀態
    state = state.copyWith(
      amount: amount,
      fromCurrency: state.fromCurrency,
      toCurrency: state.toCurrency,
      result: state.result,
      showError: state.showError,
      currencies: state.currencies,
    );
    convert();
  }

  // 轉換貨幣
  void convert() {
    final fromCurrency = state.fromCurrency;
    final toCurrency = state.toCurrency;

    // 若未選擇幣別，僅更新錯誤狀態，並保留現有的貨幣選擇
    if (fromCurrency == null || toCurrency == null) {
      state = state.copyWith(
        result: 0.0,
        showError: true,
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
        amount: state.amount,
        currencies: state.currencies,
      );
      return;
    }

    // 若 amount 為 0 或輸入框為空，僅更新錯誤狀態，並保留現有選擇
    if (state.amount <= 0 || amountController.text.trim().isEmpty) {
      state = state.copyWith(
        result: 0.0,
        showError: true,
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
        amount: state.amount,
        currencies: state.currencies,
      );
      return;
    }

    // 使用 Decimal 進行精確運算
    final amount = Decimal.parse(state.amount.toString());
    final fromPrice = Decimal.parse(fromCurrency.twdPrice.toString());
    final toPrice = Decimal.parse(toCurrency.twdPrice.toString());

    final result = amount * (fromPrice / toPrice).toDecimal(scaleOnInfinitePrecision: 18);


    state = state.copyWith(
      result: result.toDouble(),
      showError: false,
      fromCurrency: state.fromCurrency,
      toCurrency: state.toCurrency,
      amount: state.amount,
      currencies: state.currencies,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
