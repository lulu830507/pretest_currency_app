import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/currency_view_model.dart';
import '../widgets/currency_converter.dart';

class ConversionScreen extends ConsumerWidget {
  const ConversionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Conversion'),
      ),
      body: state.currencies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CurrencyConverter(),
    );
  }
}