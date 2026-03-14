import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'add_product_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final user = provider.currentUser;
        return Scaffold(
          backgroundColor: AppTheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.primary,
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
                  child: Column(
                    children: [
                      Row(children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
                          onPressed: () => _showEditProfile(context, provider),
                        ),
                      ]),
                      UserAvatar(name: user?.name ?? 'User', imagePath: user?.profileImagePath, size: 72),
                      const SizedBox(height: 12),
                      Text(user?.name ?? '-', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.primaryMid),
                        const SizedBox(width: 4),
                        Text(user?.location ?? '-', style: const TextStyle(color: AppTheme.primaryMid, fontSize: 13)),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        _StatCard(value: provider.myProducts.length.toString(), label: 'สินค้า'),
                        _VertDivider(),
                        _StatCard(value: user?.totalSales.toString() ?? '0', label: 'ขายแล้ว'),
                        _VertDivider(),
                        _StatCard(value: user?.rating.toStringAsFixed(1) ?? '0.0', label: 'คะแนน', suffix: '⭐'),
                        _VertDivider(),
                        _StatCard(value: provider.myOrders.length.toString(), label: 'คำสั่งซื้อ'),
                      ]),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: SectionHeader(title: 'สินค้าของฉัน', actionLabel: provider.myProducts.isNotEmpty ? '${provider.myProducts.length} รายการ' : null),
                ),
              ),
              provider.myProducts.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: EmptyState(emoji: '🛍️', title: 'ยังไม่มีสินค้า', subtitle: 'กดปุ่ม + เพื่อเพิ่มสินค้าแรกของคุณ'),
                      ))
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = provider.myProducts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ProductListTile(
                                product: product,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductScreen(editProduct: product))),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: product.isAvailable ? AppTheme.primaryPale : const Color(0xFFFCEBEB),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    product.isAvailable ? 'ขายอยู่' : 'ปิด',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: product.isAvailable ? AppTheme.primaryAccent : const Color(0xFFA32D2D)),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: provider.myProducts.length,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfile(BuildContext context, ProductProvider provider) {
    final user = provider.currentUser;
    if (user == null) return;
    final nameCtrl = TextEditingController(text: user.name);
    final locationCtrl = TextEditingController(text: user.location);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('แก้ไขโปรไฟล์', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(ctx)),
            ]),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'ชื่อ-นามสกุล', prefixIcon: Icon(Icons.person_outline, size: 20))),
            const SizedBox(height: 12),
            TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'ที่อยู่/พื้นที่', prefixIcon: Icon(Icons.location_on_outlined, size: 20))),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์', prefixIcon: Icon(Icons.phone_outlined, size: 20)), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                await provider.updateUserProfile(name: nameCtrl.text.trim(), location: locationCtrl.text.trim(), phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: const Text('บันทึกข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String? suffix;
  const _StatCard({required this.value, required this.label, this.suffix});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          if (suffix != null) ...[const SizedBox(width: 4), Text(suffix!, style: const TextStyle(fontSize: 14))],
        ]),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppTheme.primaryMid, fontSize: 11)),
      ]),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 0.5, height: 36, color: Colors.white.withValues(alpha: 0.2));
}
