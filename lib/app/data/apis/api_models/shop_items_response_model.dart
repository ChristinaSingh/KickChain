class ShopItemsResponseModel {
  final int? statusCode;
  final List<ShopApiItem> data;
  final String? message;
  final bool? success;

  const ShopItemsResponseModel({
    this.statusCode,
    this.data = const [],
    this.message,
    this.success,
  });

  factory ShopItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopItemsResponseModel(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ShopApiItem.fromJson)
          .toList(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class ShopApiItem {
  final String id;
  final String category;
  final String name;
  final String image;
  final String description;
  final num price;
  final bool isFree;
  final bool isEquipped;
  final int coinAmount;
  final bool isActive;

  const ShopApiItem({
    required this.id,
    required this.category,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.isFree,
    required this.isEquipped,
    required this.coinAmount,
    required this.isActive,
  });

  factory ShopApiItem.fromJson(Map<String, dynamic> json) {
    return ShopApiItem(
      id: json['_id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] is num ? json['price'] as num : 0,
      isFree: json['isFree'] as bool? ?? false,
      isEquipped: json['isEquipped'] as bool? ?? false,
      coinAmount: json['coinAmount'] is num
          ? (json['coinAmount'] as num).toInt()
          : 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
