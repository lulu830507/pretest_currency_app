import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/currency_model.dart';

class CurrencyItem extends ConsumerWidget {
  final Currency currency;

  const CurrencyItem({super.key, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat("#,##0.00", "en_US");

    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: currency.currencyIcon,
        width: 40,
        height: 40,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text('${currency.currency} / TWD'),
      trailing: Text(
        numberFormat.format(currency.twdPrice),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
