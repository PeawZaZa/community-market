class Order {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String productId;
  final String productTitle;
  final String? productImagePath;
  final double price;
  final int quantity;
  final OrderStatus status;
  final DateTime createdAt;
  final String? note;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.productId,
    required this.productTitle,
    this.productImagePath,
    required this.price,
    this.quantity = 1,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.note,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'product_id': productId,
      'product_title': productTitle,
      'product_image_path': productImagePath,
      'price': price,
      'quantity': quantity,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      buyerId: map['buyer_id'],
      buyerName: map['buyer_name'],
      sellerId: map['seller_id'],
      sellerName: map['seller_name'],
      productId: map['product_id'],
      productTitle: map['product_title'],
      productImagePath: map['product_image_path'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] ?? 1,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at']),
      note: map['note'],
    );
  }

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      buyerId: buyerId,
      buyerName: buyerName,
      sellerId: sellerId,
      sellerName: sellerName,
      productId: productId,
      productTitle: productTitle,
      productImagePath: productImagePath,
      price: price,
      quantity: quantity,
      status: status ?? this.status,
      createdAt: createdAt,
      note: note,
    );
  }
}

enum OrderStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'รอยืนยัน';
      case OrderStatus.confirmed:
        return 'ยืนยันแล้ว';
      case OrderStatus.completed:
        return 'สำเร็จ';
      case OrderStatus.cancelled:
        return 'ยกเลิก';
    }
  }
}
