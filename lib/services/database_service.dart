import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../utils/app_theme.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  final _uuid = const Uuid();

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        phone TEXT,
        profile_image_path TEXT,
        rating REAL DEFAULT 0.0,
        total_sales INTEGER DEFAULT 0,
        joined_at TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        seller_id TEXT NOT NULL,
        seller_name TEXT NOT NULL,
        seller_location TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        image_path TEXT,
        stock INTEGER DEFAULT 1,
        is_available INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        rating REAL DEFAULT 0.0,
        review_count INTEGER DEFAULT 0,
        FOREIGN KEY (seller_id) REFERENCES users(id)
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        buyer_id TEXT NOT NULL,
        buyer_name TEXT NOT NULL,
        seller_id TEXT NOT NULL,
        seller_name TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_title TEXT NOT NULL,
        product_image_path TEXT,
        price REAL NOT NULL,
        quantity INTEGER DEFAULT 1,
        status TEXT DEFAULT 'pending',
        created_at TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (buyer_id) REFERENCES users(id),
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');

    // Insert default user
    await db.insert('users', {
      'id': AppConstants.defaultUserId,
      'name': AppConstants.defaultUserName,
      'location': AppConstants.defaultUserLocation,
      'rating': 4.8,
      'total_sales': 34,
      'joined_at': DateTime.now().subtract(const Duration(days: 180)).toIso8601String(),
    });

    // Insert sample products
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }

  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    final sampleProducts = [
      {
        'id': _uuid.v4(),
        'seller_id': 'seller_002',
        'seller_name': 'ป้าแดง',
        'seller_location': 'แม่มาลัย, เชียงใหม่',
        'title': 'ผักออร์แกนิก รวมแพ็ค',
        'description': 'ผักสดจากสวน ปลูกเองไม่ใช้สารเคมี มีผักบุ้ง คะน้า กวางตุ้ง พาร์สลีย์',
        'price': 45.0,
        'category': 'vegetables',
        'stock': 20,
        'is_available': 1,
        'rating': 4.9,
        'review_count': 28,
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'seller_id': 'seller_003',
        'seller_name': 'ลุงสมศักดิ์',
        'seller_location': 'บ้านถวาย, เชียงใหม่',
        'title': 'ตะกร้าสานไม้ไผ่',
        'description': 'ตะกร้าสานมือจากไม้ไผ่ธรรมชาติ แข็งแรง ทนทาน งานฝีมือดั้งเดิม',
        'price': 120.0,
        'category': 'handicraft',
        'stock': 8,
        'is_available': 1,
        'rating': 4.7,
        'review_count': 15,
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'seller_id': 'seller_004',
        'seller_name': 'แม่สมหญิง',
        'seller_location': 'สันทราย, เชียงใหม่',
        'title': 'ขนมทองพับโบราณ',
        'description': 'ขนมไทยโบราณทำจากแป้งข้าวเจ้า กะทิสด น้ำตาลทราย อร่อยและกรอบ',
        'price': 80.0,
        'category': 'food',
        'stock': 15,
        'is_available': 1,
        'rating': 5.0,
        'review_count': 42,
        'created_at': now.subtract(const Duration(hours: 8)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'seller_id': 'seller_005',
        'seller_name': 'ป้านุ่น',
        'seller_location': 'สะเมิง, เชียงใหม่',
        'title': 'ชาดอยแม่สลอง',
        'description': 'ชาอู่หลงจากดอยแม่สลอง เก็บเองจากสวนชาอายุ 20 ปี กลิ่นหอมเข้มข้น',
        'price': 200.0,
        'category': 'herbs',
        'stock': 30,
        'is_available': 1,
        'rating': 4.8,
        'review_count': 67,
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'seller_id': 'seller_006',
        'seller_name': 'พ่อใจ',
        'seller_location': 'หางดง, เชียงใหม่',
        'title': 'มะม่วงน้ำดอกไม้สุก',
        'description': 'มะม่วงหวานจากสวน เนื้อนุ่ม หอม ไม่มียาง เก็บสดทุกวัน',
        'price': 60.0,
        'category': 'vegetables',
        'stock': 50,
        'is_available': 1,
        'rating': 4.6,
        'review_count': 19,
        'created_at': now.subtract(const Duration(days: 1, hours: 3)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'seller_id': AppConstants.defaultUserId,
        'seller_name': AppConstants.defaultUserName,
        'seller_location': AppConstants.defaultUserLocation,
        'title': 'พริกแกงเขียวหวานโฮมเมด',
        'description': 'พริกแกงทำเอง สูตรดั้งเดิม ใช้พริกสด ตะไคร้ กระชาย ไม่ใส่สารกันบูด',
        'price': 35.0,
        'category': 'food',
        'stock': 25,
        'is_available': 1,
        'rating': 4.9,
        'review_count': 11,
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];

    for (final product in sampleProducts) {
      await db.insert('products', product);
    }

    // Sample orders
    final sampleOrders = [
      {
        'id': _uuid.v4(),
        'buyer_id': AppConstants.defaultUserId,
        'buyer_name': AppConstants.defaultUserName,
        'seller_id': 'seller_002',
        'seller_name': 'ป้าแดง',
        'product_id': sampleProducts[0]['id'],
        'product_title': 'ผักออร์แกนิก รวมแพ็ค',
        'price': 45.0,
        'quantity': 2,
        'status': 'confirmed',
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'note': 'ขอผักบุ้งเยอะหน่อยนะคะ',
      },
      {
        'id': _uuid.v4(),
        'buyer_id': AppConstants.defaultUserId,
        'buyer_name': AppConstants.defaultUserName,
        'seller_id': 'seller_004',
        'seller_name': 'แม่สมหญิง',
        'product_id': sampleProducts[2]['id'],
        'product_title': 'ขนมทองพับโบราณ',
        'price': 80.0,
        'quantity': 1,
        'status': 'completed',
        'created_at': now.subtract(const Duration(days: 3)).toIso8601String(),
        'note': null,
      },
    ];

    for (final order in sampleOrders) {
      await db.insert('orders', order);
    }
  }

  // ==================== PRODUCT METHODS ====================

  Future<List<Product>> getAllProducts({String? category, String? query}) async {
    final db = await database;
    String whereClause = 'is_available = 1';
    List<dynamic> whereArgs = [];

    if (category != null && category != 'all') {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    if (query != null && query.isNotEmpty) {
      whereClause += ' AND (title LIKE ? OR description LIKE ?)';
      whereArgs.add('%$query%');
      whereArgs.add('%$query%');
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: whereClause,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getMyProducts(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'seller_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

  Future<String> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap());
    return product.id;
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.update(
      'products',
      {'is_available': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== ORDER METHODS ====================

  Future<List<Order>> getMyOrders(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'buyer_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<List<Order>> getSellerOrders(String sellerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'seller_id = ?',
      whereArgs: [sellerId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<String> insertOrder(Order order) async {
    final db = await database;
    await db.insert('orders', order.toMap());
    return order.id;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  // ==================== USER METHODS ====================

  Future<AppUser?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return AppUser.fromMap(maps.first);
  }

  Future<void> updateUser(AppUser user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ==================== STATS ====================

  Future<Map<String, dynamic>> getSellerStats(String sellerId) async {
    final db = await database;

    final productCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM products WHERE seller_id = ? AND is_available = 1',
        [sellerId],
      ),
    ) ?? 0;

    final salesCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM orders WHERE seller_id = ? AND status = "completed"',
        [sellerId],
      ),
    ) ?? 0;

    return {
      'product_count': productCount,
      'sales_count': salesCount,
    };
  }
}
