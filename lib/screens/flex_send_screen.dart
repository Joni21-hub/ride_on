import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FlexSendScreen extends StatefulWidget {
  const FlexSendScreen({super.key});

  @override
  State<FlexSendScreen> createState() => _FlexSendScreenState();
}

class _FlexSendScreenState extends State<FlexSendScreen> {
  int _serviceType = 0; // 0 = Instant (15.000), 1 = SameDay (10.000)
  final TextEditingController _senderController =
      TextEditingController(text: 'Jl. Melati No. 42, Banda Aceh');
  final TextEditingController _receiverController =
      TextEditingController(text: 'Kampus Unimal Reulet, Gedung Kuliah');
  final TextEditingController _itemDescController =
      TextEditingController(text: 'Dokumen Penting & Paket Belanja');

  @override
  void dispose() {
    _senderController.dispose();
    _receiverController.dispose();
    _itemDescController.dispose();
    super.dispose();
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
                      'FlexSend',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender & Receiver card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accentPastel),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.radio_button_checked, color: AppColors.primaryPurple, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _senderController,
                          decoration: const InputDecoration(
                            labelText: 'Lokasi Pengambilan Paket',
                            labelStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(indent: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _receiverController,
                          decoration: const InputDecoration(
                            labelText: 'Lokasi Tujuan Pengantaran',
                            labelStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Item Details
            const Text(
              'Detail Barang / Paket',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _itemDescController,
                decoration: const InputDecoration(
                  hintText: 'Deskripsi barang (contoh: Pakaian, Makanan ringan)',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Service Options
            const Text(
              'Pilihan Layanan Pengiriman',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildServiceOption(
              0,
              'FlexSend Instan (1-2 Jam)',
              'Kurir langsung mengantar khusus untuk paket Anda',
              'Rp 15.000',
            ),
            const SizedBox(height: 8),
            _buildServiceOption(
              1,
              'FlexSend Hemat (Sameday)',
              'Pengantaran di hari yang sama dengan ongkir lebih bersahabat',
              'Rp 10.000',
            ),

            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kurir FlexSend sedang dicari untuk menjemput paketmu!'),
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Pesan FlexSend Sekarang ${_serviceType == 0 ? "Rp 15.000" : "Rp 10.000"}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOption(int index, String title, String subtitle, String price) {
    final isSelected = _serviceType == index;
    return GestureDetector(
      onTap: () => setState(() => _serviceType = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : const Color(0xFFF3F0FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping,
                color: isSelected ? Colors.white : AppColors.primaryPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
