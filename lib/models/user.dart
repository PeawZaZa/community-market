class AppUser {
  final String id;
  final String name;
  final String location;
  final String? phone;
  final String? profileImagePath;
  final double rating;
  final int totalSales;
  final DateTime joinedAt;

  AppUser({
    required this.id,
    required this.name,
    required this.location,
    this.phone,
    this.profileImagePath,
    this.rating = 0.0,
    this.totalSales = 0,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'profile_image_path': profileImagePath,
      'rating': rating,
      'total_sales': totalSales,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      phone: map['phone'],
      profileImagePath: map['profile_image_path'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalSales: map['total_sales'] ?? 0,
      joinedAt: DateTime.parse(map['joined_at']),
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  AppUser copyWith({
    String? name,
    String? location,
    String? phone,
    String? profileImagePath,
    double? rating,
    int? totalSales,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      rating: rating ?? this.rating,
      totalSales: totalSales ?? this.totalSales,
      joinedAt: joinedAt,
    );
  }
}
