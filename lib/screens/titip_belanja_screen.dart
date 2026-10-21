import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'customer_tracking_screen.dart';

class ShoppingItemData {
  String name;
  int estimatedPrice;

  ShoppingItemData({required this.name, required this.estimatedPrice});
}

class ShoppingLocationData {
  String name;
  bool isMarket;
  List<ShoppingItemData> items;

  ShoppingLocationData({
    required this.name,
    this.isMarket = false,
    required this.items,
  });
}

class TitipBelanjaScreen extends StatefulWidget {
  const TitipBelanjaScreen({super.key});

  @override
  State<TitipBelanjaScreen> createState() => _TitipBelanjaScreenState();
}

class _TitipBelanjaScreenState extends State<TitipBelanjaScreen> {
  bool _driverTalangiDulu = true;
  final int _maxTalanganLimit = 300000;
  final int _baseDistanceFee = 12000;

  late List<ShoppingLocationData> _locations;

  @override
  void initState() {
    super.initState();
    _locations = [
      ShoppingLocationData(
        name: 'Pasar Tradisional Sukaramai',
        isMarket: true,
        items: [
          ShoppingItemData(name: 'Daging Sapi (1 kg)', estimatedPrice: 120000),
          ShoppingItemData(name: 'Cabai Merah (1/2 kg)', estimatedPrice: 20000),
          ShoppingItemData(name: 'Bawang Merah (1/4 kg)', estimatedPrice: 10000),
          ShoppingItemData(name: 'Santan Instan (2 bks)', estimatedPrice: 6000),
        ],
      ),
      ShoppingLocationData(
        name: 'Apotek Kimia Farma Batuphat',
        isMarket: false,
        items: [
          ShoppingItemData(name: 'Minyak Kayu Putih (60ml)', estimatedPrice: 25000),
        ],
      ),
    ];
  }

  int get _totalItemsCount {
    int count = 0;
    for (final loc in _locations) {
      count += loc.items.length;
    }
    return count;
  }

  int get _totalEstimatedGoodsPrice {
    int total = 0;
    for (final loc in _locations) {
      for (final item in loc.items) {
        total += item.estimatedPrice;
      }
    }
    return total;
  }

  // Logika Kenaikan Ongkir dari Dokumen:
  // 1-3 item = Rp 0 biaya tambahan kuota.
  // 4-6 item = +Rp 1.000.
  // 7-9 item = +Rp 2.000, dst (+Rp 1.000 per 3 item berikutnya).
  int get _itemQuotaFee {
    final count = _totalItemsCount;
    if (count <= 3) return 0;
    final tiersAboveThree = ((count - 1) ~/ 3);
    return tiersAboveThree * 1000;
  }

  // Setiap nambah toko/lokasi singgah non-pasar = +Rp 2.000 per tempat
  int get _extraLocationFee {
    if (_locations.length <= 1) return 0;
    return (_locations.length - 1) * 2000;
  }

  int get _totalDeliveryFee {
    return _baseDistanceFee + _extraLocationFee + _itemQuotaFee;
  }

  void _showAddItemDialog(int locationIndex) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.add_shopping_cart, color: AppColors.primaryPurple, size: 22),
            SizedBox(width: 8),
            Text('Tambah Barang Belanja', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Barang & Takaran',
                hintText: 'Contoh: Tomat Segar 1/2 kg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Estimasi Harga (Rp)',
                hintText: 'Contoh: 15000',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
              if (name.isNotEmpty) {
                setState(() {
                  _locations[locationIndex].items.add(
                    ShoppingItemData(name: name, estimatedPrice: price),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan Barang'),
          ),
        ],
      ),
    );
  }

  void _showAddLocationDialog() {
    if (_locations.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 3 lokasi singgah per pesanan')),
      );
      return;
    }

    final locCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.add_location_alt, color: AppColors.primaryPurple, size: 22),
            SizedBox(width: 8),
            Text('Tambah Lokasi Singgah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biaya singgah bertambah +Rp 2.000 untuk kurir per tempat belanja tambahan.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: locCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Toko / Tempat Belanja',
                hintText: 'Contoh: Toko Bumbu Makmur',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final locName = locCtrl.text.trim();
              if (locName.isNotEmpty) {
                setState(() {
                  _locations.add(
                    ShoppingLocationData(
                      name: locName,
                      isMarket: false,
                      items: [],
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tambahkan'),
          ),
        ],
      ),
    );
  }

  String _formatRp(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _startSearchingDriver() {
    if (_totalItemsCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal 1 barang belanjaan')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerTrackingScreen(
          locations: _locations,
          deliveryFee: _totalDeliveryFee,
          estimatedTalangan: _totalEstimatedGoodsPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8667FD), Color(0xFFC7BCFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Titip Belanja Manual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accentPastel),
              ),
              child: Row(
                children: const [
                  Icon(Icons.storefront, color: AppColors.primaryPurple, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Beli kebutuhan bebas di pasar tradisional, lapak basah, warung, atau apotek tanpa batas barcode.',
                      style: TextStyle(fontSize: 11, color: AppColors.textDark, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // LOKASI BELANJA HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LOKASI BELANJA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${_locations.length}/3 Tempat',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Locations List
            ...List.generate(_locations.length, (locIdx) {
              final loc = _locations[locIdx];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Header Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: locIdx == 0 ? const Color(0xFFEDE7F6) : const Color(0xFFF7F6FF),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            loc.isMarket ? Icons.store : Icons.local_pharmacy,
                            color: AppColors.primaryPurple,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '📍 Lokasi ${locIdx + 1}${locIdx > 0 ? " (+Rp 2.000)" : ""}: ${loc.name}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          if (locIdx > 0)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() => _locations.removeAt(locIdx));
                              },
                            ),
                        ],
                      ),
                    ),

                    // Items in this location
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          if (loc.items.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Belum ada barang belanjaan. Ketuk Tambah Barang di bawah.',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ),
                          ...List.generate(loc.items.length, (itemIdx) {
                            final item = loc.items[itemIdx];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: itemIdx == loc.items.length - 1
                                        ? Colors.transparent
                                        : Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      'Item ${itemIdx + 1}: ${item.name}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    'Est: ${_formatRp(item.estimatedPrice)}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      setState(() => loc.items.removeAt(itemIdx));
                                    },
                                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                          // Tambah Barang Button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () => _showAddItemDialog(locIdx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primaryPurple),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              icon: const Icon(Icons.add, size: 16, color: AppColors.primaryPurple),
                              label: const Text(
                                'Tambah Barang',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Tambah Lokasi Singgah Button
            if (_locations.length < 3)
              OutlinedButton.icon(
                onPressed: _showAddLocationDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPurple, style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                icon: const Icon(Icons.add_location_outlined, color: AppColors.primaryPurple, size: 18),
                label: const Text(
                  '+ Tambah Lokasi Singgah Lain (Maks. 3 Tempat)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 12),
                ),
              ),

            const SizedBox(height: 20),

            // PENGATURAN BIAYA & TALANGAN
            const Text(
              'PENGATURAN BIAYA & TALANGAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accentPastel),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.shield, color: AppColors.successGreen, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Driver Talangi Dulu',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Switch(
                        value: _driverTalangiDulu,
                        activeColor: AppColors.successGreen,
                        onChanged: (val) => setState(() => _driverTalangiDulu = val),
                      ),
                    ],
                  ),
                  Text(
                    'Maksimal batas limit talangan belanja: ${_formatRp(_maxTalanganLimit)}.',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimasi Belanjaan:', style: TextStyle(fontSize: 12)),
                      Text(
                        _formatRp(_totalEstimatedGoodsPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // RINCIAN ONGKIR SEMENTARA
            const Text(
              'RINCIAN ONGKIR SEMENTARA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
                ],
              ),
              child: Column(
                children: [
                  _buildCostRow('• Ongkir Jarak Tempuh', _formatRp(_baseDistanceFee)),
                  if (_extraLocationFee > 0)
                    _buildCostRow('• Tambahan Toko ke-${_locations.length}', '+ ${_formatRp(_extraLocationFee)}'),
                  _buildCostRow(
                    '• Tambahan Item ($_totalItemsCount Barang)',
                    _itemQuotaFee > 0 ? '+ ${_formatRp(_itemQuotaFee)}' : 'Rp 0 (Termasuk kuota)',
                  ),
                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Ongkir Driver',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                      ),
                      Text(
                        _formatRp(_totalDeliveryFee),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '*Catatan: Uang belanja riil & karcis parkir dimasukkan ke struk belanja driver saat barang tiba.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF8D6E63), fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TOMBOL CARI DRIVER BELANJA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
                onPressed: _startSearchingDriver,
                icon: const Icon(Icons.search, size: 20),
                label: const Text(
                  'CARI DRIVER BELANJA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String cost) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
          Text(cost, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
