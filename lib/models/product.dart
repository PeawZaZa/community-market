class Product {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerLocation;
  final String title;
  final String description;
  final double price;
  final String category;
  final String? imagePath;
  final int stock;
  final bool isAvailable;
  final DateTime createdAt;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLocation,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.imagePath,
    this.stock = 1,
    this.isAvailable = true,
    required this.createdAt,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'seller_id': sellerId,
        'seller_name': sellerName,
        'seller_location': sellerLocation,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'image_path': imagePath,
        'stock': stock,
        'is_available': isAvailable ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
        'rating': rating,
        'review_count': reviewCount,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        sellerId: map['seller_id'],
        sellerName: map['seller_name'],
        sellerLocation: map['seller_location'],
        title: map['title'],
        description: map['description'],
        price: (map['price'] as num).toDouble(),
        category: map['category'],
        imagePath: map['image_path'],
        stock: map['stock'] ?? 1,
        isAvailable: map['is_available'] == 1,
        createdAt: DateTime.parse(map['created_at']),
        rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: map['review_count'] ?? 0,
      );

  Product copyWith({
    String? title,
    String? description,
    double? price,
    String? category,
    String? imagePath,
    int? stock,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
  }) =>
      Product(
        id: id,
        sellerId: sellerId,
        sellerName: sellerName,
        sellerLocation: sellerLocation,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        category: category ?? this.category,
        imagePath: imagePath ?? this.imagePath,
        stock: stock ?? this.stock,
        isAvailable: isAvailable ?? this.isAvailable,
        createdAt: createdAt,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
      );

  String get categoryEmoji {
    const map = {
      'vegetables': '🥬',
      'food': '🍜',
      'handicraft': '🧺',
      'clothing': '👗',
      'herbs': '🌿',
      'other': '📦',
    };
    return map[category] ?? '📦';
  }

  String get categoryName {
    const map = {
      'vegetables': 'ผักผลไม้',
      'food': 'อาหาร',
      'handicraft': 'หัตถกรรม',
      'clothing': 'เสื้อผ้า',
      'herbs': 'สมุนไพร',
      'other': 'อื่นๆ',
    };
    return map[category] ?? 'อื่นๆ';
  }
}
