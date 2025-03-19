import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/currency_model.dart';

class CurrencyItem extends StatelessWidget {
  final Currency currency;

  const CurrencyItem({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0.00", "en_US");

    return ListTile(
      key: ValueKey(currency.id), // 確保 ListView 識別每個項目，減少重建
      leading: CachedNetworkImage(
        imageUrl: currency.currencyIcon,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => const SizedBox(
          width: 40,
          height: 40,
          child: Center(child: Icon(Icons.error, size: 24, color: Colors.red)),
        ),
      ),
      title: Text('${currency.currency} / TWD'),
      trailing: Text(
        numberFormat.format(currency.twdPrice),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
