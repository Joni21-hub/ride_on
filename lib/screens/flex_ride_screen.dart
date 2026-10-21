import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/map_widget.dart';
import 'chat_screen.dart';

enum RideBookingStage { select, searching, driverFound, inTrip, completed }

class FlexRideScreen extends StatefulWidget {
  const FlexRideScreen({super.key});

  @override
  State<FlexRideScreen> createState() => _FlexRideScreenState();
}

class _FlexRideScreenState extends State<FlexRideScreen> with SingleTickerProviderStateMixin {
  RideBookingStage _stage = RideBookingStage.select;
  int _selectedVehicle = 0; // 0 = Motor (14.000), 1 = Mobil (30.000)
  late AnimationController _radarController;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    _stageTimer?.cancel();
    super.dispose();
  }

  void _startBooking() {
    setState(() => _stage = RideBookingStage.searching);
    _stageTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _stage = RideBookingStage.driverFound);
      }
    });
  }

  void _showCallModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/avatar_peter.png'),
            ),
            const SizedBox(height: 14),
            const Text(
              'Pikri Haykal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Memanggil Driver via VoIP...',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 32),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Panggilan suara terhubung')),
                    );
                  },
                  icon: const Icon(Icons.call, color: Colors.white, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          RideMapWidget(
            showDriver: _stage == RideBookingStage.driverFound || _stage == RideBookingStage.inTrip,
            driverEta: 'Pikri (3 mnt)',
          ),

          // Searching Radar Overlay
          if (_stage == RideBookingStage.searching)
            Center(
              child: AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Container(
                    width: 140 * (1 + _radarController.value * 0.4),
                    height: 140 * (1 + _radarController.value * 0.4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple.withOpacity(0.3 * (1 - _radarController.value)),
                      border: Border.all(
                        color: AppColors.primaryPurple.withOpacity(1 - _radarController.value),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.radar, color: Colors.white, size: 36),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Bottom Sheet Cards
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _stage == RideBookingStage.driverFound
                ? _buildDriverFoundSheet()
                : _buildSelectionSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDCD5FE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Destination pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.location_on, color: AppColors.primaryPurple, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Jl. Ranked No. 133, Land of down IV (2.9 Km 12mnt)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Service Cards: Flex Motor vs Flex Mobil
          _buildVehicleCard(
            index: 0,
            title: 'Flex Motor',
            subtitle: 'Tercepat (1-2 mnt Penjemputan)',
            price: 'Rp 14.000',
            icon: Icons.two_wheeler,
          ),
          const SizedBox(height: 8),
          _buildVehicleCard(
            index: 1,
            title: 'Flex Mobil',
            subtitle: 'Nyaman & ber-AC dingin',
            price: 'Rp 30.000',
            icon: Icons.directions_car,
          ),
          const SizedBox(height: 10),

          // Note input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.edit_note, color: AppColors.textMuted, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Patokan jemput: "Didepan Mesjid Al-Munawarah"',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main CTA Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _stage == RideBookingStage.searching ? null : _startBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _stage == RideBookingStage.searching
                    ? 'Mencari Driver Terdekat...'
                    : _selectedVehicle == 0
                        ? 'Pesan Flex Motor Sekarang Rp 14.000'
                        : 'Pesan Flex Mobil Sekarang Rp 30.000',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverFoundSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDCD5FE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Status banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryPurple, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Driver Menuju Lokasimu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Tiba Dalam 3 Menit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Driver details card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                // Driver Avatar with star badge
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.accentSoft,
                      backgroundImage: const AssetImage('assets/images/avatar_peter.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, color: AppColors.goldYellow, size: 10),
                            SizedBox(width: 2),
                            Text(
                              '4.9',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Driver Name & Plate
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pikri Haykal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BG 4563 R',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Honda Vario 160 Hitam',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Buttons: Chat & Call
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F0FF),
                    foregroundColor: AppColors.primaryPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatTab(isStandalone: true),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                ),
                const SizedBox(width: 6),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE8F5E9),
                    foregroundColor: AppColors.successGreen,
                  ),
                  onPressed: _showCallModal,
                  icon: const Icon(Icons.phone, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Pickup point label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: const [
                Icon(Icons.circle, color: Color(0xFF00BFA5), size: 10),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jemput: Jl. Brawl No. 77 (Patokan: Depan Mr.DIY)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Cancel or Done action
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                setState(() => _stage = RideBookingStage.select);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                side: const BorderSide(color: AppColors.primaryDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Batalkan Pesanan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required IconData icon,
  }) {
    final isSelected = _selectedVehicle == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.primaryPurple : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryPurple : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
