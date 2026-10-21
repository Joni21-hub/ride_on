import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class DriverActivityTab extends StatelessWidget {
  const DriverActivityTab({super.key});

  void _showShoppingDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Titip Belanja Manual',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
                      ),
                      Text(
                        'FlexSend • Pemesan: Gufran',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: AppColors.successGreen, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Lokasi 1: Pasar Pagi Batuphat
              _buildLocationCard(
                locationName: 'Lokasi 1: Pasar Pagi Batuphat',
                itemsCount: '4 Barang',
                items: [
                  _ShoppingItemRow(name: '1. Daging Sapi (1 kg)', price: 'Rp 120.000', note: 'Catatan: Potong dadu rendang'),
                  _ShoppingItemRow(name: '2. Cabai Merah (1/2 kg)', price: 'Rp 20.000'),
                  _ShoppingItemRow(name: '3. Bawang Merah (1/4 kg)', price: 'Rp 10.000'),
                  _ShoppingItemRow(name: '4. Santan Instan (2 bks)', price: 'Rp 6.000'),
                ],
                parkingFee: 'Rp 2.000',
              ),
              const SizedBox(height: 14),

              // Lokasi 2: Apotik Dien Farma
              _buildLocationCard(
                locationName: 'Lokasi 2: Apotik Dien Farma',
                itemsCount: '1 Barang',
                items: [
                  _ShoppingItemRow(name: '1. Paracetamol (1 Papan)', price: 'Rp 10.000'),
                ],
                parkingFee: 'Rp 0',
              ),
              const SizedBox(height: 16),

              // Route & Destination Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Alamat Tujuan Pengantaran:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                    SizedBox(height: 4),
                    Text('Jl. Lauser, PIM No. 88 (Gufran)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Total Jarak Tempuh: 4.2 km • Estimasi: 10 menit', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bill Breakdown Table
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildBillRow('Total Belanjaan:', 'Rp 166.000'),
                    const SizedBox(height: 6),
                    _buildBillRow('Total Retribusi Parkir:', 'Rp 2.000'),
                    const SizedBox(height: 6),
                    _buildBillRow('Ongkir Driver (Pendapatan):', '+ Rp 15.000', isGreen: true),
                    const Divider(height: 16),
                    _buildBillRow('TOTAL TAGIHAN:', 'Rp 183.000', isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup Rincian', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLocationCard({
    required String locationName,
    required String itemsCount,
    required List<_ShoppingItemRow> items,
    required String parkingFee,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryPurple)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(8)),
                child: Text(itemsCount, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(it.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(it.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    if (it.note != null)
                      Text(it.note!, style: const TextStyle(fontSize: 10, color: Colors.orange, fontStyle: FontStyle.italic)),
                  ],
                ),
              )),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Biaya Retribusi Parkir Pasar:', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              Text(parkingFee, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildBillRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.textDark : AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: isGreen ? AppColors.successGreen : (isBold ? AppColors.primaryPurple : AppColors.textDark),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Aktivitas Driver',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Riwayat trip dan pengantaran yang telah diselesaikan',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            // Orders list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Item 1: Titip Belanja (With detail breakdown trigger)
                  _buildTripCard(
                    context: context,
                    orderId: '#12E4S67',
                    title: 'Titip Belanja Manual',
                    service: 'FlexSend • Gufran',
                    earnings: '+ Rp 15.000',
                    totalNote: 'Total Talangan & Belanja: Rp 183.000',
                    icon: Icons.shopping_basket,
                    badgeColor: const Color(0xFFF3F0FF),
                    iconColor: AppColors.primaryPurple,
                    onTap: () => _showShoppingDetailSheet(context),
                  ),
                  const SizedBox(height: 12),

                  // Item 2: Pesanan Makanan
                  _buildTripCard(
                    context: context,
                    orderId: '#I2E4S68',
                    title: 'Pesanan Makanan Waroeng Bamboe',
                    service: 'FlexFood • Fikri (Jl. Dumai)',
                    earnings: '+ Rp 35.000',
                    totalNote: 'Non-Tunai (E-Wallet) • 2x Nasi Goreng Spesial',
                    icon: Icons.restaurant,
                    badgeColor: const Color(0xFFFFF3E0),
                    iconColor: Colors.deepOrange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Detail pesanan makanan Waroeng Bamboe #I2E4S68')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Item 3: Antar Penumpang
                  _buildTripCard(
                    context: context,
                    orderId: '#12E4S69',
                    title: 'Antar Penumpang (Ojek)',
                    service: 'FlexRide • M.Topik',
                    earnings: '+ Rp 35.000',
                    totalNote: 'Rute: Jl. Seulawah -> Suzuya Mall Lhokseumawe (18 km)',
                    icon: Icons.two_wheeler,
                    badgeColor: const Color(0xFFE8F5E9),
                    iconColor: AppColors.successGreen,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Detail trip antar penumpang M.Topik #12E4S69')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard({
    required BuildContext context,
    required String orderId,
    required String title,
    required String service,
    required String earnings,
    required String totalNote,
    required IconData icon,
    required Color badgeColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryPurple)),
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                      ],
                    ),
                  ],
                ),
                Text(
                  earnings,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.successGreen),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(service, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    totalNote,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Row(
                  children: [
                    Text('Lihat Rincian', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primaryPurple),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingItemRow {
  final String name;
  final String price;
  final String? note;
  const _ShoppingItemRow({required this.name, required this.price, this.note});
}
