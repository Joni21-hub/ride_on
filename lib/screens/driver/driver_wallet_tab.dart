import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class DriverWalletTab extends StatefulWidget {
  final int activeBalance;
  final ValueChanged<int> onBalanceUpdated;

  const DriverWalletTab({
    super.key,
    required this.activeBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<DriverWalletTab> createState() => _DriverWalletTabState();
}

class _DriverWalletTabState extends State<DriverWalletTab> {
  void _showWithdrawDialog() {
    final amountController = TextEditingController(text: '100000');
    String selectedBank = 'BCA (123-456-7890 a/n Joni Utama)';

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
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 24),
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
              const SizedBox(height: 16),
              const Text(
                'Tarik Uang Anda (Penarikan Dana)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Saldo Tersedia: Rp ${widget.activeBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              const Text('Rekening Tujuan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedBank,
                    items: const [
                      DropdownMenuItem(
                        value: 'BCA (123-456-7890 a/n Joni Utama)',
                        child: Text('BCA (123-456-7890 a/n Joni Utama)', style: TextStyle(fontSize: 13)),
                      ),
                      DropdownMenuItem(
                        value: 'Mandiri (987-654-3210 a/n Joni Utama)',
                        child: Text('Mandiri (987-654-3210 a/n Joni Utama)', style: TextStyle(fontSize: 13)),
                      ),
                      DropdownMenuItem(
                        value: 'DANA E-Wallet (0812-3456-7890)',
                        child: Text('DANA E-Wallet (0812-3456-7890)', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedBank = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Nominal Penarikan (Rp):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final amount = int.tryParse(amountController.text.replaceAll('.', '')) ?? 0;
                    if (amount <= 0 || amount > widget.activeBalance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nominal tidak valid atau melebihi saldo tersedia!')),
                      );
                      return;
                    }
                    widget.onBalanceUpdated(widget.activeBalance - amount);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Permintaan penarikan Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} berhasil diajukan!'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  child: const Text('Konfirmasi Tarik Dana', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKlaimDanaDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.verified_user, color: AppColors.primaryPurple, size: 22),
                SizedBox(width: 8),
                Text(
                  'Klaim Proteksi Talangan Driver',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Customer membatalkan pesanan atau tidak dapat dihubungi saat belanjaan sudah dibeli? Sistem RideOn menjamin penggantian 100% uang talangan Anda.',
              style: TextStyle(fontSize: 12, color: AppColors.textDark, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Langkah Pengajuan Klaim:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('1. Foto struk/nota belanjaan dari toko/pasar', style: TextStyle(fontSize: 11)),
                  Text('2. Foto fisik barang belanjaan yang ada di tangan', style: TextStyle(fontSize: 11)),
                  Text('3. Kirimkan laporan ke CS WhatsApp RideOn Prioritas', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.support_agent),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Menghubungkan ke Tim Layanan Klaim Proteksi Driver RideOn...'),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  );
                },
                label: const Text('Hubungi CS WhatsApp Klaim 100%', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // Title
            const Text(
              'Dompet Driver',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),

            // Saldo Aktif Card (Frame 242:17755)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.purpleGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Saldo Aktif',
                        style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Siap Ditarik', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${widget.activeBalance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Pendapatan Ongkir', style: TextStyle(color: Colors.white70, fontSize: 10)),
                              SizedBox(height: 2),
                              Text('Rp 45.000', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Refund Talangan', style: TextStyle(color: Colors.white70, fontSize: 10)),
                              SizedBox(height: 2),
                              Text('Rp 50.000', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.payments_outlined, size: 18),
                      onPressed: _showWithdrawDialog,
                      label: const Text('Tarik Uang Anda', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Banner Klaim Talangan Penipuan/Pembatalan (Frame 242:17755)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: Color(0xFFF57F17), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Customer Batalkan / Masalah Talangan?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark),
                        ),
                        Text(
                          'Ajukan klaim ganti rugi 100% uang belanjaan',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showKlaimDanaDialog,
                    child: const Text('Klaim Dana ->', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE65100), fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Riwayat Mutasi Dompet
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Transaksi Dompet Terbaru',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text('Riwayat Transparan', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 10),

            _buildMutationTile(
              orderId: 'ID : I2E4S68',
              title: 'Ongkos Kirim Pesanan Waroeng Bamboe',
              amount: '+ Rp 35.000',
              isIncome: true,
            ),
            _buildMutationTile(
              orderId: 'ID : I2E4S68',
              title: 'Fee Admin Platform (10%)',
              amount: '- Rp 3.500',
              isIncome: false,
            ),
            _buildMutationTile(
              orderId: 'ID : I2E4S67',
              title: 'Ongkos Kirim FlexSend (Pasar Pagi)',
              amount: '+ Rp 15.000',
              isIncome: true,
            ),
            _buildMutationTile(
              orderId: 'ID : I2E4S67',
              title: 'Fee Admin Platform (10%)',
              amount: '- Rp 1.500',
              isIncome: false,
            ),
            _buildMutationTile(
              orderId: 'WD-20261005',
              title: 'Penarikan Dana ke Rekening BCA',
              amount: '- Rp 100.000',
              isIncome: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMutationTile({
    required String orderId,
    required String title,
    required String amount,
    required bool isIncome,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isIncome ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? AppColors.successGreen : AppColors.dangerRed,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  Text(orderId, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isIncome ? AppColors.successGreen : AppColors.dangerRed,
            ),
          ),
        ],
      ),
    );
  }
}
