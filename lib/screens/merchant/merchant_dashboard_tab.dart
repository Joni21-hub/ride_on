import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'merchant_models.dart';

class MerchantDashboardTab extends StatelessWidget {
  final bool isOpen;
  final ValueChanged<bool> onToggleOpen;
  final int todayEarnings;
  final int todayCompletedOrders;
  final List<MerchantOrder> orders;
  final VoidCallback onNavigateToOrders;
  final VoidCallback onNavigateToMenu;
  final VoidCallback onNavigateToWallet;
  final Function(MerchantOrder) onStartCooking;
  final VoidCallback onOpenRegistration;

  const MerchantDashboardTab({
    super.key,
    required this.isOpen,
    required this.onToggleOpen,
    required this.todayEarnings,
    required this.todayCompletedOrders,
    required this.orders,
    required this.onNavigateToOrders,
    required this.onNavigateToMenu,
    required this.onNavigateToWallet,
    required this.onStartCooking,
    required this.onOpenRegistration,
  });

  void _handleSwitchChanged(BuildContext context, bool val) {
    if (!val) {
      // Show Figma 03_Merchant_Sheet_ToggleClosed_Reason
      _showCloseReasonSheet(context);
    } else {
      onToggleOpen(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gerai sekarang BUKA dan siap menerima pesanan!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  void _showCloseReasonSheet(BuildContext context) {
    String selectedReason = 'Bahan baku habis / restock';
    final reasons = [
      'Bahan baku habis / restock',
      'Istirahat sejenak (Makan / Ibadah)',
      'Antrean pesanan offline sedang padat',
      'Tutup operasional hari ini',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tutup Gerai Sementara',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih alasan penutupan gerai untuk diinformasikan kepada pelanggan di aplikasi:',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              ...reasons.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: selectedReason == r ? const Color(0xFFF7F6FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedReason == r ? AppColors.primaryPurple : AppColors.borderLight,
                      ),
                    ),
                    child: RadioListTile<String>(
                      title: Text(r, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      value: r,
                      groupValue: selectedReason,
                      activeColor: AppColors.primaryPurple,
                      onChanged: (val) {
                        if (val != null) setSheetState(() => selectedReason = val);
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Batal', style: TextStyle(color: AppColors.textDark)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onToggleOpen(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gerai TUTUP: $selectedReason'),
                            backgroundColor: AppColors.dangerRed,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dangerRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Konfirmasi Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders.where((o) => o.status != MerchantOrderStatus.completed && o.status != MerchantOrderStatus.rejected).toList();
    final urgentOrder = activeOrders.isNotEmpty ? activeOrders.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gerai Profile Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dapur Sambal Sukaramai',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Icon(Icons.star, color: AppColors.goldYellow, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '4.8 (250+ Ulasan) • Jam Buka: 09:00 - 21:00',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onOpenRegistration,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentPastel),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.verified, color: AppColors.primaryPurple, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Mitra Pro',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Status Gerai Card (Figma 01_Merchant_Dashboard_Open vs 02_Merchant_Dashboard_Closed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isOpen ? AppColors.successGreen : AppColors.dangerRed,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.storefront,
                  color: isOpen ? AppColors.successGreen : AppColors.dangerRed,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOpen ? 'Status Gerai: BUKA' : 'Status Gerai: TUTUP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isOpen ? AppColors.successGreen : AppColors.dangerRed,
                        ),
                      ),
                      Text(
                        isOpen ? 'Pelanggan dapat membuat pesanan' : 'Gerai sedang tidak menerima order',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isOpen,
                  activeColor: AppColors.successGreen,
                  inactiveThumbColor: AppColors.dangerRed,
                  onChanged: (val) => _handleSwitchChanged(context, val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pendapatan Hari Ini Card (Figma Dark Card)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Pendapatan Bersih Hari Ini',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '5 Okt 2026',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatNumber(todayEarnings)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '$todayCompletedOrders Pesanan Selesai',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Text(
                      'Rata-rata Masak: 12 mnt',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Quick Tabs (3 items matching Figma)
          Row(
            children: [
              Expanded(
                child: _buildActionTab(
                  icon: Icons.checklist_rtl_rounded,
                  title: 'Kelola Pesanan',
                  badge: '${activeOrders.length} Aktif',
                  isSelected: true,
                  onTap: onNavigateToOrders,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionTab(
                  icon: Icons.fastfood_outlined,
                  title: 'Katalog Menu',
                  onTap: onNavigateToMenu,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionTab(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Tarik Dana',
                  onTap: onNavigateToWallet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section Header: Pesanan Perlu Diproses Dapur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pesanan Perlu Diproses Dapur',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              GestureDetector(
                onTap: onNavigateToOrders,
                child: Text(
                  '${activeOrders.length} Pesanan Masuk >',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Order Card Preview from Figma
          if (urgentOrder != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryPurple, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${urgentOrder.id} • ${urgentOrder.customerName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: urgentOrder.status == MerchantOrderStatus.cooking
                              ? const Color(0xFFEDE8FF)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          urgentOrder.status == MerchantOrderStatus.cooking
                              ? 'Sedang Dimasak'
                              : 'Pesanan Baru',
                          style: TextStyle(
                            color: urgentOrder.status == MerchantOrderStatus.cooking
                                ? AppColors.primaryPurple
                                : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    urgentOrder.summaryText,
                    style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total Tagihan: Rp ${_formatNumber(urgentOrder.totalPrice)}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (urgentOrder.status == MerchantOrderStatus.newOrder) {
                          onStartCooking(urgentOrder);
                        } else {
                          onNavigateToOrders();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        urgentOrder.status == MerchantOrderStatus.newOrder
                            ? 'Buka Dapur & Masak Sekarang'
                            : 'Lihat Detail & Serah Terima Driver',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: const [
                  Icon(Icons.done_all, color: AppColors.successGreen, size: 36),
                  SizedBox(height: 8),
                  Text(
                    'Dapur Santai!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tidak ada pesanan antre yang perlu diproses saat ini.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Store schedule & Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.schedule, color: AppColors.primaryPurple, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Jadwal Operasional Aktif',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Setiap Hari (09:00 - 21:00 WIB)',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onNavigateToWallet,
                  child: const Text('Atur', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTab({
    required IconData icon,
    required String title,
    String? badge,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Icon(icon, color: isSelected ? AppColors.primaryPurple : AppColors.textDark, size: 22),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -16,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
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
