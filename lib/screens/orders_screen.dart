import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../services/product_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('รายการสั่งซื้อ'),
          bottom: const TabBar(
            indicatorColor: AppTheme.primarySoft,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: 'รอยืนยัน'),
              Tab(text: 'กำลังดำเนินการ'),
              Tab(text: 'เสร็จสิ้น'),
            ],
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            final pending = provider.myOrders
                .where((o) => o.status == OrderStatus.pending)
                .toList();
            final active = provider.myOrders
                .where((o) => o.status == OrderStatus.confirmed)
                .toList();
            final done = provider.myOrders
                .where((o) =>
                    o.status == OrderStatus.completed ||
                    o.status == OrderStatus.cancelled)
                .toList();

            return TabBarView(
              children: [
                _OrderList(
                  orders: pending,
                  emptyTitle: 'ไม่มีรายการรอยืนยัน',
                  emptySubtitle: 'ออเดอร์ใหม่ของคุณจะปรากฏที่นี่',
                  emptyEmoji: '📋',
                  onCancel: (id) => provider.cancelOrder(id),
                ),
                _OrderList(
                  orders: active,
                  emptyTitle: 'ไม่มีรายการที่กำลังดำเนินการ',
                  emptySubtitle: 'รายการที่ยืนยันแล้วจะปรากฏที่นี่',
                  emptyEmoji: '🚚',
                ),
                _OrderList(
                  orders: done,
                  emptyTitle: 'ยังไม่มีประวัติการซื้อ',
                  emptySubtitle: 'รายการที่เสร็จสิ้นจะปรากฏที่นี่',
                  emptyEmoji: '✅',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final String emptyTitle;
  final String emptySubtitle;
  final String emptyEmoji;
  final void Function(String orderId)? onCancel;

  const _OrderList({
    required this.orders,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyEmoji,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyState(
        emoji: emptyEmoji,
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return OrderTile(
          order: orders[index],
          onCancel: onCancel != null
              ? () => onCancel!(orders[index].id)
              : null,
        );
      },
    );
  }
}
