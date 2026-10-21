import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'merchant_models.dart';

class MerchantOrdersTab extends StatefulWidget {
  final List<MerchantOrder> orders;
  final Function(MerchantOrder) onStartCooking;
  final Function(MerchantOrder) onMarkReady;
  final Function(MerchantOrder) onCompleteOrder;
  final Function(MerchantOrder, String reason) onRejectOrder;

  const MerchantOrdersTab({
    super.key,
    required this.orders,
    required this.onStartCooking,
    required this.onMarkReady,
    required this.onCompleteOrder,
    required this.onRejectOrder,
  });

  @override
  State<MerchantOrdersTab> createState() => _MerchantOrdersTabState();
}

class _MerchantOrdersTabState extends State<MerchantOrdersTab> {
  int _selectedSubTab = 0; // 0: Pesanan Baru, 1: Sedang Dimasak, 2: Siap Diambil

  @override
  Widget build(BuildContext context) {
    final newOrders = widget.orders.where((o) => o.status == MerchantOrderStatus.newOrder).toList();
    final cookingOrders = widget.orders.where((o) => o.status == MerchantOrderStatus.cooking).toList();
    final readyOrders = widget.orders.where((o) => o.status == MerchantOrderStatus.readyToPickup).toList();

    return Column(
      children: [
        // Top Segmented Sub-tabs matching Figma 01_Merchant_Tab1, Tab2, Tab3
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              _buildSubTabItem(
                index: 0,
                label: 'Pesanan Baru',
                count: newOrders.length,
                isSelected: _selectedSubTab == 0,
              ),
              const SizedBox(width: 8),
              _buildSubTabItem(
                index: 1,
                label: 'Dimasak',
                count: cookingOrders.length,
                isSelected: _selectedSubTab == 1,
              ),
              const SizedBox(width: 8),
              _buildSubTabItem(
                index: 2,
                label: 'Siap Diambil',
                count: readyOrders.length,
                isSelected: _selectedSubTab == 2,
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.borderLight),

        // Order List by Selected Sub-tab
        Expanded(
          child: _selectedSubTab == 0
              ? _buildNewOrdersList(newOrders)
              : _selectedSubTab == 1
                  ? _buildCookingOrdersList(cookingOrders)
                  : _buildReadyOrdersList(readyOrders),
        ),
      ],
    );
  }

  Widget _buildSubTabItem({
    required int index,
    required String label,
    required int count,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPurple : const Color(0xFFF7F6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textDark,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.primaryPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryPurple : Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewOrdersList(List<MerchantOrder> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox_outlined,
        title: 'Tidak Ada Pesanan Baru',
        subtitle: 'Pesanan masuk dari pelanggan akan langsung muncul di sini.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 90),
      itemCount: orders.length,
      itemBuilder: (context, i) {
        final order = orders[i];
        return _buildOrderCard(
          order: order,
          primaryActionText: 'Terima & Masak Sekarang',
          primaryActionColor: AppColors.primaryDark,
          onPrimaryAction: () => widget.onStartCooking(order),
          secondaryActionText: 'Tolak Pesanan',
          onSecondaryAction: () => _showRejectSheet(context, order),
        );
      },
    );
  }

  Widget _buildCookingOrdersList(List<MerchantOrder> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.soup_kitchen_outlined,
        title: 'Dapur Sedang Tidak Memasak',
        subtitle: 'Terima pesanan baru untuk mulai memproses hidangan di dapur.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 90),
      itemCount: orders.length,
      itemBuilder: (context, i) {
        final order = orders[i];
        return _buildOrderCard(
          order: order,
          customBanner: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.primaryPurple, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimasi Masak: ${order.cookingEstimateMinutes} Menit',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                      ),
                      Text(
                        'Driver: ${order.assignedDriverName ?? "Joni Utama"} (${order.assignedDriverPlate ?? "BK 4892 ABC"}) sedang menuju resto',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          primaryActionText: 'Makanan Matang & Siap Diambil',
          primaryActionColor: AppColors.primaryPurple,
          onPrimaryAction: () => widget.onMarkReady(order),
          secondaryActionText: '+ 5 Mnt Waktu Masak',
          onSecondaryAction: () {
            setState(() => order.cookingEstimateMinutes += 5);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Waktu memasak diperpanjang +5 menit')),
            );
          },
        );
      },
    );
  }

  Widget _buildReadyOrdersList(List<MerchantOrder> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.delivery_dining_outlined,
        title: 'Belum Ada Pesanan Siap Diambil',
        subtitle: 'Selesaikan proses masak untuk memanggil driver mitra.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 90),
      itemCount: orders.length,
      itemBuilder: (context, i) {
        final order = orders[i];
        return _buildOrderCard(
          order: order,
          customBanner: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.successGreen.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.two_wheeler, color: AppColors.successGreen, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver: ${order.assignedDriverName ?? "Joni Utama"} (GPS SIAP)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.successGreen),
                      ),
                      Text(
                        'Plat: ${order.assignedDriverPlate ?? "BK 4892 ABC"} • Sudah di gerai',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PIN: 4092',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          primaryActionText: 'Validasi PIN & Serahkan Makanan',
          primaryActionColor: AppColors.successGreen,
          onPrimaryAction: () => _showHandoverPinDialog(context, order),
        );
      },
    );
  }

  Widget _buildOrderCard({
    required MerchantOrder order,
    Widget? customBanner,
    required String primaryActionText,
    required Color primaryActionColor,
    required VoidCallback onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.id} • ${order.customerName}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  Text(
                    'Waktu Pesan: 10:24 WIB (${order.customerPhone})',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order.status == MerchantOrderStatus.cooking
                      ? const Color(0xFFEDE8FF)
                      : order.status == MerchantOrderStatus.readyToPickup
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status == MerchantOrderStatus.cooking
                      ? 'Dimasak'
                      : order.status == MerchantOrderStatus.readyToPickup
                          ? 'Siap Diambil'
                          : 'Baru',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: order.status == MerchantOrderStatus.cooking
                        ? AppColors.primaryPurple
                        : order.status == MerchantOrderStatus.readyToPickup
                            ? AppColors.successGreen
                            : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 18),

          ?customBanner,

          // Items List
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.name}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
                      ),
                    ),
                    Text(
                      'Rp ${_formatNumber(item.price * item.quantity)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pendapatan Toko:', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              Text(
                'Rp ${_formatNumber(order.totalPrice)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              if (secondaryActionText != null && onSecondaryAction != null) ...[
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: onSecondaryAction,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.dangerRed,
                      side: const BorderSide(color: AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      secondaryActionText,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: onPrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryActionColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    primaryActionText,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Figma 02_Merchant_Sheet_TolakPesanan
  void _showRejectSheet(BuildContext context, MerchantOrder order) {
    String selectedReason = 'Bahan baku menu tertentu habis';
    final reasons = [
      'Bahan baku menu tertentu habis',
      'Antrean pesanan dapur sedang overload',
      'Toko akan segera tutup jam operasional',
      'Permintaan varian khusus tidak dapat dipenuhi',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
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
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: AppColors.dangerRed, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Tolak Pesanan ${order.id}',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Harap pilih alasan yang jelas agar pelanggan memahami kendala di gerai Anda:',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              ...reasons.map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: selectedReason == r ? const Color(0xFFFFEBEE) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedReason == r ? AppColors.dangerRed : AppColors.borderLight,
                      ),
                    ),
                    child: RadioListTile<String>(
                      title: Text(r, style: const TextStyle(fontSize: 13)),
                      value: r,
                      groupValue: selectedReason,
                      activeColor: AppColors.dangerRed,
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedReason = val);
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
                        widget.onRejectOrder(order, selectedReason);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pesanan ${order.id} ditolak: $selectedReason'),
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
                      child: const Text('Konfirmasi Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Figma 01_Merchant_Handover_PIN_Default, 02_Error, 03_Success_Modal
  void _showHandoverPinDialog(BuildContext context, MerchantOrder order) {
    final pinController = TextEditingController();
    bool isError = false;
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.pin, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text(
                'PIN Serah Terima Driver',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tanyakan 4 digit PIN yang tertera pada aplikasi driver mitra (${order.assignedDriverName ?? "Joni Utama"}) sebelum menyerahkan makanan:',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 18),

              // PIN Input 4 boxes
              TextField(
                controller: pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 16,
                  color: AppColors.primaryDark,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• • • •',
                  hintStyle: const TextStyle(letterSpacing: 10, color: Colors.black26),
                  filled: true,
                  fillColor: isError ? const Color(0xFFFFEBEE) : const Color(0xFFF7F6FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: isError ? AppColors.dangerRed : AppColors.primaryPurple, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: isError ? AppColors.dangerRed : AppColors.borderLight),
                  ),
                ),
                onChanged: (val) {
                  if (isError) {
                    setDialogState(() {
                      isError = false;
                      errorMessage = '';
                    });
                  }
                },
              ),

              if (isError) ...[
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.dangerRed),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, size: 16, color: AppColors.primaryPurple),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Petunjuk Pengujian: Masukkan PIN driver "4092"',
                        style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredPin = pinController.text.trim();
                if (enteredPin != order.handoverPin) {
                  // Figma 02_Merchant_Handover_PIN_Error
                  setDialogState(() {
                    isError = true;
                    errorMessage = 'PIN Driver Salah! Harap cek kembali di layar driver Joni Utama.';
                  });
                } else {
                  // Figma 03_Merchant_Handover_PIN_Success_Modal
                  Navigator.pop(dialogCtx);
                  widget.onCompleteOrder(order);
                  _showHandoverSuccessModal(context, order);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Verifikasi PIN', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Figma 03_Merchant_Handover_PIN_Success_Modal
  void _showHandoverSuccessModal(BuildContext context, MerchantOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.successGreen, width: 2),
              ),
              child: const Icon(Icons.check, color: AppColors.successGreen, size: 40),
            ),
            const SizedBox(height: 18),
            const Text(
              'Serah Terima Makanan Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesanan ${order.id} telah diserahkan ke driver Joni Utama (BK 4892 ABC).\nDana penjualan sebesar Rp ${_formatNumber(order.totalPrice)} otomatis ditambahkan ke Dompet Toko Anda.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Kembali ke Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentPastel),
              ),
              child: Icon(icon, size: 48, color: AppColors.primaryPurple),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
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
