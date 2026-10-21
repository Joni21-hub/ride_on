import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/map_widget.dart';
import 'driver_models.dart';

class DriverRadarTab extends StatefulWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggleOnline;
  final int cashCapital;
  final ValueChanged<int> onUpdateCashCapital;
  final int todayEarnings;
  final int todayTrips;
  final Function(DriverActiveOrder order, int earnings) onTripCompleted;
  final VoidCallback onOpenChat;

  const DriverRadarTab({
    super.key,
    required this.isOnline,
    required this.onToggleOnline,
    required this.cashCapital,
    required this.onUpdateCashCapital,
    required this.todayEarnings,
    required this.todayTrips,
    required this.onTripCompleted,
    required this.onOpenChat,
  });

  @override
  State<DriverRadarTab> createState() => _DriverRadarTabState();
}

class _DriverRadarTabState extends State<DriverRadarTab> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  DriverActiveOrder? _incomingOrder;
  DriverActiveOrder? _activeOrder;
  DriverTripStage _tripStage = DriverTripStage.idle;
  int _countdown = 18;
  Timer? _countdownTimer;
  int _tripStep = 0; // For multi-step deliveries
  final Set<int> _checkedShoppingItems = {0};

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _triggerIncomingOrder(DriverActiveOrder order) {
    if (!widget.isOnline) {
      widget.onToggleOnline(true);
    }
    setState(() {
      _incomingOrder = order;
      _tripStage = DriverTripStage.incoming;
      _countdown = 18;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _rejectOrder();
      }
    });
  }

  void _acceptOrder() {
    _countdownTimer?.cancel();
    setState(() {
      _activeOrder = _incomingOrder;
      _incomingOrder = null;
      _tripStage = DriverTripStage.headingToPickup;
      _tripStep = 1;
    });
  }

  void _rejectOrder() {
    _countdownTimer?.cancel();
    setState(() {
      _incomingOrder = null;
      _tripStage = DriverTripStage.idle;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Orderan dilewati. Radar tetap siaga mencari orderan terbaik.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _advanceTripStep() {
    setState(() {
      if (_tripStep == 1) {
        _tripStep = 2;
        _tripStage = DriverTripStage.atPickup;
      } else if (_tripStep == 2) {
        _tripStep = 3;
        _tripStage = DriverTripStage.delivering;
      } else {
        // Complete trip
        final completedOrder = _activeOrder!;
        final earned = completedOrder.deliveryFee;
        widget.onTripCompleted(completedOrder, earned);
        _activeOrder = null;
        _tripStage = DriverTripStage.idle;
        _tripStep = 0;
        _showTripFinishedDialog(completedOrder, earned);
      }
    });
  }

  void _showTripFinishedDialog(DriverActiveOrder order, int earned) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.successGreen, size: 28),
            SizedBox(width: 8),
            Text('Trip Berhasil Selesai!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pesanan ${order.orderId} telah diterima oleh ${order.customerName}.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ongkir Masuk Saldo:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '+ Rp ${earned.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Radar'),
          ),
        ],
      ),
    );
  }

  void _showAturModalKasDialog() {
    int selectedVal = widget.cashCapital;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Icon(Icons.shield, color: AppColors.primaryPurple, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'ATUR MODAL KAS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Berapa uang tunai yang Anda bawa di saku hari ini untuk membelanjakan titipan customer?',
                style: TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
              ),
              const SizedBox(height: 16),
              ...[100000, 200000, 300000].map((val) {
                final isSelected = selectedVal == val;
                final label = val == 300000 ? 'Rp 300.000 (Maks)' : 'Rp ${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setModalState(() => selectedVal = val),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF3F0FF) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPurple : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.primaryPurple, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.successGreen, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pilih Proteksi Saldo Anda untuk menerima order dengan tidak melebihi talangan dana anda.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
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
                    widget.onUpdateCashCapital(selectedVal);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Batas modal kas berhasil disimpan: Rp ${selectedVal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}'),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    );
                  },
                  child: const Text('Simpan & Terapkan ke Radar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map background
        const RideMapWidget(),

        // Pulsing radar ripple when online
        if (widget.isOnline && _activeOrder == null)
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 220 * (1 + _pulseController.value * 0.4),
                  height: 220 * (1 + _pulseController.value * 0.4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPurple.withOpacity(0.12 * (1 - _pulseController.value)),
                    border: Border.all(
                      color: AppColors.primaryPurple.withOpacity(0.45 * (1 - _pulseController.value)),
                      width: 1.5,
                    ),
                  ),
                );
              },
            ),
          ),

        // Driver Center Icon
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
                ),
                child: const Icon(Icons.two_wheeler, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Text('Lokasimu', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // Top Dashboard Cards (Online Toggle, Proteksi Talangan, Pendapatan)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                // Online / Offline Status Toggle Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: widget.isOnline ? const Color(0xFFE8F5E9) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.isOnline ? AppColors.successGreen : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.isOnline ? const Color(0xFFC8E6C9) : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.isOnline ? Icons.radar : Icons.power_settings_new,
                          color: widget.isOnline ? AppColors.successGreen : Colors.grey[600],
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isOnline ? 'Status: ONLINE (SIAGA)' : 'Status: OFFLINE (Istirahat)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: widget.isOnline ? const Color(0xFF1B5E20) : Colors.grey[800],
                              ),
                            ),
                            Text(
                              widget.isOnline ? 'Geser tombol untuk off' : 'Geser tombol untuk mulai cari order',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: widget.isOnline,
                        activeColor: AppColors.successGreen,
                        onChanged: widget.onToggleOnline,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Proteksi Talangan Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.shield_outlined, color: AppColors.primaryPurple, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'PROTEKSI TALANGAN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: AppColors.primaryPurple,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _showAturModalKasDialog,
                            child: const Text(
                              'Atur Batas Modal Kas Belanja ->',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Modal Kas Belanja Hari Ini',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          Text(
                            'Rp ${widget.cashCapital.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sistem hanya akan memberi order titip belanja dengan total nota kas belanja anda. Tidak dipaksa menalangi lebih.',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Pendapatan Bersih Hari Ini Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Pendapatan Bersih Hari Ini',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '• 5 Okt 2026',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rp ${widget.todayEarnings.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Trip Selesai: ${widget.todayTrips} Order',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick simulation chips (Only visible when idle)
        if (_tripStage == DriverTripStage.idle)
          Positioned(
            left: 16,
            right: 16,
            bottom: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.touch_app, size: 14, color: AppColors.primaryPurple),
                          SizedBox(width: 4),
                          Text(
                            'Simulasi Orderan Masuk (Uji Desain Figma):',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      Text(
                        widget.isOnline ? 'Radar Aktif' : 'Offline',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.isOnline ? AppColors.successGreen : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSimButton(
                          title: '1. Titip Belanja',
                          subtitle: 'FlexSend',
                          icon: Icons.shopping_basket,
                          onTap: () => _triggerIncomingOrder(DriverActiveOrder.shoppingSample()),
                        ),
                        const SizedBox(width: 8),
                        _buildSimButton(
                          title: '2. Antar Penumpang',
                          subtitle: 'FlexRide',
                          icon: Icons.two_wheeler,
                          onTap: () => _triggerIncomingOrder(DriverActiveOrder.passengerSample()),
                        ),
                        const SizedBox(width: 8),
                        _buildSimButton(
                          title: '3. Pesan Makanan',
                          subtitle: 'FlexFood (PIN Kasir)',
                          icon: Icons.restaurant,
                          onTap: () => _triggerIncomingOrder(DriverActiveOrder.foodSample()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Bottom Radar Scanning Status (When idle)
        if (_tripStage == DriverTripStage.idle)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: widget.isOnline ? const Color(0xFF00E676) : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.isOnline ? 'Mencari orderan terbaik di sekitarmu...' : 'Driver sedang offline. Nyalakan siaga.',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Incoming Order Sheet (Frames 242:15891 & 242:16297)
        if (_tripStage == DriverTripStage.incoming && _incomingOrder != null)
          _buildIncomingOrderSheet(_incomingOrder!),

        // Active In-Progress Trip Sheet (Frames 242:15848, 242:15111, etc.)
        if (_activeOrder != null)
          _buildActiveTripSheet(_activeOrder!),
      ],
    );
  }

  Widget _buildSimButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.accentPastel),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryPurple),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingOrderSheet(DriverActiveOrder order) {
    final isUrgent = _countdown <= 10;
    final typeName = order.type == DriverOrderType.shopping
        ? 'TITIP BELANJA'
        : order.type == DriverOrderType.passenger
            ? 'ANTAR PENUMPANG'
            : 'PESAN MAKANAN';

    return Positioned(
      left: 12,
      right: 12,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))],
          border: Border.all(
            color: isUrgent ? AppColors.dangerRed : AppColors.primaryPurple,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUrgent ? const Color(0xFFFFEBEE) : const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: isUrgent ? AppColors.dangerRed : AppColors.primaryPurple,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_countdown Detik',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isUrgent ? AppColors.dangerRed : AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    typeName,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Urgent alert if <= 10 seconds
            if (isUrgent)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: AppColors.dangerRed, size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Waktu hampir habis! Orderan akan otomatis dialihkan.',
                        style: TextStyle(color: AppColors.dangerRed, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // Order info & Earnings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pendapatan Bersih', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text(
                      'Rp ${order.deliveryFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                    ),
                    if (order.type == DriverOrderType.shopping) ...[
                      const Text('• Ongkir Jarak Tempuh', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      const Text('• Tambahan 1 Toko Singgah (+Rp 2.000)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      const Text('• Tambahan 4 Item Barang (+Rp 1.000)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ] else
                      const Text('Ongkir rute + kuota item', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                if (order.estimatedTalangan > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Estimasi Talangan', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Text(
                        'Rp ${order.estimatedTalangan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const Text('Sesuai modal kas driver', style: TextStyle(fontSize: 10, color: AppColors.successGreen)),
                    ],
                  ),
              ],
            ),
            const Divider(height: 18),

            // Route stops
            ...order.routeStops.map((stop) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.primaryPurple),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          stop,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Klik Maps', style: TextStyle(fontSize: 9, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 6),
            Text(
              order.distanceInfo,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            // Buttons: Terima Order vs SKIP
            Row(
              children: [
                TextButton(
                  onPressed: _rejectOrder,
                  child: const Text(
                    'SKIP >>',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _acceptOrder,
                    child: Text(
                      order.type == DriverOrderType.shopping
                          ? 'Terima Order Belanja'
                          : order.type == DriverOrderType.passenger
                              ? 'Terima Order Penumpang'
                              : 'Terima Order Makanan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTripSheet(DriverActiveOrder order) {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with customer & action icons
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryPurple,
                  radius: 18,
                  child: Text(
                    order.customerName.isNotEmpty ? order.customerName[0] : 'C',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        _tripStep == 1
                            ? 'Menuju titik jemput / resto'
                            : _tripStep == 2
                                ? 'Sedang di lokasi penjemputan / toko'
                                : 'Mengantar ke tujuan',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primaryPurple),
                  onPressed: widget.onOpenChat,
                ),
                IconButton(
                  icon: const Icon(Icons.phone, color: AppColors.successGreen),
                  onPressed: widget.onOpenChat,
                ),
              ],
            ),
            const Divider(height: 16),

            // If Food order at Step 2 -> PIN KASIR (Frame 242:15848)
            if (order.type == DriverOrderType.food && _tripStep == 2 && order.storePin != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentPastel),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TUNJUKKAN / SEBUTKAN PIN KE KASIR TOKO',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.storePin!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kasir wajib memasukkan 4 angka ini sebelum pesanan diserahkan.',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Item summary
              ...order.items.map((it) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '• ${it.quantity} ${it.name} ${it.note.isNotEmpty ? "(${it.note})" : ""}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  )),
              const SizedBox(height: 12),
            ],

            // If Shopping order at Step 2 -> Mode Titip Belanja (Halaman 4 Skenario A)
            if (order.type == DriverOrderType.shopping && _tripStep == 2) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'STATUS: DI LOKASI 1 (PASAR SUKARAMAI)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryPurple),
                ),
              ),
              const SizedBox(height: 8),
              const Text('DAFTAR BARANG YANG DIBELI:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textDark)),
              const SizedBox(height: 4),

              // Interactive Checklist Items
              ...List.generate(order.items.length, (idx) {
                final it = order.items[idx];
                final isChecked = _checkedShoppingItems.contains(idx);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _checkedShoppingItems.remove(idx);
                      } else {
                        _checkedShoppingItems.add(idx);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isChecked ? const Color(0xFFE8F5E9) : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isChecked ? AppColors.successGreen : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 18,
                          color: isChecked ? AppColors.successGreen : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${idx + 1}. ${it.name} (${it.quantity})',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (it.note.isNotEmpty)
                                Text(
                                  'Catatan: ${it.note}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          'Rp ${it.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),

              // Quick Communication Buttons: Chat Customer & Foto Alternatif
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: widget.onOpenChat,
                      icon: const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.primaryPurple),
                      label: const Text('💬 Chat Customer', style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📷 Foto barang alternatif/nota berhasil dikirim ke ruang chat customer')),
                        );
                      },
                      icon: const Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.primaryPurple),
                      label: const Text('📷 Foto Alternatif', style: TextStyle(fontSize: 11, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            // Step instructions
            Text(
              _tripStep == 1
                  ? 'Lokasi Jemput/Toko: ${order.pickupLocation}'
                  : _tripStep == 2
                      ? (order.type == DriverOrderType.food
                          ? 'Waroeng Bamboe (Ambil Makanan)'
                          : 'Lokasi 1 Pasar Sukaramai -> Apotek Sehat Farma')
                      : 'Lokasi Pengantaran: ${order.destinationLocation}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Advance Step Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tripStep == 3 ? AppColors.successGreen : AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (order.type == DriverOrderType.shopping && _tripStep == 2) {
                    _showSettlementFormSheet(order);
                  } else {
                    _advanceTripStep();
                  }
                },
                child: Text(
                  _tripStep == 1
                      ? 'Saya Sudah Sampai di Lokasi Jemput ->'
                      : _tripStep == 2
                          ? (order.type == DriverOrderType.food
                              ? 'Kasir Sudah Verifikasi PIN & Makanan Diterima'
                              : 'SUDAH SELESAI BELANJA -> INPUT STRUK')
                          : 'Konfirmasi Pesanan Diterima Customer (Selesai)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Halaman 5: Formulir Selesai Belanja & Input Struk (Settlement Form)
  void _showSettlementFormSheet(DriverActiveOrder order) {
    int marketReceipt = 115000;
    int pharmacyReceipt = 25000;
    int parkingFee = 2000;
    bool hasCashNoTicket = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final totalTalangan = marketReceipt + pharmacyReceipt + (hasCashNoTicket ? parkingFee : 0);
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
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
                      const Icon(Icons.receipt_long, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Ringkasan Pengeluaran & Bukti Talangan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Lokasi 1
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F6FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accentPastel),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LOKASI 1: Pasar Sukaramai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('• Total Nota Belanja :', style: TextStyle(fontSize: 12)),
                                Text('Rp 115.000', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryPurple)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('• Retribusi Parkir    :', style: TextStyle(fontSize: 12)),
                                Text('Rp 2.000', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Lokasi 2
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F6FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accentPastel),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LOKASI 2: Apotek Sehat Farma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('• Total Nota Belanja :', style: TextStyle(fontSize: 12)),
                                Text('Rp 25.000', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryPurple)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('• Retribusi Parkir    :', style: TextStyle(fontSize: 12)),
                                Text('Rp 0 (Gratis parkir)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // BUKTI FOTO
                      const Text('BUKTI FOTO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Foto struk nota fisik & karcis parkir berhasil diambil')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFA5D6A7)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, color: AppColors.successGreen, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Ambil Foto Semua Struk & Karcis Parkir',
                                style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: hasCashNoTicket,
                            activeColor: AppColors.primaryPurple,
                            onChanged: (val) => setSheetState(() => hasCashNoTicket = val ?? false),
                          ),
                          const Expanded(
                            child: Text(
                              'Centang jika parkir tunai tanpa karcis (Maks Rp 2.000)',
                              style: TextStyle(fontSize: 11, color: AppColors.textDark),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // TOTAL TALANGAN MODAL DRIVER
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryPurple, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('TOTAL TALANGAN MODAL DRIVER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                                SizedBox(height: 2),
                                Text('(Customer wajib mengganti nominal ini di tujuan)', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                              ],
                            ),
                            Text(
                              'Rp ${totalTalangan.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // TOMBOL SIMPAN DAN MENUJU RUMAH CUSTOMER
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _advanceTripStep();
                          },
                          child: const Text(
                            'SIMPAN DAN MENUJU RUMAH CUSTOMER',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
