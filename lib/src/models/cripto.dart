class Cripto {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double totalVolume;
  final List<double> sparkline7d;

  Cripto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.sparkline7d,
  });

  factory Cripto.fromJson(Map<String, dynamic> json) {
    return Cripto(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: json['current_price']?.toDouble() ?? 0.0,
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble() ?? 0.0,
      totalVolume: json['total_volume']?.toDouble() ?? 0.0,
      sparkline7d: List<double>.from(json['sparkline_in_7d']['price'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChangePercentage24h,
      'total_volume': totalVolume,
      'sparkline_in_7d': {
        'price': sparkline7d,
      },
    };
  }

  Cripto copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? priceChangePercentage24h,
    double? totalVolume,
    List<double>? sparkline7d,
  }) {
    return Cripto(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      totalVolume: totalVolume ?? this.totalVolume,
      sparkline7d: sparkline7d ?? this.sparkline7d,
    );
  }

  bool get isPriceUp => priceChangePercentage24h >= 0;
}