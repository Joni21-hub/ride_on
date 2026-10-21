import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/map_widget.dart';
import 'chat_screen.dart';
import 'titip_belanja_screen.dart';

enum TrackingStage {
  searchingDriver,
  headingToStore,
  shoppingAtMarket,
  headingToCustomer,
  arrivedAndSettlement,
}

class CustomerTrackingScreen extends StatefulWidget {
  final List<ShoppingLocationData> locations;
  final int deliveryFee;
  final int estimatedTalangan;

  const CustomerTrackingScreen({
    super.key,
    required this.locations,
    required this.deliveryFee,
    required this.estimatedTalangan,
  });

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  TrackingStage _currentStage = TrackingStage.headingToStore;
  final String _driverName = 'Joni Utama';
  final String _driverPlate = 'BK 4892 ABC';
  final String _driverVehicle = 'Honda Vario 160 Hitam';
  final double _driverRating = 4.9;

  // Struk Pelunasan Data (Halaman 7)
  final int _actualMarketReceipt = 115000;
  final int _actualPharmacyReceipt = 25000;
  final int _parkingFee = 2000;
  bool _payWithWallet = true;

  int get _actualTalanganTotal => _actualMarketReceipt + _actualPharmacyReceipt + _parkingFee;
  int get _finalTotalBill => _actualTalanganTotal + widget.deliveryFee;

  String _formatRp(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showRatingModal() {
    int driverStars = 5;
    int serviceStars = 5;
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.stars_rounded, color: AppColors.goldYellow, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Pesanan Selesai!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              const Text(
                'Bagikan ulasan Anda untuk meningkatkan kualitas layanan:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),

              // Rating Driver
              Text(
                'Beri Rating Driver ($_driverName)',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < driverStars ? Icons.star : Icons.star_border,
                      color: AppColors.goldYellow,
                      size: 32,
                    ),
                    onPressed: () => setModalState(() => driverStars = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 10),

              // Rating Ketepatan Belanja
              const Text(
                'Kesesuaian Barang & Belanjaan Pasar',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < serviceStars ? Icons.star : Icons.star_border,
                      color: AppColors.goldYellow,
                      size: 28,
                    ),
                    onPressed: () => setModalState(() => serviceStars = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar atau pujian untuk driver...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  filled: true,
                  fillColor: const Color(0xFFF7F6FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context); // Back to Home
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terima kasih! Ulasan dan tip telah dikirimkan ke driver.'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  child: const Text('KIRIM PENILAIAN & SELESAI', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettlementReceiptDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8667FD), Color(0xFFC7BCFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Rincian Tagihan Akhir (Struk Pelunasan)',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),

              // Scrollable bill content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Badge info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFA5D6A7)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified, color: AppColors.successGreen, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Barang telah dibeli & diverifikasi sesuai nota fisik toko dan karcis parkir.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1B5E20), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // KOMPONEN A: TALANGAN RIIL DRIVER
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
                            children: const [
                              Icon(Icons.payments, size: 16, color: AppColors.primaryPurple),
                              SizedBox(width: 6),
                              Text(
                                'KOMPONEN A: TALANGAN RIIL DRIVER',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Wajib diganti 100% kepada driver sesuai nota belanja riil:',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          const Divider(height: 16),

                          _buildReceiptItem('1. Nota Pasar Tradisional Sukaramai', _formatRp(_actualMarketReceipt)),
                          const Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 4),
                            child: Text('• Daging, cabai merah, bawang, santan', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                          _buildReceiptItem('2. Nota Apotek Kimia Farma', _formatRp(_actualPharmacyReceipt)),
                          const Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 4),
                            child: Text('• Minyak kayu putih 60ml', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ),
                          _buildReceiptItem('3. Retribusi Parkir Resmi', _formatRp(_parkingFee)),
                          const Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 8),
                            child: Text('• Karcis retribusi pasar (Rp 2.000)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ),

                          // Foto Struk Bukti Digital Card
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE7F6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.receipt, color: AppColors.primaryPurple, size: 24),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Lampiran 2 Foto Struk & Karcis',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Diunggah oleh Joni Utama (12:44 WIB)',
                                        style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Menampilkan foto struk resolusi tinggi')),
                                    );
                                  },
                                  child: const Text('Lihat Foto', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal Talangan Belanja:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                _formatRp(_actualTalanganTotal),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // KOMPONEN B: ONGKIR APLIKASI
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.two_wheeler, size: 16, color: AppColors.primaryDark),
                              SizedBox(width: 6),
                              Text(
                                'KOMPONEN B: ONGKOS KIRIM APLIKASI',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          _buildReceiptItem('Ongkir Rute Tempuh (4.2 km)', 'Rp 12.000'),
                          _buildReceiptItem('Tambahan Toko ke-2 (Apotek)', 'Rp  2.000'),
                          _buildReceiptItem('Tambahan Kuota Item (5 barang)', 'Rp  1.000'),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Ongkir Driver:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                _formatRp(widget.deliveryFee),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TOTAL TAGIHAN
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8667FD), Color(0xFF6B42F6)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: AppColors.primaryPurple.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'TOTAL BAYAR PELUNASAN',
                                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Talangan + Ongkir',
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                          Text(
                            _formatRp(_finalTotalBill),
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // METODE PEMBAYARAN
                    const Text('Metode Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setSheetState(() => _payWithWallet = true),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _payWithWallet ? const Color(0xFFF3F0FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _payWithWallet ? AppColors.primaryPurple : AppColors.borderLight,
                                  width: _payWithWallet ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _payWithWallet ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: _payWithWallet ? AppColors.primaryPurple : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('E-Wallet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        Text('Saldo: Rp 165.000', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => setSheetState(() => _payWithWallet = false),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: !_payWithWallet ? const Color(0xFFF3F0FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: !_payWithWallet ? AppColors.primaryPurple : AppColors.borderLight,
                                  width: !_payWithWallet ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    !_payWithWallet ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: !_payWithWallet ? AppColors.primaryPurple : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Uang Tunai', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        Text('Bayar ke Driver', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // BUTTON KONFIRMASI PELUNASAN
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showRatingModal();
                        },
                        child: const Text(
                          'KONFIRMASI BAYAR & SELESAIKAN',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptItem(String title, String cost) {
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

  @override
  Widget build(BuildContext context) {
    String stageTitle = '';
    String stageSubtitle = '';
    int stepNumber = 1;

    switch (_currentStage) {
      case TrackingStage.searchingDriver:
        stageTitle = 'Mencari Driver Terdekat...';
        stageSubtitle = 'Menghubungkan radar ke driver terdekat dengan modal belanja cukup';
        stepNumber = 1;
        break;
      case TrackingStage.headingToStore:
        stageTitle = 'Driver Menuju Pasar / Toko';
        stageSubtitle = '$_driverName sedang menuju Pasar Sukaramai (Estimasi tiba: 3 mnt)';
        stepNumber = 2;
        break;
      case TrackingStage.shoppingAtMarket:
        stageTitle = 'Driver Sedang Belanja Pesanan';
        stageSubtitle = 'Memilih item daging, cabai, & bawang segar di lapak pasar';
        stepNumber = 3;
        break;
      case TrackingStage.headingToCustomer:
        stageTitle = 'Belanja Selesai! Driver Menuju Rumah Anda';
        stageSubtitle = '$_driverName sedang meluncur ke alamat Anda membawa pesanan';
        stepNumber = 4;
        break;
      case TrackingStage.arrivedAndSettlement:
        stageTitle = 'Driver Tiba di Depan Rumah';
        stageSubtitle = 'Serah terima barang & nota fisik talangan belanja';
        stepNumber = 4;
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Simulated Map Background
          const Positioned.fill(
            child: RideMapWidget(
              showDriver: true,
              driverEta: 'Joni Utama (3 mnt)',
            ),
          ),

          // Simulation Switcher Bar at Top
          Positioned(
            top: 48,
            left: 70,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Simulasi: ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    _buildSimChip('Menuju Toko', TrackingStage.headingToStore),
                    _buildSimChip('Sedang Belanja', TrackingStage.shoppingAtMarket),
                    _buildSimChip('Menuju Rumah', TrackingStage.headingToCustomer),
                    _buildSimChip('Tiba & Struk', TrackingStage.arrivedAndSettlement),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Tracking Card & Driver Info
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator (4 Status Tahapan Operasional)
                  Row(
                    children: List.generate(4, (index) {
                      final isPassed = index < stepNumber;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: isPassed ? AppColors.primaryPurple : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  // Stage Status Title & Subtitle
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delivery_dining, color: AppColors.primaryPurple, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stageTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                            ),
                            Text(
                              stageSubtitle,
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Driver Profile Card
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/avatar_peter.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _driverName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF9C4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 12, color: Colors.amber),
                                      const SizedBox(width: 2),
                                      Text(
                                        '$_driverRating',
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$_driverVehicle • $_driverPlate',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: const Color(0xFFF3F0FF)),
                        icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryPurple, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatTab(isStandalone: true)),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: const Color(0xFFE8F5E9)),
                        icon: const Icon(Icons.phone, color: AppColors.successGreen, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Menghubungi driver via telepon WhatsApp...')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons: Lihat Struk Pelunasan
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStage == TrackingStage.arrivedAndSettlement
                            ? AppColors.successGreen
                            : AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _showSettlementReceiptDialog,
                      icon: const Icon(Icons.receipt_long, size: 18),
                      label: Text(
                        _currentStage == TrackingStage.arrivedAndSettlement
                            ? 'LIHAT STRUK & BAYAR PELUNASAN'
                            : 'Lihat Estimasi Struk Tagihan Akhir',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimChip(String label, TrackingStage stage) {
    final isSelected = _currentStage == stage;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: () => setState(() => _currentStage = stage),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPurple : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
