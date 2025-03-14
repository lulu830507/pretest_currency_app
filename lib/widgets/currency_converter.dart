import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_model.dart';
import '../view_models/currency_converter_state.dart';
import '../view_models/currency_view_model.dart';
import 'currency_dropdown.dart';

class CurrencyConverter extends ConsumerWidget {
  const CurrencyConverter({super.key, required this.currencies});

  final List<Currency> currencies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(
      currencyViewModelProvider.notifier,
    ); // 只需要 ViewModel，不需要監聽
    final state = ref.watch(currencyViewModelProvider); // 用來處理 UI 顯示的狀態
    return CurrencyConverterForm(
        currencies: currencies,
        state: state,
        viewModel: viewModel,
    );
  }
}

class CurrencyConverterForm extends ConsumerWidget {
  final List<Currency> currencies;
  final CurrencyConverterState state;
  final CurrencyConverterViewModel viewModel;

  const CurrencyConverterForm({
    super.key,
    required this.currencies,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CurrencyDropdown(
                    hint: 'Select currency',
                    currencies: currencies,
                    isFromCurrency: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: viewModel.amountController,
                    onChanged: viewModel.setAmount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.showError) ...[
              const SizedBox(height: 8),
              const Text(
                '請選擇轉換幣別或輸入數量',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CurrencyDropdown(
                    hint: 'Select currency',
                    currencies: currencies,
                    isFromCurrency: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    viewModel.amountController.text.isEmpty ||
                            state.result == 0.0
                        ? ''
                        : state.result.toStringAsFixed(
                          state.toCurrency?.amountDecimal ?? 2,
                        ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
