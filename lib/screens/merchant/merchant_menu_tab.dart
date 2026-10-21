import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'merchant_models.dart';

class MerchantMenuTab extends StatefulWidget {
  final List<MerchantMenuItem> menuItems;
  final Function(MerchantMenuItem) onAddMenuItem;
  final Function(MerchantMenuItem) onUpdateMenuItem;
  final Function(String id) onDeleteMenuItem;

  const MerchantMenuTab({
    super.key,
    required this.menuItems,
    required this.onAddMenuItem,
    required this.onUpdateMenuItem,
    required this.onDeleteMenuItem,
  });

  @override
  State<MerchantMenuTab> createState() => _MerchantMenuTabState();
}

class _MerchantMenuTabState extends State<MerchantMenuTab> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrEditMenuDialog(context),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Menu', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari menu hidangan gerai...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryPurple, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF7F6FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),

                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Makanan Utama', 'Minuman', 'Camilan'].map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : AppColors.textDark,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primaryPurple,
                          backgroundColor: const Color(0xFFF7F6FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),

          // Menu List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.restaurant_menu_outlined, size: 48, color: AppColors.accentPastel),
                        SizedBox(height: 12),
                        Text('Tidak ada menu ditemukan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Coba ganti kata kunci pencarian atau tambah menu baru', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _buildMenuItemCard(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, MerchantMenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF7F6FF),
              child: item.imageAsset != null
                  ? Image.asset(
                      item.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: AppColors.primaryPurple),
                    )
                  : const Icon(Icons.fastfood, color: AppColors.primaryPurple, size: 36),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryPurple),
                      onPressed: () => _showAddOrEditMenuDialog(context, existingItem: item),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Text(
                  item.category,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_formatNumber(item.price)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),

                // Variants Tags
                if (item.variants.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: item.variants.map((v) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE8FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            v,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                          ),
                        )).toList(),
                  ),
                const SizedBox(height: 6),

                // Stock Availability Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.isAvailable ? 'Status: Tersedia' : 'Status: Habis',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: item.isAvailable ? AppColors.successGreen : AppColors.dangerRed,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: item.isAvailable,
                        activeColor: AppColors.successGreen,
                        onChanged: (val) {
                          setState(() => item.isAvailable = val);
                          widget.onUpdateMenuItem(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(val ? '${item.name} siap dipesan' : '${item.name} ditandai stok habis'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Figma 02_Merchant_Form_AddMenu_Detail & 03_Merchant_Setting_Variants
  void _showAddOrEditMenuDialog(BuildContext context, {MerchantMenuItem? existingItem}) {
    final isEdit = existingItem != null;
    final nameCtrl = TextEditingController(text: isEdit ? existingItem.name : '');
    final priceCtrl = TextEditingController(text: isEdit ? existingItem.price.toString() : '');
    final descCtrl = TextEditingController(text: isEdit ? existingItem.description : '');
    String category = isEdit ? existingItem.category : 'Makanan Utama';
    final List<String> variants = isEdit ? List.from(existingItem.variants) : ['Level Pedas: 1-5'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.85,
            padding: EdgeInsets.only(bottom: bottomInset),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Ubah Menu Hidangan' : 'Tambah Menu Baru',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Menu
                        const Text('Nama Menu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Ayam Bakar Madu Spesial',
                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF7F6FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderLight)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Kategori & Harga Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Kategori', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F6FF),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: AppColors.borderLight),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: category,
                                        isExpanded: true,
                                        items: ['Makanan Utama', 'Minuman', 'Camilan']
                                            .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) setSheetState(() => category = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Harga (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: priceCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '25000',
                                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                                      filled: true,
                                      fillColor: const Color(0xFFF7F6FF),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderLight)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Deskripsi
                        const Text('Deskripsi Menu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: descCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Jelaskan porsi, bahan utama, rasa, kelengkapan menu...',
                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF7F6FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderLight)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Figma 03_Merchant_Setting_Variants
                        const Text(
                          'Pengaturan Varian & Opsi Tambahan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Level Pedas: 1-5',
                            'Topping Telur Mata Sapi (+Rp 4.000)',
                            'Ekstra Kerupuk (+Rp 2.000)',
                            'Ukuran Porsi Jumbo (+Rp 6.000)',
                            'Es Batu Terpisah',
                          ].map((v) {
                            final hasVar = variants.contains(v);
                            return FilterChip(
                              label: Text(v, style: TextStyle(fontSize: 11, color: hasVar ? AppColors.primaryPurple : AppColors.textDark)),
                              selected: hasVar,
                              selectedColor: const Color(0xFFEDE8FF),
                              backgroundColor: const Color(0xFFF7F6FF),
                              onSelected: (selected) {
                                setSheetState(() {
                                  if (selected) {
                                    variants.add(v);
                                  } else {
                                    variants.remove(v);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Save Action
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final price = int.tryParse(priceCtrl.text.trim()) ?? 20000;
                        final desc = descCtrl.text.trim();

                        if (name.isEmpty) return;

                        if (isEdit) {
                          existingItem.name = name;
                          existingItem.price = price;
                          existingItem.description = desc;
                          existingItem.category = category;
                          existingItem.variants = variants;
                          widget.onUpdateMenuItem(existingItem);
                        } else {
                          final newItem = MerchantMenuItem(
                            id: 'M-${DateTime.now().millisecondsSinceEpoch}',
                            name: name,
                            description: desc.isNotEmpty ? desc : 'Hidangan lezat khas Dapur Sambal Sukaramai',
                            price: price,
                            category: category,
                            variants: variants,
                            imageAsset: 'assets/images/nasi_goreng.png',
                          );
                          widget.onAddMenuItem(newItem);
                        }

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEdit ? 'Menu berhasil diperbarui' : 'Menu baru berhasil ditambahkan!'),
                            backgroundColor: AppColors.successGreen,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        isEdit ? 'Simpan Perubahan' : 'Tambahkan ke Katalog Toko',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
