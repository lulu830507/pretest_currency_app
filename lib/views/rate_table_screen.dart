import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/currency_repositories.dart';
import '../widgets/currency_item.dart';
import 'conversion_screen.dart';

class RateTableScreen extends ConsumerWidget {
  const RateTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsyncValue = ref.watch(currencyProvider); // 直接監聽 currencyProvider

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Table (TWD)')),
      body: currencyAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Failed to load data')),
        data: (currencies) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  // 使用 Consumer 監聽單一 Currency 數據達到局部更新
                  return Consumer(
                    builder: (context, ref, _) {
                      return CurrencyItem(currency: currency);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConversionScreen()),
                  );
                },
                child: const Text(
                  'Rate Conversion',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
