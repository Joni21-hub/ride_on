import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class DriverRegistrationFlow extends StatefulWidget {
  const DriverRegistrationFlow({super.key});

  @override
  State<DriverRegistrationFlow> createState() => _DriverRegistrationFlowState();
}

class _DriverRegistrationFlowState extends State<DriverRegistrationFlow> {
  int _currentStep = 1;
  final TextEditingController _nameController = TextEditingController(text: 'Joni Utama');
  final TextEditingController _emailController = TextEditingController(text: 'joni.utama@rideon.id');
  final TextEditingController _phoneController = TextEditingController(text: '0812-3456-7890');
  final TextEditingController _passController = TextEditingController(text: '••••••••');

  bool _ktpUploaded = true;
  bool _simUploaded = true;
  bool _stnkUploaded = true;
  bool _skckUploaded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _currentStep == 3 ? 'Pendaftaran Sukses' : 'Daftar Akun Driver',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: _currentStep == 1
            ? _buildStep1()
            : _currentStep == 2
                ? _buildStep2()
                : _buildStep3Success(),
      ),
    );
  }

  // Step 1: Personal Data
  Widget _buildStep1() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Lengkapi data diri Anda untuk memulai',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        _buildTextField('Nama Lengkap', _nameController, Icons.person_outline),
        const SizedBox(height: 14),
        _buildTextField('Email', _emailController, Icons.email_outlined),
        const SizedBox(height: 14),
        _buildTextField('No. WhatsApp Aktif', _phoneController, Icons.phone_outlined),
        const SizedBox(height: 14),
        _buildTextField('Kata sandi (Min. 8 karakter)', _passController, Icons.lock_outline, isObscure: true),
        const SizedBox(height: 14),
        _buildTextField('Ulangi Kata Sandi', _passController, Icons.lock_outline, isObscure: true),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => setState(() => _currentStep = 2),
            child: const Text('LANJUTKAN KE UNGGAH BERKAS', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // Step 2: Documents upload
  Widget _buildStep2() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Unggah Berkas Persyaratan Mitra',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pastikan foto dokumen jelas, tidak terpotong, dan masih berlaku.',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),

        _buildDocUploadCard(
          title: 'KTP Elektronik (e-KTP)',
          subtitle: 'KTP asli pengemudi',
          isUploaded: _ktpUploaded,
          onToggle: () => setState(() => _ktpUploaded = !_ktpUploaded),
        ),
        const SizedBox(height: 12),

        _buildDocUploadCard(
          title: 'SIM C Asli',
          subtitle: 'Masa berlaku aktif minimal 6 bulan',
          isUploaded: _simUploaded,
          onToggle: () => setState(() => _simUploaded = !_simUploaded),
        ),
        const SizedBox(height: 12),

        _buildDocUploadCard(
          title: 'STNK Motor (BK 4892 ABC)',
          subtitle: 'Pajak hidup & sesuai kendaraan',
          isUploaded: _stnkUploaded,
          onToggle: () => setState(() => _stnkUploaded = !_stnkUploaded),
        ),
        const SizedBox(height: 12),

        _buildDocUploadCard(
          title: 'SKCK Kepolisian',
          subtitle: 'Surat keterangan catatan kepolisian',
          isUploaded: _skckUploaded,
          onToggle: () => setState(() => _skckUploaded = !_skckUploaded),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => setState(() => _currentStep = 3),
            child: const Text('KIRIM & SELESAIKAN PENDAFTARAN', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // Step 3: Success Screen (Frame 242:15096 - Berkas berhasil di lengkapi)
  Widget _buildStep3Success() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, size: 72, color: AppColors.successGreen),
          ),
          const SizedBox(height: 24),
          const Text(
            'BERKAS BERHASIL DI UPLOAD',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tim operasional sedang memvalidasi Keaslian Berkas Anda.\nProses aktivasi radar memakan waktu 1x24 jam.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('CEK EMAIL SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.successGreen,
                side: const BorderSide(color: AppColors.successGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.support_agent),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp Bantuan Pendaftaran Mitra CS')),
                );
              },
              label: const Text('Bantuan Pendaftaran Mitra (CS WhatsApp)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textDark)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primaryPurple),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey[300]!)),
          ),
        ),
      ],
    );
  }

  Widget _buildDocUploadCard({
    required String title,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUploaded ? const Color(0xFFF3F0FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUploaded ? AppColors.primaryPurple : Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(isUploaded ? Icons.check_circle : Icons.upload_file, color: isUploaded ? AppColors.primaryPurple : Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(isUploaded ? 'Ubah' : 'Unggah', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
          ),
        ],
      ),
    );
  }
}
