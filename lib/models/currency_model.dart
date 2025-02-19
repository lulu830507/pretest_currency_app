class Currency {
  final int id;
  final String currency;
  final String currencyIcon;
  final double twdPrice;
  final int amountDecimal;

  Currency({
    required this.id,
    required this.currency,
    required this.currencyIcon,
    required this.twdPrice,
    required this.amountDecimal,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: int.parse(json['id']),
      currency: json['currency'],
      currencyIcon: json['currency_icon'] ?? '',
      twdPrice: double.parse(json['twd_price'].toString()),
      amountDecimal: int.parse(json['amount_decimal'].toString()),
    );
  }
}
