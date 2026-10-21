import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class MerchantRegistrationFlow extends StatefulWidget {
  const MerchantRegistrationFlow({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const MerchantRegistrationFlow(),
    );
  }

  @override
  State<MerchantRegistrationFlow> createState() => _MerchantRegistrationFlowState();
}

class _MerchantRegistrationFlowState extends State<MerchantRegistrationFlow> {
  int _currentStep = 1; // 1: Data Usaha, 2: Legalitas & Bank, 3: Under Review

  // Step 1 Controllers
  final _namaUsahaController = TextEditingController(text: 'Dapur Sambal Sukaramai');
  final _alamatController = TextEditingController(text: 'Jl. Merdeka No. 45, Lhokseumawe');
  final _waController = TextEditingController(text: '0812-3456-7890');
  String _selectedCategory = 'Restoran / Rumah Makan';

  // Step 2 Controllers
  final _namaBankController = TextEditingController(text: 'BCA');
  final _noRekeningController = TextEditingController(text: '8820192831');
  final _namaPemilikRekeningController = TextEditingController(text: 'Siti Nuraini');
  bool _ktpUploaded = true;
  bool _outletPhotoUploaded = true;

  @override
  void dispose() {
    _namaUsahaController.disposeWidget();
    _alamatController.disposeWidget();
    _waController.disposeWidget();
    _namaBankController.disposeWidget();
    _noRekeningController.disposeWidget();
    _namaPemilikRekeningController.disposeWidget();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentStep == 3
                          ? 'Status Pendaftaran'
                          : 'Daftar Mitra Gerai (Step $_currentStep/2)',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      _currentStep == 1
                          ? 'Informasi profil dan alamat usaha'
                          : _currentStep == 2
                              ? 'Legalitas identitas & rekening pencairan'
                              : 'Tinjauan verifikasi akun merchant',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          if (_currentStep < 3)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              height: 4,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentStep >= 2 ? AppColors.primaryPurple : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Action
          if (_currentStep < 3)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep == 2) ...[
                    OutlinedButton(
                      onPressed: () => setState(() => _currentStep = 1),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: const Text('Kembali', style: TextStyle(color: AppColors.textDark)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentStep == 1) {
                          setState(() => _currentStep = 2);
                        } else {
                          setState(() => _currentStep = 3);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentStep == 1 ? 'Lanjut ke Legalitas & Bank' : 'Kirim Pendaftaran Mitra',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Kembali ke Dashboard Gerai', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Nama Gerai / Restoran',
            controller: _namaUsahaController,
            hint: 'Contoh: Dapur Sambal Sukaramai',
            prefixIcon: Icons.storefront,
          ),
          const SizedBox(height: 16),
          const Text(
            'Kategori Usaha Kuliner',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                items: [
                  'Restoran / Rumah Makan',
                  'Minuman, Kopi & Boba',
                  'Camilan & Jajanan Pasar',
                  'Bakso & Mie Ayam',
                  'Seafood & Ikan Bakar',
                ].map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Alamat Lengkap Gerai',
            controller: _alamatController,
            hint: 'Nama jalan, patokan, nomor toko',
            prefixIcon: Icons.location_on_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Nomor WhatsApp Pemilik Gerai',
            controller: _waController,
            hint: '0812-xxxx-xxxx',
            prefixIcon: Icons.phone_android,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primaryPurple, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pastikan nomor WhatsApp aktif untuk menerima konfirmasi verifikasi dan notifikasi pesanan masuk.',
                    style: TextStyle(fontSize: 11, color: AppColors.primaryPurple),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Dokumen Legalitas Usaha',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 10),

          // Upload KTP Card
          _buildUploadCard(
            title: 'Foto e-KTP Pemilik Usaha',
            subtitle: 'Wajib tampak jelas & tidak buram',
            isUploaded: _ktpUploaded,
            onToggle: () => setState(() => _ktpUploaded = !_ktpUploaded),
          ),
          const SizedBox(height: 12),

          // Upload Foto Outlet Card
          _buildUploadCard(
            title: 'Foto Outlet / Tampak Depan Toko',
            subtitle: 'Memperlihatkan papan nama dan gerai fisik',
            isUploaded: _outletPhotoUploaded,
            onToggle: () => setState(() => _outletPhotoUploaded = !_outletPhotoUploaded),
          ),
          const SizedBox(height: 20),

          const Text(
            'Rekening Bank untuk Pencairan Dana',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 10),

          _buildTextField(
            label: 'Bank Tujuan',
            controller: _namaBankController,
            hint: 'BCA / Mandiri / BRI / BSI',
            prefixIcon: Icons.account_balance,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            label: 'Nomor Rekening',
            controller: _noRekeningController,
            hint: 'Contoh: 8820192831',
            prefixIcon: Icons.credit_card,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            label: 'Nama Pemilik Rekening',
            controller: _namaPemilikRekeningController,
            hint: 'Sesuai dengan nama buku tabungan',
            prefixIcon: Icons.person_outline,
          ),
        ],
      );
    } else {
      // Step 3: Under Review (Figma 04_Merchant_Register_UnderReview)
      return Column(
        children: [
          const SizedBox(height: 30),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.successGreen, width: 2),
            ),
            child: const Icon(Icons.hourglass_top_rounded, color: AppColors.successGreen, size: 44),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pendaftaran Berhasil Dikirim!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data pendaftaran gerai "Dapur Sambal Sukaramai" sedang dalam proses verifikasi tim operasional FlexFood.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F6FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                _buildReviewItem(
                  icon: Icons.check_circle,
                  color: AppColors.successGreen,
                  title: 'Data Usaha & Menu Awal',
                  status: 'Terkirim',
                ),
                const Divider(height: 20),
                _buildReviewItem(
                  icon: Icons.check_circle,
                  color: AppColors.successGreen,
                  title: 'e-KTP & Foto Gerai Fisik',
                  status: 'Terkirim',
                ),
                const Divider(height: 20),
                _buildReviewItem(
                  icon: Icons.sync,
                  color: AppColors.primaryPurple,
                  title: 'Validasi Legalitas & Rekening',
                  status: 'Sedang Berlangsung (1x24 Jam)',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Setelah akun diverifikasi, Anda dapat langsung mengaktifkan tombol Buka Toko untuk menerima pesanan online.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
            prefixIcon: Icon(prefixIcon, color: AppColors.primaryPurple, size: 20),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUploaded ? const Color(0xFFE8F5E9) : const Color(0xFFF7F6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded ? AppColors.successGreen : AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUploaded ? AppColors.successGreen : AppColors.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isUploaded ? Icons.check : Icons.cloud_upload_outlined,
              color: isUploaded ? Colors.white : AppColors.primaryPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(
              isUploaded ? 'Ganti' : 'Unggah',
              style: TextStyle(
                color: isUploaded ? AppColors.successGreen : AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required IconData icon,
    required Color color,
    required String title,
    required String status,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text(status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

extension on TextEditingController {
  void disposeWidget() {
    dispose();
  }
}
