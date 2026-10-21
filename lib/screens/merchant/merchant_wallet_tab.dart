import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'merchant_models.dart';

class MerchantWalletTab extends StatefulWidget {
  final int activeBalance;
  final ValueChanged<int> onBalanceUpdated;

  const MerchantWalletTab({
    super.key,
    required this.activeBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<MerchantWalletTab> createState() => _MerchantWalletTabState();
}

class _MerchantWalletTabState extends State<MerchantWalletTab> {
  final List<StoreScheduleDay> _schedules = [
    StoreScheduleDay(dayName: 'Senin', isOpen: true),
    StoreScheduleDay(dayName: 'Selasa', isOpen: true),
    StoreScheduleDay(dayName: 'Rabu', isOpen: true),
    StoreScheduleDay(dayName: 'Kamis', isOpen: true),
    StoreScheduleDay(dayName: 'Jumat', isOpen: true),
    StoreScheduleDay(dayName: 'Sabtu', isOpen: true),
    StoreScheduleDay(dayName: 'Minggu', isOpen: true),
  ];

  final List<MerchantTransaction> _transactions = [
    const MerchantTransaction(
      id: 'TRX-9901',
      title: 'Pencairan Dana ke Rekening BCA',
      date: '5 Okt 2026 • 14:10 WIB',
      amount: 500000,
      isCredit: false,
      status: 'Berhasil Ditransfer',
    ),
    const MerchantTransaction(
      id: 'ORD-8820',
      title: 'Pendapatan Pesanan #FD-8820',
      date: '5 Okt 2026 • 12:45 WIB',
      amount: 72000,
      isCredit: true,
      status: 'Selesai',
    ),
    const MerchantTransaction(
      id: 'ORD-8819',
      title: 'Pendapatan Pesanan #FD-8819',
      date: '5 Okt 2026 • 11:20 WIB',
      amount: 45000,
      isCredit: true,
      status: 'Selesai',
    ),
    const MerchantTransaction(
      id: 'FEE-8819',
      title: 'Biaya Platform FlexFood (10%)',
      date: '5 Okt 2026 • 11:20 WIB',
      amount: 4500,
      isCredit: false,
      status: 'Dipotong',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saldo Overview Card (Figma 01_Merchant_Wallet_Overview)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo Dompet Gerai',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_clock, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text('Dana Aman', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Rp ${_formatNumber(widget.activeBalance)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Tertahan (Dalam Masak)', style: TextStyle(color: Colors.white70, fontSize: 10)),
                            SizedBox(height: 2),
                            Text('Rp 48.000', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Omzet Bulan Ini', style: TextStyle(color: Colors.white70, fontSize: 10)),
                            SizedBox(height: 2),
                            Text('Rp 12.850.000', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Button Tarik Saldo
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _showWithdrawalForm(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.account_balance, size: 18),
                        SizedBox(width: 8),
                        Text('Tarik Uang ke Rekening Bank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Jadwal Operasional Card (Figma 04_Merchant_Schedule_Settings)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE8FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.more_time, color: AppColors.primaryPurple, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Jadwal Operasional Toko',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Senin - Minggu: 09:00 - 21:00 WIB',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showScheduleSettingsDialog(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Atur', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Riwayat Transaksi Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Mutasi Transaksi Dompet',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              Text(
                'Semua Riwayat',
                style: TextStyle(fontSize: 12, color: AppColors.primaryPurple, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Transaksi List
          ..._transactions.map((tx) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tx.isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: tx.isCredit ? AppColors.successGreen : AppColors.dangerRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          Text(
                            tx.date,
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${tx.isCredit ? "+" : "-"} Rp ${_formatNumber(tx.amount)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: tx.isCredit ? AppColors.successGreen : AppColors.dangerRed,
                          ),
                        ),
                        Text(
                          tx.status,
                          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // Figma 02_Merchant_Withdrawal_Form
  void _showWithdrawalForm(BuildContext context) {
    final amountCtrl = TextEditingController(text: '500000');
    String selectedBank = 'BCA (8820192831 - Sukaramai)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.75,
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
                      const Text(
                        'Tarik Saldo Gerai',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
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
                        const Text('Rekening Bank Tujuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F6FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedBank,
                              isExpanded: true,
                              items: [
                                'BCA (8820192831 - Sukaramai)',
                                'Mandiri (15800039281 - Siti Nuraini)',
                                'BRI (01928374921 - Siti Nuraini)',
                              ].map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (val) {
                                if (val != null) setSheetState(() => selectedBank = val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        const Text('Nominal Penarikan (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: amountCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            prefixText: 'Rp ',
                            filled: true,
                            fillColor: const Color(0xFFF7F6FF),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderLight)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Quick Chips
                        Wrap(
                          spacing: 8,
                          children: [100000, 250000, 500000, widget.activeBalance].map((val) {
                            final isAll = val == widget.activeBalance;
                            return ActionChip(
                              label: Text(
                                isAll ? 'Tarik Semua' : 'Rp ${_formatNumber(val)}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: const Color(0xFFF7F6FF),
                              onPressed: () {
                                setSheetState(() => amountCtrl.text = val.toString());
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Fee info
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Biaya Admin Transfer', style: TextStyle(fontSize: 12, color: AppColors.textDark)),
                              Text('GRATIS (Rp 0)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.successGreen)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final nominal = int.tryParse(amountCtrl.text.trim()) ?? 0;
                        if (nominal <= 0 || nominal > widget.activeBalance) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nominal penarikan tidak valid atau melebihi saldo.')),
                          );
                          return;
                        }

                        Navigator.pop(ctx);
                        final newBalance = widget.activeBalance - nominal;
                        widget.onBalanceUpdated(newBalance);

                        setState(() {
                          _transactions.insert(
                            0,
                            MerchantTransaction(
                              id: 'TRX-${DateTime.now().millisecondsSinceEpoch % 10000}',
                              title: 'Penarikan Dana ke $selectedBank',
                              date: 'Baru saja',
                              amount: nominal,
                              isCredit: false,
                              status: 'Sedang Diproses',
                            ),
                          );
                        });

                        // Show Figma 03_Merchant_Withdrawal_Success_Modal
                        _showWithdrawalSuccessModal(context, nominal, selectedBank);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Konfirmasi Penarikan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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

  // Figma 03_Merchant_Withdrawal_Success_Modal
  void _showWithdrawalSuccessModal(BuildContext context, int nominal, String bank) {
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
              'Permintaan Penarikan Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Dana sebesar Rp ${_formatNumber(nominal)} sedang diproses ke $bank.\nEstimasi dana masuk ke rekening: 5 - 15 menit.',
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
                child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Figma 04_Merchant_Schedule_Settings
  void _showScheduleSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
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
                    const Text(
                      'Pengaturan Jam Buka Gerai',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: _schedules.length,
                  itemBuilder: (ctx, i) {
                    final day = _schedules[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: day.isOpen ? const Color(0xFFF7F6FF) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: day.isOpen ? AppColors.accentPastel : Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch(
                                value: day.isOpen,
                                activeColor: AppColors.primaryPurple,
                                onChanged: (val) {
                                  setSheetState(() => day.isOpen = val);
                                },
                              ),
                              Text(
                                day.dayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: day.isOpen ? AppColors.textDark : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          if (day.isOpen)
                            Row(
                              children: [
                                Text(
                                  '${day.openTime.format(context)} - ${day.closeTime.format(context)}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.access_time, size: 16, color: AppColors.primaryPurple),
                              ],
                            )
                          else
                            const Text('Libur', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Jadwal operasional toko berhasil diperbarui!'),
                          backgroundColor: AppColors.successGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Simpan Jadwal Operasional', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
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
