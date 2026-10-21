import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Peter';
  final String _phone = '0812-3456-7890';
  String _email = 'Belum ditambahkan';
  bool _isDarkMode = false;

  void _showEditProfileDialog() {
    final controller = TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama Profil'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama Lengkap'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _name = controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showAddEmailDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Alamat Email'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'nama@example.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _email = controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showFavoriteAddressesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.bookmark_border, color: AppColors.primaryPurple, size: 22),
                SizedBox(width: 8),
                Text(
                  'Buku Alamat Favorit (Halaman 8)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Simpan titik peta alamat agar pemesanan dan checkout bisa sekali klik:',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            _buildAddressCard(
              label: 'Rumah',
              address: 'Jl. Medan - Banda Aceh No. 45, Batuphat Timur, Lhokseumawe',
              icon: Icons.home,
              isDefault: true,
            ),
            const SizedBox(height: 10),
            _buildAddressCard(
              label: 'Kantor',
              address: 'Kompleks Perumahan PIM / Arun, Muara Satu',
              icon: Icons.business,
            ),
            const SizedBox(height: 10),
            _buildAddressCard(
              label: 'Kos',
              address: 'Kos Mahasiswa Unimal Bukit Indah Blok B',
              icon: Icons.apartment,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form pinpoint alamat baru dibuka')),
                  );
                },
                icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primaryPurple, size: 18),
                label: const Text('+ Tambah Alamat Baru', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required String label,
    required String address,
    required IconData icon,
    bool isDefault = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? const Color(0xFFF3F0FF) : const Color(0xFFF7F6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDefault ? AppColors.primaryPurple : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDefault ? AppColors.primaryPurple : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    if (isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Utama', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(address, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
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
                      'Pengaturan Akun',
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Card (Peter)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCD5FE),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/avatar_peter.png'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_android, size: 14, color: AppColors.textDark),
                            const SizedBox(width: 4),
                            Text(
                              _phone,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Verified Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF72D5C8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'PENGATURAN AKUN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Settings List Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDCD5FE).withOpacity(0.7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline,
                    title: 'Ubah Profil',
                    subtitle: 'Nama dan foto akun',
                    onTap: _showEditProfileDialog,
                  ),
                  _buildSettingTile(
                    icon: Icons.palette_outlined,
                    title: 'Ubah Tema',
                    subtitle: 'Sesuaikan Tema (${_isDarkMode ? "Mode Gelap" : "Mode Terang"})',
                    trailing: Switch(
                      value: _isDarkMode,
                      activeThumbColor: AppColors.primaryPurple,
                      onChanged: (val) {
                        setState(() => _isDarkMode = val);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tema diubah ke ${val ? "Gelap" : "Terang"}')),
                        );
                      },
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Nomor WhatsApp',
                    subtitle: _phone,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF72D5C8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Aktif',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.mail_outline,
                    title: 'Alamat Email',
                    subtitle: _email,
                    trailing: InkWell(
                      onTap: _showAddEmailDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF72D5C8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _email == 'Belum ditambahkan' ? '+Tambahkan' : 'Ubah',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    title: 'Keamanan Akun',
                    subtitle: 'Ubah kata sandi akun',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tautan ganti kata sandi dikirim via WhatsApp')),
                      );
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.bookmark_border,
                    title: 'Buku Alamat Favorit',
                    subtitle: 'Rumah, Kantor, Kos (Checkout 1-klik)',
                    onTap: _showFavoriteAddressesSheet,
                  ),
                  _buildSettingTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Metode Pembayaran & E-Wallet',
                    subtitle: 'FlexPay: Rp 145.000 (Terhubung)',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Atur',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('E-Wallet FlexPay terhubung aktif')),
                      );
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.location_on_outlined,
                    title: 'Lokasi Anda',
                    subtitle: 'Atur GPS dan titik pinpoint',
                    showDivider: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('GPS akurat telah aktif')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Privacy Policy Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFDCD5FE).withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kebijakan Privasi & syarat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Ketentuan Penggunaan Platform',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textDark),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // KELUAR AKUN Button
            Center(
              child: SizedBox(
                width: 200,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text(
                    'KELUAR AKUN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textDark, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
          trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textDark, size: 18),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.5)),
          ),
      ],
    );
  }
}
