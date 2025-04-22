class CriptoDetails {
  final String id;
  final String name;
  final String symbol;
  final String description;
  final CriptoImage? images;
  final MarketData? marketData;
  final Map<String, String> links;

  CriptoDetails({
    required this.id,
    required this.name,
    required this.symbol,
    required this.description,
    this.images,
    this.marketData,
    required this.links,
  });

  factory CriptoDetails.fromJson(Map<String, dynamic> json) {
    try {
      return CriptoDetails(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Nome não disponível',
        symbol: json['symbol']?.toString() ?? '',
        description: json['description']?['en']?.toString() ?? 'Descrição não disponível',
        images: json['image'] != null ? CriptoImage.fromJson(json['image']) : null,
        marketData: json['market_data'] != null ? MarketData.fromJson(json['market_data']) : null,
        links: _parseLinks(json['links']),
      );
    } catch (e) {
      throw Exception('Erro ao parsear detalhes: $e');
    }
  }

  static Map<String, String> _parseLinks(Map<String, dynamic>? links) {
    final result = <String, String>{};
    if (links == null) return result;
    
    try {
      if (links['homepage'] is List && (links['homepage'] as List).isNotEmpty) {
        result['homepage'] = links['homepage'][0]?.toString() ?? '';
      }
      if (links['whitepaper'] != null) {
        result['whitepaper'] = links['whitepaper']?.toString() ?? '';
      }
      if (links['twitter_screen_name'] != null) {
        result['twitter'] = 'https://twitter.com/${links['twitter_screen_name']}';
      }
      if (links['subreddit_url'] != null) {
        result['reddit'] = links['subreddit_url']?.toString() ?? '';
      }
    } catch (e) {
      Exception('Erro ao parsear links: $e');
    }
    
    return result;
  }
}

class MarketData {
  final double currentPrice;
  final double priceChangePercentage24h;
  final double totalVolume;
  final double marketCap;
  final int marketCapRank;
  final List<double> sparkline7d;

  MarketData({
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.marketCap,
    required this.marketCapRank,
    required this.sparkline7d,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    try {
      return MarketData(
        currentPrice: json['current_price']?['brl']?.toDouble() ?? 0.0,
        priceChangePercentage24h: 
            json['price_change_percentage_24h_in_currency']?['brl']?.toDouble() ?? 0.0,
        totalVolume: json['total_volume']?['brl']?.toDouble() ?? 0.0,
        marketCap: json['market_cap']?['brl']?.toDouble() ?? 0.0,
        marketCapRank: json['market_cap_rank']?.toInt() ?? 0,
        sparkline7d: List<double>.from(json['sparkline_7d']?['price'] ?? []),
      );
    } catch (e) {
      throw Exception('Erro ao parsear market_data: $e');
    }
  }
}

class CriptoImage {
  final String thumb;
  final String small;
  final String large;

  CriptoImage({
    required this.thumb,
    required this.small,
    required this.large,
  });

  factory CriptoImage.fromJson(Map<String, dynamic> json) {
    return CriptoImage(
      thumb: json['thumb'],
      small: json['small'],
      large: json['large'],
    );
  }
}