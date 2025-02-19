import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/rate_table_screen.dart';
import 'views/conversion_screen.dart';

void main() {
  runApp(ProviderScope(child: CurrencyConversionApp()));
}

class CurrencyConversionApp extends StatelessWidget {
  const CurrencyConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RateTableScreen(),
      routes: {
        '/conversion': (context) => ConversionScreen(),
      },
    );
  }
}