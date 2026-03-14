import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../utils/app_theme.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final _uuid = const Uuid();

  List<Product> _products = [];
  List<Product> _myProducts = [];
  List<Order> _myOrders = [];
  AppUser? _currentUser;
  bool _isLoading = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  // Getters
  List<Product> get products => _products;
  List<Product> get myProducts => _myProducts;
  List<Order> get myOrders => _myOrders;
  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  int get pendingOrderCount => _myOrders
      .where((o) => o.status == OrderStatus.pending)
      .length;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _db.getUserById(AppConstants.defaultUserId);
    await loadProducts();
    await loadMyProducts();
    await loadMyOrders();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _products = await _db.getAllProducts(
      category: _selectedCategory == 'all' ? null : _selectedCategory,
      query: _searchQuery.isEmpty ? null : _searchQuery,
    );
    notifyListeners();
  }

  Future<void> loadMyProducts() async {
    _myProducts = await _db.getMyProducts(AppConstants.defaultUserId);
    notifyListeners();
  }

  Future<void> loadMyOrders() async {
    _myOrders = await _db.getMyOrders(AppConstants.defaultUserId);
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    loadProducts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadProducts();
  }

  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    required String category,
    String? imagePath,
    int stock = 1,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    final product = Product(
      id: _uuid.v4(),
      sellerId: user.id,
      sellerName: user.name,
      sellerLocation: user.location,
      title: title,
      description: description,
      price: price,
      category: category,
      imagePath: imagePath,
      stock: stock,
      createdAt: DateTime.now(),
    );

    await _db.insertProduct(product);
    await loadMyProducts();
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _db.updateProduct(product);
    await loadMyProducts();
    await loadProducts();
  }

  Future<void> deleteProduct(String productId) async {
    await _db.deleteProduct(productId);
    await loadMyProducts();
    await loadProducts();
  }

  Future<void> placeOrder({
    required Product product,
    int quantity = 1,
    String? note,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    final order = Order(
      id: _uuid.v4(),
      buyerId: user.id,
      buyerName: user.name,
      sellerId: product.sellerId,
      sellerName: product.sellerName,
      productId: product.id,
      productTitle: product.title,
      productImagePath: product.imagePath,
      price: product.price,
      quantity: quantity,
      createdAt: DateTime.now(),
      note: note,
    );

    await _db.insertOrder(order);
    await loadMyOrders();
  }

  Future<void> cancelOrder(String orderId) async {
    await _db.updateOrderStatus(orderId, OrderStatus.cancelled);
    await loadMyOrders();
  }

  Future<void> updateUserProfile({
    required String name,
    required String location,
    String? phone,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    final updated = user.copyWith(
      name: name,
      location: location,
      phone: phone,
    );

    await _db.updateUser(updated);
    _currentUser = updated;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getStats() async {
    return await _db.getSellerStats(AppConstants.defaultUserId);
  }
}
