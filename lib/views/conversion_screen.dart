import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/currency_repositories.dart';
import '../view_models/currency_view_model.dart';
import '../widgets/currency_converter.dart';

class ConversionScreen extends ConsumerWidget {
  const ConversionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsyncValue = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Conversion'),
      ),
      body:currencyAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (currencies) => CurrencyConverter(currencies: currencies), // 傳遞資料到 CurrencyConverter
      ),
    );
  }
}