import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/currency_model.dart';
import '../view_models/currency_view_model.dart';
import 'currency_dropdown.dart';

class CurrencyConverter extends ConsumerWidget {
  const CurrencyConverter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyViewModelProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(currencyViewModelProvider.notifier).resetInput();
        }
      },
      child: state.currencies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CurrencyConverterForm(currencies: state.currencies),
    );
  }
}

class CurrencyConverterForm extends ConsumerWidget {
  final List<Currency> currencies;

  const CurrencyConverterForm({super.key, required this.currencies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyViewModelProvider);
    final viewModel = ref.read(currencyViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
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