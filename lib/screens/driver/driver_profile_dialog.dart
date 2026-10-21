import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'driver_registration_flow.dart';

class DriverProfileDialog extends StatelessWidget {
  final VoidCallback onBackToCustomer;

  const DriverProfileDialog({super.key, required this.onBackToCustomer});

  static void show(BuildContext context, {required VoidCallback onBackToCustomer}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: DriverProfileDialog(onBackToCustomer: onBackToCustomer),
        ),
      ),
    );
  }

  void _showVehicleInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.two_wheeler, color: AppColors.primaryPurple),
            SizedBox(width: 8),
            Text('Informasi Kendaraan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _InfoRow(label: 'Nomor Polisi:', value: 'BK 4892 ABC'),
            _InfoRow(label: 'Jenis Kendaraan:', value: 'Sepeda Motor (Flex Motor)'),
            _InfoRow(label: 'Merk & Model:', value: 'Honda Vario 160cc Hitam'),
            _InfoRow(label: 'Tahun Pembuatan:', value: '2023'),
            _InfoRow(label: 'Masa Berlaku STNK:', value: '18 November 2028'),
            _InfoRow(label: 'Status Pajak:', value: 'Aktif / Taat Pajak'),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showVerificationStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.verified, color: AppColors.successGreen),
            SizedBox(width: 8),
            Text('Status Verifikasi Dokumen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _DocStatusRow(title: 'KTP Elektronik Asli', isVerified: true),
            _DocStatusRow(title: 'SIM C Aktif', isVerified: true),
            _DocStatusRow(title: 'STNK Motor BK 4892 ABC', isVerified: true),
            _DocStatusRow(title: 'SKCK Kepolisian Aktif', isVerified: true),
            _DocStatusRow(title: 'Foto Profil & Kendaraan', isVerified: true),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showKlaimTalanganDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.shield, color: AppColors.primaryPurple, size: 22),
            SizedBox(width: 8),
            Text('Klaim Talangan Belanja', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jalur cepat ganti rugi 100% jika pembeli fiktif membatalkan pesanan setelah Anda membelanjakan uang di pasar:',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentPastel),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ID Order Batal: #12E4S67', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(height: 2),
                  Text('Pasar: Pasar Tradisional Sukaramai', style: TextStyle(fontSize: 11)),
                  Text('Total Nota Fisik: Rp 142.000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: AppColors.successGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Foto nota fisik & karcis parkir telah terverifikasi sistem.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF1B5E20), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Klaim talangan diajukan. Dana talangan Rp 142.000 diganti instan ke dompet Anda!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            child: const Text('Ajukan Penggantian Talangan'),
          ),
        ],
      ),
    );
  }

  void _showSosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Tombol Darurat (SOS)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
        content: const Text(
          'Mengirimkan sinyal darurat beserta titik koordinat GPS real-time ke Call Center MARBUN Delivery dan pos keamanan terdekat.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sinyal SOS darurat aktif! Bantuan sedang menuju lokasi Anda.')),
              );
            },
            child: const Text('KIRIM SINYAL SOS SEKARANG'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 16),

        // Profile Header (Frame 242:20519)
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryPurple, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/driver_avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Joni Utama',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(color: AppColors.successGreen, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text('BK 4892 ABC • Honda Vario 160', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  const Text('Rating Mitra: ★ 4.9 (1.240 Trip)', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 28),

        const Text(
          'PENGATURAN AKUN',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),

        _buildSettingTile(
          icon: Icons.person_outline,
          title: 'Ubah Profil',
          subtitle: 'Nama dan foto akun Joni Utama',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ubah Profil Joni Utama (Tersimpan)')),
            );
          },
        ),
        _buildSettingTile(
          icon: Icons.verified_user_outlined,
          title: 'Status Verifikasi',
          subtitle: 'Status dokumen driver (KTP, SIM, STNK)',
          onTap: () => _showVerificationStatus(context),
        ),
        _buildSettingTile(
          icon: Icons.two_wheeler,
          title: 'Informasi Kendaraan',
          subtitle: 'Jenis motor dan nomor polisi BK 4892 ABC',
          onTap: () => _showVehicleInfo(context),
        ),
        _buildSettingTile(
          icon: Icons.palette_outlined,
          title: 'Ubah Tema',
          subtitle: 'Sesuaikan tema (Terang / Gelap / Sistem)',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tema saat ini: Mengikuti Sistem (Default Ungu Muda)')),
            );
          },
        ),
        _buildSettingTile(
          icon: Icons.lock_outline,
          title: 'Keamanan Akun',
          subtitle: 'Ubah kata sandi akun mitra',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur Ubah Sandi Driver Aktif')),
            );
          },
        ),
        _buildSettingTile(
          icon: Icons.description_outlined,
          title: 'Kebijakan Privasi & Syarat',
          subtitle: 'Ketentuan penggunaan platform RideOn Mitra',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kebijakan Privasi & Syarat Driver')),
            );
          },
        ),
        _buildSettingTile(
          icon: Icons.shield_outlined,
          title: 'Klaim Talangan Belanja (Proteksi)',
          subtitle: 'Ganti rugi jika pesanan belanja dibatalkan customer',
          onTap: () => _showKlaimTalanganDialog(context),
        ),
        _buildSettingTile(
          icon: Icons.emergency,
          title: 'Tombol Darurat (SOS)',
          subtitle: 'Kirim sinyal darurat & titik GPS ke posko bantuan',
          onTap: () => _showSosDialog(context),
        ),
        _buildSettingTile(
          icon: Icons.app_registration,
          title: 'Pendaftaran Mitra Baru (Figma Flow)',
          subtitle: 'Simulasi alur registrasi mitra 9 step & verifikasi',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DriverRegistrationFlow()),
            );
          },
        ),
        const SizedBox(height: 12),

        // Keluar Akun button (Frame 242:20519)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.dangerRed,
              side: const BorderSide(color: AppColors.dangerRed),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
              onBackToCustomer();
            },
            label: const Text('KELUAR AKUN / KEMBALI KE CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryPurple, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _DocStatusRow extends StatelessWidget {
  final String title;
  final bool isVerified;
  const _DocStatusRow({required this.title, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13)),
          Row(
            children: const [
              Icon(Icons.check_circle, color: AppColors.successGreen, size: 16),
              SizedBox(width: 4),
              Text('Terverifikasi', style: TextStyle(color: AppColors.successGreen, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
