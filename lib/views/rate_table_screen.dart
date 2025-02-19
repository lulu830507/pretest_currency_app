import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/currency_view_model.dart';
import '../widgets/currency_item.dart';
import 'conversion_screen.dart';

class RateTableScreen extends ConsumerWidget {
  const RateTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Rate Table (TWD)')),
      body: Column(
        children: [
          state.currencies.isEmpty
              ? const Center(child: CircularProgressIndicator()) // 顯示 Loading 狀態
              : Expanded(
            child: ListView.builder(
              itemCount: state.currencies.length,
              itemBuilder: (context, index) {
                final currency = state.currencies[index];
                return CurrencyItem(currency: currency);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.black, width: 1),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConversionScreen()),
                );
              },
              child: Text(
                'Rate Conversion',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}