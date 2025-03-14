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
    // 只監聽選中的貨幣，避免 UI 重繪
    final selectedCurrency = ref.watch(currencyViewModelProvider.select((state) =>
    isFromCurrency ? state.fromCurrency : state.toCurrency));

    return DropdownButton<Currency>(
      value: selectedCurrency,
      hint: Text(hint),
      onChanged: (newValue) => _onCurrencyChanged(newValue, ref),
      items: currencies.map((currency) => _buildDropdownItem(currency)).toList(),
    );
  }

  DropdownMenuItem<Currency> _buildDropdownItem(Currency currency) {
    return DropdownMenuItem<Currency>(
      value: currency,
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: currency.currencyIcon,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) => Image.asset('assets/images/default_coin.png', width: 24, height: 24),
          ),
          const SizedBox(width: 8),
          Text(currency.currency),
        ],
      ),
    );
  }

  void _onCurrencyChanged(Currency? newValue, WidgetRef ref) {
    if (newValue == null) return;
    isFromCurrency
        ? ref.read(currencyViewModelProvider.notifier).setFromCurrency(newValue)
        : ref.read(currencyViewModelProvider.notifier).setToCurrency(newValue);
  }
}