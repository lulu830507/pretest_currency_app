import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_model.dart';
import '../repositories/currency_repositories.dart';
import 'currency_converter_state.dart';

// Provider
final currencyRepositoryProvider = Provider<CurrencyRepository>(
      (ref) => CurrencyRepository(),
);

final currencyViewModelProvider = StateNotifierProvider.autoDispose<CurrencyConverterViewModel, CurrencyConverterState>((ref) {
  return CurrencyConverterViewModel(currencyRepository: ref.read(currencyRepositoryProvider));
});
class CurrencyConverterViewModel extends StateNotifier<CurrencyConverterState> {
  final CurrencyRepository currencyRepository;
  final TextEditingController amountController = TextEditingController();

  CurrencyConverterViewModel({required this.currencyRepository})
      : super(
    CurrencyConverterState(
      amount: 0,
      result: 0.0,
      showError: false,
      fromCurrency: null,
      toCurrency: null,
      currencies: [],
    ),
  ) {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    try {
      final currencies = await currencyRepository.fetchCurrencies();
      state = state.copyWith(currencies: currencies);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching currencies: $e');
      }
    }
  }

  // 設置貨幣
  void setFromCurrency(Currency? currency) {
    // 更新 fromCurrency 時，保留其他狀態
    state = state.copyWith(
      fromCurrency: currency,
      toCurrency: state.toCurrency, // 保留現有 toCurrency
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
      fromCurrency: state.fromCurrency, // 保留現有 fromCurrency
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

    // 正常計算轉換結果
    final result = state.amount * (fromCurrency.twdPrice / toCurrency.twdPrice);
    state = state.copyWith(
      result: result,
      showError: false,
      fromCurrency: state.fromCurrency,
      toCurrency: state.toCurrency,
      amount: state.amount,
      currencies: state.currencies,
    );
  }

  // 清空輸入框
  void resetInput() {
    amountController.clear();
    state = state.copyWith(
      fromCurrency: null,
      toCurrency: null,
      amount: 0,
      result: 0.0,
      showError: false,
      currencies: state.currencies,
    );
    if (kDebugMode) {
      print('Reset Input: fromCurrency = ${state.fromCurrency}, toCurrency = ${state.toCurrency}');
    }
  }

  @override
  void dispose() {
    resetInput();
    amountController.dispose();
    super.dispose();
  }
}
