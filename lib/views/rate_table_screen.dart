import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/currency_repositories.dart';
import '../widgets/currency_item.dart';
import 'conversion_screen.dart';

class RateTableScreen extends ConsumerWidget {
  const RateTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsyncValue = ref.watch(
      currencyProvider,
    ); // 直接監聽 currencyProvider

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Table (TWD)')),
      body: currencyAsyncValue.maybeWhen( // 避免整個 Scaffold 重建
        orElse: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load data')),
        data: (currencies) => CustomScrollView(
              // CustomScrollView + SliverList
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final currency = currencies[index];
                    return CurrencyItem(
                      key: ValueKey(currency.id),
                      currency: currency,
                    );
                  }, childCount: currencies.length),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.black, width: 1),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ConversionScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Rate Conversion',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
