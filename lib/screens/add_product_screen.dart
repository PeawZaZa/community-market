import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/product_provider.dart';
import '../utils/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  final Product? editProduct;
  const AddProductScreen({super.key, this.editProduct});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '1');
  String _selectedCategory = 'vegetables';
  String? _imagePath;
  bool _isLoading = false;
  final _picker = ImagePicker();

  bool get isEditing => widget.editProduct != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final p = widget.editProduct!;
      _titleCtrl.text = p.title;
      _descCtrl.text = p.description;
      _priceCtrl.text = p.price.toStringAsFixed(0);
      _stockCtrl.text = p.stock.toString();
      _selectedCategory = p.category;
      _imagePath = p.imagePath;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('เลือกรูปภาพ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _ImageSourceOption(icon: Icons.camera_alt_outlined, label: 'ถ่ายรูป', onTap: () async {
                  Navigator.pop(ctx);
                  final img = await _picker.pickImage(source: ImageSource.camera, maxWidth: 800, imageQuality: 80);
                  if (img != null) setState(() => _imagePath = img.path);
                })),
                const SizedBox(width: 12),
                Expanded(child: _ImageSourceOption(icon: Icons.photo_library_outlined, label: 'คลังรูปภาพ', onTap: () async {
                  Navigator.pop(ctx);
                  final img = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
                  if (img != null) setState(() => _imagePath = img.path);
                })),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final provider = context.read<ProductProvider>();
      if (isEditing) {
        final updated = widget.editProduct!.copyWith(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          price: double.parse(_priceCtrl.text),
          category: _selectedCategory,
          imagePath: _imagePath,
          stock: int.parse(_stockCtrl.text),
        );
        await provider.updateProduct(updated);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('แก้ไขสินค้าเรียบร้อยแล้ว')));
      } else {
        await provider.addProduct(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          price: double.parse(_priceCtrl.text),
          category: _selectedCategory,
          imagePath: _imagePath,
          stock: int.parse(_stockCtrl.text),
        );
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลงประกาศสำเร็จแล้ว! 🎉')));
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ลบสินค้า'),
        content: Text('ต้องการลบ "${widget.editProduct!.title}" ใช่ไหม?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(foregroundColor: AppTheme.secondary), child: const Text('ลบ')),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<ProductProvider>().deleteProduct(widget.editProduct!.id);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบสินค้าเรียบร้อยแล้ว')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขสินค้า' : 'ลงขายสินค้า'),
        actions: [
          if (isEditing) IconButton(icon: const Icon(Icons.delete_outline, color: Colors.white70), onPressed: _confirmDelete),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPale,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryAccent, width: 1.5),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(File(_imagePath!), fit: BoxFit.cover, width: double.infinity,
                            errorBuilder: (_, __, ___) => _placeholderWidget()))
                    : _placeholderWidget(),
              ),
            ),
            const SizedBox(height: 20),

            _Label(text: 'ชื่อสินค้า *'),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(hintText: 'เช่น ผักออร์แกนิก มะม่วงน้ำดอกไม้'),
              validator: (v) => v == null || v.trim().isEmpty ? 'กรุณาระบุชื่อสินค้า' : null,
            ),
            const SizedBox(height: 16),

            _Label(text: 'หมวดหมู่ *'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.categories.where((c) => c['id'] != 'all').map((cat) {
                final isSelected = _selectedCategory == cat['id'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(cat['icon'], style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(cat['name'], style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? Colors.white : AppTheme.textPrimary)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Row(children: [
              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Label(text: 'ราคา (บาท) *'),
                TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(hintText: '0', prefixText: '฿ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'ระบุราคา';
                    if (double.tryParse(v) == null) return 'ราคาไม่ถูกต้อง';
                    return null;
                  },
                ),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Label(text: 'จำนวน *'),
                TextFormField(
                  controller: _stockCtrl,
                  decoration: const InputDecoration(hintText: '1'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'ระบุจำนวน';
                    if (int.tryParse(v) == null || int.parse(v) < 1) return 'ไม่ถูกต้อง';
                    return null;
                  },
                ),
              ])),
            ]),
            const SizedBox(height: 16),

            _Label(text: 'รายละเอียด *'),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(hintText: 'อธิบายสินค้าของคุณ เช่น วิธีผลิต แหล่งที่มา คุณสมบัติพิเศษ'),
              maxLines: 4,
              minLines: 2,
              validator: (v) => v == null || v.trim().isEmpty ? 'กรุณาใส่รายละเอียดสินค้า' : null,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(isEditing ? 'บันทึกการแก้ไข' : 'ลงประกาศสินค้า', style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _placeholderWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: AppTheme.primaryAccent.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: const Icon(Icons.add_photo_alternate_outlined, color: AppTheme.primaryAccent, size: 24),
      ),
      const SizedBox(height: 8),
      const Text('เพิ่มรูปภาพสินค้า', style: TextStyle(color: AppTheme.primaryAccent, fontSize: 14, fontWeight: FontWeight.w500)),
      const Text('แตะเพื่อเลือกรูป', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
    ]);
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
  );
}

class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ImageSourceOption({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: AppTheme.primaryPale, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Icon(icon, color: AppTheme.primaryAccent, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppTheme.primaryAccent, fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}
