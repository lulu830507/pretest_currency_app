import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency_model.dart';
import '../view_models/currency_view_model.dart';

class CurrencyDropdown extends ConsumerWidget {
  final bool isFromCurrency;
  final String hint;
  final List<Currency> currencies;

  const CurrencyDropdown({
    super.key,
    required this.isFromCurrency,
    required this.hint,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyViewModelProvider);
    final viewModel = ref.read(currencyViewModelProvider.notifier);

    // 根據 isFromCurrency 選擇顯示的貨幣
    final selectedCurrency = isFromCurrency ? state.fromCurrency : state.toCurrency;

    return DropdownButton<Currency>(
      value: selectedCurrency,
      hint: Text(hint),
      onChanged: (Currency? newValue) {
        if (newValue != null) {
          isFromCurrency
              ? viewModel.setFromCurrency(newValue)
              : viewModel.setToCurrency(newValue);
        }
      },
      items: currencies.map((currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: currency.currencyIcon,
                placeholder: (context, url) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error, size: 24),
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(currency.currency),
            ],
          ),
        );
      }).toList(),
    );
  }
}
