import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 130,
                pinned: true,
                backgroundColor: AppTheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppTheme.primary,
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'สวัสดี, ${provider.currentUser?.name.split(' ').first ?? 'ผู้ใช้'}',
                                style: const TextStyle(color: AppTheme.primaryMid, fontSize: 13),
                              ),
                              const Text(
                                'ตลาดชุมชน 🌿',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        UserAvatar(name: provider.currentUser?.name ?? 'User', size: 38),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(52),
                  child: Container(
                    color: AppTheme.primary,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: TextField(
                      controller: _searchController,
                      onChanged: provider.setSearchQuery,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาสินค้าในชุมชน...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.15),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.white.withValues(alpha: 0.7), size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: AppConstants.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = AppConstants.categories[index];
                          return CategoryChip(
                            label: cat['name'],
                            emoji: cat['icon'],
                            isSelected: provider.selectedCategory == cat['id'],
                            onTap: () => provider.setCategory(cat['id']),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(
                        title: provider.searchQuery.isNotEmpty
                            ? 'ผลการค้นหา "${provider.searchQuery}"'
                            : provider.selectedCategory == 'all'
                                ? 'สินค้าล่าสุด'
                                : AppConstants.categories.firstWhere((c) => c['id'] == provider.selectedCategory)['name'],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              provider.isLoading
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: AppTheme.primaryAccent)))
                  : provider.products.isEmpty
                      ? const SliverFillRemaining(
                          child: EmptyState(emoji: '🔍', title: 'ไม่พบสินค้า', subtitle: 'ลองเปลี่ยนหมวดหมู่หรือคำค้นหาดูนะ'))
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = provider.products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                                  ),
                                );
                              },
                              childCount: provider.products.length,
                            ),
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }
}
