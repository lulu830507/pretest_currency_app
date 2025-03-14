import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/currency_model.dart';

class CurrencyRepository {
  final String _baseUrl = 'https://65efcc68ead08fa78a50f929.mockapi.io/api/v1/pairs';

  Future<List<Currency>> fetchCurrencies() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Currency.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}

// Provider 只提供 Repository
final currencyRepositoryProvider = Provider<CurrencyRepository>(
      (ref) => CurrencyRepository(),
);

// FutureProvider 負責監聽 API 資料
final currencyProvider = FutureProvider<List<Currency>>((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return repository.fetchCurrencies();
});

